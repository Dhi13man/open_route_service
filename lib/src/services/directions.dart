part of 'package:open_route_service/src/open_route_service_base.dart';

extension ORSDirections on OpenRouteService {
  /// The endpoint of the openrouteservice Directions API.
  String get _directionsEndpointURL => '$_baseUrl/v2/directions';

  /// Fetches the Direction Route information for the route between
  /// [startCoordinate] and [endCoordinate] from the openrouteservice API,
  /// and returns the entire geojson [GeoJsonFeatureCollection] containing data.
  ///
  /// To get only the parsed route coordinates,
  /// use [ORSDirections.directionsRouteCoordsGet].
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/get
  Future<GeoJsonFeatureCollection> directionsRouteGeoJsonGet({
    required ORSCoordinate startCoordinate,
    required ORSCoordinate endCoordinate,
    ORSProfile? profileOverride,
  }) async {
    // If a path parameter override is provided, use it.
    final ORSProfile chosenPathParam = profileOverride ?? _defaultProfile;

    // Extract coordinate information.
    final double startLat = startCoordinate.latitude;
    final double startLng = startCoordinate.longitude;
    final double endLat = endCoordinate.latitude;
    final double endLng = endCoordinate.longitude;

    // Build the request URL.
    final Uri uri = Uri.parse(
      '$_directionsEndpointURL/${chosenPathParam.name}?api_key=$_apiKey&start=$startLng,$startLat&end=$endLng,$endLat',
    );

    // Fetch the data.
    final Map<String, dynamic> data = await _openRouteServiceGet(uri: uri);
    return GeoJsonFeatureCollection.fromJson(data);
  }

  /// Fetches the Direction Route information for the route between
  /// [startCoordinate] and [endCoordinate] from the openrouteservice API, and
  /// parses it's coordinates to a [List] of [ORSCoordinate] objects.
  ///
  /// To return the entire [GeoJsonFeatureCollection] containing the response
  /// data, use [ORSDirections.directionsRouteGeoJsonGet].
  ///
  /// Information about the endpoint and all the parameters can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/get
  Future<List<ORSCoordinate>> directionsRouteCoordsGet({
    required ORSCoordinate startCoordinate,
    required ORSCoordinate endCoordinate,
    ORSProfile? profileOverride,
  }) async {
    // Fetch and parse the data.
    final GeoJsonFeatureCollection featureCollection =
        await directionsRouteGeoJsonGet(
      startCoordinate: startCoordinate,
      endCoordinate: endCoordinate,
      profileOverride: profileOverride,
    );
    return featureCollection.features.first.geometry.coordinates.first;
  }

  /// Fetches the Direction Route information for the route connecting the
  /// various [coordinates] from the openrouteservice API, and returns the
  /// entire geojson [GeoJsonFeatureCollection] containing the response data.
  ///
  /// To get only the parsed route coordinates,
  /// use [ORSDirections.directionsMultiRouteCoordsPost].
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/geojson/post
  Future<GeoJsonFeatureCollection> directionsMultiRouteGeoJsonPost({
    required List<ORSCoordinate> coordinates,
    Object? alternativeRoutes,
    List<String>? attributes,
    bool continueStraight = false,
    bool? elevation,
    List<String>? extraInfo,
    bool geometrySimplify = false,
    String? id,
    bool instructions = true,
    String instructionsFormat = 'text',
    String language = 'en',
    bool maneuvers = false,
    Object? options,
    String preference = 'recommended',
    List<int>? radiuses,
    bool roundaboutExits = false,
    List<int>? skipSegments,
    bool suppressWarnings = false,
    String units = 'm',
    bool geometry = true,
    int? maximumSpeed,
    ORSProfile? profileOverride,
  }) async {
    // If a path parameter override is provided, use it.
    final ORSProfile chosenPathParam = profileOverride ?? _defaultProfile;

    // Build the request URL.
    final Uri uri =
        Uri.parse('$_directionsEndpointURL/${chosenPathParam.name}/geojson');

    // Ready data to be sent.
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'coordinates': coordinates
          .map<List<double>>(
            (ORSCoordinate coordinate) =>
                <double>[coordinate.longitude, coordinate.latitude],
          )
          .toList(),
      'alternative_routes': alternativeRoutes,
      'attributes': attributes,
      'continue_straight': continueStraight,
      'elevation': elevation,
      'extra_info': extraInfo,
      'geometry_simplify': geometrySimplify,
      'id': id,
      'instructions': instructions,
      'instructions_format': instructionsFormat,
      'language': language,
      'maneuvers': maneuvers,
      'options': options,
      'preference': preference,
      'radiuses': radiuses,
      'roundabout_exits': roundaboutExits,
      'skip_segments': skipSegments,
      'suppress_warnings': suppressWarnings,
      'units': units,
      'geometry': geometry,
      'maximum_speed': maximumSpeed,
    }..removeWhere((String _, dynamic value) => value == null);

    // Fetch the data.
    final Map<String, dynamic> data =
        await _openRouteServicePost(uri: uri, data: queryParameters);
    return GeoJsonFeatureCollection.fromJson(data);
  }

  /// Fetches the Direction Route information for the route connecting the
  /// various given [coordinates], from the openrouteservice API, and then
  /// parses it's coordinates to a [List] of [ORSCoordinate] objects.
  ///
  /// To return the entire [GeoJsonFeatureCollection] containing the response
  /// data, use [ORSDirections.directionsRouteGeoJsonGet].
  ///
  /// Information about the endpoint and all the parameters can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/geojson/post
  Future<List<ORSCoordinate>> directionsMultiRouteCoordsPost({
    required List<ORSCoordinate> coordinates,
    Object? alternativeRoutes,
    List<String>? attributes,
    bool continueStraight = false,
    bool? elevation,
    List<String>? extraInfo,
    bool geometrySimplify = false,
    String? id,
    bool instructions = true,
    String instructionsFormat = 'text',
    String language = 'en',
    bool maneuvers = false,
    Object? options,
    String preference = 'recommended',
    List<int>? radiuses,
    bool roundaboutExits = false,
    List<int>? skipSegments,
    bool suppressWarnings = false,
    String units = 'm',
    bool geometry = true,
    int? maximumSpeed,
    ORSProfile? profileOverride,
  }) async {
    // Fetch and parse the data.
    final GeoJsonFeatureCollection featureCollection =
        await directionsMultiRouteGeoJsonPost(
      coordinates: coordinates,
      alternativeRoutes: alternativeRoutes,
      attributes: attributes,
      continueStraight: continueStraight,
      elevation: elevation,
      extraInfo: extraInfo,
      geometrySimplify: geometrySimplify,
      id: id,
      instructions: instructions,
      instructionsFormat: instructionsFormat,
      language: language,
      maneuvers: maneuvers,
      options: options,
      preference: preference,
      radiuses: radiuses,
      roundaboutExits: roundaboutExits,
      skipSegments: skipSegments,
      suppressWarnings: suppressWarnings,
      units: units,
      geometry: geometry,
      maximumSpeed: maximumSpeed,
      profileOverride: profileOverride,
    );
    return featureCollection.features.first.geometry.coordinates.first;
  }

  /// Fetches the Direction Route information for the route connecting the
  /// various [coordinates] from the openrouteservice API, and returns the
  /// entire geojson [DirectionRouteData] containing the response data.
  ///
  /// To get the geojson [GeoJsonFeatureCollection] containing the response
  /// data, use [ORSDirections.directionsMultiRouteGeoJsonPost].
  ///
  /// To get only the parsed route coordinates,
  /// use [ORSDirections.directionsMultiRouteCoordsPost].
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/post
  Future<List<DirectionRouteData>> directionsMultiRouteDataPost({
    required List<ORSCoordinate> coordinates,
    Object? alternativeRoutes,
    List<String>? attributes,
    bool continueStraight = false,
    bool? elevation,
    List<String>? extraInfo,
    bool geometrySimplify = false,
    String? id,
    bool instructions = true,
    String instructionsFormat = 'text',
    String language = 'en',
    bool maneuvers = false,
    Object? options,
    String preference = 'recommended',
    List<int>? radiuses,
    bool roundaboutExits = false,
    List<int>? skipSegments,
    bool suppressWarnings = false,
    String units = 'm',
    bool geometry = true,
    int? maximumSpeed,
    ORSProfile? profileOverride,
  }) async {
    // If a path parameter override is provided, use it.
    final ORSProfile chosenPathParam = profileOverride ?? _defaultProfile;

    // Build the request URL.
    final Uri uri =
        Uri.parse('$_directionsEndpointURL/${chosenPathParam.name}');

    // Ready data to be sent.
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'coordinates': coordinates
          .map<List<double>>(
            (ORSCoordinate coordinate) =>
                <double>[coordinate.longitude, coordinate.latitude],
          )
          .toList(),
      'alternative_routes': alternativeRoutes,
      'attributes': attributes,
      'continue_straight': continueStraight,
      'elevation': elevation,
      'extra_info': extraInfo,
      'geometry_simplify': geometrySimplify,
      'id': id,
      'instructions': instructions,
      'instructions_format': instructionsFormat,
      'language': language,
      'maneuvers': maneuvers,
      'options': options,
      'preference': preference,
      'radiuses': radiuses,
      'roundabout_exits': roundaboutExits,
      'skip_segments': skipSegments,
      'suppress_warnings': suppressWarnings,
      'units': units,
      'geometry': geometry,
      'maximum_speed': maximumSpeed,
    }..removeWhere((String _, dynamic value) => value == null);

    // Fetch the data.
    final Map<String, dynamic> data =
        await _openRouteServicePost(uri: uri, data: queryParameters);
    return (data['routes'] as List<dynamic>)
        .map<DirectionRouteData>(
          (dynamic route) => DirectionRouteData.fromJson(route),
        )
        .toList();
  }
}
