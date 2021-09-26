import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

double percentageError(double a, double b) {
  return (a - b).abs() / a * 100;
}

void isochronesTests({
  required OpenRouteService service,
  required List<Coordinate> coordinates,
}) {
  test(
    'Fetch Isochrone Data using [getIsochrones]',
    () async {
      final IsochroneData isochroneData = await service.getIsochrones(
        locations: coordinates,
        range: <int>[300, 200],
      );
      expect(isochroneData.bbox.length, 2);
      expect(isochroneData.features.length, greaterThan(0));
      expect(isochroneData.features.first.properties.groupIndex, 0);
    },
  );
}
