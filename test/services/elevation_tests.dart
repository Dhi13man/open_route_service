import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

double percentageError(double a, double b) {
  return (a - b).abs() / a * 100;
}

void elevationTests({
  required OpenRouteService service,
  required Coordinate coordinate,
}) {
  test(
    'Fetch Elevation using GET Method [elevationDataGet]',
    () async {
      // Attempt 1 using geojson format.
      const String formatOut1 = 'geojson';
      final ElevationData elevationData = await service.elevationDataGet(
        geometry: coordinate,
        formatOut: formatOut1,
      );

      // Validate that round-off error is less than 1%.
      expect(
        percentageError(
          elevationData.coordinates.first.longitude,
          coordinate.longitude,
        ),
        lessThan(1),
      );
      expect(
        percentageError(
          elevationData.coordinates.first.latitude,
          coordinate.latitude,
        ),
        lessThan(1),
      );

      // Attempt 2 using point format.
      const String formatOut2 = 'point';
      final ElevationData elevationData2 = await service.elevationDataGet(
        geometry: coordinate,
        formatOut: formatOut2,
      );

      // Validate that same data came out using both formats.
      expect(elevationData.coordinates, equals(elevationData2.coordinates));
    },
  );

  test(
    'Fetch Elevation using POST Method [elevationDataPostGet]',
    () async {
      // Attempt 1 using geojson format.
      const String formatOut1 = 'geojson';
      final ElevationData elevationData = await service.elevationDataPostGet(
        geometry: coordinate,
        formatIn: formatOut1,
        formatOut: formatOut1,
      );

      // Validate that round-off error is less than 1%.
      expect(
        percentageError(
          elevationData.coordinates.first.longitude,
          coordinate.longitude,
        ),
        lessThan(1),
      );
      expect(
        percentageError(
          elevationData.coordinates.first.latitude,
          coordinate.latitude,
        ),
        lessThan(1),
      );

      // Attempt 2 using point format.
      const String formatOut2 = 'point';
      final ElevationData elevationData2 = await service.elevationDataPostGet(
        geometry: coordinate,
        formatIn: formatOut2,
        formatOut: formatOut2,
      );

      // Validate that same data came out using both formats.
      expect(elevationData.coordinates, equals(elevationData2.coordinates));
    },
  );

  test(
    'Cross-validate GET and POST Elevation fetching methods [elevationDataGet] and [elevationDataPostGet]',
    () async {
      // Attempt 1 using GET
      final ElevationData elevationDataGet =
          await service.elevationDataGet(geometry: coordinate);

      // Attempt 2 using POST
      final ElevationData elevationDataPost =
          await service.elevationDataPostGet(
        geometry: coordinate,
        formatIn: 'point',
      );

      // Validate both methods returned same inherent result.
      expect(elevationDataGet, equals(elevationDataPost));
    },
  );

  test(
    'Fetch Elevation through planar 2D Line Geometry using [elevationDataLinePostGet]',
    () async {
      final ElevationData elevationData =
          await service.elevationDataLinePostGet(
        geometry: 'u`rgFswjpAKD',
        formatIn: 'encodedpolyline5',
      );
      expect(elevationData.coordinates.length, greaterThan(1));
    },
  );
}
