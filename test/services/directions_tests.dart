import 'dart:math';

import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

void directionsTests({
  required OpenRouteService service,
  required ORSCoordinate startCoordinate,
  required ORSCoordinate endCoordinate,
}) {
  test(
    'Fetch and parse route for 2 points using [directionsRouteCoordsGet], for all profiles',
    () async {
      // Validate API for each profile
      for (ORSProfile profile in ORSProfile.values) {
        final List<ORSCoordinate> routeCoordinates =
            await service.directionsRouteCoordsGet(
          startCoordinate: startCoordinate,
          endCoordinate: endCoordinate,
          profileOverride: profile,
        );
        expect(routeCoordinates.length, greaterThan(1));
      }
    },
  );

  test(
    'Error Validation for 2 point route in first and last path points [directionsRouteCoordsGet]',
    () async {
      final List<ORSCoordinate> routeCoordinates =
          await service.directionsRouteCoordsGet(
        startCoordinate: startCoordinate,
        endCoordinate: endCoordinate,
      );
      final ORSCoordinate first = routeCoordinates.first,
          last = routeCoordinates.last;

      // Calculate percentage error in first and last path points
      final double startLatErr =
          (first.latitude - startCoordinate.latitude).abs() /
              startCoordinate.latitude *
              100;
      final double startLngErr =
          (first.longitude - startCoordinate.longitude).abs() /
              startCoordinate.longitude *
              100;
      final double endLatErr = (last.latitude - endCoordinate.latitude).abs() /
          endCoordinate.latitude *
          100;
      final double endLngErr =
          (last.longitude - endCoordinate.longitude).abs() /
              endCoordinate.longitude *
              100;

      // Validate that the first and last points of the route are not too far
      // from the start and end points (less than 0.1% error)
      expect((startLatErr + startLngErr).abs() / 2.0, lessThan(0.1));
      expect((endLatErr + endLngErr).abs() / 2.0, lessThan(0.1));
    },
  );

  test(
      'Fetch and parse route for multiple points using [directionsMultiRouteCoordsPostGet]',
      () async {
    final List<ORSCoordinate> routeCoordinates =
        await service.directionsMultiRouteCoordsPost(
      coordinates: <ORSCoordinate>[
        startCoordinate,
        endCoordinate,
        startCoordinate,
      ],
    );
    expect(routeCoordinates.length, greaterThan(0));
  });

  test(
      'Cross-validate [directionsRouteCoordsGet] and [directionsMultiRouteCoordsPostGet]',
      () async {
    final List<ORSCoordinate> routeCoordinates =
        await service.directionsRouteCoordsGet(
      startCoordinate: startCoordinate,
      endCoordinate: endCoordinate,
    );
    final List<ORSCoordinate> routeCoordinatesMulti =
        await service.directionsMultiRouteCoordsPost(
      coordinates: <ORSCoordinate>[startCoordinate, endCoordinate],
    );

    // Validate that the route coordinates are the same as in each case route
    // will be same despite using different APIs.
    final int minLength =
        min(routeCoordinates.length, routeCoordinatesMulti.length);
    for (int i = 0; i < minLength; i++) {
      expect(routeCoordinates[i], routeCoordinatesMulti[i]);
    }
  });

  test('Get Directions API Route Data using [directionsMultiRouteDataPostGet]',
      () async {
    final List<DirectionRouteData> directionRouteData =
        await service.directionsMultiRouteDataPost(
      coordinates: <ORSCoordinate>[startCoordinate, endCoordinate],
    );
    expect(directionRouteData.length, greaterThan(0));
    final DirectionRouteData firstRoute = directionRouteData.first;
    expect(firstRoute.bbox.length, equals(2));

    double totalDistance = 0;
    for (DirectionRouteSegment segment in firstRoute.segments) {
      totalDistance += segment.distance;
    }
    expect(firstRoute.summary.distance, totalDistance);
  });
}
