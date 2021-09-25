import 'package:open_route_service/open_route_service.dart';

Future<void> main() async {
  // Initialize the OpenRouteService with your API key.
  final OpenRouteService client = OpenRouteService(apiKey: 'YOUR-API-KEY');

  // Example coordinates to test between
  const double startLat = 37.4220698;
  const double startLng = -122.0862784;
  const double endLat = 37.4111466;
  const double endLng = -122.0792365;

  // Form Route between coordinates
  final List<Coordinate> routeCoordinates = await client.getRouteCoordinates(
    startCoordinate: Coordinate(startLat, startLng),
    endCoordinate: Coordinate(endLat, endLng),
  );

  // Print the route coordinates
  routeCoordinates.forEach(print);

  // Map route coordinates to a list of LatLng (requires google_maps_flutter)
  // to be used in Polyline
  // final List<LatLng> routePoints = routeCoordinates
  //     .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
  //     .toList();

  // Create Polyline (requires Material UI for Color)
  // final Polyline routePolyline = Polyline(
  //   polylineId: PolylineId('route'),
  //   visible: true,
  //   points: routePoints,
  //   color: Colors.red,
  //   width: 4,
  // );

  // Use Polyline to draw route on map or do anything else with the data :)
}
