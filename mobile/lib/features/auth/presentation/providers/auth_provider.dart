import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../home/presentation/providers/health_provider.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// --- Auth States ---

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class Authenticated extends AuthState {
  const Authenticated(this.user);
  final UserEntity user;
  @override
  List<Object?> get props => [user];
}

final class Unauthenticated extends AuthState {}

final class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

// --- Providers ---

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return InMemorySecureStorageService();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSource(apiClient);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final storageService = ref.watch(secureStorageServiceProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    storageService: storageService,
  );
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository)..checkAuthStatus();
});

// --- State Notifier ---

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(AuthInitial());
  final AuthRepository _repository;

  Future<void> checkAuthStatus() async {
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = Authenticated(user);
      } else {
        state = Unauthenticated();
      }
    } catch (_) {
      state = Unauthenticated();
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = AuthLoading();
    try {
      final user = await _repository.login(email: email, password: password);
      state = Authenticated(user);
    } catch (e) {
      state = AuthError(_cleanErrorMessage(e));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = AuthLoading();
    try {
      final user = await _repository.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = Authenticated(user);
    } catch (e) {
      state = AuthError(_cleanErrorMessage(e));
    }
  }

  Future<void> logout() async {
    state = AuthLoading();
    try {
      await _repository.logout();
    } finally {
      state = Unauthenticated();
    }
  }

  String _cleanErrorMessage(Object error) {
    final str = error.toString();
    if (str.contains(':')) {
      return str.split(':').last.trim();
    }
    return str;
  }
}
