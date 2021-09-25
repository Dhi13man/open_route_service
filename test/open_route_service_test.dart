import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

import 'services/directions_tests.dart';

Future<void> main() async {
  const String apiKey = 'test';
  // Dummy Start and Destination Points
  const double startLat = 37.4220698;
  const double startLng = -122.0862784;
  const double endLat = 37.4111466;
  const double endLng = -122.0792365;
  const Coordinate startCoordinate = Coordinate(startLat, startLng);
  const Coordinate endCoordinate = Coordinate(endLat, endLng);

  final OpenRouteService service = OpenRouteService(apiKey: apiKey);
  group('Initial test', () {
    test('Validate API Key', () async {
      expect(apiKey != 'test', true);
    });
  });

  group(
    'Directions API tests:',
    () => directionsTests(
      service: service,
      startCoordinate: startCoordinate,
      endCoordinate: endCoordinate,
    ),
  );
}
