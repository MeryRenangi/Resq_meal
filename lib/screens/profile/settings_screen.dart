import 'package:flutter/material.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _tile(
            context,
            icon: Icons.person_outline,
            title: 'Edit profile',
            onTap: () => FeatureNavigation.openEditProfile(context),
          ),
          _tile(
            context,
            icon: Icons.lock_outline,
            title: 'Change password',
            onTap: () => FeatureNavigation.openChangePassword(context),
          ),
          _tile(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notification settings',
            onTap: () => FeatureNavigation.openNotificationSettings(context),
          ),
          _tile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy settings',
            onTap: () => FeatureNavigation.openPrivacySettings(context),
          ),
          _tile(
            context,
            icon: Icons.analytics_outlined,
            title: 'Analytics & reports',
            onTap: () => FeatureNavigation.openAdvancedAnalytics(context),
          ),
          _tile(
            context,
            icon: Icons.history,
            title: 'Activity history',
            onTap: () => FeatureNavigation.openActivityHistory(context),
          ),
          _tile(
            context,
            icon: Icons.payment_outlined,
            title: 'Payment history',
            onTap: () => FeatureNavigation.openPaymentHistory(context),
          ),
          _tile(
            context,
            icon: Icons.rate_review_outlined,
            title: 'Feedback & ratings',
            onTap: () => FeatureNavigation.openSubmitFeedback(context),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
