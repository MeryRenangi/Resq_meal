import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_meal/models/donation_model.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/food_request_model.dart';
import 'package:resq_meal/models/notification_model.dart';
import 'package:resq_meal/routes/app_routes.dart';
import 'package:resq_meal/screens/admin/admin_donations_screen.dart';
import 'package:resq_meal/screens/admin/admin_feedback_screen.dart';
import 'package:resq_meal/screens/admin/admin_ngos_screen.dart';
import 'package:resq_meal/screens/admin/admin_reports_screen.dart';
import 'package:resq_meal/screens/admin/admin_requests_screen.dart';
import 'package:resq_meal/screens/admin/admin_users_screen.dart';
import 'package:resq_meal/screens/activity/activity_history_screen.dart';
import 'package:resq_meal/screens/admin/donation_approval_screen.dart';
import 'package:resq_meal/screens/admin/export_reports_screen.dart';
import 'package:resq_meal/screens/admin/ngo_verification_workflow_screen.dart';
import 'package:resq_meal/screens/analytics/advanced_analytics_screen.dart';
import 'package:resq_meal/screens/analytics/analytics_screen.dart';
import 'package:resq_meal/screens/feedback/submit_feedback_screen.dart';
import 'package:resq_meal/screens/location/location_tracking_screen.dart';
import 'package:resq_meal/screens/payments/payment_history_screen.dart';
import 'package:resq_meal/screens/chat/chat_detail_screen.dart';
import 'package:resq_meal/screens/chat/chats_tab.dart';
import 'package:resq_meal/screens/donations/create_donation_screen.dart';
import 'package:resq_meal/screens/donations/donation_detail_screen.dart';
import 'package:resq_meal/screens/donations/donation_history_screen.dart';
import 'package:resq_meal/screens/notifications/notification_detail_screen.dart';
import 'package:resq_meal/screens/notifications/notifications_screen.dart';
import 'package:resq_meal/screens/profile/change_password_screen.dart';
import 'package:resq_meal/screens/profile/edit_profile_screen.dart';
import 'package:resq_meal/screens/profile/notification_settings_screen.dart';
import 'package:resq_meal/screens/profile/privacy_settings_screen.dart';
import 'package:resq_meal/screens/profile/settings_screen.dart';
import 'package:resq_meal/screens/qr/qr_display_screen.dart';
import 'package:resq_meal/screens/qr/qr_scanner_screen.dart';
import 'package:resq_meal/screens/qr/qr_verify_screen.dart';
import 'package:resq_meal/screens/requests/create_request_screen.dart';
import 'package:resq_meal/screens/requests/request_detail_screen.dart';
import 'package:resq_meal/screens/requests/request_history_screen.dart';
import 'package:resq_meal/screens/ngo/ngo_donations_screen.dart';
import 'package:resq_meal/screens/ngo/ngo_requests_screen.dart';
import 'package:resq_meal/screens/ngo/schedule_pickup_screen.dart';

/// Imperative navigation helpers for Phase 4 feature screens.
abstract final class FeatureNavigation {
  static Future<T?> push<T>(BuildContext context, Widget screen) {
    return Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => screen));
  }

  static void openDonationDetail(BuildContext context, DonationModel donation) {
    push(context, DonationDetailScreen(donationId: donation.id));
  }

  static void openCreateDonation(BuildContext context, {DonationModel? existing}) {
    push(context, CreateDonationScreen(existing: existing));
  }

  static void openDonationHistory(BuildContext context) {
    push(context, const DonationHistoryScreen());
  }

  static void openCreateRequest(BuildContext context, {DonationModel? donation}) {
    push(context, CreateRequestScreen(donation: donation));
  }

  static void openRequestDetail(BuildContext context, FoodRequestModel request) {
    push(context, RequestDetailScreen(request: request));
  }

  static void openRequestHistory(BuildContext context) {
    push(context, const RequestHistoryScreen());
  }

  static void openNotifications(BuildContext context) {
    push(context, const NotificationsScreen());
  }

  static void openNotificationDetail(BuildContext context, NotificationModel notification) {
    push(context, NotificationDetailScreen(notification: notification));
  }

  static void openChats(BuildContext context) {
    push(context, const ChatsTab());
  }

  static void openChatDetail(
    BuildContext context, {
    required String chatId,
    required String title,
    required List<String> participantIds,
  }) {
    push(
      context,
      ChatDetailScreen(chatId: chatId, title: title, participantIds: participantIds),
    );
  }

  static void openQrDisplay(BuildContext context, String donationId, {QrVerificationType type = QrVerificationType.pickup}) {
    push(context, QrDisplayScreen(donationId: donationId, type: type));
  }

  static void openQrScanner(BuildContext context, {QrVerificationType type = QrVerificationType.pickup}) {
    push(context, QrScannerScreen(type: type));
  }

  static void openQrVerify(BuildContext context, String donationId, {QrVerificationType type = QrVerificationType.pickup}) {
    push(context, QrVerifyScreen(donationId: donationId, type: type));
  }

  static void openAnalytics(BuildContext context) {
    push(context, const AnalyticsScreen());
  }

  static void openAdvancedAnalytics(BuildContext context) {
    push(context, const AdvancedAnalyticsScreen());
  }

  static void openDonationApproval(BuildContext context) {
    push(context, const DonationApprovalScreen());
  }

  static void openNgoVerification(BuildContext context) {
    push(context, const NgoVerificationWorkflowScreen());
  }

  static void openExportReports(BuildContext context) {
    push(context, const ExportReportsScreen());
  }

  static void openPaymentHistory(BuildContext context, {bool adminView = false}) {
    push(context, PaymentHistoryScreen(adminView: adminView));
  }

  static void openLocationTracking(BuildContext context, {DonationModel? donation}) {
    push(context, LocationTrackingScreen(donation: donation));
  }

  static void openSubmitFeedback(
    BuildContext context, {
    String? referenceId,
    String? referenceType,
  }) {
    push(
      context,
      SubmitFeedbackScreen(referenceId: referenceId, referenceType: referenceType),
    );
  }

  static void openActivityHistory(BuildContext context) {
    push(context, const ActivityHistoryScreen());
  }

  static void openEditProfile(BuildContext context) {
    push(context, const EditProfileScreen());
  }

  static void openSettings(BuildContext context) {
    push(context, const SettingsScreen());
  }

  static void openPrivacySettings(BuildContext context) {
    push(context, const PrivacySettingsScreen());
  }

  static void openNotificationSettings(BuildContext context) {
    push(context, const NotificationSettingsScreen());
  }

  static void openChangePassword(BuildContext context) {
    push(context, const ChangePasswordScreen());
  }

  static void openNgoDonations(BuildContext context) {
    push(context, const NgoDonationsScreen());
  }

  static void openNgoRequests(BuildContext context) {
    push(context, const NgoRequestsScreen());
  }

  static void openSchedulePickup(BuildContext context, DonationModel donation) {
    push(context, SchedulePickupScreen(donation: donation));
  }

  static void openAdminUsers(BuildContext context) => push(context, const AdminUsersScreen());
  static void openAdminNgos(BuildContext context) => push(context, const AdminNgosScreen());
  static void openAdminDonations(BuildContext context) => push(context, const AdminDonationsScreen());
  static void openAdminRequests(BuildContext context) => push(context, const AdminRequestsScreen());
  static void openAdminFeedback(BuildContext context) => push(context, const AdminFeedbackScreen());
  static void openAdminReports(BuildContext context) => push(context, const AdminReportsScreen());

  static void openFromNotification(BuildContext context, NotificationModel n) {
    openNotificationDetail(context, n);
    final ref = n.referenceId;
    if (ref == null) return;
    switch (n.referenceType) {
      case 'donation':
        push(context, DonationDetailScreen(donationId: ref));
      case 'food_request':
        break;
      case 'chat':
        openChats(context);
      default:
        break;
    }
  }

  static void goHome(BuildContext context) => context.go(AppRoutes.home);
}
