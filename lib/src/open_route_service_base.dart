import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:open_route_service/src/models/coordinate_model.dart';
import 'package:open_route_service/src/models/elevation_data_model.dart';
import 'package:open_route_service/src/models/isochrone_data_models.dart';

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
    OpenRouteServiceProfile profile = OpenRouteServiceProfile.footWalking,
  })  : _apiKey = apiKey,
        _profile = profile {
    // Initialize HTTP client
    _client = http.Client();
  }

  static const String _baseURL = 'https://api.openrouteservice.org';

  /// The API key used to authenticate the request.
  final String _apiKey;

  /// The path parameter determines the routing method.
  OpenRouteServiceProfile _profile;

  /// Converts the enum [profile] to a [String] which can be used in API request
  static String getProfileString(OpenRouteServiceProfile profile) {
    switch (profile) {
      case OpenRouteServiceProfile.drivingCar:
        return 'driving-car';

      case OpenRouteServiceProfile.drivingHgv:
        return 'driving-hgv';

      case OpenRouteServiceProfile.cyclingRoad:
        return 'cycling-road';

      case OpenRouteServiceProfile.cyclingMountain:
        return 'cycling-mountain';

      case OpenRouteServiceProfile.cyclingElectric:
        return 'cycling-electric';

      case OpenRouteServiceProfile.footWalking:
        return 'foot-walking';

      case OpenRouteServiceProfile.footHiking:
        return 'foot-hiking';

      case OpenRouteServiceProfile.wheelchair:
        return 'wheelchair';

      default:
        return 'foot-walking';
    }
  }

  /// HTTP Client used to persistently make the request.
  late http.Client _client;

  /// Get current profile/path parameter.
  OpenRouteServiceProfile get profile => _profile;

  /// Change the profile/path parameter.
  set setProfile(OpenRouteServiceProfile newPathParam) =>
      _profile = newPathParam;

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

/// OpenRouteService API profiles as enum values to prevent typos in direct
/// [String] usage.
enum OpenRouteServiceProfile {
  drivingCar,
  drivingHgv,
  cyclingRoad,
  cyclingMountain,
  cyclingElectric,
  footWalking,
  footHiking,
  wheelchair,
}
