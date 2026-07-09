import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/onboarding_provider.dart';
import 'package:resq_meal/screens/admin/advanced_admin_dashboard_screen.dart';
import 'package:resq_meal/screens/dashboard/donor_dashboard_screen.dart';
import 'package:resq_meal/screens/dashboard/home_dashboard_screen.dart';
import 'package:resq_meal/screens/dashboard/ngo_dashboard_screen.dart';

/// Home tab: routes to the correct role dashboard.
class DashboardHostScreen extends StatelessWidget {
  const DashboardHostScreen({super.key});

  UserRole? _resolveRole(BuildContext context) {
    final authRole = context.read<AuthProvider>().user?.role;
    if (authRole != null) return authRole;
    return context.read<OnboardingProvider>().selectedRole;
  }

  @override
  Widget build(BuildContext context) {
    final role = _resolveRole(context);

    return switch (role) {
      UserRole.donor => const DonorDashboardScreen(),
      UserRole.ngo => const NgoDashboardScreen(),
      UserRole.admin => const AdvancedAdminDashboardScreen(),
      null => const HomeDashboardScreen(),
    };
  }
}
