import 'package:open_route_service/open_route_service.dart';

/// A class that encapsulates the matrix of travel times between sources and
/// destinations.
///
/// Includes the travel time [durations] between each pair of points, the
/// [destinations] and the [sources].
///
/// https://openrouteservice.org/dev/#/api-docs/matrix
class Matrix {
  const Matrix({
    required this.durations,
    this.distances,
    required this.destinations,
    required this.sources,
  });

  /// Generate a [Matrix] of travel times between the sources and destinations
  /// from a [Map] having keys 'durations', 'destinations', and 'sources'.
  factory Matrix.fromJson(Map<String, dynamic> json) => Matrix(
        durations: (json['durations'] as List<dynamic>)
            .map<List<double>>(
              (duration) => (duration as List<dynamic>)
                  .map<double>((d) => d as double)
                  .toList(),
            )
            .toList(),
        distances: (json['distances'] as List<dynamic>?)
            ?.map<List<double>>(
              (duration) => (duration as List<dynamic>)
                  .map<double>((d) => d as double)
                  .toList(),
            )
            .toList(),
        destinations: (json['destinations'] as List<dynamic>)
            .map<MatrixLocation>(
              (destination) => MatrixLocation.fromJson(destination),
            )
            .toList(),
        sources: (json['sources'] as List<dynamic>)
            .map<MatrixLocation>((source) => MatrixLocation.fromJson(source))
            .toList(),
      );

  /// The travel times of the Matrix Routes
  final List<List<double>> durations;

  /// The destinations of the Matrix Routes
  final List<List<double>>? distances;

  /// The destination values of the Matrix.
  final List<MatrixLocation> destinations;

  /// The source values of the Matrix.
  final List<MatrixLocation> sources;

  /// Converts the [Matrix] to a [Map] having [String] keys 'durations',
  /// 'destinations', and 'sources'.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'durations': durations,
        'destinations': destinations
            .map<Map<String, dynamic>>((MatrixLocation e) => e.toJson())
            .toList(),
        'sources': sources
            .map<Map<String, dynamic>>((MatrixLocation e) => e.toJson())
            .toList(),
      };

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) =>
      other is Matrix &&
      destinations == other.destinations &&
      sources == other.sources &&
      durations == other.durations;

  @override
  int get hashCode => toJson().hashCode;
}

/// A class that denotes a source or destination location data in a Matrix.
///
/// Includes the [snappedDistance] and [location], the [Coordinate]
/// of the location.
class MatrixLocation {
  const MatrixLocation({required this.snappedDistance, required this.location});

  /// Generates a [MatrixLocation] from a [Map] having [String] keys
  /// 'latitude' and 'longitude', respectively having [latitude] and [longitude]
  /// as [double] values.
  factory MatrixLocation.fromJson(Map<String, dynamic> json) => MatrixLocation(
        snappedDistance: json['snapped_distance'],
        location: Coordinate.fromList(json['location'] as List<dynamic>),
      );

  /// The snapped distance of the location.
  final double snappedDistance;

  /// The coordinate of the location.
  final Coordinate location;

  /// Generates a [Map] having [String] keys 'snapped_distance' and 'location'
  /// which has [longitude] and [latitude] as a [List] of [double] values.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'snapped_distance': snappedDistance,
        'location': <double>[location.longitude, location.latitude],
      };

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) =>
      other is MatrixLocation &&
      other.snappedDistance == snappedDistance &&
      other.location == location;

  @override
  int get hashCode => snappedDistance.hashCode ^ location.hashCode;
}
