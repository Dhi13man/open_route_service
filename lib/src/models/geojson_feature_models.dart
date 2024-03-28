import 'package:open_route_service/src/models/coordinate_model.dart';

/// Data that represents GeoJSON feature collection for Isochrone or Direction
/// Data models in their respective endpoints.
///
/// Includes its bounding box coordinates [bbox] and [features].
///
/// Used by APIs:
///
/// https://openrouteservice.org/dev/#/api-docs/geocode/search/get
///
/// https://openrouteservice.org/dev/#/api-docs/geocode/autocomplete/get
///
/// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/geojson/post
///
/// https://openrouteservice.org/dev/#/api-docs/v2/isochrones/{profile}/post
class GeoJsonFeatureCollection {
  const GeoJsonFeatureCollection({required this.bbox, required this.features});

  /// Generate a [GeoJsonFeatureCollection] from a received [Map] having keys
  /// 'bbox' and 'features'.
  factory GeoJsonFeatureCollection.fromJson(Map<String, dynamic> json) =>
      GeoJsonFeatureCollection(
        bbox: ((json['bbox'] ?? <dynamic>[]) as List<dynamic>).length < 4
            ? <ORSCoordinate>[]
            : <ORSCoordinate>[
                ORSCoordinate(
                  longitude: json['bbox'][0],
                  latitude: json['bbox'][1],
                ),
                ORSCoordinate(
                  longitude: json['bbox'][2],
                  latitude: json['bbox'][3],
                ),
              ],
        features: (json['features'] as List<dynamic>)
            .map<GeoJsonFeature>(
              (dynamic e) => GeoJsonFeature.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );

  /// The bounding box of the requested feature collection's area.
  /// Should have 2 coordinates.
  final List<ORSCoordinate> bbox;

  /// The list of features of the requested feature collection.
  final List<GeoJsonFeature> features;

  /// Converts the [GeoJsonFeatureCollection] to a [Map] with keys 'type',
  /// 'bbox' and 'features'.
  ///
  /// The 'bbox' key is converted to list of 4 [double]s implying 2 coordinates.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': 'FeatureCollection',
        'bbox': <double>[
          bbox[0].longitude,
          bbox[0].latitude,
          bbox[1].longitude,
          bbox[1].latitude,
        ],
        'features': features
            .map<Map<String, dynamic>>(
              (GeoJsonFeature feature) => feature.toJson(),
            )
            .toList(),
      };

  @override
  String toString() => toJson().toString();
}

/// A feature of an Isochrone or Directions API endpoint response formatted as
/// geojson.
///
/// Includes its [geometry] and [properties].
class GeoJsonFeature {
  const GeoJsonFeature({
    required this.type,
    required this.properties,
    required this.geometry,
    this.bbox,
  });

  GeoJsonFeature.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        properties = json['properties'],
        geometry = GeoJsonFeatureGeometry.fromJson(json['geometry']),
        bbox = json['bbox'] == null
            ? null
            : <ORSCoordinate>[
                ORSCoordinate(
                  longitude: json['bbox'][0],
                  latitude: json['bbox'][1],
                ),
                ORSCoordinate(
                  longitude: json['bbox'][2],
                  latitude: json['bbox'][3],
                ),
              ];

  /// The type of the feature.
  final String type;

  /// The properties of the feature as [Map] of [String] keys and [dynamic]
  /// values to keep up with the API's unconstrained response.
  ///
  /// Possible Data Models include responses of:
  ///
  /// https://openrouteservice.org/dev/#/api-docs/geocode/search/get
  ///
  /// https://openrouteservice.org/dev/#/api-docs/geocode/autocomplete/get
  ///
  /// https://openrouteservice.org/dev/#/api-docs/v2/isochrones/{profile}/post
  ///
  /// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/geojson/post
  final Map<String, dynamic> properties;

  /// The geometry of the feature as [GeoJsonFeatureGeometry].
  final GeoJsonFeatureGeometry geometry;

  /// The bounding box of the requested feature's area.
  ///
  /// Should have 2 coordinates.
  final List<ORSCoordinate>? bbox;

  /// Converts the [GeoJsonFeature] to a [Map] with keys 'type', 'properties'
  /// and 'geometry'.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type,
        'properties': properties,
        'geometry': geometry.toJson(),
        if (bbox != null)
          'bbox': <double>[
            bbox![0].longitude,
            bbox![0].latitude,
            bbox![1].longitude,
            bbox![1].latitude,
          ],
      };

  @override
  String toString() => toJson().toString();
}

/// The geometry of a [GeoJsonFeature].
///
/// Includes its [type] and [List] of [List] of [ORSCoordinate], [coordinates].
class GeoJsonFeatureGeometry {
  const GeoJsonFeatureGeometry({
    required this.type,
    required this.coordinates,
    required this.internalType,
  });

  factory GeoJsonFeatureGeometry.fromJson(Map<String, dynamic> json) {
    final dynamic type = json['type'];
    final dynamic coordinates = json['coordinates'];
    if (coordinates is List<dynamic>) {
      final List<dynamic> dynamicList = coordinates;
      if (dynamicList.first is List<dynamic>) {
        final List<List<dynamic>> dynamicListList = dynamicList
            .map<List<dynamic>>((dynamic c) => c as List<dynamic>)
            .toList();
        // For Isochrone feature geometry, it has a list of list of coordinates.
        if (dynamicListList.first.first is List<dynamic>) {
          return _generateIsochroneGeometry(type, dynamicListList);
        }

        // For direction feature geometry, it has a list of coordinates.
        if (dynamicListList.first.first is num) {
          return _generateDirectionGeometry(type, dynamicListList);
        }
      }
    }

    // For Point feature geometry, it has a single coordinate.
    return _generatePointGeometry(type, coordinates);
  }

  final GsonFeatureGeometryCoordinatesType internalType;

  /// Coordinates associated with the feature geometry.
  ///
  /// It might either be a proper [List] of [List] of [ORSCoordinate] or a
  /// [List] of [ORSCoordinate] wrapped in an empty [List], or a [ORSCoordinate]
  /// wrapped in an empty [List] which is again wrapped in an empty [List].
  ///
  /// Depends upon which endpoint [GeoJsonFeatureGeometry] was extracted from.
  final List<List<ORSCoordinate>> coordinates;

  /// The type of the feature geometry.
  final String type;

  /// Converts the [GeoJsonFeatureGeometry] to a [Map] with keys 'type' and
  /// 'coordinates'.
  ///
  /// The [coordinates] are converted to a [List] of [List]s of
  /// [List]s of 2 elements.
  Map<String, dynamic> toJson() {
    switch (internalType) {
      case GsonFeatureGeometryCoordinatesType.listList:
        return <String, dynamic>{
          'type': type,
          'coordinates': coordinates
              .map<List<List<double>>>(
                (List<ORSCoordinate> c) => c
                    .map<List<double>>(
                      (ORSCoordinate c) => c.toList(),
                    )
                    .toList(),
              )
              .toList(),
        };
      case GsonFeatureGeometryCoordinatesType.list:
        return <String, dynamic>{
          'type': type,
          'coordinates': coordinates
              .map<List<double>>(
                (List<ORSCoordinate> c) => c.first.toList(),
              )
              .toList(),
        };
      case GsonFeatureGeometryCoordinatesType.single:
        return <String, dynamic>{
          'type': type,
          'coordinates': coordinates.first.first.toList(),
        };
    }
  }

  @override
  String toString() => toJson().toString();

  /// For Isochrone feature geometry, it has a list of list of coordinates.
  static GeoJsonFeatureGeometry _generateIsochroneGeometry(
    String type,
    List<List<dynamic>> dynamicListList,
  ) {
    final List<List<ORSCoordinate>> coordinateListList = dynamicListList
        .map<List<List<dynamic>>>(
          (List<dynamic> c) =>
              c.map<List<dynamic>>((dynamic c) => c as List<dynamic>).toList(),
        )
        .map<List<List<num>>>(
          (List<List<dynamic>> c) => c
              .map<List<num>>(
                (List<dynamic> c) =>
                    c.map<num>((dynamic c) => c as num).toList(),
              )
              .toList(),
        )
        .map<List<ORSCoordinate>>(
          (List<List<num>> c) => c
              .map<ORSCoordinate>((List<num> c) => ORSCoordinate.fromList(c))
              .toList(),
        )
        .toList();
    return GeoJsonFeatureGeometry(
      type: type,
      coordinates: coordinateListList,
      internalType: GsonFeatureGeometryCoordinatesType.listList,
    );
  }

  /// For direction feature geometry, it has a list of coordinates.
  static _generateDirectionGeometry(
    String type,
    List<List<dynamic>> dynamicListList,
  ) {
    final List<ORSCoordinate> coordinateList = dynamicListList
        .map<ORSCoordinate>(
          (List<dynamic> c) => ORSCoordinate.fromList(
            c.map<double>((dynamic c) => (c as num).toDouble()).toList(),
          ),
        )
        .toList();
    return GeoJsonFeatureGeometry(
      type: type,
      coordinates: <List<ORSCoordinate>>[coordinateList],
      internalType: GsonFeatureGeometryCoordinatesType.list,
    );
  }

  /// For Point feature geometry, it has a single coordinate.
  static _generatePointGeometry(String type, dynamic coordinates) {
    final ORSCoordinate coordinate = ORSCoordinate.fromList(coordinates);
    return GeoJsonFeatureGeometry(
      type: type,
      coordinates: <List<ORSCoordinate>>[
        <ORSCoordinate>[coordinate],
      ],
      internalType: GsonFeatureGeometryCoordinatesType.single,
    );
  }
}

enum GsonFeatureGeometryCoordinatesType { listList, list, single }
