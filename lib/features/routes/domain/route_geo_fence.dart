import 'dart:math' as math;

class RouteGeoFence {
  const RouteGeoFence._();

  static const maxAccuracyMeters = 25.0;

  static bool isReliable(double accuracyMeters) =>
      accuracyMeters >= 0 && accuracyMeters <= maxAccuracyMeters;

  static double distanceMeters({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
  }) {
    double radians(double degrees) => degrees * math.pi / 180;
    final dLat = radians(toLatitude - fromLatitude);
    final dLon = radians(toLongitude - fromLongitude);
    final lat1 = radians(fromLatitude);
    final lat2 = radians(toLatitude);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return 6371000 * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  static bool isInside({
    required double latitude,
    required double longitude,
    required double checkpointLatitude,
    required double checkpointLongitude,
    required double radiusMeters,
    required double accuracyMeters,
  }) =>
      isReliable(accuracyMeters) &&
      distanceMeters(
            fromLatitude: latitude,
            fromLongitude: longitude,
            toLatitude: checkpointLatitude,
            toLongitude: checkpointLongitude,
          ) <=
          radiusMeters;
}
