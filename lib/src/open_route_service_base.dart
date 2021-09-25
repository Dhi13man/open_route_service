import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_route_service/src/models/basic_models.dart';

export 'package:open_route_service/src/models/basic_models.dart';

part 'package:open_route_service/src/services/directions.dart';
part 'package:open_route_service/src/services/elevation.dart';
part 'package:open_route_service/src/services/geocode.dart';
part 'package:open_route_service/src/services/isochrones.dart';
part 'package:open_route_service/src/services/matrix.dart';
part 'package:open_route_service/src/services/optimization.dart';
part 'package:open_route_service/src/services/pois.dart';

/// This class is used to fetch the data from the OpenRouteService API
/// and parse it to a list of [Coordinate] objects which can be used to draw
/// a polyline on the map.
///
/// The API documentation can be found here:
/// https://openrouteservice.org/dev/#/api-docs
class OpenRouteService {
  OpenRouteService({
    required String apiKey,
    String pathParam = 'foot-walking',
  })  : _apiKey = apiKey,
        _pathParam = pathParam {
    _checkIfValidPathParameter(pathParam);
    // Initialize HTTP client
    _client = http.Client();
  }

  /// The API key used to authenticate the request.
  final String _apiKey;

  /// The path parameter determines the routing method.
  String _pathParam;

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

  /// HTTP Client used to persistently make the request.
  late http.Client _client;

  /// Get current path parameter.
  String get pathParam => _pathParam;

  /// Change the path parameter.
  set setPathParam(String newPathParam) {
    _checkIfValidPathParameter(newPathParam);
    _pathParam = newPathParam;
  }

  /// Checks if the given [pathParam] is supported by the API.
  /// If not, an [ArgumentError] is thrown.
  void _checkIfValidPathParameter(String pathParam) {
    if (!supportedPathParams.contains(pathParam)) {
      throw ArgumentError.value(
        pathParam,
        'pathParam',
        'pathParam must be one of ${supportedPathParams.join(', ')}',
      );
    }
  }

  /// Performs a GET request on the OpenRouteService API endpoint [uri].
  ///
  /// Returns a [Future] that resolves to json-decoded [http.Response] object body.
  /// Throws an [HttpException] if the request fails.
  Future<dynamic> _openRouteServiceGet({required Uri uri}) async {
    // Fetch the data.
    final http.Response response = await _client.get(uri);
    // Check if the request was successful.
    if (response.statusCode == 200) {
      final String data = response.body;
      return jsonDecode(data);
    } else {
      final dynamic errorData = jsonDecode(response.body);
      throw HttpException(
        'Failed! Status: ${errorData['error']} Code: ${response.statusCode}',
        uri: uri,
      );
    }
  }

  /// Performs a POST request on the OpenRouteService API endpoint [uri] with
  /// the given [data] and [headers].
  ///
  /// Returns a [Future] that resolves to json-decoded [http.Response] object body.
  /// Throws an [HttpException] if the request fails.
  Future<dynamic> _openRouteServicePost({
    required Uri uri,
    required Map<String, dynamic> data,
  }) async {
    // Fetch the data.
    final http.Response response = await _client.post(
      uri,
      body: jsonEncode(data),
      headers: {
        'Accept':
            'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
        'Authorization': _apiKey,
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    // Check if the request was successful.
    if (response.statusCode == 200) {
      final String data = response.body;
      return jsonDecode(data);
    } else {
      final dynamic errorData = jsonDecode(response.body);
      throw HttpException(
        'Failed! Status: ${errorData['error']} Code: ${response.statusCode}',
        uri: uri,
      );
    }
  }
}
