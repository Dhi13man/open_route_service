part of 'package:open_route_service/src/open_route_service_base.dart';

extension ORSGeocode on OpenRouteService {
  /// The endpoint of the openrouteservice Geocode API.
  static const String _geocodeEndpointURL =
      '${OpenRouteService._baseURL}/geocode';

  /// Available Sources for Geocoding
  Set<String> get geocodeSourcesAvailable =>
      <String>{'openstreetmap', 'openaddresses', 'whosonfirst', 'geonames'};

  /// Available Layer settings for Geocoding
  Set<String> get geocodeLayersAvailable => const <String>{
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

  /// Fetches the Geocode Autocomplete data for the given [text] from chosen
  /// [sources] and using settings [layers], and returns the entire geojson
  /// [GeoJsonFeatureCollection] containing the data.
  ///
  /// Can be constrained using the various [Coordinate] parameters.
  ///
  /// [GeoJsonFeatureCollection] -> [GeoJsonFeatureCollection.features]
  /// is a list of [GeoJsonFeature]s whose [GeoJsonFeature.properties] have all
  /// the information about the result of the autocomplete query.
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  ///
  /// https://openrouteservice.org/dev/#/api-docs/geocode/autocomplete/get
  ///
  /// https://github.com/pelias/documentation/blob/master/autocomplete.md
  Future<GeoJsonFeatureCollection> geocodeAutoCompleteGet({
    required String text,
    Coordinate? focusPointCoordinate,
    Coordinate? boundaryRectangleMinCoordinate,
    Coordinate? boundaryRectangleMaxCoordinate,
    String? boundaryCountry,
    List<String>? sources,
    List<String> layers = const <String>[],
  }) async {
    // Validate input.
    _bothOrNeitherNullValidation(
      boundaryRectangleMinCoordinate,
      boundaryRectangleMaxCoordinate,
    );
    // Form input from parameters.
    sources ??= geocodeSourcesAvailable.toList();
    final String sourcesString = _validateAndJoinList(
      inputArr: sources,
      availableIterable: geocodeSourcesAvailable,
    );
    final String layersString = _validateAndJoinList(
      inputArr: layers,
      availableIterable: geocodeLayersAvailable,
    );
    String getURIString =
        '$_geocodeEndpointURL/autocomplete?api_key=$_apiKey&text=$text&sources=$sourcesString';
    if (layersString.isNotEmpty) {
      getURIString += '&layers=$layersString';
    }
    if (focusPointCoordinate != null) {
      getURIString += '&focus.point.lon=${focusPointCoordinate.longitude}';
      getURIString += '&focus.point.lat=${focusPointCoordinate.latitude}';
    }
    if (boundaryRectangleMinCoordinate != null) {
      getURIString +=
          '&boundary.rect.min_lon=${boundaryRectangleMinCoordinate.longitude}';
      getURIString +=
          '&boundary.rect.min_lat=${boundaryRectangleMinCoordinate.latitude}';
    }
    if (boundaryRectangleMaxCoordinate != null) {
      getURIString +=
          '&boundary.rect.max_lon=${boundaryRectangleMaxCoordinate.longitude}';
      getURIString +=
          '&boundary.rect.max_lat=${boundaryRectangleMaxCoordinate.latitude}';
    }
    if (boundaryCountry != null) {
      getURIString += '&boundary.country=$boundaryCountry';
    }

    // Build the request URL.
    final Uri uri = Uri.parse(getURIString);
    final Map<String, dynamic> data = await _openRouteServiceGet(uri: uri);
    return GeoJsonFeatureCollection.fromJson(data);
  }

  /// Fetches the Geocode Search data for the given search [text] from chosen
  /// [sources] and using settings [layers], and returns the entire geojson
  /// [GeoJsonFeatureCollection] containing the data.
  ///
  /// Can be constrained using the various [Coordinate] parameters.
  ///
  /// [GeoJsonFeatureCollection] -> [GeoJsonFeatureCollection.features]
  /// is a list of [GeoJsonFeature]s whose [GeoJsonFeature.properties] have all
  /// the information about the result of the search.
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  ///
  /// https://openrouteservice.org/dev/#/api-docs/geocode/search/get
  ///
  /// https://github.com/pelias/documentation/blob/master/search.md#search-the-world
  Future<GeoJsonFeatureCollection> geocodeSearchGet({
    required String text,
    Coordinate? focusPointCoordinate,
    Coordinate? boundaryRectangleMinCoordinate,
    Coordinate? boundaryRectangleMaxCoordinate,
    Coordinate? boundaryCircleCoordinate,
    double boundaryCircleRadius = 50,
    String? boundaryGid,
    String? boundaryCountry,
    List<String>? sources,
    List<String> layers = const <String>[],
    int size = 10,
  }) async {
    // Validate Input.
    _bothOrNeitherNullValidation(
      boundaryRectangleMinCoordinate,
      boundaryRectangleMaxCoordinate,
    );
    // Form input from parameters.
    sources ??= geocodeSourcesAvailable.toList();
    final String sourcesString = _validateAndJoinList(
      inputArr: sources,
      availableIterable: geocodeSourcesAvailable,
    );
    final String layersString = _validateAndJoinList(
      inputArr: layers,
      availableIterable: geocodeLayersAvailable,
    );
    String getURIString =
        '$_geocodeEndpointURL/search?api_key=$_apiKey&text=$text&sources=$sourcesString&size=$size';
    if (layersString.isNotEmpty) {
      getURIString += '&layers=$layersString';
    }
    if (focusPointCoordinate != null) {
      getURIString += '&focus.point.lon=${focusPointCoordinate.longitude}';
      getURIString += '&focus.point.lat=${focusPointCoordinate.latitude}';
    }
    if (boundaryRectangleMinCoordinate != null) {
      getURIString +=
          '&boundary.rect.min_lon=${boundaryRectangleMinCoordinate.longitude}';
      getURIString +=
          '&boundary.rect.min_lat=${boundaryRectangleMinCoordinate.latitude}';
    }
    if (boundaryRectangleMaxCoordinate != null) {
      getURIString +=
          '&boundary.rect.max_lon=${boundaryRectangleMaxCoordinate.longitude}';
      getURIString +=
          '&boundary.rect.max_lat=${boundaryRectangleMaxCoordinate.latitude}';
    }
    if (boundaryCircleCoordinate != null) {
      getURIString +=
          '&boundary.circle.lon=${boundaryCircleCoordinate.longitude}';
      getURIString +=
          '&boundary.circle.lat=${boundaryCircleCoordinate.latitude}';
      getURIString += '&boundary.circle.radius=$boundaryCircleRadius';
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

  /// Fetches the Geocode Structured Search data for the given search [address]
  /// and/or [neighbourhood] and/or [country] and/or [postalcode] and/or
  /// [region] and/or [county] and/or [locality] and/or [borough] from chosen
  /// [sources] and using settings [layers], and returns the entire geojson
  /// [GeoJsonFeatureCollection] containing the data. Uses the Structured Search
  /// API endpoint.
  ///
  /// Can be constrained using the various [Coordinate] parameters.
  ///
  /// [GeoJsonFeatureCollection] -> [GeoJsonFeatureCollection.features]
  /// is a list of [GeoJsonFeature]s whose [GeoJsonFeature.properties] have all
  /// the information about the result of the search.
  ///
  /// At least one of the following fields is required: venue, address,
  /// neighbourhood, borough, locality, county, region, postalcode, country.
  /// Otherwise, throws an [ArgumentError].
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  ///
  /// https://openrouteservice.org/dev/#/api-docs/geocode/search/structured/get
  ///
  /// https://github.com/pelias/documentation/blob/master/structured-geocoding.md#structured-geocoding
  Future<GeoJsonFeatureCollection> geocodeSearchStructuredGet({
    String? address,
    String? neighbourhood,
    String? country,
    String? postalcode,
    String? region,
    String? county,
    String? locality,
    String? borough,
    Coordinate? focusPointCoordinate,
    Coordinate? boundaryRectangleMinCoordinate,
    Coordinate? boundaryRectangleMaxCoordinate,
    Coordinate? boundaryCircleCoordinate,
    double boundaryCircleRadius = 50,
    String? boundaryCountry,
    List<String>? sources,
    List<String> layers = const <String>[],
    int size = 10,
  }) async {
    // Validate input
    if (address == null &&
        neighbourhood == null &&
        country == null &&
        postalcode == null &&
        region == null &&
        county == null &&
        locality == null &&
        borough == null) {
      throw ArgumentError(
        'At least one of the following fields is required: venue, address, neighbourhood, borough, locality, county, region, postalcode, country',
      );
    }
    _bothOrNeitherNullValidation(
      boundaryRectangleMinCoordinate,
      boundaryRectangleMaxCoordinate,
    );
    // Form input from parameters.
    sources ??= geocodeSourcesAvailable.toList();
    final String sourcesString = _validateAndJoinList(
      inputArr: sources,
      availableIterable: geocodeSourcesAvailable,
    );
    final String layersString = _validateAndJoinList(
      inputArr: layers,
      availableIterable: geocodeLayersAvailable,
    );
    String getURIString =
        '$_geocodeEndpointURL/search/structured?api_key=$_apiKey&sources=$sourcesString&size=$size';
    if (layersString.isNotEmpty) {
      getURIString += '&layers=$layersString';
    }
    if (address != null) {
      getURIString += '&address=$address';
    }
    if (neighbourhood != null) {
      getURIString += '&neighbourhood=$neighbourhood';
    }
    if (country != null) {
      getURIString += '&country=$country';
    }
    if (postalcode != null) {
      getURIString += '&postalcode=$postalcode';
    }
    if (region != null) {
      getURIString += '&region=$region';
    }
    if (county != null) {
      getURIString += '&county=$county';
    }
    if (locality != null) {
      getURIString += '&locality=$locality';
    }
    if (borough != null) {
      getURIString += '&borough=$borough';
    }
    if (focusPointCoordinate != null) {
      getURIString += '&focus.point.lon=${focusPointCoordinate.longitude}';
      getURIString += '&focus.point.lat=${focusPointCoordinate.latitude}';
    }
    if (boundaryRectangleMinCoordinate != null) {
      getURIString +=
          '&boundary.rect.min_lon=${boundaryRectangleMinCoordinate.longitude}';
      getURIString +=
          '&boundary.rect.min_lat=${boundaryRectangleMinCoordinate.latitude}';
    }
    if (boundaryRectangleMaxCoordinate != null) {
      getURIString +=
          '&boundary.rect.max_lon=${boundaryRectangleMaxCoordinate.longitude}';
      getURIString +=
          '&boundary.rect.max_lat=${boundaryRectangleMaxCoordinate.latitude}';
    }
    if (boundaryCircleCoordinate != null) {
      getURIString +=
          '&boundary.circle.lon=${boundaryCircleCoordinate.longitude}';
      getURIString +=
          '&boundary.circle.lat=${boundaryCircleCoordinate.latitude}';
      getURIString += '&boundary.circle.radius=$boundaryCircleRadius';
    }
    if (boundaryCountry != null) {
      getURIString += '&boundary.country=$boundaryCountry';
    }

    // Build the request URL.
    final Uri uri = Uri.parse(getURIString);
    final Map<String, dynamic> data = await _openRouteServiceGet(uri: uri);
    return GeoJsonFeatureCollection.fromJson(data);
  }

  /// Fetches the Reverse Geocode data from the given [sources] and using
  /// settings [layers], and returns the entire geojson [GeoJsonFeatureCollection]
  /// containing the data.
  ///
  /// [GeoJsonFeatureCollection] -> [GeoJsonFeatureCollection.features]
  /// is a list of [GeoJsonFeature]s whose [GeoJsonFeature.properties] have all
  /// the information about the result of the reverse geocoding.
  ///
  /// Information about the endpoint, parameters, response etc. can be found at:
  ///
  /// https://openrouteservice.org/dev/#/api-docs/geocode/reverse/get
  ///
  /// https://github.com/pelias/documentation/blob/master/reverse.md#reverse-geocoding
  Future<GeoJsonFeatureCollection> geocodeReverseGet({
    required Coordinate point,
    double boundaryCircleRadius = 1,
    int size = 10,
    List<String> layers = const <String>[],
    List<String>? sources,
    String? boundaryCountry,
  }) async {
    // Form Input from parameters.
    sources ??= geocodeSourcesAvailable.toList();
    final String sourcesString = _validateAndJoinList(
      inputArr: sources,
      availableIterable: geocodeSourcesAvailable,
    );
    final String layersString = _validateAndJoinList(
      inputArr: layers,
      availableIterable: geocodeLayersAvailable,
    );

    String getURIString =
        '$_geocodeEndpointURL/reverse?api_key=$_apiKey&sources=$sourcesString';
    if (layersString.isNotEmpty) {
      getURIString += '&layers=$layersString';
    }
    if (boundaryCountry != null) {
      getURIString += '&boundary.country=$boundaryCountry';
    }
    getURIString += '&point.lon=${point.longitude}&point.lat=${point.latitude}';
    getURIString += '&boundary.circle.radius=$boundaryCircleRadius';
    getURIString += '&size=$size';

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
  String _validateAndJoinList({
    required List<String> inputArr,
    required Iterable<String> availableIterable,
  }) {
    for (String inp in inputArr) {
      if (!availableIterable.contains(inp)) {
        throw ArgumentError.value(
          inp,
          'inputArr',
          'Input Array must be one of ${availableIterable.join(', ')}',
        );
      }
    }
    return inputArr.join(',');
  }

  /// Validates whether either both parameters are none or neither parameter is
  /// null.
  ///
  /// If not, then throws an [ArgumentError].
  void _bothOrNeitherNullValidation(dynamic a, dynamic b) {
    final bool validateMinMax =
        (a == null && b == null) || (a != null && b != null);
    if (!validateMinMax) {
      throw ArgumentError(
        'Either both parameters must be null, or neither must be null!',
      );
    }
  }
}
