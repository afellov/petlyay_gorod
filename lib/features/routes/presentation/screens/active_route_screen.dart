import 'dart:async';

import 'package:flutter/material.dart';
import 'package:walk_city/core/theme/app_visuals.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:walk_city/features/routes/data/repositories/route_repository.dart';
import 'package:walk_city/features/routes/domain/route.dart' as domain;
import 'package:walk_city/features/routes/domain/route_geo_fence.dart';

class ActiveRouteScreen extends StatefulWidget {
  const ActiveRouteScreen({
    super.key,
    required this.route,
    required this.completionId,
  });
  final domain.Route route;
  final String completionId;

  @override
  State<ActiveRouteScreen> createState() => _ActiveRouteScreenState();
}

class _ActiveRouteScreenState extends State<ActiveRouteScreen> {
  final _repository = RouteRepository();
  StreamSubscription<Position>? _subscription;
  List<RecordModel> _checkpoints = [];
  final Set<String> _visited = {};
  Position? _position;
  String? _gpsError;
  String? _message;
  bool _loading = true;
  bool _sending = false;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _checkpoints = await _repository.getCheckpoints(widget.route.id);
      final visits = await _repository.getCheckpointVisits(widget.completionId);
      _visited.addAll(
        visits.map((visit) => visit.getStringValue('checkpoint')),
      );
      if (_checkpoints.isNotEmpty) await _startLocation();
    } catch (error) {
      _gpsError = error.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _startLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw StateError('Включите геолокацию в настройках устройства.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw StateError('Разрешите приложению доступ к геолокации.');
    }
    _subscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen(
          _onPosition,
          onError: (Object error) {
            if (mounted) {
              setState(() => _gpsError = 'Потерян GPS-сигнал: $error');
            }
          },
        );
  }

  Future<void> _onPosition(Position position) async {
    if (!mounted) return;
    setState(() {
      _position = position;
      _gpsError = position.accuracy > 25
          ? 'Сигнал GPS неточный (${position.accuracy.toStringAsFixed(0)} м). Подождите.'
          : null;
    });
    if (_sending ||
        _finished ||
        !RouteGeoFence.isReliable(position.accuracy) ||
        _checkpoints.isEmpty) {
      return;
    }
    final next = _checkpoints.firstWhere(
      (point) => !_visited.contains(point.id),
      orElse: () => _checkpoints.last,
    );
    final lat = (next.data['latitude'] as num).toDouble();
    final lon = (next.data['longitude'] as num).toDouble();
    if (!RouteGeoFence.isInside(
      latitude: position.latitude,
      longitude: position.longitude,
      checkpointLatitude: lat,
      checkpointLongitude: lon,
      radiusMeters: widget.route.checkpointRadiusM.toDouble(),
      accuracyMeters: position.accuracy,
    )) {
      return;
    }
    _sending = true;
    try {
      final result = await _repository.confirmCheckpoint(
        widget.completionId,
        position,
      );
      if (!mounted) return;
      setState(() {
        _visited.add(result['checkpoint_id'] as String);
        _message = 'Контрольная точка пройдена: ${result['title']}';
      });
    } catch (error) {
      // Server validates the exact order and radius; temporary GPS/network misses are retried on next location fix.
      if (mounted &&
          _message == null &&
          !error.toString().toLowerCase().contains('контрольную')) {
        setState(
          () => _message = 'Проверка точки не прошла. Проверьте связь и GPS.',
        );
      }
    } finally {
      _sending = false;
    }
  }

  Future<void> _finish() async {
    final position = _position;
    if (position == null || position.accuracy > 25) {
      setState(() => _gpsError = 'Нужен точный сигнал GPS рядом с финишем.');
      return;
    }
    setState(() => _sending = true);
    try {
      final result = await _repository.finishRoute(
        widget.completionId,
        position,
      );
      if (!mounted) return;
      setState(() {
        _finished = true;
        _message =
            'Маршрут завершён! Начислено баллов: ${result['awarded_points']}';
      });
    } catch (error) {
      if (mounted) {
        setState(() => _message = 'Не удалось завершить маршрут: $error');
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completedAll =
        _checkpoints.isNotEmpty &&
        _checkpoints.last.getBoolValue('is_finish') &&
        _checkpoints.every((point) => _visited.contains(point.id));
    final finishNearby =
        _position != null &&
        RouteGeoFence.isReliable(_position!.accuracy) &&
        _checkpoints.isNotEmpty &&
        _checkpoints.last.getBoolValue('is_finish') &&
        _visited.contains(_checkpoints.last.id) &&
        RouteGeoFence.isInside(
          latitude: _position!.latitude,
          longitude: _position!.longitude,
          checkpointLatitude: (_checkpoints.last.data['latitude'] as num)
              .toDouble(),
          checkpointLongitude: (_checkpoints.last.data['longitude'] as num)
              .toDouble(),
          radiusMeters: widget.route.checkpointRadiusM.toDouble(),
          accuracyMeters: _position!.accuracy,
        );
    return Scaffold(
      appBar: AppBar(title: const Text('Прохождение маршрута')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppVisuals.of(context).background),
            fit: BoxFit.cover,
            opacity: AppVisuals.backgroundOpacity,
            colorFilter: AppVisuals.of(context).dark
                ? const ColorFilter.mode(
                    AppVisuals.darkBackgroundTint,
                    BlendMode.multiply,
                  )
                : null,
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    widget.route.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _checkpoints.isEmpty
                        ? 'Для маршрута ещё не настроены контрольные точки.'
                        : 'Посетите контрольные точки по порядку. Радиус — ${widget.route.checkpointRadiusM} м.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (_position != null)
                    ListTile(
                      leading: const Icon(Icons.my_location),
                      title: Text(
                        'Точность GPS: ${_position!.accuracy.toStringAsFixed(0)} м',
                      ),
                    ),
                  if (_gpsError != null)
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(_gpsError!),
                      ),
                    ),
                  if (_message != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(_message!),
                    ),
                  const SizedBox(height: 8),
                  for (var i = 0; i < _checkpoints.length; i++)
                    ListTile(
                      leading: Icon(
                        _visited.contains(_checkpoints[i].id)
                            ? Icons.check_circle
                            : (_checkpoints[i].getBoolValue('is_finish')
                                  ? Icons.flag
                                  : Icons.radio_button_unchecked),
                        color: _visited.contains(_checkpoints[i].id)
                            ? Colors.green
                            : null,
                      ),
                      title: Text(_checkpoints[i].getStringValue('title')),
                      subtitle: Text(
                        i == _visited.length
                            ? 'Следующая точка'
                            : 'Контрольная точка ${i + 1}',
                      ),
                    ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed:
                        completedAll && finishNearby && !_sending && !_finished
                        ? _finish
                        : null,
                    icon: const Icon(Icons.flag),
                    label: Text(
                      _finished ? 'Маршрут завершён' : 'Завершить маршрут',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
