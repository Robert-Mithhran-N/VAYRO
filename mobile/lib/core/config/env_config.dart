/// Environment configuration with dart-define support and runtime overrides.
class EnvConfig {
  EnvConfig({
    String? apiBaseUrl,
    String? environment,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  })  : apiBaseUrl = apiBaseUrl ?? _defaultBaseUrl,
        environment = environment ?? const String.fromEnvironment('VAYRO_ENV', defaultValue: 'development'),
        connectTimeout = connectTimeout ?? const Duration(seconds: 10),
        receiveTimeout = receiveTimeout ?? const Duration(seconds: 10);

  final String apiBaseUrl;
  final String environment;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  static const String _defaultBaseUrl = String.fromEnvironment(
    'VAYRO_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api/v1',
  );

  bool get isDevelopment => environment == 'development';
  bool get isProduction => environment == 'production';

  EnvConfig copyWith({
    String? apiBaseUrl,
    String? environment,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) {
    return EnvConfig(
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      environment: environment ?? this.environment,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
    );
  }
}

