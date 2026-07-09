import 'package:flutter/foundation.dart';

abstract final class AppLogger {
  static void debug(String message, [Object? error, StackTrace? stack]) {
    if (kDebugMode) {
      debugPrint('[ResQ Meal] $message');
      if (error != null) debugPrint('  $error');
      if (stack != null) debugPrint('  $stack');
    }
  }

  static void info(String message) {
    if (kDebugMode) debugPrint('[ResQ Meal] $message');
  }

  static void error(String message, [Object? error, StackTrace? stack]) {
    debugPrint('[ResQ Meal][ERROR] $message');
    if (error != null) debugPrint('  $error');
    if (stack != null) debugPrint('  $stack');
  }
}
