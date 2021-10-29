part of 'package:open_route_service/src/open_route_service_base.dart';

extension ORSGeocode on OpenRouteService {
  /// The endpoint of the openrouteservice Geocode API.
  static const String _geocodeEndpointURL =
      '${OpenRouteService._baseURL}/geocode';

  /// Available Sources for Geocoding
  Set<String> get geocodeSearchSourcesAvailable => <String>{
    'openstreetmap',
    'openaddresses',
    'whosonfirst',
    'geonames'
  };

  /// Available Layer settings for Geocoding
  Set<String> get geocodeSearchLayersAvailable => const <String>{
    'address',
    'venue',
    'neighbourhood',
    'locality',
    'borough',
    'localadmin',
    'county',
    'macrocounty',
    'region',
    'macroregion',
    'country',
    'coarse',
  };

  Future<GeoJsonFeatureCollection> geocodeSearch({
    required String text,
    double? focusPointLongitude,
    double? boundaryRectangleMinLongitude,
    double? boundaryCircleLongitude,
    String? boundaryGid,
    String? boundaryCountry,
    List<String>? sources,
    List<String> layers = const <String>[],
    int size = 10,
  }) async {
    // Form Input from parameters
    sources ??= geocodeSearchSourcesAvailable.toList();
    final String sourcesString = _validateAndJoin(
      inputArr: sources,
      availableIterable: geocodeSearchSourcesAvailable,
    );
    final String layersString = _validateAndJoin(
      inputArr: layers,
      availableIterable: geocodeSearchLayersAvailable,
    );
    String getURIString =
        '$_geocodeEndpointURL/search?api_key=$_apiKey&text=$text&sources=$sourcesString&size=$size';
    if (layersString.isNotEmpty) {
      getURIString += '&layers=$layersString';
    }
    if (focusPointLongitude != null) {
      getURIString += '&focus.point.lon=$focusPointLongitude';
    }
    if (boundaryRectangleMinLongitude != null) {
      getURIString += '&boundary.rect.min_lon=$boundaryRectangleMinLongitude';
    }
    if (boundaryCircleLongitude != null) {
      getURIString += '&boundary.circle.lon=$boundaryCircleLongitude';
    }
    if (boundaryGid != null) {
      getURIString += '&boundary.gid=$boundaryGid';
    }
    if (boundaryCountry != null) {
      getURIString += '&boundary.country=$boundaryCountry';
    }

    // Build the request URL.
    final Uri uri = Uri.parse(getURIString);
    final Map<String, dynamic> data = await _openRouteServiceGet(uri: uri);
    return GeoJsonFeatureCollection.fromJson(data);
  }

  /// Validates whether each element of [inputArr] is in [availableIterable].
  ///
  /// If so, returns a [String] of the elements joined by a comma that can be
  /// used in a URI.
  ///
  /// If not, throws an [ArgumentError].
  String _validateAndJoin({
    required List<String> inputArr,
    required Iterable<String> availableIterable,
  }) {
    for (String inp in inputArr) {
      if (!availableIterable.contains(inp)) {
        throw ArgumentError.value(
          inp,
          'sources',
          'Source must be one of ${availableIterable.join(', ')}',
        );
      }
    }
    return inputArr.join(',');
  }
}
