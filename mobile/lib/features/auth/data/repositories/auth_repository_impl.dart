import 'dart:convert';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService storageService,
  })  : _remoteDataSource = remoteDataSource,
        _storageService = storageService;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _storageService;

  @override
  Future<UserEntity?> getCurrentUser() async {
    final token = await _storageService.read(key: SecureStorageService.keyAccessToken);
    if (token == null) return null;

    try {
      final user = await _remoteDataSource.getProfile(token);
      await _cacheUser(user);
      return user;
    } catch (_) {
      // If fetching fails, attempt to read cached user profile
      final cachedJson = await _storageService.read(key: SecureStorageService.keyCachedUser);
      if (cachedJson != null) {
        try {
          return UserModel.fromJson(jsonDecode(cachedJson) as Map<String, dynamic>);
        } catch (_) {}
      }
      return null;
    }
  }

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    final result = await _remoteDataSource.login(email: email, password: password);
    await _saveAuthData(result.user, result.tokens.accessToken, result.tokens.refreshToken);
    return result.user;
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final result = await _remoteDataSource.register(
      email: email,
      password: password,
      displayName: displayName,
    );
    await _saveAuthData(result.user, result.tokens.accessToken, result.tokens.refreshToken);
    return result.user;
  }

  @override
  Future<void> logout() async {
    final token = await _storageService.read(key: SecureStorageService.keyAccessToken);
    final refreshToken = await _storageService.read(key: SecureStorageService.keyRefreshToken);

    try {
      await _remoteDataSource.logout(token, refreshToken);
    } catch (_) {
      // Local teardown should proceed even if remote revoke network call times out
    } finally {
      await _storageService.delete(key: SecureStorageService.keyAccessToken);
      await _storageService.delete(key: SecureStorageService.keyRefreshToken);
      await _storageService.delete(key: SecureStorageService.keyCachedUser);
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return _storageService.read(key: SecureStorageService.keyAccessToken);
  }

  Future<void> _saveAuthData(UserModel user, String accessToken, String refreshToken) async {
    await _storageService.write(key: SecureStorageService.keyAccessToken, value: accessToken);
    await _storageService.write(key: SecureStorageService.keyRefreshToken, value: refreshToken);
    await _cacheUser(user);
  }

  Future<void> _cacheUser(UserModel user) async {
    await _storageService.write(
      key: SecureStorageService.keyCachedUser,
      value: jsonEncode(user.toJson()),
    );
  }
}
