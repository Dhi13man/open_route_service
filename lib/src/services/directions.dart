part of 'package:open_route_service/src/open_route_service_base.dart';

extension OpenRouteServiceDirections on OpenRouteService {
  /// The endpoint of the OpenRouteService Directions API.
  static const String _directionsEndpointURL =
      'https://api.openrouteservice.org/v2/directions/';

  /// Fetches the Direction Route coordinates for the route between
  /// [startCoordinate] and [endCoordinate] from the OpenRouteService API,
  /// and directly returns the entire unparsed response object.
  ///
  /// To get only the parsed route coordinates,
  /// use [OpenRouteServiceDirections.getRouteDirections].
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/get
  Future<Map<String, dynamic>> getRouteDirectionsUnparsed({
    required Coordinate startCoordinate,
    required Coordinate endCoordinate,
    String? pathParameterOverride,
  }) async {
    // If a path parameter override is provided, use it.
    final String chosenPathParam = pathParameterOverride ?? _pathParam;
    _checkIfValidPathParameter(chosenPathParam);

    // Extract coordinate information.
    final double startLat = startCoordinate.latitude;
    final double startLng = startCoordinate.longitude;
    final double endLat = endCoordinate.latitude;
    final double endLng = endCoordinate.longitude;

    // Build the request URL.
    final Uri uri = Uri.parse(
      '$_directionsEndpointURL$chosenPathParam?api_key=$_apiKey&start=$startLng,$startLat&end=$endLng,$endLat',
    );

    // Fetch the data.
    return await _openRouteServiceGet(uri: uri);
  }

  /// Fetches the Direction Route coordinates for the route between
  /// [startCoordinate] and [endCoordinate] from the OpenRouteService API, and
  /// parses it to a [List] of [Coordinate] objects.
  ///
  /// To return the entire unparsed response object,
  /// use [OpenRouteServiceDirections.getRouteDirectionsUnparsed].
  ///
  /// Information about the endpoint and all the parameters can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/get
  Future<List<Coordinate>> getRouteDirections({
    required Coordinate startCoordinate,
    required Coordinate endCoordinate,
    String? pathParameterOverride,
  }) async {
    // Fetch and parse the data.
    final Map<String, dynamic> unparsedOutput =
        await getRouteDirectionsUnparsed(
      startCoordinate: startCoordinate,
      endCoordinate: endCoordinate,
      pathParameterOverride: pathParameterOverride,
    );
    return _parseRouteCoordinates(unparsedOutput);
  }

  /// Fetches the Direction Route info for the route connecting the
  /// various [coordinates] from the OpenRouteService API, and directly returns
  /// the entire unparsed response object.
  ///
  /// To get only the parsed route coordinates,
  /// use [OpenRouteServiceDirections.getMultiRouteDirections].
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/geojson/post
  Future<Map<String, dynamic>> getMultiRouteDirectionsUnparsed({
    required List<Coordinate> coordinates,
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
    String? pathParameterOverride,
  }) async {
    // If a path parameter override is provided, use it.
    final String chosenPathParam = pathParameterOverride ?? _pathParam;
    _checkIfValidPathParameter(chosenPathParam);

    // Build the request URL.
    final Uri uri =
        Uri.parse('$_directionsEndpointURL$chosenPathParam/geojson');

    // Ready data to be sent.
    final Map<String, dynamic> sendData = <String, dynamic>{
      "coordinates": coordinates
          .map<List<double>>(
            (coordinate) => <double>[coordinate.longitude, coordinate.latitude],
          )
          .toList(),
      "alternative_routes": alternativeRoutes,
      "attributes": attributes,
      "continue_straight": continueStraight,
      "elevation": elevation,
      "extra_info": extraInfo,
      "geometry_simplify": geometrySimplify,
      "id": id,
      "instructions": instructions,
      "instructions_format": instructionsFormat,
      "language": language,
      "maneuvers": maneuvers,
      "options": options,
      "preference": preference,
      "radiuses": radiuses,
      "roundabout_exits": roundaboutExits,
      "skip_segments": skipSegments,
      "suppress_warnings": suppressWarnings,
      "units": units,
      "geometry": geometry,
      "maximum_speed": maximumSpeed,
    }..removeWhere((key, value) => value == null);

    // Fetch the data.
    return await _openRouteServicePost(uri: uri, data: sendData);
  }

  /// Fetches the Direction Route coordinates for the route connecting the
  /// various [coordinates] from the OpenRouteService API, and then parses
  /// it to a [List] of [Coordinate] objects.
  ///
  /// To return the entire unparsed response object,
  /// use [OpenRouteServiceDirections.getRouteDirectionsUnparsed].
  ///
  /// Information about the endpoint and all the parameters can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/geojson/post
  Future<List<Coordinate>> getMultiRouteDirections({
    required List<Coordinate> coordinates,
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
    String? pathParameterOverride,
  }) async {
    // Fetch and parse the data.
    final Map<String, dynamic> unparsedOutput =
        await getMultiRouteDirectionsUnparsed(
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
      pathParameterOverride: pathParameterOverride,
    );
    return _parseRouteCoordinates(unparsedOutput);
  }

  /// Parses the response from the OpenRouteService API and returns a [List] of
  /// [Coordinate] objects to be used to draw a polyline on the map.
  List<Coordinate> _parseRouteCoordinates(Map<String, dynamic> responseBody) {
    // For holding coordinates of the route from the response body
    // as primitive list of double pairs.
    final List<dynamic> linePointsRaw =
        responseBody['features'][0]['geometry']['coordinates'];
    // Parse dynamics into proper data types.
    final List<List<double>> linePoints = [];
    for (List<dynamic> unparsedPoints in linePointsRaw) {
      linePoints.add(
        unparsedPoints
            .map<double>((dynamic point) => point.toDouble())
            .toList(),
      );
    }

    // Make a list of [Coordinate] objects from the raw coordinates.
    return linePoints
        .map<Coordinate>(
          (linePoint) =>
              Coordinate(latitude: linePoint[1], longitude: linePoint[0]),
        )
        .toList();
  }
}
