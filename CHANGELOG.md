# Releases

## [1.2.4] - 6th Feb, 2024

- Made API more flexible by allowing constructor-based overrides in `OpenRouteService` class of:
  - `baseUrl`, the default API Base URL
  - `client`, the HTTP Client being used to make the requests
  - `defaultProfile`, the default profile being used to make the requests.

- **MINOR BREAKING**: Removed getter and setter for `profile` in `OpenRouteService` class. It is now final and can only be set via the constructor `defaultProfile` parameter. This system is more concurrency-safe. If it needs to be overriden at API call level, that can any way be done by passing in `profileOverride` to the respective API method.

- Ternary operator null check replaced with null-aware operator in Vroom and Optimization data models.

## [1.2.3] - 24th June, 2023

- Upgraded dependencies to keep up with the latest versions of the packages.

## [1.2.2] - 15th September, 2022

- Matrix Data Models Null Safety Fixes as per [[#12](https://github.com/Dhi13man/open_route_service/issues/12)].

## [1.2.1] - 10th February, 2022

- Better Response Status-Code verification logic as for posts it won't always be 200.

- **BREAKING:** Separated and refined openrouteservice path-profile String and ORSProfile interconversion logic.
  `OpenRouteService.getProfileString(ORSProfile profile)` -> `profile.name`

- **Minor:** Dev Dependencies updated. Pubspec improved.

## [1.1.1] - 06th February, 2022

- Optimize imports as per static analysis.

## [1.1.0] - 14th November, 2021

- **BREAKING:** Renamed `OpenRouteService` methods with even stricter naming convention:
    ```{API endpoint name} + {functionality name} + Post / Get (Based on type of Request)```

- **BREAKING:** `Coordinate` Model renamed to `ORSCoordinate` to avoid ambiguity with other location based packages.

- `ORSCoordinate.fromJSON()` fixes for errors with altitude: potential null error and wrong key fixed.

## [1.0.1] - 31st October, 2021

- Restriction applied to `request` parameter of `ORSPois.poisDataPostGet` with `ArgumentError` if restriction not followed, as per API convention. `request` can now only be 'pois', 'stats' or 'list' as per openrouteservice API.

- Linted Code. :)

## [1.0.0] - 30th October, 2021

- First Stable Release (unless there is some breaking bug that slipped by).

- Addition of GeoCoding API.

- Metadata models.

- **BREAKING:** GeoJsonFeatureProperties Data Model removed and replaced with unparsed `Map<String, dynamic>` as it doesn't have any static structure across various endpoints.

- **BREAKING:** Every method in the package has been renamed for consistency and to easily find needed methods. New method naming convention:

  ```{API endpoint name} + {functionality name} + (if functionality uses a POST endpoint) Post + Get```

  Eg. `getRouteCoordinates -> directionsRouteCoordsGet`, `getElevationDataPost -> elevationDataPostGet` and so on.

## [0.7.0] - 27th September, 2021

- **BREAKING:** `Matrix*` -> `TimeDistanceMatrix*`

- Adjust cgiar attribution link from http to https

- `Coordinate` model `toList` and `fromList` methods added for convenience (with null safety).

- Documentation updates.

- Encapsulated `Optimization` API.

## [0.6.0] - 26th September, 2021

- **BREAKING:** Naming conventions changed: `OpenRouteService*` -> `ORS*`.

- Encapsulated `Matrix` API.

- Encapsulated `POIs` API.

## [0.5.2] - 26th September, 2021

- Reworked the entire `Directions` API system to enable usage of both the normal POST endpoint as `getMultiRouteDirectionsData` and the geojson POST endpoint `getMultiRouteDirectionsGeoJson`.

- Common `GeoJsonFeatureCollection` Data Model created to be used with both the `Directions` API and the `Isochrones` API, whenever geojson is involved.

## [0.5.1] - 26th September, 2021

- Dart SDK version change to pass static analysis on pub.dev.

- Ran `dart format` on all Dart files to be in compliance with Dart's style guide.

## [0.5.0] - 26th September, 2021

- Initial version.

- APIs of OpenRouteService currently encapsulated and available:
  1. [Directions](https://openrouteservice.org/dev/#/api-docs/v2/directions/)
  2. [Elevation](https://openrouteservice.org/dev/#/api-docs/elevation/)
  3. [Isochrones](https://openrouteservice.org/dev/#/api-docs/v2/isochrones/)

- Tests Ready for the APIs too.
