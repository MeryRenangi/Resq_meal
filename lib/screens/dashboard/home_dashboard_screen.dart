import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/dashboard_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/dashboard/dashboard_body.dart';
import 'package:resq_meal/widgets/dashboard/dashboard_loading.dart';

/// Platform-wide home overview with aggregate stats.
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final user = context.read<AuthProvider>().user;
    context.read<DashboardProvider>().loadHomeOverview(
          displayName: user?.displayName ?? user?.email,
        );
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();

    if (dashboard.isLoading && dashboard.homeOverview == null) {
      return const DashboardLoading();
    }

    if (dashboard.errorMessage != null && dashboard.homeOverview == null) {
      return EmptyState(
        title: 'Could not load overview',
        subtitle: dashboard.errorMessage,
        icon: Icons.cloud_off_outlined,
        action: TextButton(onPressed: _load, child: const Text('Retry')),
      );
    }

    final data = dashboard.homeOverview;
    if (data == null) return const DashboardLoading();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => _load(),
      child: DashboardBody(data: data, showRoleBadge: false),
    );
  }
}
