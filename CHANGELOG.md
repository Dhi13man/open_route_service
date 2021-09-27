# Releases

## [0.6.0] - 26th September, 2021

- Encapsulated `Matrix` API.
- Encapsulted `POIs` API.
- **BREAKING**: Naming conventions changed: `OpenRouteService*` -> `ORS*`.

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
