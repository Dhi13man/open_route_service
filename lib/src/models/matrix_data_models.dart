import 'package:open_route_service/open_route_service.dart';

/// A class that encapsulates the matrix of travel times between sources and
/// destinations.
///
/// Includes the travel time [durations] between each pair of points, the
/// [destinations] and the [sources].
///
/// https://openrouteservice.org/dev/#/api-docs/matrix
class TimeDistanceMatrix {
  const TimeDistanceMatrix({
    required this.durations,
    this.distances,
    required this.destinations,
    required this.sources,
  });

  /// Generate a [TimeDistanceMatrix] of travel times between the sources and
  /// destinations from a [Map] having keys 'durations', 'destinations',
  /// and 'sources'.
  factory TimeDistanceMatrix.fromJson(Map<String, dynamic> json) =>
      TimeDistanceMatrix(
        durations: (json['durations'] as List<dynamic>)
            .map<List<double>>(
              (dynamic duration) => (duration as List<dynamic>)
                  .map<double>((dynamic d) => d as double)
                  .toList(),
            )
            .toList(),
        distances: (json['distances'] as List<dynamic>?)
            ?.map<List<double>>(
              (dynamic duration) => (duration as List<dynamic>)
                  .map<double>((dynamic d) => d as double)
                  .toList(),
            )
            .toList(),
        destinations: (json['destinations'] as List<dynamic>)
            .map<TimeDistanceMatrixLocation>(
              (dynamic destination) =>
                  TimeDistanceMatrixLocation.fromJson(destination),
            )
            .toList(),
        sources: (json['sources'] as List<dynamic>)
            .map<TimeDistanceMatrixLocation>(
                (dynamic source) => TimeDistanceMatrixLocation.fromJson(source))
            .toList(),
      );

  /// The travel times of the Matrix Routes
  final List<List<double>> durations;

  /// The destinations of the Matrix Routes
  final List<List<double>>? distances;

  /// The destination values of the Matrix.
  final List<TimeDistanceMatrixLocation> destinations;

  /// The source values of the Matrix.
  final List<TimeDistanceMatrixLocation> sources;

  /// Converts the [TimeDistanceMatrix] to a [Map] having [String] keys
  /// 'durations', 'destinations', and 'sources'.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'durations': durations,
        'destinations': destinations
            .map<Map<String, dynamic>>(
                (TimeDistanceMatrixLocation e) => e.toJson())
            .toList(),
        'sources': sources
            .map<Map<String, dynamic>>(
                (TimeDistanceMatrixLocation e) => e.toJson())
            .toList(),
      };

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) =>
      other is TimeDistanceMatrix &&
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
class TimeDistanceMatrixLocation {
  const TimeDistanceMatrixLocation(
      {required this.snappedDistance, required this.location});

  /// Generates a [TimeDistanceMatrixLocation] from a [Map] having [String] keys
  /// 'latitude' and 'longitude', respectively having [latitude] and [longitude]
  /// as [double] values.
  factory TimeDistanceMatrixLocation.fromJson(Map<String, dynamic> json) =>
      TimeDistanceMatrixLocation(
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
      other is TimeDistanceMatrixLocation &&
      other.snappedDistance == snappedDistance &&
      other.location == location;

  @override
  int get hashCode => snappedDistance.hashCode ^ location.hashCode;
}
