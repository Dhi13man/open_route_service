import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

void poisTests({
  required OpenRouteService service,
  required Coordinate boundingBoxStart,
  required Coordinate boundingBoxEnd,
}) {
  test(
    'Get POIs Data using geometry using [getPOIsData]',
    () async {
      final PoisData poisData = await service.getPOIsData(
        request: 'pois',
        geometry: {
          "bbox": [
            <double>[boundingBoxStart.longitude, boundingBoxStart.latitude],
            <double>[boundingBoxEnd.longitude, boundingBoxEnd.latitude],
          ],
          "geojson": {
            "type": "Point",
            "coordinates": <double>[
              boundingBoxStart.longitude,
              boundingBoxStart.latitude,
            ],
          },
          "buffer": 200
        },
      );
      expect(poisData.features.length, greaterThan(0));
    },
  );
}
