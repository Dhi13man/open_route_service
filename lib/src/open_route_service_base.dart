import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_route_service/src/models/basic_models.dart';

export 'package:open_route_service/src/models/basic_models.dart';

/// This class is used to fetch the data from the OpenRouteService API
/// and parse it to a list of [Coordinate] objects which can be used to draw
/// a polyline on the map.
///
/// The API documentation can be found here:
/// https://openrouteservice.org/dev/#/api-docs
class OpenRouteService {
  OpenRouteService({
    required String apiKey,
    this.pathParam = 'foot-walking',
  }) : _apiKey = apiKey {
    if (!supportedPathParams.contains(pathParam)) {
      throw ArgumentError.value(
        pathParam,
        'pathParam',
        'pathParam must be one of ${supportedPathParams.join(', ')}',
      );
    }
  }

  /// The API key used to authenticate the request.
  final String _apiKey;

  /// The endpoint of the OpenRouteService API.
  static const String _directionsEndpointURL =
      'https://api.openrouteservice.org/v2/directions/';

  /// The path parameter determines the routing method.
  final String pathParam;

  /// Supported path parameters for the OpenRouteService API.
  static const List<String> supportedPathParams = [
    'driving-car',
    'driving-hgv',
    'cycling-road',
    'cycling-mountain',
    'cycling-electric',
    'foot-walking',
    'foot-hiking',
    'wheelchair',
  ];

  /// Fetches the data from the OpenRouteService API and parses it to a list
  /// of [Coordinate] objects.
  Future<List<Coordinate>> getRouteCoordinates({
    required Coordinate startCoordinate,
    required Coordinate endCoordinate,
    String? pathParameterOverride,
  }) async {
    // If a path parameter override is provided, use it.
    final String chosenPathParam = pathParameterOverride ?? pathParam;
    
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
    final http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      final String data = response.body;
      return _parseResponse(jsonDecode(data));
    } else {
      final dynamic errorData = jsonDecode(response.body);
      throw HttpException(
        'Failed to load data. Status: ${errorData['error']} Code: ${response.statusCode}',
        uri: uri,
      );
    }
  }

  /// Parses the response from the OpenRouteService API and returns a list of
  /// [Coordinate] objects to be used to draw a polyline on the map.
  List<Coordinate> _parseResponse(dynamic responseBody) {
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
