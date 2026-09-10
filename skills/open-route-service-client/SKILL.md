---
name: open-route-service-client
description: >-
  Use whenever writing, fixing, or reviewing Dart/Flutter code that uses
  package:open_route_service, OpenRouteService, ORS directions, isochrones,
  matrices, geocoding, elevation, POIs, or Vroom optimization. Trigger on
  "openrouteservice", "draw a route", "isochrone", "ORSCoordinate",
  "ORSProfile", "routing API key".
---

# open_route_service

Typed Dart client for OpenRouteService. Agents invent REST paths, swap lat/lng,
and pass profile strings; this package already encodes those.

## Client

```dart
import 'package:open_route_service/open_route_service.dart';

final client = OpenRouteService(
  apiKey: apiKey, // from env/secret store, never committed
  defaultProfile: ORSProfile.drivingCar, // default is footWalking
);
```

Use `ORSProfile` values (`drivingCar`, `footWalking`, `cyclingRoad`, …). Do not
pass REST strings like `'driving-car'`; `profileOverride` is `ORSProfile?`.
Read the key from configuration. Call `client.close()` when finished.

Failures are `ORSHttpException` (`statusCode`, `errorResponse`) or
`ORSParsingException`. Do not catch generic `Exception` and retry blindly.

## Coordinates

`ORSCoordinate(latitude:, longitude:)` uses named WGS84 fields.

`ORSCoordinate.fromList` is GeoJSON order: `[longitude, latitude, altitude?]`.
Passing `[lat, lng]` silently places the point in the ocean. Prefer named
constructors unless you are parsing GeoJSON.

The client serializes to the API as `lng,lat`. Do not build query strings.

## Which method

- Two-point polyline: `directionsRouteCoordsGet` (`List<ORSCoordinate>`).
- Two-point GeoJSON: `directionsRouteGeoJsonGet`.
- 3+ waypoints: `directionsMultiRouteCoordsPost` or
  `directionsMultiRouteGeoJsonPost`.
- Reachability polygon: `isochronesPost(locations:, range:)`. Not a route.
  Default `rangeType` is `'time'`; `range` is seconds.
- Many-to-many times: `matrixPost(locations:)`. `sources`/`destinations` are
  indices into `locations`.
- Address to coordinate: `geocodeSearchGet`, `geocodeReverseGet`,
  `geocodeAutoCompleteGet`.
- Elevation, POIs, VRP: `elevationPointGet`, `poisDataPost`,
  `optimizationDataPost` on the same client.

Do not `http.get` OpenRouteService URLs. Other services stay on this client.

## Route example

```dart
final route = await client.directionsRouteCoordsGet(
  startCoordinate: ORSCoordinate(latitude: 37.422, longitude: -122.086),
  endCoordinate: ORSCoordinate(latitude: 37.411, longitude: -122.079),
  profileOverride: ORSProfile.footWalking,
);
client.close();
```

Map widgets want `(lat, lng)` in that order from each `ORSCoordinate`.
