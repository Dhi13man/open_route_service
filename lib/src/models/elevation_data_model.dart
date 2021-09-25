import 'package:open_route_service/src/models/coordinate_model.dart';

/// Class representing 2D point enriched it with elevation from a
/// variety of datasets.
///
/// Has bad [ElevationData.fromJson] code because of inconsistency of Elevation
/// data in OpenRouteService API.
///
/// https://openrouteservice.org/dev/#/api-docs/elevation/point/get
class ElevationData {
  const ElevationData({
    required this.coordinates,
    required this.timestamp,
    this.attribution =
        'service by https://openrouteservice.org | data by http://srtm.csi.cgiar.org',
    this.type = 'point',
    this.version = '0.2.1',
  });

  /// Construct Elevation data from JSON as per the schema in the api
  /// documentation.
  ///
  /// Bad code because of inconsistency of Elevation data in OpenRouteService.
  ///
  /// The json should have keys 'timestamp', 'attribution', 'version',
  /// 'elevation' and 'geometry' which corresponds to a [Map] further
  /// containing keys 'coordinates' and 'type'.
  ElevationData.fromJson(Map<String, dynamic> json)
      : this(
          coordinates: json['geometry'] is Map<String, dynamic> &&
                  json['geometry']['coordinates'] is List<dynamic> &&
                  (json['geometry']['coordinates'] as List<dynamic>).first
                      is List<dynamic>
              ? (json['geometry']['coordinates'] as List<dynamic>)
                  .map<Coordinate>(
                    (dynamic coordinate) => Coordinate(
                      latitude: coordinate[1] as double,
                      longitude: coordinate[0] as double,
                      altitude: (coordinate[2] as num).toDouble(),
                    ),
                  )
                  .toList()
              : [
                  Coordinate(
                    latitude: json['geometry'] is List
                        ? (json['geometry']?[1] as double)
                        : (json['geometry']?['coordinates']?[1]! as double),
                    longitude: json['geometry'] is List
                        ? (json['geometry']?[0] as double)
                        : (json['geometry']?['coordinates']?[0]! as double),
                    altitude: json['geometry'] is List
                        ? (json['geometry']?[2] as double)
                        : (json['geometry']?['coordinates']?[2]! as num)
                            .toDouble(),
                  ),
                ],
          timestamp: json['timestamp']! as int,
          attribution: json['attribution'] as String,
          type: (json['geometry'] is List)
              ? 'point'
              : (json['geometry']?['type'] ?? 'point') as String,
          version: json['version'] as String,
        );

  /// Attribution to the source the elevation data has been extracted from.
  final String attribution;

  /// The coordinates of the elevation Geometry data. [Lat, Lng, Alt]
  final List<Coordinate> coordinates;

  /// The type of the elevation Geometry data.
  final String type;

  /// Timestamp when the elevation data was extracted.
  final int timestamp;

  /// Version of the elevation data.
  final String version;

  /// Construct JSON from the elevation data, as per the schema in the api
  /// documentation.
  ///
  /// The json will have keys 'timestamp', 'attribution', 'version', 'elevation'
  /// and 'geometry' which corresponds to a [Map] further containing keys
  /// 'coordinates' and 'type'.
  Map<String, dynamic> toJson() => {
        'attribution': attribution,
        'geometry': {
          'coordinates': coordinates
              .map<List<double>>((e) => [e.longitude, e.latitude, e.altitude])
              .toList(),
          'type': type,
        },
        'timestamp': timestamp,
        'version': version,
      };

  @override
  bool operator ==(Object other) =>
      other is ElevationData &&
      other.attribution == attribution &&
      other.coordinates.toString() == coordinates.toString() &&
      other.type == type &&
      other.version == version;

  @override
  int get hashCode => toJson().hashCode;

  @override
  String toString() => toJson().toString();
}
