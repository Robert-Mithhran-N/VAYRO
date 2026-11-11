import 'package:flutter_test/flutter_test.dart';
import 'package:vayro/core/config/env_config.dart';
import 'package:vayro/core/network/api_client.dart';

void main() {
  group('VAYRO Network Client Configuration Tests', () {
    test('EnvConfig initializes with defaults and allows copyWith updates', () {
      final config = EnvConfig();
      expect(config.environment, 'development');
      expect(config.isDevelopment, isTrue);

      final updated = config.copyWith(apiBaseUrl: 'http://192.168.1.50:3000/api/v1');
      expect(updated.apiBaseUrl, 'http://192.168.1.50:3000/api/v1');
      expect(updated.environment, 'development');
    });

    test('ApiClient instantiates with expected baseUrl and timeout options', () {
      final config = EnvConfig(apiBaseUrl: 'http://127.0.0.1:3000/api/v1');
      final client = ApiClient(config: config);

      expect(client.baseUrl, 'http://127.0.0.1:3000/api/v1');
      expect(client.rawDio.options.baseUrl, 'http://127.0.0.1:3000/api/v1');
      expect(client.rawDio.options.connectTimeout, const Duration(seconds: 10));
    });
  });
}

