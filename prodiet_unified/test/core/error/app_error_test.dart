import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/core/error/app_error.dart';

void main() {
  group('AuthError Sanitization', () {
    test('should return friendly message for known errors', () {
      const error1 = AuthError(message: 'Invalid login credentials');
      expect(error1.displayMessage, 'Incorrect email or password');

      const error2 = AuthError(message: 'User already registered');
      expect(error2.displayMessage, 'This email is already registered');

      const error3 = AuthError(message: 'Password should be at least 6 characters');
      expect(error3.displayMessage, 'Password must be at least 6 characters');
    });

    test('should return generic fallback for unknown sensitive errors', () {
      const error = AuthError(message: 'Internal Database Error: Column "secret_token" does not exist');
      expect(error.displayMessage, 'Authentication failed. Please try again.');
    });
  });

  group('UnknownError Sanitization', () {
    test('should always return generic fallback', () {
      const error = UnknownError(message: 'FileSystemException: Cannot open file, path = "/etc/passwd"');
      expect(error.displayMessage, 'An unexpected error occurred. Please try again.');
    });
  });
}
