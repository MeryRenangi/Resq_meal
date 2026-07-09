import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/providers/donation_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/list_filters.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/screens/admin/donation_approval_screen.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/common/search_filter_bar.dart';
import 'package:resq_meal/widgets/feature/donation_list_tile.dart';

class AdminDonationsScreen extends StatefulWidget {
  const AdminDonationsScreen({super.key});

  @override
  State<AdminDonationsScreen> createState() => _AdminDonationsScreenState();
}

class _AdminDonationsScreenState extends State<AdminDonationsScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonationProvider>().watchAllDonations();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final donations = context.watch<DonationProvider>();
    var filtered = ListFilters.byQuery(
      donations.donations,
      _query,
      (d) => [d.title, d.donorName, d.category.label, d.status.name],
    );
    if (_statusFilter != null) {
      filtered = filtered.where((d) => d.status.name == _statusFilter).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation monitoring'),
        actions: [
          IconButton(
            icon: const Icon(Icons.approval_outlined),
            tooltip: 'Approval queue',
            onPressed: () => FeatureNavigation.push(context, const DonationApprovalScreen()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: Responsive.pagePadding(context).copyWith(bottom: 0),
            child: SearchFilterBar(
              searchController: _searchController,
              hint: 'Search donations...',
              filterChips: DonationStatus.values.map((s) => s.name).toList(),
              selectedFilter: _statusFilter,
              onFilterSelected: (v) => setState(() => _statusFilter = v),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: donations.isLoading && donations.donations.isEmpty
                ? const LoadingIndicator(message: 'Loading donations...')
                : filtered.isEmpty
                    ? const EmptyState(
                        title: 'No donations',
                        subtitle: 'Platform donations will appear here.',
                        icon: Icons.restaurant_outlined,
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () async =>
                            context.read<DonationProvider>().watchAllDonations(),
                        child: ListView(
                          padding: Responsive.pagePadding(context),
                          children: filtered
                              .map(
                                (d) => DonationListTile(
                                  donation: d,
                                  onTap: () =>
                                      FeatureNavigation.openDonationDetail(context, d),
                                ),
                              )
                              .toList(),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
