part of 'package:open_route_service/src/open_route_service_base.dart';

/// OpenRouteService API profiles as enum values to prevent typos in direct
/// [String] usage.
///
/// Corresponds to one of the profiles taken by openrouteservice: "driving-car",
/// "driving-hgv", "cycling-road", "cycling-mountain", "cycling-electric",
/// "foot-walking", "foot-hiking", "wheelchair".
enum ORSProfile {
  drivingCar,
  drivingHgv,
  cyclingRoad,
  cyclingMountain,
  cyclingElectric,
  footWalking,
  footHiking,
  wheelchair,
}

/// Extension on [ORSProfile] to
/// - Provide a [String] representation of the profile
/// - Statically get [ORSProfile]s from [String]s.
extension ORSProfileNamer on ORSProfile {
  /// Returns the [String] representation of the openrouteservice profile
  /// represented by the enum.
  ///
  /// Throws [ArgumentError] if the enum is not a valid profile.
  String get name {
    switch (this) {
      case ORSProfile.drivingCar:
        return 'driving-car';

      case ORSProfile.drivingHgv:
        return 'driving-hgv';

      case ORSProfile.cyclingRoad:
        return 'cycling-road';

      case ORSProfile.cyclingMountain:
        return 'cycling-mountain';

      case ORSProfile.cyclingElectric:
        return 'cycling-electric';

      case ORSProfile.footWalking:
        return 'foot-walking';

      case ORSProfile.footHiking:
        return 'foot-hiking';

      case ORSProfile.wheelchair:
        return 'wheelchair';

      default:
        throw ArgumentError('Unknown ORSProfile: $this');
    }
  }

  /// Returns the [ORSProfile] represented by the [String] profileName.
  ///
  /// The [String] is case-sensitive and has to be one of: "driving-car",
  /// "driving-hgv", "cycling-road", "cycling-mountain", "cycling-electric",
  /// "foot-walking", "foot-hiking", "wheelchair".
  ///
  /// If the [String] is not one of the above, an [ArgumentError] is thrown.
  static ORSProfile fromName(final String profileName) {
    switch (profileName) {
      case 'driving-car':
        return ORSProfile.drivingCar;

      case 'driving-hgv':
        return ORSProfile.drivingHgv;

      case 'cycling-road':
        return ORSProfile.cyclingRoad;

      case 'cycling-mountain':
        return ORSProfile.cyclingMountain;

      case 'cycling-electric':
        return ORSProfile.cyclingElectric;

      case 'foot-walking':
        return ORSProfile.footWalking;

      case 'foot-hiking':
        return ORSProfile.footHiking;

      case 'wheelchair':
        return ORSProfile.wheelchair;

      default:
        throw ArgumentError('Unknown ORSProfile: $profileName');
    }
  }
}
