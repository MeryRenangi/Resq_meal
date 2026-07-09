import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/routes/app_routes.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/app_button.dart';

class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final role = user?.role;

    return ListView(
      padding: Responsive.pagePadding(context),
      children: [
        Center(
          child: CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.surfaceVariant,
            child: Text(
              _initials(user?.displayName ?? user?.email ?? '?'),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryDark,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user?.displayName ?? 'Guest',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        if (user?.email != null) ...[
          const SizedBox(height: 4),
          Text(
            user!.email,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        if (role != null) ...[
          const SizedBox(height: 12),
          Center(
            child: Chip(
              label: Text('${role.label} account'),
              backgroundColor: AppColors.surfaceVariant,
              side: BorderSide.none,
            ),
          ),
        ],
        const SizedBox(height: 32),
        _ProfileTile(
          icon: Icons.person_outline_rounded,
          title: 'Edit profile',
          onTap: () {},
        ),
        _ProfileTile(
          icon: Icons.switch_account_rounded,
          title: 'Change role',
          onTap: () => _showRoleDialog(context),
        ),
        _ProfileTile(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          onTap: () {},
        ),
        _ProfileTile(
          icon: Icons.help_outline_rounded,
          title: 'Help & support',
          onTap: () {},
        ),
        const SizedBox(height: 24),
        AppButton(
          label: 'Sign out',
          variant: AppButtonVariant.outlined,
          onPressed: () async {
            await context.read<AuthProvider>().signOut();
            if (context.mounted) {
              context.go(AppRoutes.login);
            }
          },
        ),
      ],
    );
  }

  void _showRoleDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.volunteer_activism),
              title: const Text('Donor'),
              onTap: () => _changeRole(context, UserRole.donor),
            ),
            ListTile(
              leading: const Icon(Icons.groups),
              title: const Text('NGO'),
              onTap: () => _changeRole(context, UserRole.ngo),
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin'),
              onTap: () => _changeRole(context, UserRole.admin),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeRole(BuildContext context, UserRole role) async {
    Navigator.pop(context);

    final auth = context.read<AuthProvider>();
    final user = auth.user;

    if (user == null) return;

    await auth.updateProfile(user.copyWith(role: role));
    await auth.refreshUser();
  }

  String _initials(String value) {
    final cleaned = value.trim();

    if (cleaned.isEmpty) return '?';

    final parts = cleaned
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
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