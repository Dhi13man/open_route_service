part of 'package:open_route_service/src/open_route_service_base.dart';

extension ORSMatrix on OpenRouteService {
  /// The endpoint of the openrouteservice Matrix API.
  static const String _matrixEndpointURL =
      '${OpenRouteService._baseURL}/v2/matrix';

  /// Returns duration, distance matrix for multiple source, destination points.
  ///
  /// [destinations] and [sources] are a list of [int] indices that represent
  /// which [locations] coordinates need to be considered for destinations and
  /// sources respectively.
  ///
  /// By default a square duration matrix is returned where every point in
  /// locations is paired with each other.
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/v2/matrix/{profile}/post
  Future<TimeDistanceMatrix> matrixPostGet({
    required List<Coordinate> locations,
    List<int>? destinations,
    String? id,
    List<String> metrics = const <String>['duration'],
    List<dynamic>? metricsStrings,
    bool resolveLocations = false,
    List<int>? sources,
    String units = 'm',
    ORSProfile? profileOverride,
  }) async {
    // If a path parameter override is provided, use it.
    final ORSProfile chosenPathParam = profileOverride ?? _profile;

    // Build the request URL.
    final Uri uri = Uri.parse(
      '$_matrixEndpointURL/${OpenRouteService.getProfileString(chosenPathParam)}',
    );

    // Ready data to be sent.
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'locations': locations
          .map<List<double>>(
            (Coordinate coordinate) =>
                <double>[coordinate.longitude, coordinate.latitude],
          )
          .toList(),
      'destinations': destinations,
      'id': id,
      'metrics': metrics,
      'metricsStrings': metricsStrings,
      'resolve_locations': resolveLocations,
      'sources': sources,
      'units': units,
    }..removeWhere((String _, dynamic value) => value == null);

    // Fetch the data.
    try {
      final Map<String, dynamic> data =
          await _openRouteServicePost(uri: uri, data: queryParameters);
      return TimeDistanceMatrix.fromJson(data);
    } on FormatException catch (e) {
      throw ORSException(
        '$e; Matrix value can\'t be determined for given inputs, as per '
        'https://openrouteservice.org/dev/#/api-docs/v2/matrix/{profile}/post',
        uri: uri,
      );
    } on TypeError catch (e) {
      throw ORSException(
        '$e; Matrix value can\'t be determined for given inputs, as per '
        'https://openrouteservice.org/dev/#/api-docs/v2/matrix/{profile}/post',
        uri: uri,
      );
    }
  }
}
