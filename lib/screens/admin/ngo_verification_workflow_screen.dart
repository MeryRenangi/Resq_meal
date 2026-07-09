import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/providers/ngo_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/list_filters.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/utils/ui_helpers.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/common/search_filter_bar.dart';

class NgoVerificationWorkflowScreen extends StatefulWidget {
  const NgoVerificationWorkflowScreen({super.key});

  @override
  State<NgoVerificationWorkflowScreen> createState() =>
      _NgoVerificationWorkflowScreenState();
}

class _NgoVerificationWorkflowScreenState extends State<NgoVerificationWorkflowScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NgoProvider>().watchPendingForAdmin();
      context.read<NgoProvider>().watchVerified();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ngo = context.watch<NgoProvider>();
    final pending = ListFilters.byQuery(
      ngo.pendingNgos,
      _query,
      (n) => [n.organizationName, n.contactEmail, n.serviceArea ?? ''],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('NGO verification')),
      body: Column(
        children: [
          Padding(
            padding: Responsive.pagePadding(context).copyWith(bottom: 0),
            child: SearchFilterBar(
              searchController: _searchController,
              hint: 'Search NGOs...',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ngo.isLoading && pending.isEmpty
                ? const LoadingIndicator(message: 'Loading NGOs...')
                : pending.isEmpty
                    ? const EmptyState(
                        title: 'No pending verifications',
                        subtitle: 'All NGO registrations have been processed.',
                        icon: Icons.verified_outlined,
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () async {
                          context.read<NgoProvider>().watchPendingForAdmin();
                        },
                        child: ListView(
                          padding: Responsive.pagePadding(context),
                          children: [
                            Text(
                              'Pending (${pending.length})',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            ...pending.map(
                              (n) => Card(
                                child: ListTile(
                                  title: Text(n.organizationName),
                                  subtitle: Text(
                                    '${n.contactEmail}\n${n.registrationNumber ?? ''}',
                                  ),
                                  isThreeLine: true,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        tooltip: 'Approve',
                                        icon: const Icon(
                                          Icons.check_circle_outline,
                                          color: AppColors.success,
                                        ),
                                        onPressed: () async {
                                          final ok = await ngo.verify(
                                            n.id,
                                            n.userId,
                                            approved: true,
                                          );
                                          if (!context.mounted) return;
                                          if (ok) {
                                            UiHelpers.showSuccess(
                                              context,
                                              '${n.organizationName} verified',
                                            );
                                          }
                                        },
                                      ),
                                      IconButton(
                                        tooltip: 'Reject',
                                        icon: const Icon(
                                          Icons.cancel_outlined,
                                          color: AppColors.error,
                                        ),
                                        onPressed: () async {
                                          final ok = await ngo.verify(
                                            n.id,
                                            n.userId,
                                            approved: false,
                                          );
                                          if (!context.mounted) return;
                                          if (ok) {
                                            UiHelpers.showSuccess(
                                              context,
                                              'Registration declined',
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Verified (${ngo.verifiedNgos.length})',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            ...ngo.verifiedNgos.map(
                              (n) => ListTile(
                                title: Text(n.organizationName),
                                trailing: const Icon(
                                  Icons.verified_rounded,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
