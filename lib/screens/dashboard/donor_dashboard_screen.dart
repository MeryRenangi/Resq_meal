import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/dashboard_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/dashboard/dashboard_body.dart';
import 'package:resq_meal/widgets/dashboard/dashboard_loading.dart';

class DonorDashboardScreen extends StatefulWidget {
  const DonorDashboardScreen({super.key});

  @override
  State<DonorDashboardScreen> createState() => _DonorDashboardScreenState();
}

class _DonorDashboardScreenState extends State<DonorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (user == null) return;
    context.read<DashboardProvider>().loadRoleDashboard(
          userId: user.id,
          role: UserRole.donor,
          displayName: user.displayName ?? user.email,
        );
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();

    if (dashboard.isLoading && dashboard.roleDashboard == null) {
      return const DashboardLoading();
    }

    if (dashboard.errorMessage != null && dashboard.roleDashboard == null) {
      return EmptyState(
        title: 'Could not load dashboard',
        subtitle: dashboard.errorMessage,
        icon: Icons.cloud_off_outlined,
        action: TextButton(onPressed: _load, child: const Text('Retry')),
      );
    }

    final data = dashboard.roleDashboard;
    if (data == null) return const DashboardLoading();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => _load(),
      child: DashboardBody(data: data),
    );
  }
}
