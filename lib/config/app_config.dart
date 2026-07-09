/// Runtime configuration for ResQ Meal.
abstract final class AppConfig {
  static const bool enableFirebase = true;
  static const bool enableAnalytics = false;
  static const bool useEmulators = false;

  /// Persist FCM device token on the user document for push targeting.
  static const bool persistFcmToken = true;

  // Legacy aliases (kept for existing dashboard / meal code)
  static const String firestoreRestaurantsCollection = 'restaurants';
  static const String firestoreMealOffersCollection = 'meal_offers';
  static const String firestoreOrdersCollection = 'orders';
  static const String firestoreDashboardsCollection = 'dashboards';

  // Primary Firestore collections
  static const String firestoreUsersCollection = 'users';
  static const String firestoreDonationsCollection = 'donations';
  static const String firestoreFoodRequestsCollection = 'food_requests';
  static const String firestoreNgosCollection = 'ngos';
  static const String firestoreChatsCollection = 'chats';
  static const String firestoreMessagesSubcollection = 'messages';
  static const String firestoreNotificationsCollection = 'notifications';
  static const String firestoreReportsCollection = 'reports';
  static const String firestoreFeedbackCollection = 'feedback';
  static const String firestoreQrVerificationsCollection = 'qr_verifications';
  static const String firestorePaymentsCollection = 'payments';
  static const String firestoreLocationsCollection = 'locations';

  // Firebase Storage paths
  static const String storageDonationsPath = 'donations';
  static const String storageUsersPath = 'users';
  static const String storageNgosPath = 'ngos';

  static const String fcmTopicDonations = 'donations';
  static const String fcmTopicRequests = 'food_requests';
  static const String fcmTopicChat = 'chat';
}
