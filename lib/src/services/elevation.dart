part of 'package:open_route_service/src/open_route_service_base.dart';

extension ORSElevation on OpenRouteService {
  /// The endpoint of the openrouteservice Elevation API.
  static const String _elevationEndpointURL =
      '${OpenRouteService._baseURL}/elevation';

  /// Fetches the [ElevationData] by taking a 2D [geometry] and enriching it
  /// with  elevation from a variety of datasets. Uses the GET method for the
  /// endpoint.
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/elevation/point/get
  Future<ElevationData> elevationDataGet({
    required Coordinate geometry,
    String formatOut = 'geojson',
    String dataset = 'srtm',
  }) async {
    // Extract coordinate information.
    final double lat = geometry.latitude;
    final double lng = geometry.longitude;

    // Build the request URL.
    final Uri uri = Uri.parse(
      '$_elevationEndpointURL/point?api_key=$_apiKey&geometry=$lng,$lat&format_out=$formatOut&dataset=$dataset',
    );
    final Map<String, dynamic> data = await _openRouteServiceGet(uri: uri);
    return ElevationData.fromJson(data);
  }

  /// Fetches the [ElevationData] by taking a 2D [coordinate] and enriching it
  /// with  elevation from a variety of datasets. Uses the POST method for the
  /// endpoint.
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/elevation/point/post
  Future<ElevationData> elevationDataPostGet({
    required Coordinate geometry,
    String formatIn = 'point',
    String formatOut = 'geojson',
    String dataset = 'srtm',
  }) async {
    // Build the request URL.
    final Uri uri = Uri.parse('$_elevationEndpointURL/point');

    // Ready data to be sent.
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'format_in': formatIn,
      'format_out': formatOut,
      'dataset': dataset,
      'geometry': formatIn == 'geojson'
          ? {
              'type': 'Point',
              'coordinates': [geometry.longitude, geometry.latitude],
            }
          : [geometry.longitude, geometry.latitude],
    };

    // Fetch and parse the data.
    final Map<String, dynamic> data =
        await _openRouteServicePost(uri: uri, data: queryParameters);
    return ElevationData.fromJson(data);
  }

  /// Fetches the [ElevationData] by taking planar 2D line objects [geometry]
  /// and enriching them with  elevation from a variety of datasets.
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  /// https://openrouteservice.org/dev/#/api-docs/elevation/line/post
  Future<ElevationData> elevationDataLinePostGet({
    required Object geometry,
    required String formatIn,
    String formatOut = 'geojson',
    String dataset = 'srtm',
  }) async {
    // Validate if geometry is correct formats. Check documentation for details.
    if (geometry is! String &&
        geometry is! List<List<double>> &&
        geometry is! Map) {
      throw ArgumentError.value(
        geometry,
        'geometry',
        'Must be a String, List<List<double>> or Map.',
      );
    }
    // Build the request URL.
    final Uri uri = Uri.parse('$_elevationEndpointURL/line');

    // Ready data to be sent.
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'format_in': formatIn,
      'format_out': formatOut,
      'dataset': dataset,
      'geometry': geometry,
    };

    // Fetch and parse the data.
    final Map<String, dynamic> data =
        await _openRouteServicePost(uri: uri, data: queryParameters);
    return ElevationData.fromJson(data);
  }
}
