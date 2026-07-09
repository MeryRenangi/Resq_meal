import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/routes/app_routes.dart';

abstract final class DashboardActions {
  static void handle(BuildContext context, UserRole? role, String label) {
    debugPrint('BUTTON CLICKED: $label');

    final key = label.toLowerCase();

    if (key.contains('new donation') || key.contains('get started')) {
      FeatureNavigation.openCreateDonation(context);
      return;
    }

    if (key.contains('view listings') || key.contains('listing')) {
      FeatureNavigation.openDonationHistory(context);
      return;
    }

    if (key.contains('find ngos') || key.contains('ngo') || key.contains('explore')) {
      context.go(AppRoutes.explore);
      return;
    }

    if (key.contains('analytics') || key.contains('report')) {
      FeatureNavigation.openAnalytics(context);
      return;
    }

    if (role == UserRole.ngo) {
      if (key.contains('pickup') || key.contains('schedule')) {
        FeatureNavigation.openNgoDonations(context);
        return;
      }
      if (key.contains('request') || key.contains('distribution')) {
        FeatureNavigation.openRequestHistory(context);
        return;
      }
    }

    if (role == UserRole.admin) {
      if (key.contains('approval')) {
        FeatureNavigation.openAdminDonations(context);
        return;
      }
      if (key.contains('user')) {
        FeatureNavigation.openAdminUsers(context);
        return;
      }
      if (key.contains('export')) {
        FeatureNavigation.openAdminReports(context);
        return;
      }
    }
  }
}