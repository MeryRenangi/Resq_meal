import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/screens/donations/donation_detail_screen.dart';
import 'package:resq_meal/providers/activity_provider.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/donation_provider.dart';
import 'package:resq_meal/providers/food_request_provider.dart';
import 'package:resq_meal/providers/notification_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/formatters.dart';
import 'package:resq_meal/utils/list_filters.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/common/search_filter_bar.dart';
import 'package:resq_meal/widgets/layout/responsive_content.dart';

class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _subscribe());
  }

  void _subscribe() {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final role = user.role;
    if (role == UserRole.donor) {
      context.read<DonationProvider>().watchDonorDonations(user.id);
      context.read<FoodRequestProvider>().watchDonorRequests(user.id);
    } else if (role == UserRole.ngo) {
      context.read<FoodRequestProvider>().watchNgoRequests(user.id);
      context.read<DonationProvider>().watchAvailableDonations();
    } else {
      context.read<DonationProvider>().watchAllDonations();
      context.read<FoodRequestProvider>().watchAllRequests();
    }
    context.read<NotificationProvider>().watch(user.id);
  }

  void _rebuildActivity() {
    context.read<ActivityProvider>().load(
          donations: context.read<DonationProvider>().donations,
          requests: context.read<FoodRequestProvider>().requests,
          notifications: context.read<NotificationProvider>().notifications,
        );
    _loaded = true;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<DonationProvider>();
    context.watch<FoodRequestProvider>();
    context.watch<NotificationProvider>();

    if (!_loaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _rebuildActivity());
    }

    final activity = context.watch<ActivityProvider>();
    final filtered = ListFilters.byQuery(
      activity.items,
      _query,
      (a) => [a.title, a.subtitle, a.type],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Activity history')),
      body: ResponsiveContent(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: Responsive.pagePadding(context).copyWith(bottom: 0),
              child: SearchFilterBar(
                searchController: _searchController,
                hint: 'Search activity...',
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: activity.isLoading && filtered.isEmpty
                  ? const LoadingIndicator(message: 'Loading activity...')
                  : filtered.isEmpty
                      ? const EmptyState(
                          title: 'No activity yet',
                          subtitle: 'Your donations, requests, and alerts appear here.',
                          icon: Icons.history,
                        )
                      : RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () async {
                            _subscribe();
                            _rebuildActivity();
                          },
                          child: ListView.builder(
                            padding: Responsive.pagePadding(context),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final item = filtered[i];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.surfaceVariant,
                                    child: Icon(item.icon, color: AppColors.primary, size: 20),
                                  ),
                                  title: Text(item.title),
                                  subtitle: Text(
                                    '${item.subtitle}\n${Formatters.dateTime.format(item.timestamp)}',
                                  ),
                                  isThreeLine: true,
                                  onTap: () {
                                    if (item.referenceId == null) return;
                                    if (item.type == 'donation') {
                                      FeatureNavigation.push(
                                        context,
                                        DonationDetailScreen(donationId: item.referenceId!),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
