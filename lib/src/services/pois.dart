part of 'package:open_route_service/src/open_route_service_base.dart';

extension ORSPois on OpenRouteService {
  /// The endpoint of the openrouteservice Directions API.
  String get _poisEndpointURL => '$_baseUrl/pois';

  /// Fetches the information about the Points of Interest (POI) in the area
  /// surrounding a geometry which can either be a bounding box, polygon
  /// or buffered linestring or point.
  ///
  /// [request] should be 'pois', 'stats' or 'list'. Throws an [ArgumentError]
  /// otherwise.
  ///
  /// The [geometry] object is a geojson or a bounding box object,
  /// optionally buffered.
  ///
  /// The [filters] are Filters in terms of osm_tags which should be applied
  /// to the query.
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/pois/post
  Future<PoisData> poisDataPost({
    required String request,
    Object? geometry,
    Object? filters,
    int? limit,
    String? sortBy,
  }) async {
    // Validate [request]
    if (request != 'pois' && request != 'stats' && request != 'list') {
      throw ArgumentError.value(
        request,
        'request',
        'Must be one of "pois", "stats" or "list"',
      );
    }

    // Build the request URL.
    final Uri uri = Uri.parse(_poisEndpointURL);

    // Ready data to be sent.
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'request': request,
      'geometry': geometry,
      'filters': filters,
      'limit': limit,
      'sortBy': sortBy,
    }..removeWhere((String _, dynamic value) => value == null);

    // Fetch the data and parse it.
    final dynamic data =
        await _openRouteServicePost(uri: uri, data: queryParameters);

    if (data is Map && data.isEmpty) {
      throw ORSException(
        'Empty POIs data received. Check if ORS POIs endpoint is working! '
        'If endpoint is working, your input might be faulty!',
        uri: uri,
      );
    } else if (data is List) {
      return PoisData.fromJson(data.first);
    } else {
      return PoisData.fromJson(data);
    }
  }
}
