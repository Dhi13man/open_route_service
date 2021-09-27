import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:open_route_service/src/models/coordinate_model.dart';
import 'package:open_route_service/src/models/direction_data_models.dart';
import 'package:open_route_service/src/models/elevation_data_models.dart';
import 'package:open_route_service/src/models/feature_data_models.dart';
import 'package:open_route_service/src/models/matrix_data_models.dart';
import 'package:open_route_service/src/models/pois_data_models.dart';

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
    ORSProfile profile = ORSProfile.footWalking,
  })  : _apiKey = apiKey,
        _profile = profile {
    // Initialize HTTP client
    _client = http.Client();
  }

  /// The base URL of all the endpoints, https://api.openrouteservice.org
  static const String _baseURL = 'https://api.openrouteservice.org';

  /// The API key used to authenticate the request.
  final String _apiKey;

  /// The path parameter determines the routing method.
  ORSProfile _profile;

  /// Converts the enum [profile] to a [String] which can be used in API request
  static String getProfileString(ORSProfile profile) {
    switch (profile) {
      case ORSProfile.drivingCar:
        return 'driving-car';

      case ORSProfile.drivingHgv:
        return 'driving-hgv';

      case ORSProfile.cyclingRoad:
        return 'cycling-road';

      case ORSProfile.cyclingMountain:
        return 'cycling-mountain';

      case ORSProfile.cyclingElectric:
        return 'cycling-electric';

      case ORSProfile.footWalking:
        return 'foot-walking';

      case ORSProfile.footHiking:
        return 'foot-hiking';

      case ORSProfile.wheelchair:
        return 'wheelchair';

      default:
        return 'foot-walking';
    }
  }

  /// HTTP Client used to persistently make the request.
  late http.Client _client;

  /// Get current profile/path parameter.
  ORSProfile get profile => _profile;

  /// Change the profile/path parameter.
  set setProfile(ORSProfile newPathParam) => _profile = newPathParam;

  /// Performs a GET request on the OpenRouteService API endpoint [uri].
  ///
  /// Returns [Future] that resolves to json-decoded [http.Response] object body.
  ///
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
      throw ORSException(
        'Status: ${errorData['error']} Code: ${response.statusCode}',
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
      throw ORSException(
        'Status: ${errorData['error']} Code: ${response.statusCode}',
        uri: uri,
      );
    }
  }
}

/// OpenRouteService API profiles as enum values to prevent typos in direct
/// [String] usage.
enum ORSProfile {
  drivingCar,
  drivingHgv,
  cyclingRoad,
  cyclingMountain,
  cyclingElectric,
  footWalking,
  footHiking,
  wheelchair,
}

/// Custom Exception class for this package that contains the [message] of the
/// error, and the [uri] of the failed request (if any).
class ORSException implements Exception {
  @pragma("vm:entry-point")
  const ORSException(this.message, {this.uri}) : super();

  /// The message of the error.
  final String message;

  /// The uri of the failed request.
  final Uri? uri;

  @override
  String toString() => 'OpenRouteServiceException: $message, at url $uri';
}
