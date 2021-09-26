import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

void matrixTests({
  required OpenRouteService service,
  required List<Coordinate> locations,
}) {
  test(
    'Get Matrix Data (without distances) using [getMatrix], for all profiles',
    () async {
      for (OpenRouteServiceProfile profile in OpenRouteServiceProfile.values) {
        final Matrix matrix = await service.getMatrix(
          locations: locations,
          
          profileOverride: profile,
        );

        final int numDestinations = matrix.destinations.length;
        final int numSources = matrix.sources.length;
        final int numDurations = matrix.durations.length;

        // Check if all the arrays except distances have been received
        expect(numDestinations, greaterThan(0));
        expect(numSources, greaterThan(0));
        expect(numDurations, greaterThan(0));

        // Validate if the number of destinations, sources and durations match
        expect(
          numDestinations == numSources && numDestinations == numDurations,
          true,
        );
      }
    },
  );

  test(
    'Get Matrix Data (with distances) using [getMatrix]',
    () async {
      final Matrix matrix = await service.getMatrix(
        locations: locations,
        metrics: ['distance', 'duration'],
      );

      final int numDestinations = matrix.destinations.length;
      final int numSources = matrix.sources.length;
      final int numDurations = matrix.durations.length;
      final int numDistances = matrix.distances!.length;

      // Check if all the arrays have been received
      expect(numDestinations, greaterThan(0));
      expect(numSources, greaterThan(0));
      expect(numDurations, greaterThan(0));
      expect(numDistances, greaterThan(0));

      // Validate if the number of destinations, sources and
      // durations, distances are equal
      expect(numSources == numDestinations, true);
      expect(numDurations == numDistances, true);
    },
  );
}
