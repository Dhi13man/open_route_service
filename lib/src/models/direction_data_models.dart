import 'package:open_route_service/open_route_service.dart';

/// A class that encapsulates Direction Route data received from the JSON
/// endpoint of Directions API.
///
/// Includes the Route's [summary], [segments], [bbox], [geometry]
/// and [waypoints].
///
/// https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/post
class DirectionRouteData {
  const DirectionRouteData({
    required this.summary,
    required this.segments,
    required this.bbox,
    required this.geometry,
    required this.wayPoints,
  });

  /// Generates a [DirectionRouteData] from a received [Map] having the keys
  /// 'summary', 'segments', 'bbox', 'geometry', and 'way_points'.
  factory DirectionRouteData.fromJson(Map<String, dynamic> json) =>
      DirectionRouteData(
        summary: DirectionRouteSummary.fromJson(json['summary']),
        segments: (json['segments'] as List<dynamic>)
            .map<DirectionRouteSegment>(
                (segment) => DirectionRouteSegment.fromJson(segment))
            .toList(),
        bbox: <Coordinate>[
          Coordinate(longitude: json['bbox'][0], latitude: json['bbox'][1]),
          Coordinate(longitude: json['bbox'][2], latitude: json['bbox'][3])
        ],
        geometry: json['geometry'] as String,
        wayPoints: (json['way_points'] as List<dynamic>)
            .map<double>((dynamic e) => (e as num).toDouble())
            .toList(),
      );

  /// The summary of the route.
  final DirectionRouteSummary summary;

  /// The list of [DirectionRouteSegment]s comprising the route.
  final List<DirectionRouteSegment> segments;

  /// The bounding box covering the route.
  final List<Coordinate> bbox;

  /// The geometry of the route as encoded polyline.
  final String geometry;

  /// The list of waypoints marking the route.
  final List<double> wayPoints;

  /// Converts the [DirectionRouteData] to a [Map] with keys 'summary',
  /// 'segments', 'bbox', 'geometry', and 'way_points'.
  ///
  /// The 'bbox' key is converted to a list of 4 [double]s implying
  /// 2 coordinates.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'summary': summary.toJson(),
        'segments': segments
            .map<Map<String, dynamic>>(
              (DirectionRouteSegment segment) => segment.toJson(),
            )
            .toList(),
        'bbox': [
          bbox[0].longitude,
          bbox[0].latitude,
          bbox[1].longitude,
          bbox[1].latitude,
        ],
        'geometry': geometry,
        'way_points': wayPoints,
      };

  @override
  String toString() => toJson().toString();
}

/// A class that encapsulates the summary of a [DirectionRouteData].
///
/// Includes the [distance] and [duration] for travelling the route.
class DirectionRouteSummary {
  const DirectionRouteSummary({
    required this.distance,
    required this.duration,
  });

  /// Generates a [DirectionRouteSummary] from a received [Map] having the keys
  /// 'distance' and 'duration'.
  factory DirectionRouteSummary.fromJson(Map<String, dynamic> json) =>
      DirectionRouteSummary(
        distance: json['distance'] as double,
        duration: json['duration'] as double,
      );

  /// The distance of the route.
  final double distance;

  /// The duration required to travel the route.
  final double duration;

  /// Converts the [DirectionRouteSummary] to [Map] with keys
  /// 'distance' and 'duration'.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'distance': distance,
        'duration': duration,
      };

  @override
  String toString() => toJson().toString();
}

/// A class that encapsulates a segment of a [DirectionRouteData].
///
/// Includes the [distance], [duration] and a [List] of [DirectionRouteSegmentStep]
/// ([steps]) for travelling the segment.
class DirectionRouteSegment {
  const DirectionRouteSegment({
    required this.distance,
    required this.duration,
    required this.steps,
  });

  /// Generates a [DirectionRouteSegment] from a received [Map] having the keys
  /// 'distance', 'duration' and 'steps'.
  factory DirectionRouteSegment.fromJson(Map<String, dynamic> json) =>
      DirectionRouteSegment(
        distance: json['distance'] as double,
        duration: json['duration'] as double,
        steps: (json['steps'] as List<dynamic>)
            .map<DirectionRouteSegmentStep>(
                (step) => DirectionRouteSegmentStep.fromJson(step))
            .toList(),
      );

  /// The distance of the route segment.
  final double distance;

  /// The duration required to travel the route segment.
  final double duration;

  /// The list of [DirectionRouteSegmentStep]s that need to be taken to travel
  /// the route segment.
  final List<DirectionRouteSegmentStep> steps;

  /// Converts the [DirectionRouteSegment] to a [Map] with keys 'distance',
  /// 'duration' and 'steps'.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'distance': distance,
        'duration': duration,
        'steps': steps
            .map<Map<String, dynamic>>(
              (DirectionRouteSegmentStep step) => step.toJson(),
            )
            .toList(),
      };

  @override
  String toString() => toJson().toString();
}

/// A class that encapsulates one step of all the steps need to travel
/// a [DirectionRouteSegment].
///
/// Includes the [distance], [duration] and [instruction] for travelling
/// the [DirectionRouteSegment]'s step with its [name], as well as the [type],
/// and [wayPoints] for the step.
class DirectionRouteSegmentStep {
  const DirectionRouteSegmentStep({
    required this.distance,
    required this.duration,
    required this.type,
    required this.instruction,
    required this.name,
    required this.wayPoints,
  });

  /// Generates a [DirectionRouteSegmentStep] from a received [Map] having the
  /// keys 'distance', 'duration', 'type', 'instruction', 'name', 'way_points'.
  factory DirectionRouteSegmentStep.fromJson(Map<String, dynamic> json) =>
      DirectionRouteSegmentStep(
        distance: json['distance'] as double,
        duration: json['duration'] as double,
        type: json['type'] as int,
        instruction: json['instruction'] as String,
        name: json['name'] as String,
        wayPoints: (json['way_points'] as List<dynamic>)
            .map<double>((dynamic e) => (e as num).toDouble())
            .toList(),
      );

  /// The distance of the route segment step.
  final double distance;

  /// The duration required to travel the route segment step.
  final double duration;

  /// The type of the route segment step.
  final int type;

  /// The instruction needed to be followed to travel the route segment step.
  final String instruction;

  /// The name of the route segment step.
  final String name;

  /// The list of waypoints marking the route segment step.
  final List<double> wayPoints;

  /// Converts the [DirectionRouteSegmentStep] to a [Map] with keys 'distance',
  /// 'duration', 'type', 'instruction', 'name', and 'way_points'.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'distance': distance,
        'duration': duration,
        'type': type,
        'instruction': instruction,
        'name': name,
        'way_points': wayPoints,
      };

  @override
  String toString() => toJson().toString();
}
