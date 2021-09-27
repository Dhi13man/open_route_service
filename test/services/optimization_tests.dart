import 'dart:convert';

import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

void optimizationTests({
  required OpenRouteService service,
  required String serializedJobs,
  required String serializedVehicles,
}) {
  test(
    'Fetch Optimizations from deserialized given Jobs and Vehicles using [getOptimizationData]',
    () async {
      // Parse the Job and Vehicle data
      final List<VroomJob> jobs = (json.decode(serializedJobs) as List<dynamic>)
          .map<VroomJob>((e) => VroomJob.fromJson(e))
          .toList();
      expect(jobs.length, greaterThan(0)); // Validate deserialization

      final List<VroomVehicle> vehicles =
          (json.decode(serializedVehicles) as List<dynamic>)
              .map<VroomVehicle>((e) => VroomVehicle.fromJson(e))
              .toList();
      expect(vehicles.length, greaterThan(0)); // Validate deserialization

      // Test API using parsed data.
      final OptimizationData optimizationData =
          await service.getOptimizationData(jobs: jobs, vehicles: vehicles);
      // Validate received data.
      expect(optimizationData.code, equals(0));
      expect(optimizationData.routes.length, greaterThan(0));
    },
  );
}
