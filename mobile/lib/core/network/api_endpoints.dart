abstract final class ApiEndpoints {
  // Health & Diagnostics
  static const String health = '/health';
  static const String healthDatabase = '/health/database';
  static const String healthRedis = '/health/redis';
  static const String healthSmokeTest = '/health/smoke-test';

  // Authentication & Identity (Phase 2)
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';
  static const String authMe = '/auth/me';
}
