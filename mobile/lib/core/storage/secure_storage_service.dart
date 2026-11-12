import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage contract for tokens and device-bound cryptographic secrets.
abstract class SecureStorageService {
  static const String keyAccessToken = 'vayro_jwt_access_token';
  static const String keyRefreshToken = 'vayro_jwt_refresh_token';
  static const String keyCachedUser = 'vayro_cached_user';

  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
  Future<void> deleteAll();
}

/// Standard implementation wrapping flutter_secure_storage.
class FlutterSecureStorageServiceImpl implements SecureStorageService {
  FlutterSecureStorageServiceImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  final FlutterSecureStorage _storage;

  @override
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) async {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}

/// In-memory secure storage implementation for unit tests and diagnostics.
class InMemorySecureStorageService implements SecureStorageService {
  final Map<String, String> _data = {};

  @override
  Future<void> write({required String key, required String value}) async {
    _data[key] = value;
  }

  @override
  Future<String?> read({required String key}) async {
    return _data[key];
  }

  @override
  Future<void> delete({required String key}) async {
    _data.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _data.clear();
  }
}
