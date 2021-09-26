# open_route_service

[![open_route_service version](https://img.shields.io/pub/v/open_route_service.svg)](https://pub.dev/packages/open_route_service)

An encapsulation made around [OpenRoute Service API](https://openrouteservice.org) for Dart and Flutter projects. The package was created for the easy integration of the OpenRouteService API for generation of Routes and Directions on Maps, Isochrones, Time-Distance Matrix, Pelias Geocoding, POIs, Elevation, routing Optimizations etc, using their amazing API.

For more information about the API, view [Openroute Service API documentation](https://openrouteservice.org/dev/#/api-docs).

## Features

The goal is to develop an all-encompassing package that can encapsulate everything OpenRouteService API offers.

With all of their internal Optimizations, this includes:

1. **[Directions](https://openrouteservice.org/dev/#/api-docs/v2/directions/):**
   Route Generation between any two or more coordinates for any mode of transportation. For example, from a starting point to a destination on `'foot-walking'`.

   Eg. `OpenRouteServiceDirections.getRouteCoordinates` gives a `List` of `Coordinates` which can then be easily used to draw a Polyline route on a map in a Flutter Application or anything else you can think of.

    | Route Drawn on Map using Coordinates |
    | ------------------------------------ |
    | ![Route Drawn on Map](https://raw.githubusercontent.com/Dhi13man/open_route_service/main/screenshots/directions_map.png) |

2. **[Elevation](https://openrouteservice.org/dev/#/api-docs/elevation/):**
    Get the elevation of a coordinate or a list of coordinates. Fetches the [ElevationData] by taking a 2D [coordinate] and enriching it with  elevation from a variety of datasets.

    | Elevation Response Received |
    | --------------------------- |
    | ![Sample Elevation Response](https://raw.githubusercontent.com/Dhi13man/open_route_service/main/screenshots/elevation_response.png) |

3. **[Isochrones](https://openrouteservice.org/dev/#/api-docs/v2/isochrones/):**
    Obtain Isochrone (areas of reachability) Data for the locations given. The isochrone is a polygon that encloses a given point and is bounded by a given time.

    The isochrone data can be used to draw them on a map in a Flutter Application, or anything else you can think of.

    | Isochrone Drawn on Map |
    | ---------------------- |
    | ![Isochrone Drawn on Map](https://raw.githubusercontent.com/Dhi13man/open_route_service/main/screenshots/isochrone_map.png) |

4. **Time-Distance Matrix:**

5. **Pelias Geocoding:**

6. **POIs:**

Appropriate tests have also been written for each of the above APIs and can be used to check if the package and/or API are functioning properly.

## Getting started

Run `dart pub add open_route_service` or `flutter pub add open_route_service` to install the package.

## Usage

1. Import the package: `import 'package:open_route_service/open_route_service.dart';` where needed.
2. Create a new instance of the class with your [OpenRouteService API Key](https://openrouteservice.org/dev/#/signup): `OpenRouteService openRouteService = OpenRouteService(apiKey: 'YOUR-API-KEY');`
3. Use the handy class methods to easily generate Directions, Isochrones, Time-Distance Matrix, Pelias Geocoding, POIs, Elevation and routing Optimizations etc, letting the package handle all the complex HTTP requests in the background for you.

Example of how to use the package to use [OpenRoute Service's Directions API](https://openrouteservice.org/dev/#/api-docs/v2/directions):

```dart
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

  // Map route coordinates to a list of LatLng (requires google_maps_flutter package)
  // to be used in the Map route Polyline.
  final List<LatLng> routePoints = routeCoordinates
      .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
      .toList();

  // Create Polyline (requires Material UI for Color)
  final Polyline routePolyline = Polyline(
    polylineId: PolylineId('route'),
    visible: true,
    points: routePoints,
    color: Colors.red,
    width: 4,
  );

  // Use Polyline to draw route on map or do anything else with the data :)
}

```

## Dependencies

- [Dart,](https://www.dartlang.org/) for the Dart SDK which this obviously runs on.
- [http,](https://pub.dev/packages/http) for making HTTP requests to the API endpoints.

## Contribution Guidelines

- Contributions are welcome on [GitHub](https://www.github.com/dhi13man/open_route_service). Please ensure all the tests are running before pushing your changes. Write your own tests too!

- File any [issues or feature requests here](https://www.github.com/dhi13man/open_route_service/issues) or help me resolve existing ones. :)

## Additional information

- Please [contribute to OpenRouteService API by donating](https://openrouteservice.org/donations/) to help keep the service free and accessible to everyone.

- Go through the full documentation here: [OpenRouteService API Documentation](https://openrouteservice.org/dev/#/api-docs/v2/directions)

- Reach out to me directly @dhi13man on [Twitter](https://twitter.com/dhi13man) or [GitHub](https://www.github.com/dhi13man) if you have any general questions or suggestions.
