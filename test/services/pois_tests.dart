import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

void poisTests({
  required OpenRouteService service,
  required Coordinate boundingBoxStart,
  required Coordinate boundingBoxEnd,
}) {
  test(
    'Get POIs Data using geometry using [poisDataPostGet]',
    () async {
      try {
        final PoisData poisData = await service.poisDataPostGet(
          request: 'pois',
          geometry: {
            "bbox": <List<double>>[
              boundingBoxStart.toList(),
              boundingBoxEnd.toList(),
            ],
            "geojson": {
              "type": "Point",
              "coordinates": boundingBoxStart.toList(),
            },
            "buffer": 200
          },
        );
        expect(poisData.features.length, greaterThan(0));
      } on ORSException catch (e) {
        if (e.uri!.path.contains('pois')) {
          print('POIs Endpoint Server failure! But package should be working!');
          return;
        } else {
          rethrow;
        }
      }
    },
  );
}
