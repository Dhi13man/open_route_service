import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

void geocodeTests({
  required OpenRouteService service,
  String geocodeText = 'Namibian Brewery',
}) {
  test(
    'Do a Geocode Search using GET method [geocodeSearch]',
    () async {
      final GeoJsonFeatureCollection geocodeData = await service.geocodeSearch(
        text: geocodeText,
      );
      expect(geocodeData.bbox.length, 2);
      expect(geocodeData.features.length, greaterThan(0));
      final String? label = geocodeData.features.first.properties['label'];
      expect(label!.contains(geocodeText), true);
    },
  );
  test(
    'Do a Geocode Search using GET method [geocodeSearch], for all layers.',
    () async {
      final GeoJsonFeatureCollection geocodeData = await service.geocodeSearch(
        text: 'Namibian Brewery',
        layers: service.geocodeLayersAvailable.toList(),
      );
      expect(geocodeData.bbox.length, 2);
      expect(geocodeData.features.length, greaterThan(0));
      final String? label = geocodeData.features.first.properties['label'];
      expect(label!.contains(geocodeText), true);
    },
  );
}
