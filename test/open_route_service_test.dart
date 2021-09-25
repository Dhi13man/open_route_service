import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

Future<void> main() async {
  const String apiKey = 'test';
  // Dummy Start and Destination Points
  const double startLat = 37.4220698;
  const double startLng = -122.0862784;
  const double endLat = 37.4111466;
  const double endLng = -122.0792365;

  final OpenRouteService service = OpenRouteService(apiKey: apiKey);
  group('Directions API test', () {
    test('Validate API Key', () async {
      expect(apiKey != 'test', true);
    });

    test('Fetch and parse route.', () async {
      final List<Coordinate> routeCoordinates =
          await service.getRouteCoordinates(
        startCoordinate: Coordinate(startLat, startLng),
        endCoordinate: Coordinate(endLat, endLng),
      );
      // routeCoordinates.forEach(print);
      expect(routeCoordinates.length, greaterThan(0));
    });

    test('Error Validation in first and last path points', () async {
      final List<Coordinate> routeCoordinates =
          await service.getRouteCoordinates(
        startCoordinate: Coordinate(startLat, startLng),
        endCoordinate: Coordinate(endLat, endLng),
      );
      final Coordinate first = routeCoordinates.first,
          last = routeCoordinates.last;
      // Calculate percentage error in first and last path points
      final double startLatErr =
          (first.latitude - startLat).abs() / startLat * 100;
      final double startLngErr =
          (first.longitude - startLng).abs() / startLng * 100;
      final double endLatErr = (last.latitude - endLat).abs() / endLat * 100;
      final double endLngErr = (last.longitude - endLng).abs() / endLng * 100;

      // Validate that the first and last points of the route are not too far
      // from the start and end points (less than 0.1% error)
      expect((startLatErr + startLngErr).abs() / 2.0, lessThan(0.1));
      expect((endLatErr + endLngErr).abs() / 2.0, lessThan(0.1));
    });
  });
}
