import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:resq_meal/config/app_config.dart';
import 'package:resq_meal/services/user_profile_service.dart';
import 'package:resq_meal/utils/logger.dart';

/// Firebase Cloud Messaging — production push notification setup.
class FcmService {
  FcmService({
    FirebaseMessaging? messaging,
    this._userProfileService,
  }) : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;
  final UserProfileService? _userProfileService;
  String? _token;

  String? get token => _token;
  bool get isAvailable => Firebase.apps.isNotEmpty;

  Future<void> initialize() async {
    if (!isAvailable) return;

    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      AppLogger.info('FCM permission: ${settings.authorizationStatus}');

      _token = await _messaging.getToken();
      AppLogger.info('FCM token ready');

      _messaging.onTokenRefresh.listen((token) {
        _token = token;
        AppLogger.info('FCM token refreshed');
      });

      FirebaseMessaging.onMessage.listen((message) {
        AppLogger.info('FCM foreground: ${message.notification?.title}');
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        AppLogger.info('FCM opened app: ${message.data}');
      });

      await _messaging.subscribeToTopic(AppConfig.fcmTopicDonations);
      await _messaging.subscribeToTopic(AppConfig.fcmTopicRequests);
      await _messaging.subscribeToTopic(AppConfig.fcmTopicChat);
    } catch (e, stack) {
      AppLogger.error('FCM init failed', e, stack);
    }
  }

  Future<void> persistTokenForUser(String userId) async {
    if (!AppConfig.persistFcmToken || _token == null) return;
    final profile = _userProfileService;
    if (profile == null) return;
    try {
      await profile.saveFcmToken(userId, _token!);
    } catch (e, stack) {
      AppLogger.error('Failed to save FCM token', e, stack);
    }
  }

  Future<void> subscribeUserTopics({required bool isDonor, required bool isNgo}) async {
    if (!isAvailable) return;
    if (isDonor) await _messaging.subscribeToTopic('donors');
    if (isNgo) await _messaging.subscribeToTopic('ngos');
  }
}
