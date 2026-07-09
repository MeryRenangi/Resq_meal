import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/providers/donation_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/list_filters.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/utils/ui_helpers.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/common/search_filter_bar.dart';
import 'package:resq_meal/widgets/feature/donation_list_tile.dart';

class DonationApprovalScreen extends StatefulWidget {
  const DonationApprovalScreen({super.key});

  @override
  State<DonationApprovalScreen> createState() => _DonationApprovalScreenState();
}

class _DonationApprovalScreenState extends State<DonationApprovalScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonationProvider>().watchPendingApprovals();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DonationProvider>();
    final filtered = ListFilters.byQuery(
      provider.donations,
      _query,
      (d) => [d.title, d.description, d.donorName, d.category.label],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Donation approval')),
      body: Column(
        children: [
          Padding(
            padding: Responsive.pagePadding(context).copyWith(bottom: 0),
            child: SearchFilterBar(
              searchController: _searchController,
              hint: 'Search pending donations...',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: provider.isLoading && provider.donations.isEmpty
                ? const LoadingIndicator(message: 'Loading pending donations...')
                : filtered.isEmpty
                    ? const EmptyState(
                        title: 'No pending donations',
                        subtitle: 'New donor submissions awaiting approval appear here.',
                        icon: Icons.pending_actions,
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () async =>
                            context.read<DonationProvider>().watchPendingApprovals(),
                        child: ListView.builder(
                          padding: Responsive.pagePadding(context),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final d = filtered[i];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: [
                                  DonationListTile(
                                    donation: d,
                                    onTap: () =>
                                        FeatureNavigation.openDonationDetail(context, d),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: provider.isSaving
                                                ? null
                                                : () async {
                                                    final ok = await provider.rejectDonation(
                                                      d.id,
                                                      d.donorId,
                                                      reason: 'Does not meet guidelines',
                                                    );
                                                    if (!context.mounted) return;
                                                    if (ok) {
                                                      UiHelpers.showSuccess(
                                                        context,
                                                        'Donation rejected',
                                                      );
                                                    } else {
                                                      UiHelpers.showError(
                                                        context,
                                                        provider.error,
                                                      );
                                                    }
                                                  },
                                            child: const Text('Reject'),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: FilledButton(
                                            onPressed: provider.isSaving
                                                ? null
                                                : () async {
                                                    final ok = await provider.approveDonation(
                                                      d.id,
                                                      d.donorId,
                                                    );
                                                    if (!context.mounted) return;
                                                    if (ok) {
                                                      UiHelpers.showSuccess(
                                                        context,
                                                        'Donation approved',
                                                      );
                                                    } else {
                                                      UiHelpers.showError(
                                                        context,
                                                        provider.error,
                                                      );
                                                    }
                                                  },
                                            child: const Text('Approve'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
