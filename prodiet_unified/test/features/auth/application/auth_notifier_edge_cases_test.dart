import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_async/fake_async.dart';
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
    when(() => mockFcm.initialize(any())).thenAnswer((_) => Future<void>.value());
  });

  tearDown(() {
    try { authNotifier.dispose(); } catch (_) {}
  });

  group('AuthNotifier — Persistence & Edge Cases', () {
    test('onboardingComplete survives completeOnboarding and re-init (Persistence)', () {
      fakeAsync((async) {
        final userBefore = AppUser(
          id: 'u1', name: 'Test', email: 'u1@t.com', 
          onboardingComplete: false, createdAt: DateTime.now(),
        );
        final userAfter = userBefore.copyWith(onboardingComplete: true);

        when(() => mockRepo.fetchProfile('u1')).thenAnswer((_) async => userBefore);
        when(() => mockRepo.currentSession()).thenReturn(_makeSession('u1', 'u1@t.com'));
        when(() => mockRepo.updateProfile('u1', any())).thenAnswer((_) async {});

        authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
        async.flushMicrotasks();
        expect(authNotifier.state, isA<AuthNeedsOnboarding>());

        // 2. Complete Onboarding
        when(() => mockRepo.fetchProfile('u1')).thenAnswer((_) async => userAfter);
        
        authNotifier.completeOnboarding('u1', {'goal': 'lose_weight'});
        async.elapse(const Duration(milliseconds: 800)); 
        
        expect(authNotifier.state, isA<AuthAuthenticated>());
        verify(() => mockRepo.updateProfile('u1', any())).called(1);

        // 3. Simulate App Restart
        authNotifier.dispose();
        
        when(() => mockRepo.fetchProfile('u1')).thenAnswer((_) async => userAfter);
        when(() => mockRepo.currentSession()).thenReturn(_makeSession('u1', 'u1@t.com'));
        
        authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
        async.elapse(const Duration(milliseconds: 100));
        
        expect(authNotifier.state, isA<AuthAuthenticated>());
        expect((authNotifier.state as AuthAuthenticated).user.onboardingComplete, true);
      });
    });

    test('handles tokenRefreshed event and updates profile', () {
      fakeAsync((async) {
        final userBefore = AppUser(id: 'u1', name: 'Old', email: 'u1@t.com', onboardingComplete: true, createdAt: DateTime.now());
        final userAfter = userBefore.copyWith(name: 'New');
        
        final controller = StreamController<supabase.AuthState>(sync: true);
        when(() => mockRepo.authStateChanges()).thenAnswer((_) => controller.stream);
        when(() => mockRepo.currentSession()).thenReturn(_makeSession('u1', 'u1@t.com'));
        when(() => mockRepo.fetchProfile('u1')).thenAnswer((_) async => userBefore);

        authNotifier = AuthNotifier(mockRepo, fcm: mockFcm);
        async.flushMicrotasks();
        expect(authNotifier.state, isA<AuthAuthenticated>());
        expect((authNotifier.state as AuthAuthenticated).user.name, 'Old');

        // Trigger tokenRefreshed
        when(() => mockRepo.fetchProfile('u1')).thenAnswer((_) async => userAfter);
        controller.add(supabase.AuthState(supabase.AuthChangeEvent.tokenRefreshed, _makeSession('u1', 'u1@t.com')));
        async.flushMicrotasks();
        
        expect(authNotifier.state, isA<AuthAuthenticated>());
        expect((authNotifier.state as AuthAuthenticated).user.name, 'New');
        
        controller.close();
      });
    });

    test('transitions to AuthUnauthenticated when session becomes null (Expiry/Signout)', () {
      fakeAsync((async) {
        final user = AppUser(
          id: 'u1', name: 'T', email: 't@t.com', 
          onboardingComplete: true, createdAt: DateTime.now(),
        );
        
        final controller = StreamController<supabase.AuthState>(sync: true);
        when(() => mockRepo.authStateChanges()).thenAnswer((_) => controller.stream);
        when(() => mockRepo.currentSession()).thenReturn(_makeSession('u1', 't@t.com'));
        when(() => mockRepo.fetchProfile('u1')).thenAnswer((_) async => user);

        authNotifier = AuthNotifier(mockRepo, fcm: mockFcm, skipInit: true);
        authNotifier.state = AuthAuthenticated(user);
        
        final sub = mockRepo.authStateChanges().listen((data) {
          if (data.session == null) {
            authNotifier.state = const AuthUnauthenticated();
          }
        });

        expect(authNotifier.state, isA<AuthAuthenticated>());
        
        controller.add(const supabase.AuthState(supabase.AuthChangeEvent.signedOut, null));
        async.flushMicrotasks();
        
        expect(authNotifier.state, const AuthUnauthenticated());
        
        sub.cancel();
        controller.close();
      });
    });

    test('retryProfileLoad stops after dispose (Prevent Timer Leaks)', () {
      fakeAsync((async) {
        when(() => mockRepo.fetchProfile('u2')).thenAnswer((_) async => null);
        
        authNotifier = AuthNotifier(mockRepo, fcm: mockFcm, skipInit: true);
        authNotifier.state = const AuthProfileMissing('u2');

        // Start retry loop
        authNotifier.retryProfileLoad('u2');
        
        // Elapse first backoff (500ms)
        async.elapse(const Duration(milliseconds: 600));
        verify(() => mockRepo.fetchProfile('u2')).called(1);

        // Dispose mid-loop
        authNotifier.dispose();
        
        // Elapse second backoff (1000ms)
        async.elapse(const Duration(milliseconds: 1100));
        
        // Verify it was NOT called again after dispose
        verifyNever(() => mockRepo.fetchProfile('u2'));
      });
    });
  });
}
