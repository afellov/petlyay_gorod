import 'package:flutter_test/flutter_test.dart';
import 'package:walk_city/features/routes/domain/route_geo_fence.dart';

void main() {
  group('RouteGeoFence', () {
    test('accepts a reliable fix inside the checkpoint radius', () {
      expect(
        RouteGeoFence.isInside(
          latitude: 53.7575,
          longitude: 87.1360,
          checkpointLatitude: 53.7575,
          checkpointLongitude: 87.1360,
          radiusMeters: 30,
          accuracyMeters: 8,
        ),
        isTrue,
      );
    });

    test('rejects a fix outside the radius', () {
      expect(
        RouteGeoFence.isInside(
          latitude: 53.7585,
          longitude: 87.1360,
          checkpointLatitude: 53.7575,
          checkpointLongitude: 87.1360,
          radiusMeters: 30,
          accuracyMeters: 8,
        ),
        isFalse,
      );
    });

    test('rejects inaccurate or negative accuracy readings', () {
      expect(RouteGeoFence.isReliable(26), isFalse);
      expect(RouteGeoFence.isReliable(-1), isFalse);
      expect(RouteGeoFence.isReliable(25), isTrue);
    });
  });
}
