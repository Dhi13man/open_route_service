# open_route_service

[![License](https://img.shields.io/github/license/dhi13man/open_route_service)](https://github.com/Dhi13man/open_route_service/blob/main/LICENSE)
[![Language](https://img.shields.io/badge/language-Dart-blue.svg)](https://dart.dev)
[![Language](https://img.shields.io/badge/language-Flutter-blue.svg)](https://flutter.dev)
[![Contributors](https://img.shields.io/github/contributors-anon/dhi13man/open_route_service?style=flat)](https://github.com/Dhi13man/open_route_service/graphs/contributors)
[![GitHub forks](https://img.shields.io/github/forks/dhi13man/open_route_service?style=social)](https://github.com/Dhi13man/open_route_service/network/members)
[![GitHub Repo stars](https://img.shields.io/github/stars/dhi13man/open_route_service?style=social)](https://github.com/Dhi13man/open_route_service/stargazers)
[![Last Commit](https://img.shields.io/github/last-commit/dhi13man/open_route_service)](https://github.com/Dhi13man/open_route_service/commits/main)
[![Build, Format, Test](https://github.com/Dhi13man/open_route_service/workflows/Build,%20Format,%20Test/badge.svg)](https://github.com/Dhi13man/open_route_service/actions)
[![open_route_service version](https://img.shields.io/pub/v/open_route_service.svg)](https://pub.dev/packages/open_route_service)

[!["Buy Me A Coffee"](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20an%20Ego%20boost&emoji=%F0%9F%98%B3&slug=dhi13man&button_colour=FF5F5F&font_colour=ffffff&font_family=Lato&outline_colour=000000&coffee_colour=FFDD00****)](https://www.buymeacoffee.com/dhi13man)

This package is an encapsulation/wrapper made around [openrouteservice API](https://openrouteservice.org) for Dart and Flutter projects.

The package enables the easy integration of the openrouteservice API with relevant data models, for generation of Routes and Directions on Maps, Isochrones, Time-Distance Matrix, Pelias Geocoding, POIs, Elevation, routing Optimizations etc, using their amazing API.

[Contribute to openrouteservice API by donating](https://openrouteservice.org/donations/) to help keep the service free and accessible to everyone. For more information about the API, view the [openrouteservice API documentation](https://openrouteservice.org/dev/#/api-docs).

## Contents

- [open_route_service](#open_route_service)
  - [Contents](#contents)
  - [Features](#features)
  - [Getting started](#getting-started)
  - [Steps for Usage](#steps-for-usage)
    - [Example Usage](#example-usage)
  - [Contribution Guidelines](#contribution-guidelines)
  - [Dependencies](#dependencies)
  - [Additional information](#additional-information)
    - [Sponsor Message](#sponsor-message)

## Features

The goal is to develop an all-encompassing package that can encapsulate everything openrouteservice API offers.

With all of their internal Optimizations, this includes:

1. **[Directions](https://openrouteservice.org/dev/#/api-docs/v2/directions/):**
   Route Generation between any two or more coordinates for any mode of transportation. For example, from a starting point to a destination on `'foot-walking'`.

   E.g. `ORSDirections.directionsRouteCoordinatesGet` gives a `List` of `Coordinates` which can then be easily used to draw a Polyline route on a map in a Flutter Application or anything else you can think of.

   | Route Drawn on Map using Coordinates |
   | ------------------------------------ |
   | ![Route Drawn on Map][route_img]     |

    [route_img]: https://raw.githubusercontent.com/Dhi13man/open_route_service/main/screenshots/directions_map.png

2. **[Elevation](https://openrouteservice.org/dev/#/api-docs/elevation/):**
   Get the elevation of a coordinate, or a list of coordinates. Fetches the `ElevationData` by taking a 2D `coordinate` or planar line geometry, and enriching it with elevation from a variety of datasets.

   | Elevation Response Received                 |
   | ------------------------------------------- |
   | ![Sample Elevation Response][elevation_img] |

    [elevation_img]: https://raw.githubusercontent.com/Dhi13man/open_route_service/main/screenshots/elevation_response.png

3. **[Isochrones](https://openrouteservice.org/dev/#/api-docs/v2/isochrones/):**
   Obtain Isochrone (areas of reachability) Data for the locations given. The isochrone is a polygon that encloses a given point and is bounded by a given time.

   The isochrone data can be used to draw them on a map in a Flutter Application, or anything else you can think of.

   | Isochrone Drawn on Map                   |
   | ---------------------------------------- |
   | ![Isochrone Drawn on Map][isochrone_img] |

    [isochrone_img]: https://raw.githubusercontent.com/Dhi13man/open_route_service/main/screenshots/isochrone_map.png

4. **[Time-Distance Matrix](https://openrouteservice.org/dev/#/api-docs/matrix):**
   Obtain one-to-many, many-to-one and many-to-many matrices for time and distance. Returns duration or distance matrix for multiple source and destination points.

5. **Pelias Geocoding:**

6. **[POIs](https://openrouteservice.org/dev/#/api-docs/pois):**
   Obtains information about the Points of Interest (POIs) in the area surrounding a geometry which can either be a bounding box, polygon or buffered linestring, or point.

   The Points of Interest can be marked on a map in a Flutter Application, or their properties and information visualized in various ways, or anything else you can think of.

   | Points of Interest Drawn on Map |
   | ------------------------------- |
   | ![POI Drawn on Map][pois_img]   |

    [pois_img]: https://raw.githubusercontent.com/Dhi13man/open_route_service/main/screenshots/pois_map.png

7. **[Routing Optimizations](https://openrouteservice.org/dev/#/api-docs/optimization):**
   The optimization endpoint solves Vehicle Routing Problems and can be used to schedule multiple vehicles and jobs, respecting time windows, capacities and required skills.

   This service is based on the excellent [Vroom](https://github.com/VROOM-Project/vroom) project. Please also consult [its API documentation](https://github.com/VROOM-Project/vroom/blob/master/docs/API.md).

   | Optimization Data for Vroom Jobs and Vehicles extracted and their route information printed in Console |
   | ------------------------------------------------------------------------------------------------------ |
   | ![Optimization Route Data][optimization_routes_img]                                                    |

    [optimization_routes_img]: https://raw.githubusercontent.com/Dhi13man/open_route_service/main/screenshots/optimization_console.png

Appropriate tests have also been written for each of the above APIs and can be used to check if the package and/or API are functioning properly.

## Getting started

Run `dart pub add open_route_service` or `flutter pub add open_route_service` in your Dart/Flutter project directory to install the package.

## Steps for Usage

1. Import the package where needed:

    ```dart
    import 'package:open_route_service/open_route_service.dart';
    ```

2. Create a new instance of the class with your [openrouteservice API Key](https://openrouteservice.org/dev/#/signup):

    ```dart
    OpenRouteService openrouteservice = OpenRouteService(apiKey: 'YOUR-API-KEY');
    ```

3. Use the handy class methods to easily generate Directions, Isochrones, Time-Distance Matrix, Pelias Geocoding, POIs, Elevation and routing Optimizations etc, letting the package handle all the complex HTTP requests in the background for you.

### Example Usage

To use the package with the [Directions API](https://openrouteservice.org/dev/#/api-docs/v2/directions) to generate and draw a Route on a map in a Flutter application:

```dart
import 'package:open_route_service/open_route_service.dart';

Future<void> main() async {
  // Initialize the openrouteservice with your API key.
  final OpenRouteService client = OpenRouteService(apiKey: 'YOUR-API-KEY');

  // Example coordinates to test between
  const double startLat = 37.4220698;
  const double startLng = -122.0862784;
  const double endLat = 37.4111466;
  const double endLng = -122.0792365;

  // Form Route between coordinates
  final List<Coordinate> routeCoordinates = await client.directionsRouteCoordinatesGet(
    startCoordinate: Coordinate(latitude: startLat, longitude: startLng),
    endCoordinate: Coordinate(latitude: endLat, longitude: endLng),
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

## Contribution Guidelines

- Check the [in-depth Contribution Guide](https://github.com/Dhi13man/open_route_service/blob/main/CONTRIBUTING.md) for exact steps on how to contribute to the package.

- Contributions are welcome on [GitHub](https://www.github.com/dhi13man/open_route_service). Please ensure all the tests are running before pushing your changes. Write your own tests too!

- File any [issues or feature requests here,](https://www.github.com/dhi13man/open_route_service/issues) or help me resolve existing ones. :)

## Dependencies

- [Dart,](https://www.dartlang.org/) for the Dart SDK which this obviously runs on.
- [http,](https://pub.dev/packages/http) for internally making RESTful HTTP Network requests to the API endpoints.

## Additional information

- Please [contribute to openrouteservice API by donating](https://openrouteservice.org/donations/) to help keep the service free and accessible to everyone.

- Go through the full documentation here: [openrouteservice API Documentation](https://openrouteservice.org/dev/#/api-docs/v2/directions).

- Reach out to me directly @dhi13man on [Twitter](https://twitter.com/dhi13man) or [GitHub](https://www.github.com/dhi13man) if you have any general questions or suggestions.

### Sponsor Message

The first release of this package was sponsored by [Cashtic](https://cashtic.com/), a Cross-Platform peer-to-peer ATM cash network for Android and Web. Get it on [Google Play!](https://play.google.com/store/apps/details?id=com.cashtic&hl=en&gl=US)
