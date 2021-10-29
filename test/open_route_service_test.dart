import 'dart:io';

import 'package:test/test.dart';

import 'services/directions_tests.dart';
import 'services/elevation_tests.dart';
import 'services/geocode_tests.dart';
import 'services/isochrones_tests.dart';
import 'services/matrix_tests.dart';
import 'services/optimization_tests.dart';
import 'services/pois_tests.dart';

import 'package:open_route_service/open_route_service.dart';

Future<void> main() async {
// TODO: Change the API key to your own API key to ensure that package works.
  String apiKey = 'test';

  // Change API key from environment if tests are running on Github Actions.
  if ((Platform.environment['EXEC_ENV'] ?? '') == 'github_actions') {
    // If running on Github Actions, the last pusher shouldn't have leaked
    // their API key.
    assert(apiKey == 'test');
    apiKey = Platform.environment['ORS_API_KEY']!;
  }

  // Dummy Coordinates
  const Coordinate dirStartCoordinate =
      Coordinate(latitude: 37.4220698, longitude: -122.0862784);
  const Coordinate dirEndCoordinate =
      Coordinate(latitude: 37.4111466, longitude: -122.0792365);
  const Coordinate isochroneStartCoordinate =
      Coordinate(latitude: 49.41461, longitude: 8.681495);
  const Coordinate isochroneEndCoordinate =
      Coordinate(latitude: 49.41943, longitude: 8.686507);

  // Dummy Optimization Jobs and Vehicles
  const String serializedJobs =
      '[{"id":1,"service":300,"amount":[1],"location":[1.98935,48.701],"skills":[1],"time_windows":[[32400,36000]]},{"id":2,"service":300,"amount":[1],"location":[2.03655,48.61128],"skills":[1]},{"id":3,"service":300,"amount":[1],"location":[2.39719,49.07611],"skills":[2]},{"id":4,"service":300,"amount":[1],"location":[2.41808,49.22619],"skills":[2]},{"id":5,"service":300,"amount":[1],"location":[2.28325,48.5958],"skills":[14]},{"id":6,"service":300,"amount":[1],"location":[2.89357,48.90736],"skills":[14]}]';
  const String serializedVehicles =
      ' [{"id":1,"profile":"driving-car","start":[2.35044,48.71764],"end":[2.35044,48.71764],"capacity":[4],"skills":[1,14],"time_window":[28800,43200]},{"id":2,"profile":"driving-car","start":[2.35044,48.71764],"end":[2.35044,48.71764],"capacity":[4],"skills":[2,14],"time_window":[28800,43200]}]';

  final OpenRouteService service = OpenRouteService(apiKey: apiKey);

  // Begin tests!
  group('Initial test', () {
    test('Verify that API Key was Set before testing!', () async {
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

  group(
    'Optimization API tests:',
    () => optimizationTests(
      service: service,
      serializedJobs: serializedJobs,
      serializedVehicles: serializedVehicles,
    ),
  );

  group(
    'Geocoding API tests:',
    () => geocodeTests(
      service: service,
      geocodeQueryText: 'Namibian Brewery',
      geocodeLocalityQueryText: 'Paris',
      geocodeReversePoint:
          const Coordinate(longitude: 2.294471, latitude: 48.858268),
      reverseGeocodeQueryLocality: 'Paris',
    ),
  );
}
