import 'package:open_route_service/src/models/coordinate_model.dart';

/// Data that represents GEOJSON feature collection for Isochrone or Direction
/// Data models in their respective endpoints.
///
/// Includes its bounding box coordinates [bbox] and [features].
///
/// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/geojson/post
/// https://openrouteservice.org/dev/#/api-docs/v2/isochrones/{profile}/post
class GeoJsonFeatureCollection {
  const GeoJsonFeatureCollection({required this.bbox, required this.features});

  /// Generate a [GeoJsonFeatureCollection] from a received [Map] having keys
  /// 'bbox' and 'features'.
  factory GeoJsonFeatureCollection.fromJson(Map<String, dynamic> json) =>
      GeoJsonFeatureCollection(
        bbox: <Coordinate>[
          Coordinate(longitude: json['bbox'][0], latitude: json['bbox'][1]),
          Coordinate(longitude: json['bbox'][2], latitude: json['bbox'][3])
        ],
        features: (json['features'] as List<dynamic>)
            .map<GeoJsonFeature>((dynamic e) =>
                GeoJsonFeature.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  // The bounding box of the requested Isochrone's area.
  // Should have 2 coordinates.
  final List<Coordinate> bbox;

  // The list of features of the requested Isochrone.
  final List<GeoJsonFeature> features;

  /// Converts the [GeoJsonFeatureCollection] to a [Map] with keys 'type',
  /// 'bbox' and 'features'.
  ///
  /// The 'bbox' key is converted to list of 4 [double]s implying 2 coordinates.
  Map<String, dynamic> toJson() => {
        'type': 'FeatureCollection',
        'bbox': [
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
  const GeoJsonFeature({required this.properties, required this.geometry});

  GeoJsonFeature.fromJson(Map<String, dynamic> json)
      : properties = GeoJsonFeatureProperties.fromJson(json['properties']),
        geometry = GeoJsonFeatureGeometry.fromJson(json['geometry']);

  /// The properties of the feature.
  final GeoJsonFeatureProperties properties;

  /// The geometry of the feature.
  final GeoJsonFeatureGeometry geometry;

  /// Converts the [GeoJsonFeature] to a [Map] with keys 'type', 'properties'
  /// and 'geometry'.
  Map<String, dynamic> toJson() => {
        'type': 'Feature',
        'properties': properties.toJson(),
        'geometry': geometry.toJson(),
      };

  @override
  String toString() => 'Feature(properties: $properties, geometry: $geometry)';
}

/// Properties of a [GeoJsonFeature].
///
/// Includes its [groupIndex], [value] and [center] coordinates.
class GeoJsonFeatureProperties {
  const GeoJsonFeatureProperties({
    this.groupIndex,
    this.value,
    this.center,
  });

  GeoJsonFeatureProperties.fromJson(Map<String, dynamic> json)
      : groupIndex = json['group_index'],
        value = json['value'],
        center = json['center'] == null
            ? null
            : Coordinate(
                longitude: json['center'][0],
                latitude: json['center'][1],
              );

  /// The index of the group of the feature.
  final int? groupIndex;

  /// The value of the feature.
  final double? value;

  /// The center [Coordinate] of the feature.
  final Coordinate? center;

  /// Converts the [GeoJsonFeatureProperties] to a [Map] with keys 'groupIndex',
  /// 'value' and 'center'.
  ///
  /// The [center] is converted to a [List] with 2 elements.
  Map<String, dynamic> toJson() => {
        'group_index': groupIndex,
        'value': value,
        'center': center == null
            ? null
            : <double>[center!.longitude, center!.latitude],
      };

  @override
  String toString() => toJson().toString();
}

/// The geometry of a [GeoJsonFeature].
///
/// Includes its [type] and [List] of [Coordinate], [coordinates].
class GeoJsonFeatureGeometry {
  const GeoJsonFeatureGeometry({required this.type, required this.coordinates});

  /// Generate a [GeoJsonFeatureGeometry] from a received [Map].
  GeoJsonFeatureGeometry.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        coordinates = (((json['coordinates'] as List<dynamic>).first as List)
                .first is List)
            ? (json['coordinates'] as List<dynamic>)
                .map<List<Coordinate>>(
                  (dynamic coords) => (coords as List<dynamic>)
                      .map<Coordinate>(
                        (c) => Coordinate(longitude: c[0], latitude: c[1]),
                      )
                      .toList(),
                )
                .toList()
            : [
                (json['coordinates'] as List<dynamic>)
                    .map<Coordinate>(
                      (dynamic c) => Coordinate(
                        longitude: c[0],
                        latitude: c[1],
                      ),
                    )
                    .toList()
              ];

  /// Coordinates associated with the feature geometry.
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
              (coordinate) => coordinate
                  .map<List<double>>((c) => [c.longitude, c.latitude])
                  .toList(),
            )
            .toList(),
      };

  @override
  String toString() => toJson().toString();
}
