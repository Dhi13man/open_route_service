import 'package:open_route_service/src/models/coordinate_model.dart';

/// Data that represents an Isochrone, which denote areas of reachability
/// from given locations.
///
/// Includes its bounding box coordinates [bbox] and [features].
class IsochroneData {
  const IsochroneData({required this.bbox, required this.features});

  /// Generate a [IsochroneData] from a received [Map].
  IsochroneData.fromJson(Map<String, dynamic> json)
      : bbox = <Coordinate>[
          Coordinate(longitude: json['bbox'][0], latitude: json['bbox'][1]),
          Coordinate(longitude: json['bbox'][2], latitude: json['bbox'][3])
        ],
        features = (json['features'] as List<dynamic>)
            .map<Feature>(
                (dynamic e) => Feature.fromJson(e as Map<String, dynamic>))
            .toList();

  // The bounding box of the requested Isochrone's area.
  // Should have 2 coordinates.
  final List<Coordinate> bbox;

  // The list of features of the requested Isochrone.
  final List<Feature> features;

  /// Converts the [IsochroneData] to a [Map] with keys 'type', 'bbox'
  /// and 'features'.
  ///
  /// The 'bbox' key is converted to a list of 4 [double]s
  /// implying 2 coordinates.
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

/// A feature of an Isochrone.
///
/// Includes its [geometry] and [properties].
class Feature {
  const Feature({required this.properties, required this.geometry});

  Feature.fromJson(Map<String, dynamic> json)
      : properties = FeatureProperties.fromJson(json['properties']),
        geometry = FeatureGeometry.fromJson(json['geometry']);

  /// The properties of the feature.
  final FeatureProperties properties;

  /// The geometry of the feature.
  final FeatureGeometry geometry;

  /// Converts the [Feature] to a [Map] with keys 'type', 'properties'
  /// and 'geometry'.
  Map<String, dynamic> toJson() => {
        'type': 'Feature',
        'properties': properties.toJson(),
        'geometry': geometry.toJson(),
      };
  
  @override
  String toString() => 'Feature(properties: $properties, geometry: $geometry)';
}

/// Properties of a [Feature].
///
/// Includes its [groupIndex], [value] and [center] coordinates.
class FeatureProperties {
  const FeatureProperties({
    required this.groupIndex,
    required this.value,
    required this.center,
  });

  FeatureProperties.fromJson(Map<String, dynamic> json)
      : groupIndex = json['group_index'],
        value = json['value'],
        center = Coordinate(
          longitude: json['center'][0],
          latitude: json['center'][1],
        );

  /// The index of the group of the feature.
  final int groupIndex;

  /// The value of the feature.
  final double value;

  /// The center [Coordinate] of the feature.
  final Coordinate center;

  /// Converts the [FeatureProperties] to a [Map] with keys 'groupIndex',
  /// 'value' and 'center'.
  ///
  /// The [center] is converted to a [List] with 2 elements.
  Map<String, dynamic> toJson() => {
        'group_index': groupIndex,
        'value': value,
        'center': [center.longitude, center.latitude],
      };

  @override
  String toString() => toJson().toString();
}

/// The geometry of a [Feature].
///
/// Includes its [type] and [List] of [Coordinate], [coordinates].
class FeatureGeometry {
  const FeatureGeometry({required this.type, required this.coordinates});

  /// Generate a [FeatureGeometry] from a received [Map].
  FeatureGeometry.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        coordinates = (json['coordinates'] as List<dynamic>)
            .map<List<Coordinate>>(
              (dynamic coords) => (coords as List<dynamic>)
                  .map<Coordinate>(
                    (c) => Coordinate(longitude: c[0], latitude: c[1]),
                  )
                  .toList(),
            )
            .toList();

  /// Coordinates associated with the feature geometry.
  final List<List<Coordinate>> coordinates;

  /// The type of the feature geometry.
  final String type;

  /// Converts the [FeatureGeometry] to a [Map] with keys 'type' and
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
