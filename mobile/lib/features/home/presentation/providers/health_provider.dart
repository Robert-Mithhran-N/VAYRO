import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/local_database.dart';
import '../../../../shared/models/health_status_model.dart';

/// Provider for Environment Configuration with override support.
final envConfigProvider = StateNotifierProvider<EnvConfigNotifier, EnvConfig>((ref) {
  return EnvConfigNotifier();
});

class EnvConfigNotifier extends StateNotifier<EnvConfig> {
  EnvConfigNotifier() : super(EnvConfig());

  void setBaseUrl(String newUrl) {
    state = state.copyWith(apiBaseUrl: newUrl);
  }
}

/// Centralized ApiClient provider reacting to configuration changes.
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(envConfigProvider);
  return ApiClient(config: config);
});

/// Local health repository provider (in-memory / Drift persistence).
final localHealthRepositoryProvider = Provider<LocalHealthRepository>((ref) {
  final repo = InMemoryHealthRepository();
  ref.onDispose(() {
    repo.dispose();
  });
  return repo;
});

/// Async state for integration smoke test.
final backendHealthProvider = FutureProvider.autoDispose<BackendHealthModel>((ref) async {
  final client = ref.watch(apiClientProvider);
  final localRepo = ref.watch(localHealthRepositoryProvider);

  AppLogger.info('Triggering health check request to ${client.baseUrl}', 'HealthProvider');
  
  final response = await client.get<Map<String, dynamic>>(ApiEndpoints.healthSmokeTest);
  final data = response.data ?? <String, dynamic>{};
  final model = BackendHealthModel.fromJson(data);

  // Persist record to local Drift database
  await localRepo.insertRecord(
    checkType: 'backend_smoke_test',
    status: model.isHealthy ? 'SUCCESS' : 'FAILED',
    details: 'Backend ${model.version} | DB: ${model.databaseStatus}',
  );

  return model;
});

