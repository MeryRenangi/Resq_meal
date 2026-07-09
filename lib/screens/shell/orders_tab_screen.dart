import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/onboarding_provider.dart';
import 'package:resq_meal/providers/report_provider.dart';
import 'package:resq_meal/screens/donations/donations_tab.dart';
import 'package:resq_meal/screens/requests/requests_tab.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/dashboard/stat_card.dart';
import 'package:resq_meal/models/dashboard_stat_model.dart';
import 'package:resq_meal/widgets/feature/simple_bar_chart.dart';

class OrdersTabScreen extends StatefulWidget {
  const OrdersTabScreen({super.key});

  @override
  State<OrdersTabScreen> createState() => _OrdersTabScreenState();
}

class _OrdersTabScreenState extends State<OrdersTabScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final role = context.read<AuthProvider>().user?.role ??
          context.read<OnboardingProvider>().selectedRole;
      if (role == UserRole.admin) {
        context.read<ReportProvider>().watchLatest();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().user?.role ??
        context.watch<OnboardingProvider>().selectedRole;

    return switch (role) {
      UserRole.donor => const DonationsTab(mode: DonationsTabMode.donorHistory),
      UserRole.ngo => const RequestsTab(),
      UserRole.admin => const _AdminReportsView(),
      null => const RequestsTab(),
    };
  }
}

class _AdminReportsView extends StatelessWidget {
  const _AdminReportsView();

  @override
  Widget build(BuildContext context) {
    final report = context.watch<ReportProvider>().report;

    if (report == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    return ListView(
      padding: Responsive.pagePadding(context),
      children: [
        Text('Reports & analytics', style: Theme.of(context).textTheme.headlineMedium),
        Text(report.periodLabel, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            StatCard(
              stat: DashboardStatModel(
                id: 'donations',
                label: 'Total donations',
                value: '${report.totalDonations}',
                icon: Icons.restaurant_rounded,
              ),
            ),
            StatCard(
              stat: DashboardStatModel(
                id: 'meals',
                label: 'Meals saved',
                value: '${report.mealsSaved}',
                icon: Icons.eco_rounded,
              ),
            ),
            StatCard(
              stat: DashboardStatModel(
                id: 'waste',
                label: 'Waste reduced',
                value: '${report.wasteReducedKg}',
                unit: 'kg',
                icon: Icons.delete_outline_rounded,
              ),
            ),
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
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Monthly chart', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                SimpleBarChart(data: report.monthlyStats),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Admin management', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        _AdminLink(
          title: 'User management',
          icon: Icons.people_outline,
          onTap: () => FeatureNavigation.openAdminUsers(context),
        ),
        _AdminLink(
          title: 'NGO management',
          icon: Icons.groups_outlined,
          onTap: () => FeatureNavigation.openAdminNgos(context),
        ),
        _AdminLink(
          title: 'Donation monitoring',
          icon: Icons.restaurant_outlined,
          onTap: () => FeatureNavigation.openAdminDonations(context),
        ),
        _AdminLink(
          title: 'Request monitoring',
          icon: Icons.inbox_outlined,
          onTap: () => FeatureNavigation.openAdminRequests(context),
        ),
        _AdminLink(
          title: 'Feedback monitoring',
          icon: Icons.rate_review_outlined,
          onTap: () => FeatureNavigation.openAdminFeedback(context),
        ),
        _AdminLink(
          title: 'Full analytics',
          icon: Icons.analytics_outlined,
          onTap: () => FeatureNavigation.openAnalytics(context),
        ),
      ],
    );
  }
}

class _AdminLink extends StatelessWidget {
  const _AdminLink({required this.title, required this.icon, required this.onTap});

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
