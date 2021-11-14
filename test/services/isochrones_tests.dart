import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

void isochronesTests({
  required OpenRouteService service,
  required List<ORSCoordinate> coordinates,
}) {
  test(
    'Fetch Isochrone Data using [isochronesGet]',
    () async {
      final GeoJsonFeatureCollection isochroneData = await service
          .isochronesPost(locations: coordinates, range: <int>[300, 200]);
      expect(isochroneData.bbox.length, 2);
      expect(isochroneData.features.length, greaterThan(0));
      expect(isochroneData.features.first.properties['group_index'], 0);
    },
  );
}
