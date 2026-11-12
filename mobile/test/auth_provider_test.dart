import 'package:flutter_test/flutter_test.dart';
import 'package:vayro/features/auth/domain/entities/user_entity.dart';
import 'package:vayro/features/auth/domain/repositories/auth_repository.dart';
import 'package:vayro/features/auth/presentation/providers/auth_provider.dart';

class MockAuthRepository implements AuthRepository {
  UserEntity? currentUser;

  @override
  Future<UserEntity?> getCurrentUser() async => currentUser;

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    if (email == 'valid@vayro.app' && password == 'Password123!') {
      final user = UserEntity(
        id: 'usr-1',
        email: email,
        displayName: 'Test Traveler',
      );
      currentUser = user;
      return user;
    }
    throw Exception('Invalid email or password.');
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final user = UserEntity(
      id: 'usr-2',
      email: email,
      displayName: displayName,
    );
    currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    currentUser = null;
  }

  @override
  Future<String?> getAccessToken() async => currentUser != null ? 'test-access-token' : null;
}

void main() {
  group('AuthNotifier Tests', () {
    late MockAuthRepository mockRepo;
    late AuthNotifier notifier;

    setUp(() {
      mockRepo = MockAuthRepository();
      notifier = AuthNotifier(mockRepo);
    });

    test('initial state is AuthInitial, transitions to Unauthenticated when no cached session', () async {
      expect(notifier.state, isA<AuthInitial>());
      await notifier.checkAuthStatus();
      expect(notifier.state, isA<Unauthenticated>());
    });

    test('login with valid credentials transitions to Authenticated state', () async {
      await notifier.login(email: 'valid@vayro.app', password: 'Password123!');
      expect(notifier.state, isA<Authenticated>());
      final auth = notifier.state as Authenticated;
      expect(auth.user.email, 'valid@vayro.app');
      expect(auth.user.displayName, 'Test Traveler');
    });

    test('login with invalid credentials transitions to AuthError state', () async {
      await notifier.login(email: 'invalid@vayro.app', password: 'WrongPassword');
      expect(notifier.state, isA<AuthError>());
      final error = notifier.state as AuthError;
      expect(error.message, contains('Invalid email or password'));
    });

    test('logout transitions back to Unauthenticated state', () async {
      await notifier.login(email: 'valid@vayro.app', password: 'Password123!');
      expect(notifier.state, isA<Authenticated>());

      await notifier.logout();
      expect(notifier.state, isA<Unauthenticated>());
    });
  });
}
