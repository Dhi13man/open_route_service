import 'package:open_route_service/src/models/coordinate_model.dart';

/// Class Representing a Vroom API Vehicle model required as input to the
/// optimization API endpoint.
///
/// Full Data Schema available here:
/// https://github.com/VROOM-Project/vroom/blob/master/docs/API.md#vehicles
class VroomVehicle {
  const VroomVehicle({
    required this.id,
    this.profile = 'driving-car',
    this.description,
    this.start,
    this.startIndex,
    this.end,
    this.endIndex,
    this.capacity,
    this.skills,
    this.timeWindow,
    this.breaks,
    this.speedFactor = 1,
    this.maxTasks,
    this.steps,
  }) : assert(start != null || end != null);

  /// Generates a [VroomVehicle] from a [Map] having keys matching the Vroom API
  /// Vehicle model that includes:
  ///
  /// 'id', 'profile', 'description', 'start', 'start_index', 'end',
  /// 'end_index', 'capacity', 'skills', 'time_window', 'breaks',
  /// 'speed_factor', 'max_tasks', 'steps'.
  factory VroomVehicle.fromJson(Map<String, dynamic> json) => VroomVehicle(
        id: json['id'],
        profile: json['profile'],
        description: json['description'],
        start: Coordinate.fromList(json['start']),
        startIndex: json['start_index'],
        end: Coordinate.fromList(json['end']),
        endIndex: json['end_index'],
        capacity: json['capacity'] == null
            ? null
            : (json['capacity'] as List<dynamic>)
                .map<int>((e) => e as int)
                .toList(),
        skills: json['skills'] == null
            ? null
            : (json['skills'] as List<dynamic>)
                .map<int>((e) => e as int)
                .toList(),
        timeWindow: json['time_window'] == null
            ? null
            : (json['time_window'] as List<dynamic>)
                .map<int>((e) => e as int)
                .toList(),
        breaks: json['breaks'] == null
            ? null
            : (json['breaks'] as List<dynamic>)
                .map<VroomVehicleBreak>((e) => VroomVehicleBreak.fromJson(e))
                .toList(),
        speedFactor: json['speed_factor'],
        maxTasks: json['max_tasks'],
        steps: json['steps'] == null
            ? null
            : (json['steps'] as List<dynamic>)
                .map<VroomVehicleStep>((e) => VroomVehicleStep.fromJson(e))
                .toList(),
      );

  /// Unique [int] identifier for this vehicle.
  final int id;

  /// [String] describing this vehicle.
  final String? description;

  /// [String] describing the routing profile for this vehicle.
  final String profile;

  /// [Coordinate] object describing the start location of this vehicle.
  ///
  /// [start] and [end] are optional for a vehicle, as long as at least one of
  /// them is present. If start is omitted, the resulting route will start at
  /// the first visited task, whose choice is determined by the optimization
  /// process.
  ///
  /// To request a round trip, just specify both [start] and [end] with the same
  /// coordinates.
  final Coordinate? start;

  /// [int] Start index of relevant row and column in custom matrices.
  final int? startIndex;

  /// [Coordinate] object describing the end location of this vehicle.
  ///
  /// [start] and [end] are optional for a vehicle, as long as at least one of
  /// them is present. If end is omitted, the resulting route will stop at the
  /// last visited task, whose choice is determined by the optimization process
  ///
  /// To request a round trip, just specify both [start] and [end] with the same
  /// coordinates.
  final Coordinate? end;

  /// [int] End index of relevant row and column in custom matrices.
  final int? endIndex;

  /// [List] of [int] describing multidimensional quantities.
  final List<int>? capacity;

  /// [List] of [int] defining skills.
  final List<int>? skills;

  /// [List] of [int] Time window describing working hours.
  final List<int>? timeWindow;

  /// [List] of [VroomVehicleBreak] describing breaks.
  final List<VroomVehicleBreak>? breaks;

  /// [double] value used to scale all vehicle travel times. (Defaults to 1)
  /// The respected precision is limited to two digits after the decimal point.
  final double? speedFactor;

  /// [int] defining the maximum number of tasks in a route for this vehicle.
  final int? maxTasks;

  /// [List] of [VroomVehicleStep] describing a custom route for this vehicle.
  final List<VroomVehicleStep>? steps;

  /// [Map] representation of this [VroomVehicle] object having keys: 'id',
  /// 'profile', 'description', 'start', 'start_index', 'end', 'end_index',
  /// 'capacity', 'skills', 'time_window', 'breaks', 'speed_factor', 'max_tasks'
  /// and 'steps'.
  Map<String, dynamic> toJson() => {
        'id': id,
        'profile': profile,
        'description': description,
        'start': start?.toList(),
        'start_index': startIndex,
        'end': end?.toList(),
        'end_index': endIndex,
        'capacity': capacity,
        'skills': skills,
        'time_window': timeWindow,
        'breaks': breaks == null
            ? null
            : breaks!
                .map<Map<String, dynamic>>((VroomVehicleBreak b) => b.toJson())
                .toList(),
        'speed_factor': speedFactor,
        'max_tasks': maxTasks,
        'steps': steps == null
            ? null
            : steps!
                .map<Map<String, dynamic>>(
                    (VroomVehicleStep step) => step.toJson())
                .toList(),
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) => other is VroomVehicle && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Class Representing a Vroom API Job model required as input to the
/// optimization API endpoint.
///
/// Full Data Schema available here:
/// https://github.com/VROOM-Project/vroom/blob/master/docs/API.md#jobs
class VroomJob {
  const VroomJob({
    required this.id,
    this.location,
    this.description,
    this.locationIndex,
    this.setup = 0,
    this.service = 0,
    this.amount,
    this.delivery,
    this.pickup,
    this.skills,
    this.priority = 0,
    this.timeWindows,
  }) : assert(priority == null || (priority >= 0 && priority <= 100));

  /// Generates a VroomJob from a [Map] having keys matching the Vroom API Job
  /// model that includes:
  ///
  /// 'id', 'description', 'location', 'location_index', 'setup', 'service',
  /// 'amount', 'delivery', 'pickup', 'skills', 'priority', and 'time_windows'.
  factory VroomJob.fromJson(Map<String, dynamic> json) => VroomJob(
        id: json['id'],
        description: json['description'],
        location: Coordinate.fromList(json['location']),
        locationIndex: json['location_index'],
        setup: json['setup'],
        service: json['service'],
        amount: json['amount'] == null
            ? null
            : (json['amount'] as List<dynamic>)
                .map<int>((e) => e as int)
                .toList(),
        delivery: json['delivery'] == null
            ? null
            : (json['delivery'] as List<dynamic>)
                .map<int>((e) => e as int)
                .toList(),
        pickup: json['pickup'] == null
            ? null
            : (json['pickup'] as List<dynamic>)
                .map<int>((e) => e as int)
                .toList(),
        skills: json['skills'] == null
            ? null
            : (json['skills'] as List<dynamic>)
                .map<int>((e) => e as int)
                .toList(),
        priority: json['priority'],
        timeWindows: json['time_windows'] == null
            ? null
            : (json['time_windows'] as List<dynamic>)
                .map<List<int>>(
                  (timeWindow) => (timeWindow as List<dynamic>)
                      .map<int>((time) => time as int)
                      .toList(),
                )
                .toList(),
      );

  /// Unique [int] identifier for this job.
  final int id;

  /// [String] describing this job.
  final String? description;

  /// [Coordinate] describing the location of this job.
  final Coordinate? location;

  /// [int] index of relevant row and column in custom matrices.
  final int? locationIndex;

  /// [int] describing the setup duration of this job. Defaults to 0.
  final int? setup;

  /// [int] describing the service duration of this job. Defaults to 0.
  final int? service;

  /// [List] of [int] describing multidimensional quantities of this job for
  /// amount.
  final List<int>? amount;

  /// [List] of [int] describing multidimensional quantities of this job for
  /// delivery.
  final List<int>? delivery;

  /// [List] of [int] describing multidimensional quantities of this job for
  /// pickup.
  final List<int>? pickup;

  /// [List] of [int] describing mandatory skills of this job.
  final List<int>? skills;

  /// [int] describing the priority of this job. VALID RANGE: [0, 100].
  /// Defaults to 0.
  final int? priority;

  /// [List] of time windows describing the valid time windows for this job.
  final List<List<int>>? timeWindows;

  /// [Map] representation of this [VroomJob] having keys 'id', 'description',
  /// 'location', 'location_index', 'setup', 'service', 'amount', 'delivery',
  /// 'pickup', 'skills', 'priority', and 'time_windows'
  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'location': location?.toList(),
        'location_index': locationIndex,
        'setup': setup,
        'service': service,
        'amount': amount,
        'delivery': delivery,
        'pickup': pickup,
        'skills': skills,
        'priority': priority,
        'time_windows': timeWindows,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) => other is VroomJob && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Class Representing a Vroom API Vehicle Break Model.
///
/// View the Vehicles Section to find the Break Model schema.
/// https://github.com/VROOM-Project/vroom/blob/master/docs/API.md#vehicles
class VroomVehicleBreak {
  const VroomVehicleBreak({
    required this.id,
    this.timeWindows,
    this.service = 0,
    this.description,
  });

  /// Generates a VroomVehicleBreak from a [Map] having keys matching the Vroom
  /// API Vehicle Break model that includes:
  ///
  /// 'id', 'time_windows', 'service', and 'description'.
  factory VroomVehicleBreak.fromJson(Map<String, dynamic> json) =>
      VroomVehicleBreak(
        id: json['id'],
        timeWindows: json['time_windows'] == null
            ? null
            : (json['time_windows'] as List<dynamic>)
                .map<List<int>>(
                  (timeWindow) => (timeWindow as List<dynamic>)
                      .map<int>((time) => time as int)
                      .toList(),
                )
                .toList(),
        service: json['service'] ?? 0,
        description: json['description'],
      );

  /// Unique [int] identifier for this break.
  final int id;

  /// [List] of time windows describing the valid time windows for this break.
  final List<List<int>>? timeWindows;

  /// [num] describing the service duration of this break. Defaults to 0.
  final int service;

  /// [String] describing this break.
  final String? description;

  /// [Map] representation of this [VroomVehicleBreak] having keys 'id',
  /// 'time_windows', 'service', and 'description'.
  Map<String, dynamic> toJson() => {
        'id': id,
        'time_windows': timeWindows,
        'service': service,
        'description': description,
      };

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) =>
      other is VroomVehicleBreak && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Class Representing a Vroom API Vehicle Step Model.
///
/// [type] 	a string (either start, job, pickup, delivery, break or end)
/// [id] 	id of the task to be performed at this step if type value is job, pickup, delivery or break
/// [service_at] 	hard constraint on service time
/// [service_after] 	hard constraint on service time lower bound
/// [service_before] 	hard constraint on service time upper bound
///
/// View the Vehicles Section to find the Step Model schema.
/// https://github.com/VROOM-Project/vroom/blob/master/docs/API.md#vehicles
class VroomVehicleStep {
  const VroomVehicleStep({
    required this.id,
    required this.type,
    this.serviceAt,
    this.serviceAfter,
    this.serviceBefore,
  });

  /// Generates a VroomVehicleStep from a [Map] having keys matching the Vroom
  /// API Vehicle Step model that includes:
  ///
  /// 'type', 'id', 'service_at', 'service_after', and 'service_before'.
  factory VroomVehicleStep.fromJson(Map<String, dynamic> json) =>
      VroomVehicleStep(
        type: vroomVehicleStepTypeFromString(json['type'] as String),
        id: json['id'],
        serviceAt: json['service_at'],
        serviceAfter: json['service_after'],
        serviceBefore: json['service_before'],
      );

  /// [String] describing the type of this step.
  final VroomVehicleStepType type;

  /// [int] identifier for this step.
  final int id;

  /// [int] describing the hard constraint on service time.
  final int? serviceAt;

  /// [int] describing the hard constraint on service time lower bound.
  final int? serviceAfter;

  /// [int] describing the hard constraint on service time upper bound.
  final int? serviceBefore;

  /// Converts enum [VroomVehicleStepType] to corresponding [String].
  static String vroomVehicleStepTypeToString(VroomVehicleStepType type) {
    switch (type) {
      case VroomVehicleStepType.start:
        return 'start';

      case VroomVehicleStepType.job:
        return 'job';

      case VroomVehicleStepType.pickup:
        return 'pickup';

      case VroomVehicleStepType.delivery:
        return 'delivery';

      case VroomVehicleStepType.break_:
        return 'break';

      case VroomVehicleStepType.end:
        return 'end';

      default:
        throw ArgumentError('Invalid VroomVehicleStepType: $type');
    }
  }

  /// Converts [String] to corresponding enum [VroomVehicleStepType].
  static VroomVehicleStepType vroomVehicleStepTypeFromString(String type) {
    switch (type) {
      case 'start':
        return VroomVehicleStepType.start;

      case 'job':
        return VroomVehicleStepType.job;

      case 'pickup':
        return VroomVehicleStepType.pickup;

      case 'delivery':
        return VroomVehicleStepType.delivery;

      case 'break':
        return VroomVehicleStepType.break_;

      case 'end':
        return VroomVehicleStepType.end;

      default:
        throw ArgumentError('Invalid VroomVehicleStepType: $type');
    }
  }

  /// [Map] representation of this [VroomVehicleStep] having keys 'type',
  /// 'id', 'service_at', 'service_after', and 'service_before'.
  Map<String, dynamic> toJson() => {
        'type': vroomVehicleStepTypeToString(type),
        'id': id,
        'service_at': serviceAt,
        'service_after': serviceAfter,
        'service_before': serviceBefore,
      };

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) =>
      other is VroomVehicleStep && id == other.id && type == other.type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}

/// Enums of the Vroom Vehicle Step Types.
///
/// Corresponds to possible [VroomVehicleStep.type] values:
/// 'start', 'job', 'pickup', 'delivery', 'break' and 'end' respectively.
enum VroomVehicleStepType {
  start,
  job,
  pickup,
  delivery,
  break_,
  end,
}
