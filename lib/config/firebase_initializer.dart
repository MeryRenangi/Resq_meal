import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:resq_meal/config/app_config.dart';
import 'package:resq_meal/config/firebase_options.dart';
import 'package:resq_meal/config/production_config.dart';
import 'package:resq_meal/utils/logger.dart';

/// Background FCM handler (top-level required by Firebase Messaging).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppLogger.info('FCM background: ${message.notification?.title}');
}

/// Initializes Firebase when enabled. Safe to call before [runApp].
Future<void> initializeFirebase() async {
  if (!AppConfig.enableFirebase) {
    AppLogger.info('Firebase disabled via AppConfig');
    return;
  }

  if (!ProductionConfig.isFirebaseConfigured && kReleaseMode) {
    AppLogger.error(
      'Firebase not configured for production. Run flutterfire configure.',
    );
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _configureFirestoreForProduction();

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    AppLogger.info('Firebase initialized (${ProductionConfig.isFirebaseConfigured ? 'configured' : 'placeholder'})');

    if (AppConfig.useEmulators && !kReleaseMode) {
      await _connectToEmulators();
    }

  } catch (e, stack) {
    AppLogger.error(
      'Firebase initialization failed — run `flutterfire configure` and update firebase_options.dart',
      e,
      stack,
    );
  }
}

void _configureFirestoreForProduction() {
  final firestore = FirebaseFirestore.instance;
  firestore.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
}

Future<void> _connectToEmulators() async {
  const host = 'localhost';
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  AppLogger.info('Firestore emulator connected');
}
