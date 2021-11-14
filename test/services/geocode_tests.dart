import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

void geocodeTests({
  required OpenRouteService service,
  String geocodeQueryText = 'Namibian Brewery',
  String geocodeLocalityQueryText = 'Paris',
  ORSCoordinate geocodeReversePoint =
      const ORSCoordinate(longitude: 2.294471, latitude: 48.858268),
  String reverseGeocodeQueryLocality = 'Paris',
}) {
  test(
    'Do a Geocode Search using [geocodeSearchGet]',
    () async {
      final GeoJsonFeatureCollection geocodeData =
          await service.geocodeSearchGet(
        text: geocodeQueryText,
      );
      expect(geocodeData.bbox.length, 2);
      expect(geocodeData.features.length, greaterThan(0));
      final String label = geocodeData.features.first.properties['label']!;
      expect(label.contains(geocodeQueryText), true);
    },
  );
  test(
    'Do a Geocode Search using [geocodeSearchGet], for all layers.',
    () async {
      final GeoJsonFeatureCollection geocodeData =
          await service.geocodeSearchGet(
        text: geocodeQueryText,
        layers: service.geocodeLayersAvailable.toList(),
      );
      expect(geocodeData.bbox.length, 2);
      expect(geocodeData.features.length, greaterThan(0));
      final String label = geocodeData.features.first.properties['label']!;
      expect(label.contains(geocodeQueryText), true);
    },
  );
  test(
    'Do a Geocode Autocomplete query using [geocodeAutoCompleteGet], for all layers.',
    () async {
      final GeoJsonFeatureCollection geocodeData =
          await service.geocodeAutoCompleteGet(
        text: geocodeQueryText,
        layers: service.geocodeLayersAvailable.toList(),
      );
      expect(geocodeData.bbox.length, 2);
      expect(geocodeData.features.length, greaterThan(0));
      final String label = geocodeData.features.first.properties['label']!;
      expect(label.contains(geocodeQueryText), true);
    },
  );
  test(
    'Do a Geocode Structured Search using [geocodeSearchStructuredGet], for all layers.',
    () async {
      final GeoJsonFeatureCollection geocodeData =
          await service.geocodeSearchStructuredGet(
        locality: geocodeLocalityQueryText,
        layers: service.geocodeLayersAvailable.toList(),
      );
      expect(geocodeData.bbox.length, 2);
      expect(geocodeData.features.length, greaterThan(0));
      final String label = geocodeData.features.first.properties['label']!;
      expect(label.contains(geocodeLocalityQueryText), true);
    },
  );
  test(
    'Do a Reverse Geocode using [geocodeReverseGet], for all layers.',
    () async {
      final GeoJsonFeatureCollection reverseGeocodeData =
          await service.geocodeReverseGet(
        point: geocodeReversePoint,
        layers: service.geocodeLayersAvailable.toList(),
      );
      expect(reverseGeocodeData.bbox.length, 2);
      expect(reverseGeocodeData.features.length, greaterThan(0));
      final String label =
          reverseGeocodeData.features.first.properties['locality']!;
      expect(label.contains(reverseGeocodeQueryLocality), true);
    },
  );
  test(
    'Cross-validate geocode [geocodeSearchStructuredGet] and reverse geocode [geocodeReverseGet]',
    () async {
      // First geocode geocodeLocalityQueryText with [geocodeSearchStructuredGet]
      final GeoJsonFeatureCollection geocodeData =
          await service.geocodeSearchStructuredGet(
        locality: geocodeLocalityQueryText,
        layers: service.geocodeLayersAvailable.toList(),
      );
      final ORSCoordinate geocodedCoordinate =
          geocodeData.features.first.geometry.coordinates.first.first;

      // Now, reverse geocode the coordinate received
      // from geocoding geocodeLocalityQueryText.
      final GeoJsonFeatureCollection reverseGeocodeData =
          await service.geocodeReverseGet(
        point: geocodedCoordinate,
        layers: service.geocodeLayersAvailable.toList(),
      );
      final String reverseGeocodedLocality =
          reverseGeocodeData.features.first.properties['locality']!;

      // The reverseGeocodedLocality should be similar to originally geocoded
      // geocodeLocalityQueryText from which we extracted the coordinate.
      expect(reverseGeocodedLocality.contains(geocodeLocalityQueryText), true);
    },
  );
}
