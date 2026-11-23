import 'package:pocketbase/pocketbase.dart';
import 'package:geolocator/geolocator.dart';
import 'package:walk_city/core/network/pb_client.dart';
import 'package:walk_city/features/routes/domain/route.dart' as domain;

class RouteRepository {
  final PocketBase _pb;

  RouteRepository({PocketBase? pocketBase})
    : _pb = pocketBase ?? PbClient.instance;

  Future<List<domain.Route>> getPublishedRoutes() async {
    final records = await _pb
        .collection('routes')
        .getFullList(sort: 'title', filter: 'status = "published"');
    return records.map(_toRoute).toList(growable: false);
  }

  Future<String> startRoute(domain.Route route) async {
    final user = _pb.authStore.record;
    if (user == null) {
      throw StateError('Войдите в аккаунт, чтобы начать маршрут.');
    }

    final active = await _pb
        .collection('route_completions')
        .getList(
          perPage: 1,
          filter:
              'user = "${user.id}" && route = "${route.id}" && status = "in_progress"',
          sort: '-created',
        );
    if (active.items.isNotEmpty) return active.items.first.id;

    final attemptKey = '${user.id}_${DateTime.now().microsecondsSinceEpoch}';
    final record = await _pb
        .collection('route_completions')
        .create(
          body: {
            'user': user.id,
            'route': route.id,
            'status': 'in_progress',
            'attempt_key': attemptKey,
          },
        );
    return record.id;
  }

  Future<List<RecordModel>> getCheckpoints(String routeId) => _pb
      .collection('route_checkpoints')
      .getFullList(filter: 'route = "$routeId"', sort: 'sequence');

  Future<List<RecordModel>> getCheckpointVisits(String completionId) => _pb
      .collection('route_checkpoint_visits')
      .getFullList(
        filter: 'completion = "$completionId"',
        expand: 'checkpoint',
      );

  Future<Map<String, dynamic>> confirmCheckpoint(
    String completionId,
    Position position,
  ) => _pb.send(
    '/api/gorod/route-progress/checkpoint',
    method: 'POST',
    body: {
      'completion_id': completionId,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'accuracy_m': position.accuracy,
    },
  );

  Future<Map<String, dynamic>> finishRoute(
    String completionId,
    Position position,
  ) => _pb.send(
    '/api/gorod/route-progress/finish',
    method: 'POST',
    body: {
      'completion_id': completionId,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'accuracy_m': position.accuracy,
    },
  );

  domain.Route _toRoute(RecordModel record) {
    final cover = record.getStringValue('cover');
    final distance = record.data['distance_km'];
    final minutes = record.data['estimated_minutes'];
    final points = record.data['reward_points'];
    final radius = record.data['checkpoint_radius_m'];
    return domain.Route(
      id: record.id,
      slug: record.getStringValue('slug'),
      title: record.getStringValue('title'),
      summary: record.getStringValue('summary'),
      description: record.getStringValue('description'),
      coverUrl: cover.isEmpty
          ? null
          : _pb.files.getUrl(record, cover).toString(),
      distanceKm: distance is num ? distance.toDouble() : null,
      estimatedMinutes: minutes is num ? minutes.toInt() : null,
      rewardPoints: points is num ? points.toInt() : null,
      difficulty: record.getStringValue('difficulty'),
      checkpointRadiusM: radius is num ? radius.toInt() : 30,
    );
  }
}
