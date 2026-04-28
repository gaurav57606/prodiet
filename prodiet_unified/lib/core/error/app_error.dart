sealed class AppError {
  final String code;
  final String message;
  const AppError({required this.code, required this.message});

  @override
  String toString() => '[$code] $message';

  /// User-friendly display message (safe to show in UI)
  String get displayMessage => message;
}

class NetworkError extends AppError {
  const NetworkError({super.message = 'No internet connection'})
      : super(code: 'NETWORK_ERROR');
}

class AuthError extends AppError {
  const AuthError({required super.message, super.code = 'AUTH_ERROR'});
  @override
  String get displayMessage => _sanitize(message);
  // Strip internal codes from user-visible text
  static String _sanitize(String msg) {
    if (msg.contains('Invalid login')) return 'Incorrect email or password';
    if (msg.contains('already registered')) return 'This email is already registered';
    if (msg.contains('Password should')) return 'Password must be at least 6 characters';
    return msg;
  }
}

class DatabaseError extends AppError {
  const DatabaseError({required super.message})
      : super(code: 'DB_ERROR');
  @override
  String get displayMessage => 'Something went wrong. Please try again.';
}

class ValidationError extends AppError {
  final String field;
  const ValidationError({required this.field, required super.message})
      : super(code: 'VALIDATION_ERROR');
}

class ServerError extends AppError {
  final int? statusCode;
  const ServerError({required super.message, this.statusCode})
      : super(code: 'SERVER_ERROR');
  @override
  String get displayMessage => 'Server error. Please try again later.';
}

class CacheError extends AppError {
  const CacheError({super.message = 'Cache operation failed'})
      : super(code: 'CACHE_ERROR');
}

class OfflineError extends AppError {
  const OfflineError({super.message = 'You are offline. Showing cached data.'})
      : super(code: 'OFFLINE');
}

class UnknownError extends AppError {
  const UnknownError({super.message = 'An unexpected error occurred'})
      : super(code: 'UNKNOWN');
}
