/// A Coordinate Data Model independent of any other external libraries.
/// Contains a [double] Latitude, a [double] Longitude value and
/// a [double] Altitude value.
///
/// Should be easily convertible to a LatLng, GeoPoint etc for use in projects.
class Coordinate {
  /// Generates a coordinate from a [latitude] and [longitude].
  const Coordinate({
    required this.latitude,
    required this.longitude,
    this.altitude = 0,
  });

  /// Generates a [Coordinate] from a [Map] having [String] keys
  /// 'latitude' and 'longitude', respectively each having [double] values.
  factory Coordinate.fromJson(Map<String, dynamic> json) => Coordinate(
        latitude: json['latitude']! as double,
        longitude: json['longitude']! as double,
        altitude: json['longitude'] as double,
      );

  /// Generates a [Coordinate] from a [List] having [double] values.
  factory Coordinate.fromList(List<dynamic> json) => Coordinate(
        longitude: (json[0]! as num).toDouble(),
        latitude: (json[1]! as num).toDouble(),
        altitude: json.length > 2 ? (json[2]! as num).toDouble() : 0.0,
      );

  /// The latitude of the coordinate.
  final double latitude;

  /// The longitude of the coordinate.
  final double longitude;

  /// The altitude of the coordinate.
  final double? altitude;

  /// Returns a [Map] having [String] keys 'latitude' and 'longitude',
  /// respectively having [latitude] and [longitude] as [double] values.
  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
      }..removeWhere((key, value) => value == null);

  /// Returns a [List] having [double] values.
  /// [longitude] and [latitude] are the first two values respectively.
  /// [altitude] is the third value if it exists (otherwise it is 0.0).
  List<double> toList() => <double>[
        longitude,
        latitude,
        if (altitude != null) altitude!,
      ];

  /// Adding two coordinates.
  Coordinate operator +(Coordinate other) => Coordinate(
        latitude: latitude + other.latitude,
        longitude: longitude + other.longitude,
        altitude: (altitude == null && other.altitude == null)
            ? null
            : (altitude ?? 0.0) + (other.altitude ?? 0.0),
      );

  /// Subtracting two coordinates.
  Coordinate operator -(Coordinate other) => Coordinate(
        latitude: latitude - other.latitude,
        longitude: longitude - other.longitude,
        altitude: (altitude == null && other.altitude == null)
            ? null
            : (altitude ?? 0.0) - (other.altitude ?? 0.0),
      );

  @override
  bool operator ==(Object other) =>
      other is Coordinate &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.altitude == altitude;

  @override
  int get hashCode => toJson().hashCode;

  @override
  String toString() => toJson().toString();
}
