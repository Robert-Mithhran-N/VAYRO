import 'package:flutter/foundation.dart';

/// Lightweight structured logger for development and diagnostics.
class AppLogger {
  const AppLogger._();

  static void info(String message, [String? tag]) {
    _log('INFO', tag, message);
  }

  static void warn(String message, [String? tag]) {
    _log('WARN', tag, message);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace, String? tag]) {
    _log('ERROR', tag, message);
    if (error != null && kDebugMode) {
      debugPrint('   Details: $error');
    }
    if (stackTrace != null && kDebugMode) {
      debugPrint('   StackTrace: $stackTrace');
    }
  }

  static void _log(String level, String? tag, String message) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[VAYRO]';
      debugPrint('$prefix [$level] $message');
    }
  }
}

