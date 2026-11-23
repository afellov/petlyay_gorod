import 'package:flutter/material.dart';
import 'package:walk_city/features/routes/data/repositories/route_repository.dart';
import 'package:walk_city/features/routes/domain/route.dart' as domain;
import 'package:walk_city/features/routes/presentation/screens/active_route_screen.dart';

class RouteDetailsScreen extends StatefulWidget {
  final domain.Route route;

  const RouteDetailsScreen({super.key, required this.route});

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  bool _starting = false;
  bool _started = false;

  Future<void> _start() async {
    setState(() => _starting = true);
    try {
      final completionId = await RouteRepository().startRoute(widget.route);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ActiveRouteScreen(
            route: widget.route,
            completionId: completionId,
          ),
        ),
      );
      if (mounted) setState(() => _started = true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось начать маршрут: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final route = widget.route;
    final colors = Theme.of(context).colorScheme;
    final facts = <String>[
      if (route.distanceKm != null)
        '${route.distanceKm!.toStringAsFixed(route.distanceKm! % 1 == 0 ? 0 : 1)} км',
      if (route.estimatedMinutes != null) '${route.estimatedMinutes} мин',
      if (route.rewardPoints != null) '${route.rewardPoints} баллов',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Маршрут')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          if (route.coverUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                route.coverUrl!,
                height: 240,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _imagePlaceholder(colors),
              ),
            )
          else
            _imagePlaceholder(colors),
          const SizedBox(height: 20),
          Text(route.title, style: Theme.of(context).textTheme.headlineMedium),
          if (facts.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: facts.map((fact) => Chip(label: Text(fact))).toList(),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            route.description.isNotEmpty
                ? route.description
                : route.summary.isNotEmpty
                ? route.summary
                : 'Описание маршрута пока не добавлено.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _starting || _started ? null : _start,
            child: _starting
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_started ? 'Маршрут начат' : 'Начать маршрут'),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder(ColorScheme colors) => Container(
    height: 240,
    decoration: BoxDecoration(
      color: colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Icon(
      Icons.directions_walk,
      size: 56,
      color: colors.onSurfaceVariant,
    ),
  );
}
