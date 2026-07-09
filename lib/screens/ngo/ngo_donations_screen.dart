import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/donation_provider.dart';
import 'package:resq_meal/providers/ngo_provider.dart';
import 'package:resq_meal/screens/donations/donations_tab.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/feature/donation_list_tile.dart';

/// NGO donation management: available + accepted donations.
class NgoDonationsScreen extends StatefulWidget {
  const NgoDonationsScreen({super.key});

  @override
  State<NgoDonationsScreen> createState() => _NgoDonationsScreenState();
}

class _NgoDonationsScreenState extends State<NgoDonationsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final ngoProvider = context.read<NgoProvider>();
    ngoProvider.watchProfile(user.id);
    context.read<DonationProvider>().watchAvailableDonations();
    final ngo = ngoProvider.current;
    if (ngo != null) {
      context.read<DonationProvider>().watchNgoDonations(ngo.id);
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO donations'),
        bottom: TabBar(
          controller: _tabs,
          labelColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Available'),
            Tab(text: 'My pickups'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          const DonationsTab(mode: DonationsTabMode.availableForNgo),
          _NgoAcceptedList(onRefresh: _load),
        ],
      ),
    );
  }
}

class _NgoAcceptedList extends StatelessWidget {
  const _NgoAcceptedList({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final ngo = context.watch<NgoProvider>().current;
    final donations = context.watch<DonationProvider>();

    if (ngo == null) {
      return const EmptyState(
        title: 'NGO profile required',
        subtitle: 'Complete your NGO registration to track accepted donations.',
        icon: Icons.groups_outlined,
      );
    }

    if (donations.isLoading && donations.donations.isEmpty) {
      return const LoadingIndicator(message: 'Loading your donations...');
    }

  return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        context.read<DonationProvider>().watchNgoDonations(ngo.id);
        onRefresh();
      },
      child: donations.donations.isEmpty
          ? ListView(
              children: const [
                EmptyState(
                  title: 'No accepted donations',
                  subtitle: 'Accept donations from the Available tab.',
                  icon: Icons.inbox_outlined,
                ),
              ],
            )
          : ListView(
              padding: Responsive.pagePadding(context),
              children: donations.donations
                  .map(
                    (d) => DonationListTile(
                      donation: d,
                      onTap: () => FeatureNavigation.openDonationDetail(context, d),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
