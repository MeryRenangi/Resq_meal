import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/dashboard_stat_model.dart';
import 'package:resq_meal/providers/report_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/dashboard/stat_card.dart';
import 'package:resq_meal/widgets/feature/simple_bar_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportProvider>().watchLatest();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();
    final report = provider.report;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics & reports')),
      body: provider.isLoading && report == null
          ? const LoadingIndicator(message: 'Loading analytics...')
          : report == null
              ? const Center(child: Text('No report data available'))
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => context.read<ReportProvider>().watchLatest(),
                  child: ListView(
                    padding: Responsive.pagePadding(context),
                    children: [
                      Text(
                        report.periodLabel,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Platform impact overview',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: Responsive.gridColumns(context, mobile: 2, tablet: 3, desktop: 4),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.35,
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
                              id: 'requests',
                              label: 'Total requests',
                              value: '${report.userActivity['requests'] ?? report.totalDonations}',
                              icon: Icons.inbox_rounded,
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
                              label: 'Food waste reduced',
                              value: '${report.wasteReducedKg}',
                              unit: 'kg',
                              icon: Icons.delete_outline_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text('Monthly reports', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SimpleBarChart(data: report.monthlyStats),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Active users: ${report.activeUsers}',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
    );
  }
}
