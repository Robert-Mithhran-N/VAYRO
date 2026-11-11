/// Placeholder contract for location services.
/// Location tracking will be activated in Phase 4 (Consent-based Location Engine).
abstract class LocationService {
  Future<bool> checkPermission();
  Future<bool> requestPermission();
}

