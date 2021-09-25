part of 'package:open_route_service/src/open_route_service_base.dart';

extension OpenRouteServiceDirections on OpenRouteService {
  /// The endpoint of the OpenRouteService API.
  static const String _directionsEndpointURL =
      'https://api.openrouteservice.org/v2/directions/';

  /// Fetches the Direction Route coordinates for the route between
  /// [startCoordinate] and [endCoordinate] from the OpenRouteService API, and
  /// parses it to a list of [Coordinate] objects.
  ///
  /// If [shouldParse] is true, the coordinates will be parsed to a list of
  /// [Coordinate] objects. Otherwise, the entire response object will be
  /// returned.
  ///
  /// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/get
  Future<dynamic> getRouteCoordinates({
    required Coordinate startCoordinate,
    required Coordinate endCoordinate,
    String? pathParameterOverride,
    bool shouldParse = true,
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

    // Fetch and parse the data.
    dynamic unparsedOutput = await _openRouteServiceGet(uri: uri);
    return shouldParse
        ? _parseRouteCoordinates(unparsedOutput)
        : unparsedOutput;
  }

  /// Fetches the Direction Route coordinates for the route connecting the
  /// various [coordinates] from the OpenRouteService API, and then parses
  /// it to a list of [Coordinate] objects.
  ///
  /// If [shouldParse] is true, the coordinates will be parsed to a list of
  /// [Coordinate] objects. Otherwise, the entire response object will be
  /// returned.
  ///
  /// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/geojson/post
  Future<dynamic> getMultiRouteCoordinates({
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
    bool shouldParse = true,
  }) async {
    // If a path parameter override is provided, use it.
    final String chosenPathParam = pathParameterOverride ?? _pathParam;
    _checkIfValidPathParameter(chosenPathParam);

    // Extract coordinate information.

    // Build the request URL.
    final Uri uri =
        Uri.parse('$_directionsEndpointURL$chosenPathParam/geojson');

    // Fetch and parse the data.
    Map<String, dynamic> sendData = <String, dynamic>{
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

    // Fetch and parse the data.
    dynamic unparsedOutput =
        await _openRouteServicePost(uri: uri, data: sendData);
    return shouldParse
        ? _parseRouteCoordinates(unparsedOutput)
        : unparsedOutput;
  }

  /// Parses the response from the OpenRouteService API and returns a list of
  /// [Coordinate] objects to be used to draw a polyline on the map.
  List<Coordinate> _parseRouteCoordinates(dynamic responseBody) {
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
        .map<Coordinate>((linePoint) => Coordinate(linePoint[1], linePoint[0]))
        .toList();
  }
}
