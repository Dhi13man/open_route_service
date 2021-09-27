import 'package:open_route_service/open_route_service.dart';

import 'package:open_route_service/src/models/optimization_models/vroom_data_models.dart'
    show VroomVehicleStepType;

/// A class encapsulating the Optimization Data received from the Optimization
/// endpoint of the openrouteservice API.
///
/// Includes the optimizations data's [code], its [summary], [unassigned]
/// and [routes].
///
/// https://openrouteservice.org/dev/#/api-docs/optimization
/// https://github.com/VROOM-Project/vroom
class OptimizationData {
  const OptimizationData({
    required this.code,
    required this.summary,
    required this.routes,
    this.unassigned = const [],
  });

  /// Generates a [OptimizationData] from a [Map] received from the API having
  /// the keys 'code', 'summary', 'routes' and 'unassigned'.
  factory OptimizationData.fromJson(Map<String, dynamic> json) =>
      OptimizationData(
        code: json['code'],
        summary: OptimizationSummary.fromJson(json['summary']),
        unassigned: json['unassigned'] as List<dynamic>,
        routes: (json['routes'] as List<dynamic>)
            .map<OptimizationRoute>((e) => OptimizationRoute.fromJson(e))
            .toList(),
      );

  /// [int] code of the optimization data.
  final int code;

  /// Summary of the optimization data.
  final OptimizationSummary summary;

  /// [List] of Unassigned data.
  final List<dynamic> unassigned;

  /// [List] of [OptimizationRoute]s of the optimization data.
  final List<OptimizationRoute> routes;

  /// Returns a [Map] representation of the [OptimizationData] object.
  ///
  /// The keys of the [Map] are 'code', 'summary', 'routes' and 'unassigned'.
  Map<String, dynamic> toJson() => {
        'code': code,
        'summary': summary.toJson(),
        'routes': routes
            .map<Map<String, dynamic>>((OptimizationRoute e) => e.toJson())
            .toList(),
        'unassigned': unassigned,
      };

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) =>
      other is OptimizationData &&
      runtimeType == other.runtimeType &&
      code == other.code &&
      summary == other.summary &&
      unassigned == other.unassigned &&
      routes == other.routes;

  @override
  int get hashCode => code.hashCode ^ summary.hashCode ^ unassigned.hashCode;
}

/// A class encapsulating the data included in the Optimization's Summary.
///
/// Includes the optimization's [cost], [unassigned], [delivery], [pickup],
/// [service], [duration], [waitingTime] and its [computingTimes] map.
class OptimizationSummary {
  const OptimizationSummary({
    this.cost,
    this.unassigned,
    this.amount,
    this.delivery,
    this.pickup,
    this.service = 0,
    this.duration,
    this.waitingTime,
    this.computingTimes,
  });

  /// Generates [OptimizationSummary] from a [Map] received from the API having
  /// the keys 'cost', 'unassigned', 'delivery', 'amount', 'pickup', 'service',
  /// 'duration', 'waiting_time' and 'computing_times'.
  factory OptimizationSummary.fromJson(Map<String, dynamic> json) =>
      OptimizationSummary(
        cost: json['cost'],
        unassigned: json['unassigned'],
        amount: ((json['amount'] ?? []) as List<dynamic>)
            .map<int>((e) => e as int)
            .toList(),
        delivery: ((json['delivery'] ?? []) as List<dynamic>)
            .map<int>((e) => e as int)
            .toList(),
        pickup: ((json['pickup'] ?? []) as List<dynamic>)
            .map<int>((e) => e as int)
            .toList(),
        service: json['service'],
        duration: json['duration'],
        waitingTime: json['waiting_time'],
        computingTimes: json['computing_times'] as Map<String, dynamic>,
      );

  /// [int] Optimized cost.
  final int? cost;

  /// [int] Count of unassigned values.
  final int? unassigned;

  /// [List] of [int] describing multidimensional quantities of this
  /// Optimization for amount.
  final List<int>? amount;

  /// [List] of [int] describing multidimensional quantities of this
  /// Optimization for delivery.
  final List<int>? delivery;

  /// [List] of [int] describing multidimensional quantities of this
  /// Optimization for pickup.
  final List<int>? pickup;

  /// [int] describing the service duration of this job. Defaults to 0.
  final int? service;

  /// [int] describing the duration of this Optimized job.
  final int? duration;

  /// [int] describing the waiting time for this Optimized job.
  final int? waitingTime;

  /// [Map] of [int] describing the computing times for each task.
  final Map<String, dynamic>? computingTimes;

  /// Returns a [Map] representation of the [OptimizationSummary] object.
  /// The keys of the [Map] are 'cost', 'unassigned', 'amount', 'delivery',
  /// 'pickup', 'service', 'duration', 'waiting_time' and 'computing_times'.
  Map<String, dynamic> toJson() => {
        'cost': cost,
        'unassigned': unassigned,
        'amount': amount,
        'delivery': delivery,
        'pickup': pickup,
        'service': service,
        'duration': duration,
        'waiting_time': waitingTime,
        'computing_times': computingTimes,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) =>
      other is OptimizationSummary && toString() == other.toString();

  @override
  int get hashCode => toJson().hashCode;
}

/// A class encapsulating the data included in the Optimization's Route.
///
/// Includes the optimization route's [vehicle], [cost], [delivery], [amount],
/// [pickup], [service], [duration], [waitingTime] and its [steps] list.
class OptimizationRoute {
  const OptimizationRoute({
    this.vehicle,
    this.cost,
    this.delivery,
    this.amount,
    this.pickup,
    this.service = 0,
    this.duration,
    this.waitingTime,
    this.steps = const <OptimizationRouteStep>[],
  });

  /// Generates [OptimizationRoute] from a [Map] received from the API having
  /// the keys 'vehicle', 'cost', 'delivery', 'amount', 'pickup', 'service',
  /// 'duration', 'waiting_time' and 'steps'.
  factory OptimizationRoute.fromJson(Map<String, dynamic> json) =>
      OptimizationRoute(
        vehicle: json['vehicle'],
        cost: json['cost'],
        amount: ((json['amount'] ?? []) as List<dynamic>)
            .map<int>((e) => e as int)
            .toList(),
        delivery: ((json['delivery'] ?? []) as List<dynamic>)
            .map<int>((e) => e as int)
            .toList(),
        pickup: ((json['pickup'] ?? []) as List<dynamic>)
            .map<int>((e) => e as int)
            .toList(),
        service: json['service'],
        duration: json['duration'],
        waitingTime: json['waiting_time'],
        steps: (json['steps'] as List<dynamic>)
            .map<OptimizationRouteStep>(
              (e) => OptimizationRouteStep.fromJson(e),
            )
            .toList(),
      );

  /// [int] describing the vehicle number used for this route.
  final int? vehicle;

  /// [int] describing the cost of this route.
  final int? cost;

  /// [List] of [int] describing multidimensional quantities of this
  /// [OptimizationRoute] for delivery.
  final List<int>? delivery;

  /// [List] of [int] describing multidimensional quantities of this
  /// [OptimizationRoute] for amount.
  final List<int>? amount;

  /// [List] of [int] describing multidimensional quantities of this
  /// [OptimizationRoute] for pickup.
  final List<int>? pickup;

  /// [int] describing the service duration of this job. Defaults to 0.
  final int? service;

  /// [int] describing the duration of this Optimized Route.
  final int? duration;

  /// [int] describing the waiting time for this Optimized Route.
  final int? waitingTime;

  /// [List] of [OptimizationRouteStep]s of this [OptimizationRoute].
  final List<OptimizationRouteStep> steps;

  /// Returns a [Map] representation of the [OptimizationRoute] object.
  /// The keys of the [Map] are 'vehicle', 'cost', 'delivery', 'amount',
  /// 'pickup', 'service', 'duration', 'waiting_time' and 'steps'.
  Map<String, dynamic> toJson() => {
        'vehicle': vehicle,
        'cost': cost,
        'amount': amount,
        'delivery': delivery,
        'pickup': pickup,
        'service': service,
        'duration': duration,
        'waiting_time': waitingTime,
        'steps': steps
            .map<Map<String, dynamic>>((OptimizationRouteStep e) => e.toJson())
            .toList(),
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) =>
      other is OptimizationRoute && toString() == other.toString();

  @override
  int get hashCode => toJson().hashCode;
}

/// The class encapsulating the data included in a Optimization Route's Step.
///
/// Includes the Optimization Route Step's [type], [location], [arrival],
/// [duration], [id], [service], [waitingTime], [job] and [load].
//type" :  "job" ,     +             "location" :  [  /* 2 items */  ] ,                 "id" :  1 ,                 "service" :  300 ,                 "waiting_time" :  0 ,                 "job" :  1 ,     +             "load" :  [  /* 1 item */  ] ,                 "arrival" :  32400 ,                 "duration" :  2544
class OptimizationRouteStep {
  const OptimizationRouteStep({
    required this.type,
    required this.location,
    required this.arrival,
    required this.duration,
    this.id,
    this.service = 0,
    this.waitingTime,
    this.job,
    this.load = const <int>[],
  });

  /// Generates [OptimizationRouteStep] from a [Map] received from the API having
  /// the keys 'type', 'location', 'arrival', 'duration', 'id', 'service',
  /// 'waiting_time', 'job' and 'load'.
  factory OptimizationRouteStep.fromJson(Map<String, dynamic> json) =>
      OptimizationRouteStep(
        type: json['type'],
        location: Coordinate.fromList(json['location'] as List<dynamic>),
        arrival: json['arrival'],
        duration: json['duration'],
        id: json['id'],
        service: json['service'],
        waitingTime: json['waiting_time'],
        job: json['job'],
        load: ((json['load'] ?? []) as List<dynamic>)
            .map<int>((e) => e as int)
            .toList(),
      );

  /// Corresponds to possible [VroomVehicleStepType] values:
  /// 'start', 'job', 'pickup', 'delivery', 'break' and 'end' respectively.
  final String type;

  /// [Coordinate] of the Route Step's location.
  final Coordinate location;

  /// [int] describing the identifier of this Route Step.
  final int? id;

  /// [int] describing the service duration of this job. Defaults to 0.
  final int service;

  /// [int] describing the waiting time for this Optimized Route Step.
  final int? waitingTime;

  /// [int] describing the job number of this Optimized Route Step.
  final int? job;

  /// [List] of [int] describing multidimensional quantities of this
  /// [OptimizationRouteStep]'s load.
  final List<int> load;

  /// [int] describing the arrival time of this Optimized Route Step.
  final int arrival;

  /// [int] describing the duration of this Optimized Route Step.
  final int duration;

  /// Returns a [Map] representation of the [OptimizationRouteStep] object.
  /// The keys of the [Map] are 'type', 'location', 'arrival', 'duration',
  /// 'id', 'service', 'waiting_time', 'job' and 'load'.
  Map<String, dynamic> toJson() => {
        'type': type,
        'location': location.toList(),
        'arrival': arrival,
        'duration': duration,
        'id': id,
        'service': service,
        'waiting_time': waitingTime,
        'job': job,
        'load': load,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) =>
      other is OptimizationRouteStep && toString() == other.toString();

  @override
  int get hashCode => toJson().hashCode;
}
