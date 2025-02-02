import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_route_service/src/exceptions/base.dart';
import 'package:open_route_service/src/exceptions/matrix.dart';
import 'package:open_route_service/src/exceptions/pois.dart';

import 'package:open_route_service/src/models/coordinate_model.dart';
import 'package:open_route_service/src/models/direction_data_models.dart';
import 'package:open_route_service/src/models/elevation_data_models.dart';
import 'package:open_route_service/src/models/geojson_feature_models.dart';
import 'package:open_route_service/src/models/matrix_data_models.dart';
import 'package:open_route_service/src/models/optimization_models/optimization_data_models.dart';
import 'package:open_route_service/src/models/optimization_models/vroom_data_models.dart';
import 'package:open_route_service/src/models/pois_data_models.dart';

part 'package:open_route_service/src/models/ors_profile_enum.dart';
part 'package:open_route_service/src/services/directions.dart';
part 'package:open_route_service/src/services/elevation.dart';
part 'package:open_route_service/src/services/geocode.dart';
part 'package:open_route_service/src/services/isochrones.dart';
part 'package:open_route_service/src/services/matrix.dart';
part 'package:open_route_service/src/services/optimization.dart';
part 'package:open_route_service/src/services/pois.dart';

/// Class encapsulating all the OpenRoute Service APIs and parsing their
/// responses into relevant data models that can be easily integrated into any
/// Dart/Flutter application.
///
/// Initialize the class with your API key [String] and optionally the
/// [ORSProfile], then use the methods to get the data you need.
///
/// Implemented OpenRoute APIs include:
/// - Directions: [ORSDirections]
/// - Elevation: [ORSElevation]
/// - Geocoding: [ORSGeocode]
/// - Isochrones: [ORServiceIsochrones]
/// - Matrix: [ORSMatrix]
/// - Optimization: [ORSOptimization]
/// - POIs: [ORSPois]
///
/// The API documentation can be found here:
/// https://openrouteservice.org/dev/#/api-docs
class OpenRouteService {
  /// Constructor.
  ///
  /// - [apiKey]: API key for authentication.
  /// - [baseUrl]: Base URL of the endpoints (defaults to [defaultBaseUrl]).
  /// - [client]: Optional HTTP client; if not provided, a new instance is created.
  /// - [defaultProfile]: Default routing profile.
  OpenRouteService({
    required String apiKey,
    String baseUrl = OpenRouteService.defaultBaseUrl,
    http.Client? client,
    ORSProfile defaultProfile = ORSProfile.footWalking,
  })  : _apiKey = apiKey,
        _baseUrl = baseUrl,
        _defaultProfile = defaultProfile {
    // Initialize HTTP client if not provided.
    _client = client ?? http.Client();
  }

  /// API key used for authentication.
  final String _apiKey;

  /// The base URL of all the endpoints.
  /// Defaults to [defaultBaseUrl].
  final String _baseUrl;

  /// HTTP Client used to persistently make the request.
  late final http.Client _client;

  /// The path parameter determines the routing method.
  final ORSProfile _defaultProfile;

  /// The default base URL of all the endpoints, https://api.openrouteservice.org
  static const String defaultBaseUrl = 'https://api.openrouteservice.org';

  /// Allows closing the HTTP client when done.
  void close() {
    _client.close();
  }

  /// Performs a GET request on the OpenRouteService API endpoint.
  ///
  /// - [uri]: The full URI for the API call.
  ///
  /// Returns a [Future] which resolves with the decoded response body.
  /// Throws an [ORSHttpException] if the request fails.
  Future<dynamic> _openRouteServiceGet({required Uri uri}) async {
    // Fetch the data.
    final http.Response response = await _client.get(uri);
    return _extractDecodedResponse(response, uri);
  }

  /// Performs a POST request on the OpenRouteService API endpoint.
  ///
  /// - [uri]: The full URI for the API call.
  /// - [data]: Request body to be sent in JSON format.
  ///
  /// Returns a [Future] which resolves with the decoded response body.
  /// Throws an [ORSHttpException] if the request fails.
  Future<dynamic> _openRouteServicePost({
    required Uri uri,
    required Map<String, dynamic> data,
  }) async {
    // Fetch the data.
    final http.Response response = await _client.post(
      uri,
      body: jsonEncode(data),
      headers: <String, String>{
        'Accept':
            'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
        'Authorization': _apiKey,
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    return _extractDecodedResponse(response, uri);
  }

  /// Extracts and returns the decoded response.
  ///
  /// - [response]: The HTTP response.
  ///
  /// Returns the decoded response body if the status code is 2xx.
  /// Throws an [ORSHttpException] if the status code is not 2xx.
  Future<dynamic> _extractDecodedResponse(http.Response response, Uri uri) {
    final dynamic parsedResponse = _parseResponse(response, uri);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return parsedResponse;
    } else {
      throw ORSHttpException(
        uri: uri,
        statusCode: response.statusCode,
        errorResponse: parsedResponse,
      );
    }
  }

  /// Parses the HTTP [response] based on its content type.
  ///
  /// - [response]: The HTTP response.
  ///
  /// Returns parsed JSON if the response contains 'application/json', otherwise the raw body.
  /// Throws an [ORSParsingException] if parsing fails.
  dynamic _parseResponse(http.Response response, Uri uri) {
    try {
      final String contentType = response.headers['content-type'] ?? '';
      return contentType.contains('application/json')
          ? jsonDecode(response.body)
          : response.body;
    } catch (e, trace) {
      throw ORSParsingException(
        uri: uri,
        cause: e is Exception ? e : Exception(e.toString()),
        causeStackTrace: trace,
      );
    }
  }
}
