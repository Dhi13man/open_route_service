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
        bbox: ((json['bbox'] ?? []) as List<dynamic>).length < 4
            ? []
            : <Coordinate>[
                Coordinate(
                  longitude: json['bbox'][0],
                  latitude: json['bbox'][1],
                ),
                Coordinate(
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
  final List<Coordinate> bbox;

  /// The list of features of the requested feature collection.
  final List<GeoJsonFeature> features;

  /// Converts the [GeoJsonFeatureCollection] to a [Map] with keys 'type',
  /// 'bbox' and 'features'.
  ///
  /// The 'bbox' key is converted to list of 4 [double]s implying 2 coordinates.
  Map<String, dynamic> toJson() => {
        'type': 'FeatureCollection',
        'bbox': <double>[
          bbox[0].longitude,
          bbox[0].latitude,
          bbox[1].longitude,
          bbox[1].latitude,
        ],
        'features': features
            .map<Map<String, dynamic>>((feature) => feature.toJson())
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
    required this.properties,
    required this.geometry,
    this.bbox,
  });

  GeoJsonFeature.fromJson(Map<String, dynamic> json)
      : properties = json['properties'],
        geometry = GeoJsonFeatureGeometry.fromJson(json['geometry']),
        bbox = json['bbox'] == null
            ? null
            : <Coordinate>[
                Coordinate(
                  longitude: json['bbox'][0],
                  latitude: json['bbox'][1],
                ),
                Coordinate(
                  longitude: json['bbox'][2],
                  latitude: json['bbox'][3],
                ),
              ];

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
  final List<Coordinate>? bbox;

  /// Converts the [GeoJsonFeature] to a [Map] with keys 'type', 'properties'
  /// and 'geometry'.
  Map<String, dynamic> toJson() => {
        'type': 'Feature',
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
/// Includes its [type] and [List] of [List] of [Coordinate], [coordinates].
class GeoJsonFeatureGeometry {
  const GeoJsonFeatureGeometry({required this.type, required this.coordinates});

  /// Generate a [GeoJsonFeatureGeometry] from a received [Map] having keys
  /// 'type' and 'coordinates'.
  ///
  /// Apologize for the completely unreadable [GeoJsonFeatureGeometry.fromJson]
  /// code, but the Feature Geometry data model is very inconsistent with what
  /// it wants [coordinates] to be.
  GeoJsonFeatureGeometry.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        coordinates = (json['coordinates'] as List<dynamic>).first is List
            ?
            // For Isochrone feature geometry.
            (((json['coordinates'] as List<dynamic>).first as List).first
                    is List)
                ? (json['coordinates'] as List<dynamic>)
                    .map<List<Coordinate>>(
                      (dynamic coords) => (coords as List<dynamic>)
                          .map<Coordinate>(
                            (c) => Coordinate.fromList(c as List<dynamic>),
                          )
                          .toList(),
                    )
                    .toList()
                :
                // For direction feature geometry
                <List<Coordinate>>[
                    (json['coordinates'] as List<dynamic>)
                        .map<Coordinate>(
                          (dynamic c) =>
                              Coordinate.fromList(c as List<dynamic>),
                        )
                        .toList()
                  ]
            :
            // For POIs feature geometry
            <List<Coordinate>>[
                <Coordinate>[
                  Coordinate.fromList(json['coordinates'] as List<dynamic>),
                ]
              ];

  /// Coordinates associated with the feature geometry.
  ///
  /// It might either be a proper [List] of [List] of [Coordinate] or a
  /// [List] of [Coordinate] wrapped in an empty [List], or a [Coordinate]
  /// wrapped in an empty [List] which is again wrapped in an empty [List].
  ///
  /// Depends upon which endpoint [GeoJsonFeatureGeometry] was extracted from.
  final List<List<Coordinate>> coordinates;

  /// The type of the feature geometry.
  final String type;

  /// Converts the [GeoJsonFeatureGeometry] to a [Map] with keys 'type' and
  /// 'coordinates'.
  ///
  /// The [coordinates] are converted to a [List] of [List]s of
  /// [List]s of 2 elements.
  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates
            .map<List<List<double>>>(
              (coordinate) =>
                  coordinate.map<List<double>>((c) => c.toList()).toList(),
            )
            .toList(),
      };

  @override
  String toString() => toJson().toString();
}
