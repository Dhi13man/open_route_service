import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

void matrixTests({
  required OpenRouteService service,
  required List<ORSCoordinate> locations,
}) {
  test(
    'Get Matrix Data (without distances) using [matrixPostGet], for all profiles',
    () async {
      for (ORSProfile profile in ORSProfile.values) {
        final TimeDistanceMatrix matrix = await service.matrixPost(
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
    'Get Matrix Data (with distances) using [matrixPostGet]',
    () async {
      final TimeDistanceMatrix matrix = await service.matrixPost(
        locations: locations,
        metrics: <String>['distance', 'duration'],
      );

      final int numDestinations = matrix.destinations.length;
      final int numSources = matrix.sources.length;
      final int numDurations = matrix.durations.length;
      final int numDistances = matrix.distances.length;

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
