import 'package:open_route_service/open_route_service.dart';

/// Data class representing the Points Of Interest (POI)s of an area.
///
/// Inherits a [GeoJsonFeatureCollection] and includes its bounding box
/// coordinates [bbox] and [features]. Additionally includes [information] about
/// the POIs.
///
///https://openrouteservice.org/dev/#/api-docs/pois
class PoisData extends GeoJsonFeatureCollection {
  const PoisData({
    required List<Coordinate> bbox,
    required List<GeoJsonFeature> features,
    required this.information,
  }) : super(bbox: bbox, features: features);

  factory PoisData.fromJson(Map<String, dynamic> json) => PoisData(
        bbox: <Coordinate>[
          Coordinate(longitude: json['bbox'][0], latitude: json['bbox'][1]),
          Coordinate(longitude: json['bbox'][2], latitude: json['bbox'][3])
        ],
        features: (json['features'] as List<dynamic>)
            .map<GeoJsonFeature>((dynamic e) =>
                GeoJsonFeature.fromJson(e as Map<String, dynamic>))
            .toList(),
        information: PoisInformation.fromJson(json['information']),
      );

  final PoisInformation information;

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addEntries(
      <MapEntry<String, dynamic>>[
        MapEntry<String, dynamic>('information', information.toJson()),
      ],
    );

  @override
  String toString() => toJson().toString();
}

/// Stores the information associated with Pois.
///
/// Includes the [attribution], [version] and [timestamp] of the Pois.
///
/// Doesn't store query yet because it felt unnecessary(?).
class PoisInformation {
  const PoisInformation({
    required this.attribution,
    required this.version,
    required this.timestamp,
  });

  factory PoisInformation.fromJson(Map<String, dynamic> json) =>
      PoisInformation(
        attribution: json['attribution'] as String,
        version: json['version'] as String,
        timestamp: json['timestamp'],
      );

  final String attribution;

  final String version;

  final int timestamp;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'attribution': attribution,
        'version': version,
        'timestamp': timestamp,
      };

  @override
  String toString() => toJson().toString();
}
