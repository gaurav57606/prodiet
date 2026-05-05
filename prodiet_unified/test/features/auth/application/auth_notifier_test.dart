import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/features/auth/data/auth_repository.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/core/services/fcm_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class MockAuthRepository extends Mock implements AuthRepository {}
class MockFcmService extends Mock implements FcmService {}
class MockAppUser extends Mock implements AppUser {}

void main() {
  late AuthNotifier authNotifier;
  late MockAuthRepository mockRepo;
  late MockFcmService mockFcm;

  setUp(() {
    mockRepo = MockAuthRepository();
    mockFcm = MockFcmService();

    // Default stubbing for initialization
    when(() => mockRepo.currentSession()).thenReturn(null);
    when(() => mockRepo.authStateChanges()).thenAnswer((_) => const Stream.empty());
  });

  group('AuthNotifier Initialization', () {
    test('should start in AuthLoading and transition to AuthUnauthenticated if no session', () async {
      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);

      expect(authNotifier.state, isA<AuthLoading>());

      // Wait for microtask in _init
      await Future.delayed(Duration.zero);

      expect(authNotifier.state, isA<AuthUnauthenticated>());
      verify(() => mockRepo.currentSession()).called(1);
    });

    test('should transition to AuthAuthenticated if session and profile exist', () async {
      final user = AppUser(
        id: 'u1',
        email: 'u1@test.com',
        onboardingComplete: true,
        createdAt: DateTime.now(),
      );
      
      when(() => mockRepo.currentSession()).thenReturn(null); // Simple for now
      when(() => mockRepo.fetchProfile('u1')).thenAnswer((_) async => user);
      when(() => mockFcm.initialize('u1')).thenAnswer((_) async {});

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      
      // Manually trigger a session handle since we mocked currentSession as null initially
      await authNotifier.signIn('u1@test.com', 'pass'); // This will call signIn in repo
      
      // Actually, let's test the stream change
      final controller = StreamController<supabase.AuthState>();
      when(() => mockRepo.authStateChanges()).thenAnswer((_) => controller.stream);
      
      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await Future.delayed(Duration.zero);

      // Simulate sign in event
      final mockSession = supabase.Session(
        accessToken: 'abc',
        tokenType: 'bearer',
        user: supabase.User(
          id: 'u1',
          email: 'u1@test.com',
          appMetadata: {},
          userMetadata: {},
          aud: 'aud',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
      
      controller.add(supabase.AuthState(supabase.AuthChangeEvent.signedIn, mockSession));
      
      // Wait for async processing in notifier
      await Future.delayed(const Duration(milliseconds: 100));

      expect(authNotifier.state, isA<AuthAuthenticated>());
      final authenticatedState = authNotifier.state as AuthAuthenticated;
      expect(authenticatedState.user.id, 'u1');
      verify(() => mockFcm.initialize('u1')).called(1);
    });

    test('should transition to AuthProfileMissing if profile does not exist after retry', () async {
      final controller = StreamController<supabase.AuthState>();
      when(() => mockRepo.authStateChanges()).thenAnswer((_) => controller.stream);
      when(() => mockRepo.fetchProfile('u2')).thenAnswer((_) async => null);

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await Future.delayed(Duration.zero);

      final mockSession = supabase.Session(
        accessToken: 'abc',
        tokenType: 'bearer',
        user: supabase.User(
          id: 'u2',
          email: 'u2@test.com',
          appMetadata: {},
          userMetadata: {},
          aud: 'aud',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
      
      controller.add(supabase.AuthState(supabase.AuthChangeEvent.signedIn, mockSession));
      
      // Wait for async processing (including the 500ms delay in _handleSession)
      await Future.delayed(const Duration(milliseconds: 700));

      expect(authNotifier.state, isA<AuthProfileMissing>());
      expect((authNotifier.state as AuthProfileMissing).userId, 'u2');
    });
  });

  group('Auth Actions', () {
    test('signIn should call repository and handle loading state', () async {
      when(() => mockRepo.signInWithEmail('e', 'p')).thenAnswer((_) async {});
      
      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await Future.delayed(Duration.zero);
      
      final future = authNotifier.signIn('e', 'p');
      
      expect(authNotifier.state, isA<AuthLoading>());
      await future;
      
      verify(() => mockRepo.signInWithEmail('e', 'p')).called(1);
    });

    test('signOut should call repository', () async {
      when(() => mockRepo.signOut()).thenAnswer((_) async {});
      
      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await authNotifier.signOut();
      
      verify(() => mockRepo.signOut()).called(1);
    });
  });
}
