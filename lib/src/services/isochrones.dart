part of 'package:open_route_service/src/open_route_service_base.dart';

extension ORServiceIsochrones on OpenRouteService {
  String get _isochronesEndpointURL => '$_baseUrl/v2/isochrones';

  /// Obtain Isochrone (areas of reachability) Data for the [locations] given
  /// as a [List] of [ORSCoordinate].
  ///
  /// The Isochrone Service supports time and distance analysis for one single
  /// or multiple locations.
  ///
  /// You may also specify the isochrone interval or provide multiple exact
  /// isochrone range values.
  ///
  /// The isochrone service supports the following [attributes]: 'area',
  /// 'reachfactor', 'total_pop'.
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/v2/isochrones/{profile}/post
  Future<GeoJsonFeatureCollection> isochronesPost({
    required List<ORSCoordinate> locations,
    required List<int> range,
    List<String> attributes = const <String>[],
    String? id,
    bool intersections = false,
    int? interval,
    String locationType = 'start',
    Map<String, dynamic>? options,
    String rangeType = 'time',
    int? smoothing,
    String areaUnits = 'm',
    String units = 'm',
    ORSProfile? profileOverride,
  }) async {
    // If a path parameter override is provided, use it.
    final ORSProfile chosenPathParam = profileOverride ?? _defaultProfile;

    // Build the request URL.
    final Uri uri =
        Uri.parse('$_isochronesEndpointURL/${chosenPathParam.name}');

    // Ready data to be sent.
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'locations': locations
          .map<List<double>>(
            (ORSCoordinate coordinate) => coordinate.toList(),
          )
          .toList(),
      'range': range,
      'attributes': attributes,
      'id': id,
      'intersections': intersections,
      'interval': interval,
      'location_type': locationType,
      'options': options,
      'range_type': rangeType,
      'smoothing': smoothing,
      'area_units': areaUnits,
      'units': units,
    }..removeWhere((String _, dynamic value) => value == null);

    // Fetch and parse the data.
    final Map<String, dynamic> data =
        await _openRouteServicePost(uri: uri, data: queryParameters);
    return GeoJsonFeatureCollection.fromJson(data);
  }
}
