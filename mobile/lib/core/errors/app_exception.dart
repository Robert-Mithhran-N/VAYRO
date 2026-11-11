/// Base class for all VAYRO mobile exceptions.
sealed class AppException implements Exception {
  const AppException(this.message, [this.details]);
  final String message;
  final Object? details;

  @override
  String toString() => '$runtimeType: $message${details != null ? ' ($details)' : ''}';
}

final class NetworkException extends AppException {
  const NetworkException(super.message, [super.details, this.statusCode]);
  final int? statusCode;
}

final class ServerException extends AppException {
  const ServerException(super.message, [super.details, this.statusCode]);
  final int? statusCode;
}

final class DatabaseException extends AppException {
  const DatabaseException(super.message, [super.details]);
}

final class ConfigurationException extends AppException {
  const ConfigurationException(super.message, [super.details]);
}

