import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../errors/app_exception.dart';
import '../logging/app_logger.dart';

/// Centralized Dio network client.
class ApiClient {
  ApiClient({required EnvConfig config, Dio? customDio})
      : _config = config,
        _dio = customDio ??
            Dio(
              BaseOptions(
                baseUrl: config.apiBaseUrl,
                connectTimeout: config.connectTimeout,
                receiveTimeout: config.receiveTimeout,
                headers: <String, String>{
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    if (customDio == null) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            AppLogger.info('HTTP ${options.method} -> ${options.uri}', 'ApiClient');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            AppLogger.info(
              'HTTP ${response.statusCode} <- ${response.requestOptions.uri}',
              'ApiClient',
            );
            return handler.next(response);
          },
          onError: (error, handler) {
            AppLogger.error(
              'HTTP Error: ${error.message} [${error.response?.statusCode}]',
              error,
              null,
              'ApiClient',
            );
            return handler.next(error);
          },
        ),
      );
    }
  }

  final EnvConfig _config;
  final Dio _dio;

  Dio get rawDio => _dio;
  String get baseUrl => _config.apiBaseUrl;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException('Unexpected request failure: $e');
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException('Unexpected request failure: $e');
    }
  }

  AppException _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout while contacting server.', error, statusCode);
      case DioExceptionType.connectionError:
        return NetworkException(
          'Failed to connect to backend at ${_dio.options.baseUrl}. '
          'Verify server is running and network route is reachable.',
          error,
          statusCode,
        );
      case DioExceptionType.badResponse:
        final message = data is Map ? (data['message']?.toString() ?? 'Server error') : error.message;
        return ServerException(message ?? 'Server error occurred.', data, statusCode);
      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled.');
      default:
        return NetworkException(error.message ?? 'Unknown network error.', error, statusCode);
    }
  }
}

