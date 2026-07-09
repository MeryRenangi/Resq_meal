import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/ngo_provider.dart';
import 'package:resq_meal/providers/onboarding_provider.dart';
import 'package:resq_meal/providers/user_management_provider.dart';
import 'package:resq_meal/screens/donations/donations_tab.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';

class ExploreTabScreen extends StatefulWidget {
  const ExploreTabScreen({super.key});

  @override
  State<ExploreTabScreen> createState() => _ExploreTabScreenState();
}

class _ExploreTabScreenState extends State<ExploreTabScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  void _init() {
    final role = _role(context);

    if (role == UserRole.admin) {
      context.read<UserManagementProvider>().watchByRole(UserRole.ngo);
      context.read<NgoProvider>().watchPendingForAdmin();
    }
  }

  UserRole? _role(BuildContext context) {
    return context.read<AuthProvider>().user?.role ??
        context.read<OnboardingProvider>().selectedRole;
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().user?.role ??
        context.watch<OnboardingProvider>().selectedRole;

    return switch (role) {
      UserRole.donor => const DonationsTab(mode: DonationsTabMode.availableForNgo),
      UserRole.ngo => const DonationsTab(mode: DonationsTabMode.availableForNgo),
      UserRole.admin => const _AdminUsersView(),
      null => const DonationsTab(mode: DonationsTabMode.availableForNgo),
    };
  }
}

class _AdminUsersView extends StatelessWidget {
  const _AdminUsersView();

  @override
  Widget build(BuildContext context) {
    final users = context.watch<UserManagementProvider>().users;
    final pending = context.watch<NgoProvider>().pendingNgos;

    return ListView(
      padding: Responsive.pagePadding(context),
      children: [
        Text('NGO approvals', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        if (pending.isEmpty)
          const Text('No pending NGO registrations')
        else
          ...pending.map(
            (n) => Card(
              child: ListTile(
                title: Text(n.organizationName),
                subtitle: Text(n.contactEmail),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.success,
                      ),
                      onPressed: () => context
                          .read<NgoProvider>()
                          .verify(n.id, n.userId, approved: true),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: AppColors.error,
                      ),
                      onPressed: () => context
                          .read<NgoProvider>()
                          .verify(n.id, n.userId, approved: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 24),
        Text(
          'NGO accounts (${users.length})',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        ...users.map(
          (u) => ListTile(
            title: Text(u.displayName ?? u.email),
            subtitle: Text(u.email),
          ),
        ),
      ],
    );
  }
}