/// Placeholder contract for runtime device permissions.
abstract class PermissionService {
  Future<bool> hasLocationPermission();
  Future<bool> hasMicrophonePermission();
  Future<bool> hasNotificationPermission();
}

