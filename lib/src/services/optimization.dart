part of 'package:open_route_service/src/open_route_service_base.dart';

extension ORSOptimization on OpenRouteService {
  /// The endpoint of the openrouteservice Elevation API.
  static const String _optimizationEndpointURL =
      '${OpenRouteService._baseURL}/optimization';

  /// Get the Optimization Data from openrouteservice for Vehicle routing
  /// problem scheduling, for the input [jobs], [vehicles] and optionally
  /// custom [matrix] and [options].
  ///
  /// The optimization endpoint solves Vehicle Routing Problems and can be used
  /// to schedule multiple vehicles and jobs, respecting time windows,
  /// capacities and required skills.
  /// https://openrouteservice.org/dev/#/api-docs/optimization/post
  ///
  /// This service is based on the excellent Vroom project. Please also consult
  /// its API documentation.
  /// https://github.com/VROOM-Project/vroom/blob/master/docs/API.md
  Future<OptimizationData> optimizationDataPostGet({
    required List<VroomJob> jobs,
    required List<VroomVehicle> vehicles,
    List<dynamic>? matrix,
    Object? options,
  }) async {
    // Build the request URL.
    final Uri uri = Uri.parse(_optimizationEndpointURL);

    // Ready data to be sent.
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'jobs': jobs,
      'vehicles': vehicles,
      'matrix': matrix,
      'options': options,
    }..removeWhere((String _, dynamic value) => value == null);

    // Fetch and parse the data.
    final Map<String, dynamic> data =
        await _openRouteServicePost(uri: uri, data: queryParameters);
    return OptimizationData.fromJson(data);
  }
}
