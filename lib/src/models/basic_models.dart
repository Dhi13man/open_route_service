/// A Coordinate Data Model independent of any other external libraries.
/// Contains a [double] Latitude and a [double] Longitude value.
/// 
/// Should be easily convertible to a LatLng, GeoPoint etc for use in projects.
class Coordinate {
  /// Generates a coordinate from a [latitude] and [longitude].
  const Coordinate(this.latitude, this.longitude);

  /// Generates a [Map] having [String] keys 'latitude' and 'longitude',
  /// respectively having [latitude] and [longitude] as [double] values.
  Coordinate.fromJson(Map<String, dynamic> json)
      : this(json['latitude']! as double, json['longitude']! as double);

  /// The latitude of the coordinate.
  final double latitude;

  /// The longitude of the coordinate.
  final double longitude;

  /// Returns a [Map] having [String] keys 'latitude' and 'longitude',
  /// respectively having [latitude] and [longitude] as [double] values.
  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  String toString() => toJson().toString();
}
