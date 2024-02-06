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
  static const Map<ORSProfile, String> _profileToNameMap = <ORSProfile, String>{
    ORSProfile.drivingCar: 'driving-car',
    ORSProfile.drivingHgv: 'driving-hgv',
    ORSProfile.cyclingRoad: 'cycling-road',
    ORSProfile.cyclingMountain: 'cycling-mountain',
    ORSProfile.cyclingElectric: 'cycling-electric',
    ORSProfile.footWalking: 'foot-walking',
    ORSProfile.footHiking: 'foot-hiking',
    ORSProfile.wheelchair: 'wheelchair',
  };

  static const Map<String, ORSProfile> _nameToProfileMap = <String, ORSProfile>{
    'driving-car': ORSProfile.drivingCar,
    'driving-hgv': ORSProfile.drivingHgv,
    'cycling-road': ORSProfile.cyclingRoad,
    'cycling-mountain': ORSProfile.cyclingMountain,
    'cycling-electric': ORSProfile.cyclingElectric,
    'foot-walking': ORSProfile.footWalking,
    'foot-hiking': ORSProfile.footHiking,
    'wheelchair': ORSProfile.wheelchair,
  };

  /// Returns the [String] representation of the openrouteservice profile
  /// represented by the enum.
  ///
  /// Throws [ArgumentError] if the enum is not a valid profile.
  String get name {
    if (_profileToNameMap.containsKey(this)) {
      return _profileToNameMap[this]!;
    }
    throw ArgumentError('Unknown ORSProfile: $this');
  }

  /// Returns the [ORSProfile] represented by the [String] profileName.
  ///
  /// The [String] is case-sensitive and has to be one of: "driving-car",
  /// "driving-hgv", "cycling-road", "cycling-mountain", "cycling-electric",
  /// "foot-walking", "foot-hiking", "wheelchair".
  ///
  /// If the [String] is not one of the above, an [ArgumentError] is thrown.
  static ORSProfile fromName(final String profileName) {
    if (_nameToProfileMap.containsKey(profileName)) {
      return _nameToProfileMap[profileName]!;
    }
    throw ArgumentError('Unknown ORSProfile: $profileName');
  }
}
