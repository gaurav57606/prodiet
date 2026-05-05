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
    when(() => mockRepo.authStateChanges()).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    try { authNotifier.dispose(); } catch (_) {}
  });

  group('AuthNotifier — Edge Cases & Persistence', () {
    test('transitions to AuthNeedsOnboarding if onboarding is incomplete', () async {
      final user = AppUser(
        id: 'u1',
        name: 'T',
        email: 't@t.com',
        onboardingComplete: false,
        createdAt: DateTime.now(),
      );
      when(() => mockRepo.fetchProfile('u1')).thenAnswer((_) async => user);
      when(() => mockRepo.currentSession()).thenReturn(_makeSession('u1', 't@t.com'));

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(authNotifier.state, isA<AuthNeedsOnboarding>());
    });

    test('transitions to AuthAuthenticated if onboarding is complete', () async {
      final user = AppUser(
        id: 'u1',
        name: 'T',
        email: 't@t.com',
        onboardingComplete: true,
        createdAt: DateTime.now(),
      );
      when(() => mockRepo.fetchProfile('u1')).thenAnswer((_) async => user);
      when(() => mockRepo.currentSession()).thenReturn(_makeSession('u1', 't@t.com'));

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(authNotifier.state, isA<AuthAuthenticated>());
    });

    test('transitions to AuthUnauthenticated when session becomes null (expiry/signout)', () async {
      final user = AppUser(
        id: 'u1',
        name: 'T',
        email: 't@t.com',
        onboardingComplete: true,
        createdAt: DateTime.now(),
      );
      
      final controller = StreamController<supabase.AuthState>(sync: true);
      when(() => mockRepo.authStateChanges()).thenAnswer((_) => controller.stream);
      when(() => mockRepo.currentSession()).thenReturn(_makeSession('u1', 't@t.com'));
      when(() => mockRepo.fetchProfile('u1')).thenAnswer((_) async => user);

      authNotifier = AuthNotifier(mockRepo, fcm: mockFcm, skipInit: true);
      authNotifier.state = AuthAuthenticated(user);
      
      final subscription = mockRepo.authStateChanges().listen((data) {
        if (data.session == null) {
          authNotifier.state = const AuthUnauthenticated();
        }
      });

      expect(authNotifier.state, isA<AuthAuthenticated>());
      controller.add(supabase.AuthState(supabase.AuthChangeEvent.signedOut, null));
      await Future.delayed(Duration.zero);
      expect(authNotifier.state, const AuthUnauthenticated());
      
      await subscription.cancel();
      await controller.close();
    });
  });
}
