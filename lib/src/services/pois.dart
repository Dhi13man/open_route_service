part of 'package:open_route_service/src/open_route_service_base.dart';

extension ORSPois on OpenRouteService {
  /// The endpoint of the OpenRouteService Directions API.
  static const String _poisEndpointURL = '${OpenRouteService._baseURL}/pois';

  /// Fetches the information about the Points of Interest (POI) in the area
  /// surrounding a geometry which can either be a bounding box, polygon
  /// or buffered linestring or point.
  ///
  /// The [geometry] object is a geojson or a bounding box object,
  /// optionally buffered.
  ///
  /// The [filters] are Filters in terms of osm_tags which should be applied
  /// to the query.
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/pois/post
  Future<PoisData> getPOIsData({
    required String request,
    Object? geometry,
    Object? filters,
    int? limit,
    String? sortBy,
  }) async {
    // Build the request URL.
    final Uri uri = Uri.parse(_poisEndpointURL);

    // Ready data to be sent.
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'request': request,
      'geometry': geometry,
      'filters': filters,
      'limit': limit,
      'sortBy': sortBy,
    }..removeWhere((key, value) => value == null);

    // Fetch the data and parse it.
    final dynamic data =
        await _openRouteServicePost(uri: uri, data: queryParameters);

    if (data is List) {
      return PoisData.fromJson(data.first);
    } else {
      return PoisData.fromJson(data);
    }
  }
}
