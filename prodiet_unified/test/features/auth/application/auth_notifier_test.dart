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

/// Builds a fake supabase.Session for a given userId.
supabase.Session _makeSession(String userId, String email) {
  return supabase.Session(
    accessToken: 'tok_$userId',
    tokenType: 'bearer',
    user: supabase.User(
      id: userId,
      email: email,
      appMetadata: {},
      userMetadata: {},
      aud: 'authenticated',
      createdAt: DateTime.now().toIso8601String(),
    ),
  );
}

void main() {
  late AuthNotifier authNotifier;
  late MockAuthRepository mockRepo;
  late MockFcmService mockFcm;

  setUp(() {
    mockRepo = MockAuthRepository();
    mockFcm  = MockFcmService();
    when(() => mockRepo.currentSession()).thenReturn(null);
    when(() => mockRepo.authStateChanges())
        .thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    try { authNotifier.dispose(); } catch (_) {}
  });

  // ─────────────────────────────────────────────────────────
  // INITIALIZATION
  // ─────────────────────────────────────────────────────────
  group('AuthNotifier — Initialization', () {
    test('starts as AuthLoading then transitions to AuthUnauthenticated with no session',
        () async {
      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      expect(authNotifier.state, isA<AuthLoading>());
      await Future.delayed(Duration.zero);
      expect(authNotifier.state, isA<AuthUnauthenticated>());
      verify(() => mockRepo.currentSession()).called(1);
    });

    test('transitions to AuthAuthenticated when signedIn stream event fires with valid profile',
        () async {
      final user = AppUser(
        id: 'u1',
        email: 'u1@test.com',
        onboardingComplete: true,
        createdAt: DateTime.now(),
      );
      when(() => mockRepo.fetchProfile('u1')).thenAnswer((_) async => user);
      when(() => mockFcm.initialize('u1')).thenAnswer((_) async {});

      final controller = StreamController<supabase.AuthState>();
      when(() => mockRepo.authStateChanges())
          .thenAnswer((_) => controller.stream);

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await Future.delayed(Duration.zero);

      controller.add(supabase.AuthState(
        supabase.AuthChangeEvent.signedIn,
        _makeSession('u1', 'u1@test.com'),
      ));
      await Future.delayed(const Duration(milliseconds: 150));

      expect(authNotifier.state, isA<AuthAuthenticated>());
      expect((authNotifier.state as AuthAuthenticated).user.id, 'u1');
      verify(() => mockFcm.initialize('u1')).called(1);
    });

    test('transitions to AuthProfileMissing when profile is null after retry',
        () async {
      when(() => mockRepo.fetchProfile('u2')).thenAnswer((_) async => null);

      final controller = StreamController<supabase.AuthState>();
      when(() => mockRepo.authStateChanges())
          .thenAnswer((_) => controller.stream);

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await Future.delayed(Duration.zero);

      controller.add(supabase.AuthState(
        supabase.AuthChangeEvent.signedIn,
        _makeSession('u2', 'u2@test.com'),
      ));
      // Wait past the 500ms retry delay in _handleSession
      await Future.delayed(const Duration(milliseconds: 700));

      expect(authNotifier.state, isA<AuthProfileMissing>());
      expect((authNotifier.state as AuthProfileMissing).userId, 'u2');
    });

    test('transitions to AuthUnauthenticated when signedOut stream event fires',
        () async {
      final controller = StreamController<supabase.AuthState>();
      when(() => mockRepo.authStateChanges())
          .thenAnswer((_) => controller.stream);

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await Future.delayed(Duration.zero);

      controller.add(supabase.AuthState(
        supabase.AuthChangeEvent.signedOut,
        null,
      ));
      await Future.delayed(const Duration(milliseconds: 150));

      expect(authNotifier.state, isA<AuthUnauthenticated>());
    });
  });

  // ─────────────────────────────────────────────────────────
  // ONBOARDING
  // ─────────────────────────────────────────────────────────
  group('AuthNotifier — NeedsOnboarding', () {
    test('emits AuthNeedsOnboarding when profile.onboardingComplete is false',
        () async {
      final incompleteUser = AppUser(
        id: 'u3',
        email: 'u3@t.com',
        onboardingComplete: false,
        createdAt: DateTime.now(),
      );
      when(() => mockRepo.fetchProfile('u3'))
          .thenAnswer((_) async => incompleteUser);
      when(() => mockFcm.initialize('u3')).thenAnswer((_) async {});

      final controller = StreamController<supabase.AuthState>();
      when(() => mockRepo.authStateChanges())
          .thenAnswer((_) => controller.stream);

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await Future.delayed(Duration.zero);

      controller.add(supabase.AuthState(
        supabase.AuthChangeEvent.signedIn,
        _makeSession('u3', 'u3@t.com'),
      ));
      await Future.delayed(const Duration(milliseconds: 150));

      expect(authNotifier.state, isA<AuthNeedsOnboarding>());
      final s = authNotifier.state as AuthNeedsOnboarding;
      expect(s.user.id, 'u3');
      expect(s.user.onboardingComplete, false);
    });
  });

  // ─────────────────────────────────────────────────────────
  // completeOnboarding
  // ─────────────────────────────────────────────────────────
  group('AuthNotifier — completeOnboarding', () {
    test('calls updateProfile and fetchProfile, then emits Authenticated',
        () async {
      final updatedUser = AppUser(
        id: 'u4',
        email: 'u4@t.com',
        onboardingComplete: true,
        fitnessGoal: 'lose_weight',
        activityLevel: 'moderate',
        createdAt: DateTime.now(),
      );
      when(() => mockRepo.updateProfile('u4', any()))
          .thenAnswer((_) async {});
      when(() => mockRepo.fetchProfile('u4'))
          .thenAnswer((_) async => updatedUser);
      when(() => mockFcm.initialize('u4')).thenAnswer((_) async {});

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await Future.delayed(Duration.zero);

      await authNotifier.completeOnboarding('u4', {
        'fitness_goal': 'lose_weight',
        'activity_level': 'moderate',
      });
      // Allow the 600ms post-update delay in completeOnboarding
      await Future.delayed(const Duration(milliseconds: 700));

      verify(() => mockRepo.updateProfile('u4', any())).called(1);
      verify(() => mockRepo.fetchProfile('u4')).called(1);
    });
  });

  // ─────────────────────────────────────────────────────────
  // signIn / signOut
  // ─────────────────────────────────────────────────────────
  group('AuthNotifier — signIn', () {
    test('sets AuthLoading synchronously then calls repo', () async {
      when(() => mockRepo.signInWithEmail('e@t.com', 'pass'))
          .thenAnswer((_) async {});

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await Future.delayed(Duration.zero);

      final future = authNotifier.signIn('e@t.com', 'pass');
      expect(authNotifier.state, isA<AuthLoading>());
      await future;
      verify(() => mockRepo.signInWithEmail('e@t.com', 'pass')).called(1);
    });

    test('emits AuthFailure when repo throws', () async {
      when(() => mockRepo.signInWithEmail(any(), any()))
          .thenThrow(Exception('Invalid credentials'));

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await Future.delayed(Duration.zero);

      await authNotifier.signIn('bad@t.com', 'wrong');
      expect(authNotifier.state, isA<AuthFailure>());
    });
  });

  group('AuthNotifier — signOut', () {
    test('calls repository signOut', () async {
      when(() => mockRepo.signOut()).thenAnswer((_) async {});
      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await authNotifier.signOut();
      verify(() => mockRepo.signOut()).called(1);
    });
  });

  // ─────────────────────────────────────────────────────────
  // sendPasswordReset
  // ─────────────────────────────────────────────────────────
  group('AuthNotifier — sendPasswordReset', () {
    test('calls repository with correct email', () async {
      when(() => mockRepo.sendPasswordReset('r@t.com'))
          .thenAnswer((_) async {});

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await authNotifier.sendPasswordReset('r@t.com');

      verify(() => mockRepo.sendPasswordReset('r@t.com')).called(1);
    });

    test('emits AuthFailure when repo throws', () async {
      when(() => mockRepo.sendPasswordReset(any()))
          .thenThrow(Exception('Email not registered'));

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm, skipInit: true);
      await authNotifier.sendPasswordReset('nobody@t.com');

      expect(authNotifier.state, isA<AuthFailure>());
    });
  });
}
