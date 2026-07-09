import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/dashboard_stat_model.dart';
import 'package:resq_meal/providers/food_request_provider.dart';
import 'package:resq_meal/providers/report_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/dashboard/stat_card.dart';
import 'package:resq_meal/widgets/feature/simple_bar_chart.dart';
import 'package:resq_meal/widgets/layout/responsive_content.dart';

class AdvancedAnalyticsScreen extends StatefulWidget {
  const AdvancedAnalyticsScreen({super.key});

  @override
  State<AdvancedAnalyticsScreen> createState() => _AdvancedAnalyticsScreenState();
}

class _AdvancedAnalyticsScreenState extends State<AdvancedAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportProvider>().watchLatest();
      context.read<FoodRequestProvider>().watchAllRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<ReportProvider>();
    final report = reportProvider.report;
    final requestCount = context.watch<FoodRequestProvider>().requests.length;
    final columns = Responsive.gridColumns(context, mobile: 2, tablet: 3, desktop: 4);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics & reporting')),
      body: reportProvider.isLoading && report == null
          ? const LoadingIndicator(message: 'Loading analytics...')
          : report == null
              ? const Center(child: Text('No analytics data'))
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    context.read<ReportProvider>().watchLatest();
                  },
                  child: ResponsiveContent(
                    child: ListView(
                      children: [
                        Text(report.periodLabel,
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.3,
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
                                value: '$requestCount',
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
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('User activity breakdown',
                                    style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 8),
                                ...report.userActivity.entries.map(
                                  (e) => ListTile(
                                    dense: true,
                                    title: Text(e.key),
                                    trailing: Text('${e.value}'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
