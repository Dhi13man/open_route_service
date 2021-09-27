import 'package:test/test.dart';

import 'services/directions_tests.dart';
import 'services/elevation_tests.dart';
import 'services/isochrones_tests.dart';
import 'services/matrix_tests.dart';
import 'services/pois_tests.dart';

import 'package:open_route_service/open_route_service.dart';

// TODO: Change the API key to your own API key to ensure that package works.
const String apiKey = 'test';

Future<void> main() async {
  // Dummy Coordinates
  const Coordinate dirStartCoordinate =
      Coordinate(latitude: 37.4220698, longitude: -122.0862784);
  const Coordinate dirEndCoordinate =
      Coordinate(latitude: 37.4111466, longitude: -122.0792365);
  const Coordinate isochroneStartCoordinate =
      Coordinate(latitude: 49.41461, longitude: 8.681495);
  const Coordinate isochroneEndCoordinate =
      Coordinate(latitude: 49.41943, longitude: 8.686507);

  final OpenRouteService service = OpenRouteService(apiKey: apiKey);
  group('Initial test', () {
    test('Validate API Key Set', () async {
      expect(apiKey != 'test', true);
    });
  });

  group(
    'Directions API tests:',
    () => directionsTests(
      service: service,
      startCoordinate: dirStartCoordinate,
      endCoordinate: dirEndCoordinate,
    ),
  );

  group(
    'Elevation API tests:',
    () => elevationTests(service: service, coordinate: dirStartCoordinate),
  );

  group(
    'Isochrones API tests:',
    () => isochronesTests(
      service: service,
      coordinates: <Coordinate>[
        isochroneStartCoordinate,
        isochroneEndCoordinate,
      ],
    ),
  );

  group(
    'Matrix API tests:',
    () => matrixTests(
      service: service,
      locations: <Coordinate>[dirStartCoordinate, dirEndCoordinate],
    ),
  );

  group(
    'POIs API tests:',
    () => poisTests(
      service: service,
      boundingBoxStart: isochroneStartCoordinate,
      boundingBoxEnd: isochroneEndCoordinate,
    ),
  );
}
