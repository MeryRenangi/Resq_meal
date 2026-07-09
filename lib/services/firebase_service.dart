import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:resq_meal/config/app_config.dart';

/// Thin wrapper around Firebase SDK instances for dependency injection.
class FirebaseService {
  FirebaseService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : auth = auth ?? FirebaseAuth.instance,
        firestore = firestore ?? FirebaseFirestore.instance,
        storage = storage ?? FirebaseStorage.instance;

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  CollectionReference<Map<String, dynamic>> collection(String name) {
    return firestore.collection(name);
  }

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      collection(AppConfig.firestoreUsersCollection);

  CollectionReference<Map<String, dynamic>> get donationsCollection =>
      collection(AppConfig.firestoreDonationsCollection);

  CollectionReference<Map<String, dynamic>> get foodRequestsCollection =>
      collection(AppConfig.firestoreFoodRequestsCollection);

  CollectionReference<Map<String, dynamic>> get ngosCollection =>
      collection(AppConfig.firestoreNgosCollection);

  CollectionReference<Map<String, dynamic>> get chatsCollection =>
      collection(AppConfig.firestoreChatsCollection);

  CollectionReference<Map<String, dynamic>> get notificationsCollection =>
      collection(AppConfig.firestoreNotificationsCollection);

  CollectionReference<Map<String, dynamic>> get reportsCollection =>
      collection(AppConfig.firestoreReportsCollection);

  CollectionReference<Map<String, dynamic>> get feedbackCollection =>
      collection(AppConfig.firestoreFeedbackCollection);

  CollectionReference<Map<String, dynamic>> get qrVerificationsCollection =>
      collection(AppConfig.firestoreQrVerificationsCollection);

  CollectionReference<Map<String, dynamic>> get paymentsCollection =>
      collection(AppConfig.firestorePaymentsCollection);

  CollectionReference<Map<String, dynamic>> get locationsCollection =>
      collection(AppConfig.firestoreLocationsCollection);

  // Legacy collections
  CollectionReference<Map<String, dynamic>> get restaurantsCollection =>
      collection(AppConfig.firestoreRestaurantsCollection);

  CollectionReference<Map<String, dynamic>> get mealOffersCollection =>
      collection(AppConfig.firestoreMealOffersCollection);

  CollectionReference<Map<String, dynamic>> get ordersCollection =>
      collection(AppConfig.firestoreOrdersCollection);

  CollectionReference<Map<String, dynamic>> get dashboardsCollection =>
      collection(AppConfig.firestoreDashboardsCollection);

  CollectionReference<Map<String, dynamic>> messagesCollection(String chatId) {
    return chatsCollection.doc(chatId).collection(AppConfig.firestoreMessagesSubcollection);
  }

  Reference storageRef(String path) => storage.ref(path);
}
