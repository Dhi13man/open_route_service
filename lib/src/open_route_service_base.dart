import 'dart:convert';

import 'package:http/http.dart' as http;

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

  /// The API key used to authenticate the request.
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

  /// Performs a GET request on the OpenRouteService API endpoint [uri].
  ///
  /// Returns [Future] that resolves to json-decoded [http.Response] object body
  ///
  /// Throws an [HttpException] if the request fails.
  Future<dynamic> _openRouteServiceGet({required Uri uri}) async {
    // Fetch the data.
    final http.Response response = await _client.get(uri);
    // Check if the request was successful.
    if (response.statusCode / 100 == 2) {
      final String data = response.body;
      return jsonDecode(data);
    } else {
      final dynamic errorData = jsonDecode(response.body);
      throw ORSException(
        'Status: ${errorData['error'] ?? errorData} '
        'Code: ${response.statusCode}',
        uri: uri,
      );
    }
  }

  /// Performs a POST request on the OpenRouteService API endpoint [uri] with
  /// the given [data] and [headers].
  ///
  /// Returns [Future] that resolves to json-decoded [http.Response] object body
  ///
  /// Throws an [HttpException] if the request fails.
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
    // Check if the request was successful.
    if (response.statusCode / 100 == 2) {
      final String data = response.body;
      return jsonDecode(data);
    } else {
      final dynamic errorData = jsonDecode(response.body);
      throw ORSException(
        'Status: ${errorData['error'] ?? errorData} '
        'Code: ${response.statusCode}',
        uri: uri,
      );
    }
  }
}

/// Custom Exception class for this package that contains the [message] of the
/// error, and the [uri] of the failed request (if any).
class ORSException implements Exception {
  @pragma('vm:entry-point')
  const ORSException(this.message, {this.uri}) : super();

  /// The message of the error.
  final String message;

  /// The uri of the failed request.
  final Uri? uri;

  @override
  String toString() => 'OpenRouteServiceException: $message, at url $uri';
}
