import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/dashboard_stat_model.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/dashboard_provider.dart';
import 'package:resq_meal/providers/donation_provider.dart';
import 'package:resq_meal/providers/ngo_provider.dart';
import 'package:resq_meal/providers/notification_provider.dart';
import 'package:resq_meal/providers/report_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/dashboard/dashboard_body.dart';
import 'package:resq_meal/widgets/dashboard/dashboard_loading.dart';
import 'package:resq_meal/widgets/dashboard/stat_card.dart';
import 'package:resq_meal/widgets/layout/responsive_content.dart';
import 'package:resq_meal/widgets/notifications/realtime_notification_strip.dart';

/// Phase 5 advanced admin hub with live metrics and quick admin actions.
class AdvancedAdminDashboardScreen extends StatefulWidget {
  const AdvancedAdminDashboardScreen({super.key});

  @override
  State<AdvancedAdminDashboardScreen> createState() => _AdvancedAdminDashboardScreenState();
}

class _AdvancedAdminDashboardScreenState extends State<AdvancedAdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    context.read<DashboardProvider>().loadRoleDashboard(
          userId: user.id,
          role: UserRole.admin,
          displayName: user.displayName ?? user.email,
        );
    context.read<ReportProvider>().watchLatest();
    context.read<NgoProvider>().watchPendingForAdmin();
    context.read<DonationProvider>().watchPendingApprovals();
    context.read<NotificationProvider>().watch(user.id);
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();
    final report = context.watch<ReportProvider>().report;
    final pendingNgos = context.watch<NgoProvider>().pendingNgos.length;
    final pendingDonations = context.watch<DonationProvider>().donations.length;

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

    final columns = Responsive.gridColumns(context, mobile: 2, tablet: 3, desktop: 4);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => _load(),
      child: ResponsiveContent(
        child: ListView(
          children: [
            const RealtimeNotificationStrip(),
            Text('Admin control center', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(data.summary, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                StatCard(
                  stat: DashboardStatModel(
                    id: 'pending_donations',
                    label: 'Pending donations',
                    value: '$pendingDonations',
                    icon: Icons.pending_actions,
                  ),
                ),
                StatCard(
                  stat: DashboardStatModel(
                    id: 'pending_ngos',
                    label: 'NGO verifications',
                    value: '$pendingNgos',
                    icon: Icons.verified_user_outlined,
                  ),
                ),
                if (report != null)
                  StatCard(
                    stat: DashboardStatModel(
                      id: 'meals',
                      label: 'Meals saved',
                      value: '${report.mealsSaved}',
                      icon: Icons.eco_rounded,
                    ),
                  ),
                if (report != null)
                  StatCard(
                    stat: DashboardStatModel(
                      id: 'users',
                      label: 'Active users',
                      value: '${report.activeUsers}',
                      icon: Icons.people_rounded,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ActionChip('Approve donations', Icons.check_circle_outline, () {
                  FeatureNavigation.openDonationApproval(context);
                }),
                _ActionChip('Verify NGOs', Icons.groups_outlined, () {
                  FeatureNavigation.openNgoVerification(context);
                }),
                _ActionChip('Export reports', Icons.download_outlined, () {
                  FeatureNavigation.openExportReports(context);
                }),
                _ActionChip('Analytics', Icons.analytics_outlined, () {
                  FeatureNavigation.openAdvancedAnalytics(context);
                }),
              ],
            ),
            const SizedBox(height: 24),
            DashboardBody(data: data, showRoleBadge: false),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip(this.label, this.icon, this.onTap);

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: AppColors.primary),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
