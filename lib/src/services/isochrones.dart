part of 'package:open_route_service/src/open_route_service_base.dart';

extension OpenRouteServiceIsochrones on OpenRouteService {
  String get isochronesUrl => '${OpenRouteService._baseURL}/v2/isochrones';

  /// Obtain Isochrones (areas of reachability) from given locations as [List]
  /// of [Coordinate].
  Future<void> getIsochrones() async {}
}
