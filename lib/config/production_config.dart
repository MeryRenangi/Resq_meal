import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:resq_meal/config/firebase_options.dart';

/// Production environment checks and Firebase readiness helpers.
abstract final class ProductionConfig {
  static const String appDisplayName = 'ResQ Meal';
  static const String androidApplicationId = 'com.resqmeal.resq_meal';

  static bool get isRelease => kReleaseMode;

  /// True when FlutterFire options have been replaced (not placeholder values).
  static bool get isFirebaseConfigured {
    try {
      final options = DefaultFirebaseOptions.currentPlatform;
      return !options.projectId.startsWith('YOUR_')
          && !options.apiKey.startsWith('YOUR_');
    } catch (_) {
      return false;
    }
  }

  static bool get isFirebaseInitialized => Firebase.apps.isNotEmpty;

  static List<String> validateForProduction() {
    final issues = <String>[];
    if (!isFirebaseConfigured) {
      issues.add('Run `dart pub global activate flutterfire_cli` then `flutterfire configure`.');
    }
    if (kReleaseMode && kDebugMode) {
      issues.add('Invalid build mode configuration.');
    }
    return issues;
  }
}
