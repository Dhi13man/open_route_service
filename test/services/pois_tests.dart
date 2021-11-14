import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

void poisTests({
  required OpenRouteService service,
  required ORSCoordinate boundingBoxStart,
  required ORSCoordinate boundingBoxEnd,
}) {
  test(
    'Get POIs Data using geometry using [poisDataPostGet]',
    () async {
      try {
        final PoisData poisData = await service.poisDataPost(
          request: 'pois',
          geometry: <String, dynamic>{
            'bbox': <List<double>>[
              boundingBoxStart.toList(),
              boundingBoxEnd.toList(),
            ],
            'geojson': <String, dynamic>{
              'type': 'Point',
              'coordinates': boundingBoxStart.toList(),
            },
            'buffer': 200
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
