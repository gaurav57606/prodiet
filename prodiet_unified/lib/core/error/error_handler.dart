import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_error.dart';

class ErrorHandler {
  ErrorHandler._();

  static AppError handle(Object error, {String? context}) {
    final tag = context != null ? '[$context] ' : '';

    if (error is AuthException) {
      return AuthError(
        message: '$tag${error.message}',
        code: 'AUTH_${error.statusCode ?? "ERR"}',
      );
    }
    if (error is PostgrestException) {
      return DatabaseError(message: '$tag${error.message}');
    }
    if (error is StorageException) {
      return ServerError(message: '$tag${error.message}');
    }
    if (error is AppError) return error;
    return UnknownError(message: '$tag${error.toString()}');
  }
}
