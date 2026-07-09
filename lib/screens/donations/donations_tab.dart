import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/donation_provider.dart';
import 'package:resq_meal/providers/ngo_provider.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/screens/donations/create_donation_screen.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/feature/donation_list_tile.dart';

class DonationsTab extends StatefulWidget {
  const DonationsTab({super.key, required this.mode});

  final DonationsTabMode mode;

  @override
  State<DonationsTab> createState() => _DonationsTabState();
}

enum DonationsTabMode { donorHistory, availableForNgo, adminAll }

class _DonationsTabState extends State<DonationsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _subscribe());
  }

  void _subscribe() {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final donations = context.read<DonationProvider>();

    switch (widget.mode) {
      case DonationsTabMode.donorHistory:
        donations.watchDonorDonations(user.id);
      case DonationsTabMode.availableForNgo:
        donations.watchAvailableDonations();
        final ngo = context.read<NgoProvider>();
        ngo.watchProfile(user.id);
      case DonationsTabMode.adminAll:
        donations.watchAllDonations();
    }
  }

  @override
  Widget build(BuildContext context) {
    final donations = context.watch<DonationProvider>();
    final role = context.watch<AuthProvider>().user?.role;

    return Stack(
      children: [
        if (!donations.isAvailable)
          const EmptyState(
            title: 'Firebase required',
            subtitle: 'Configure Firebase to load donations from Firestore.',
            icon: Icons.cloud_off_outlined,
          )
        else if (donations.isLoading && donations.donations.isEmpty)
          const LoadingIndicator(message: 'Loading donations...')
        else if (donations.donations.isEmpty)
          EmptyState(
            title: _emptyTitle(role),
            subtitle: _emptySubtitle(widget.mode),
            icon: Icons.volunteer_activism_outlined,
          )
        else
          RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => _subscribe(),
            child: ListView(
              padding: Responsive.pagePadding(context),
              children: [
                Text(_headerTitle(widget.mode), style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                ...donations.donations.map(
                  (d) => DonationListTile(
                    donation: d,
                    onTap: () => FeatureNavigation.openDonationDetail(context, d),
                  ),
                ),
              ],
            ),
          ),
        if (widget.mode == DonationsTabMode.donorHistory && role == UserRole.donor)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => const CreateDonationScreen()),
                );
                _subscribe();
              },
              icon: const Icon(Icons.add),
              label: const Text('Donate'),
            ),
          ),
      ],
    );
  }

  String _headerTitle(DonationsTabMode mode) => switch (mode) {
        DonationsTabMode.donorHistory => 'My donations',
        DonationsTabMode.availableForNgo => 'Available donations',
        DonationsTabMode.adminAll => 'All donations',
      };

  String _emptyTitle(UserRole? role) => switch (widget.mode) {
        DonationsTabMode.donorHistory => 'No donations yet',
        DonationsTabMode.availableForNgo => 'No available food',
        DonationsTabMode.adminAll => 'No records',
      };

  String _emptySubtitle(DonationsTabMode mode) => switch (mode) {
        DonationsTabMode.donorHistory => 'Tap + to create your first donation.',
        DonationsTabMode.availableForNgo => 'Check back soon for new listings.',
        DonationsTabMode.adminAll => 'Donations will appear here.',
      };
}
