import 'package:firebase_core/firebase_core.dart';

import 'package:resq_meal/repositories/chat_repository.dart';

import 'package:resq_meal/repositories/donation_repository.dart';

import 'package:resq_meal/repositories/feedback_repository.dart';

import 'package:resq_meal/repositories/food_request_repository.dart';

import 'package:resq_meal/repositories/ngo_repository.dart';

import 'package:resq_meal/repositories/notification_repository.dart';

import 'package:resq_meal/repositories/payment_repository.dart';

import 'package:resq_meal/repositories/qr_verification_repository.dart';

import 'package:resq_meal/repositories/report_repository.dart';

import 'package:resq_meal/repositories/storage_repository.dart';

import 'package:resq_meal/repositories/user_repository.dart';

import 'package:resq_meal/services/chat_service.dart';

import 'package:resq_meal/services/donation_service.dart';

import 'package:resq_meal/services/export_service.dart';

import 'package:resq_meal/services/fcm_service.dart';
import 'package:resq_meal/services/user_profile_service.dart';

import 'package:resq_meal/services/feedback_service.dart';

import 'package:resq_meal/services/firebase_service.dart';

import 'package:resq_meal/services/food_request_service.dart';

import 'package:resq_meal/services/ngo_service.dart';

import 'package:resq_meal/services/notification_service.dart';

import 'package:resq_meal/services/payment_service.dart';

import 'package:resq_meal/services/qr_verification_service.dart';

import 'package:resq_meal/services/report_service.dart';

import 'package:resq_meal/services/user_management_service.dart';



/// Wires all Firebase repositories and domain services when Firebase is available.

class BackendServiceLocator {

  BackendServiceLocator._({

    required this.firebase,

    required this.userManagement,

    required this.donations,

    required this.foodRequests,

    required this.ngos,

    required this.chats,

    required this.notifications,

    required this.reports,

    required this.qrVerifications,

    required this.payments,

    required this.feedback,

    required this.fcm,

    required this.storage,

    required this.export,

  });



  final FirebaseService firebase;

  final UserManagementService userManagement;

  final DonationService donations;

  final FoodRequestService foodRequests;

  final NgoService ngos;

  final ChatService chats;

  final NotificationService notifications;

  final ReportService reports;

  final QrVerificationService qrVerifications;

  final PaymentService payments;

  final FeedbackService feedback;

  final FcmService fcm;

  final StorageRepository storage;

  final ExportService export;



  static Future<BackendServiceLocator?> fromFirebaseApps() async {

    if (Firebase.apps.isEmpty) return null;



    final firebase = FirebaseService();

    final storage = StorageRepository(firebase);

    final userRepo = UserRepository(firebase);

    final donationRepo = DonationRepository(firebase);

    final requestRepo = FoodRequestRepository(firebase);

    final ngoRepo = NgoRepository(firebase);

    final chatRepo = ChatRepository(firebase);

    final notificationRepo = NotificationRepository(firebase);

    final reportRepo = ReportRepository(firebase);

    final qrRepo = QrVerificationRepository(firebase);

    final paymentRepo = PaymentRepository(firebase);

    final feedbackRepo = FeedbackRepository(firebase);

    final notificationService = NotificationService(notificationRepo);
    final userProfile = UserProfileService(firebase);
    final fcm = FcmService(userProfileService: userProfile);

    final locator = BackendServiceLocator._(
      firebase: firebase,
      storage: storage,
      userManagement: UserManagementService(userRepo),
      donations: DonationService(donationRepo, storage, notificationService),
      foodRequests: FoodRequestService(requestRepo, notificationService),
      ngos: NgoService(ngoRepo, notificationService),
      chats: ChatService(chatRepo, notificationService),
      notifications: notificationService,
      reports: ReportService(reportRepo),
      qrVerifications: QrVerificationService(qrRepo, donationRepo),
      payments: PaymentService(paymentRepo),
      feedback: FeedbackService(feedbackRepo),
      fcm: fcm,
      export: ExportService(),
    );

    await fcm.initialize();
    return locator;
  }
}


