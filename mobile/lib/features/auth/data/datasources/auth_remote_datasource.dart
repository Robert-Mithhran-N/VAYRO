import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiClient);
  final ApiClient _apiClient;

  Future<({UserModel user, AuthTokensModel tokens})> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.authLogin,
      data: {'email': email, 'password': password},
    );

    final data = response.data ?? {};
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>? ?? {});
    final tokens = AuthTokensModel.fromJson(data['tokens'] as Map<String, dynamic>? ?? {});

    return (user: user, tokens: tokens);
  }

  Future<({UserModel user, AuthTokensModel tokens})> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.authRegister,
      data: {
        'email': email,
        'password': password,
        'displayName': displayName,
      },
    );

    final data = response.data ?? {};
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>? ?? {});
    final tokens = AuthTokensModel.fromJson(data['tokens'] as Map<String, dynamic>? ?? {});

    return (user: user, tokens: tokens);
  }

  Future<UserModel> getProfile(String accessToken) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.authMe,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    final data = response.data ?? {};
    return UserModel.fromJson(data);
  }

  Future<AuthTokensModel> refreshTokens(String refreshToken) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.authRefresh,
      data: {'refreshToken': refreshToken},
    );

    final data = response.data ?? {};
    return AuthTokensModel.fromJson(data);
  }

  Future<void> logout(String? accessToken, String? refreshToken) async {
    await _apiClient.post<dynamic>(
      ApiEndpoints.authLogout,
      data: refreshToken != null ? {'refreshToken': refreshToken} : null,
      options: accessToken != null
          ? Options(headers: {'Authorization': 'Bearer $accessToken'})
          : null,
    );
  }
}
