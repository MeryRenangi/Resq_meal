import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';

import 'package:provider/single_child_widget.dart';

import 'package:resq_meal/providers/activity_provider.dart';

import 'package:resq_meal/providers/auth_provider.dart';

import 'package:resq_meal/providers/chat_provider.dart';

import 'package:resq_meal/providers/dashboard_provider.dart';

import 'package:resq_meal/providers/donation_provider.dart';

import 'package:resq_meal/providers/feedback_provider.dart';

import 'package:resq_meal/providers/food_request_provider.dart';

import 'package:resq_meal/providers/navigation_provider.dart';

import 'package:resq_meal/providers/ngo_provider.dart';

import 'package:resq_meal/providers/notification_provider.dart';

import 'package:resq_meal/providers/onboarding_provider.dart';

import 'package:resq_meal/providers/payment_provider.dart';

import 'package:resq_meal/providers/qr_provider.dart';

import 'package:resq_meal/providers/report_provider.dart';

import 'package:resq_meal/providers/user_management_provider.dart';

import 'package:resq_meal/services/activity_service.dart';

import 'package:resq_meal/services/auth_service.dart';

import 'package:resq_meal/services/backend_service_locator.dart';

import 'package:resq_meal/services/dashboard_service.dart';

import 'package:resq_meal/services/export_service.dart';

import 'package:resq_meal/services/firebase_service.dart';

import 'package:resq_meal/services/local_storage_service.dart';



/// Root [MultiProvider] list for the application.

Future<List<SingleChildWidget>> buildAppProviders() async {

  final storage = await LocalStorageService.create();

  final onboardingProvider = OnboardingProvider(storage);

  await onboardingProvider.initialize();



  final activityService = ActivityService();

  final exportService = ExportService();



  final providers = <SingleChildWidget>[

    Provider<LocalStorageService>.value(value: storage),

    Provider<ActivityService>.value(value: activityService),

    Provider<ExportService>.value(value: exportService),

    ChangeNotifierProvider.value(value: onboardingProvider),

    ChangeNotifierProvider(create: (_) => NavigationProvider()),

    ChangeNotifierProvider(create: (_) => ActivityProvider(activityService)),

  ];



  final backend = await BackendServiceLocator.fromFirebaseApps();

  final dashboardService = DashboardService(firebase: backend?.firebase);



  if (Firebase.apps.isNotEmpty && backend != null) {

    final firebaseService = backend.firebase;

    final authService = AuthService(firebaseService);

    providers.insertAll(0, [

      Provider<FirebaseService>.value(value: firebaseService),

      Provider<BackendServiceLocator>.value(value: backend),
      Provider<BackendServiceLocator?>.value(value: backend),

      Provider<AuthService>.value(value: authService),

      Provider<DashboardService>.value(value: dashboardService),

      ChangeNotifierProvider(create: (_) => AuthProvider(authService)),

      ChangeNotifierProvider(

        create: (_) => DashboardProvider(dashboardService),

      ),

      ChangeNotifierProvider(create: (_) => DonationProvider(backend.donations)),

      ChangeNotifierProvider(create: (_) => FoodRequestProvider(backend.foodRequests)),

      ChangeNotifierProvider(create: (_) => NgoProvider(backend.ngos)),

      ChangeNotifierProvider(create: (_) => ChatProvider(backend.chats)),

      ChangeNotifierProvider(create: (_) => NotificationProvider(backend.notifications)),

      ChangeNotifierProvider(create: (_) => ReportProvider(backend.reports)),

      ChangeNotifierProvider(create: (_) => QrProvider(backend.qrVerifications)),

      ChangeNotifierProvider(create: (_) => UserManagementProvider(backend.userManagement)),

      ChangeNotifierProvider(create: (_) => PaymentProvider(backend.payments)),

      ChangeNotifierProvider(create: (_) => FeedbackProvider(backend.feedback)),

    ]);

  } else {

    providers.insertAll(0, [

      ChangeNotifierProvider(create: (_) => AuthProvider(null)),

      ChangeNotifierProvider(create: (_) => DashboardProvider(dashboardService)),

      ChangeNotifierProvider(create: (_) => DonationProvider(null)),

      ChangeNotifierProvider(create: (_) => FoodRequestProvider(null)),

      ChangeNotifierProvider(create: (_) => NgoProvider(null)),

      ChangeNotifierProvider(create: (_) => ChatProvider(null)),

      ChangeNotifierProvider(create: (_) => NotificationProvider(null)),

      ChangeNotifierProvider(create: (_) => ReportProvider(null)),

      ChangeNotifierProvider(create: (_) => QrProvider(null)),

      ChangeNotifierProvider(create: (_) => UserManagementProvider(null)),

      ChangeNotifierProvider(create: (_) => PaymentProvider(null)),

      ChangeNotifierProvider(create: (_) => FeedbackProvider(null)),

      Provider<DashboardService>.value(value: dashboardService),
      Provider<BackendServiceLocator?>.value(value: null),

    ]);

  }



  return providers;

}


