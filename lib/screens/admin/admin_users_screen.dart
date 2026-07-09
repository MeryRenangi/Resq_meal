import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/providers/user_management_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  UserRole _role = UserRole.donor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() => context.read<UserManagementProvider>().watchByRole(_role);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserManagementProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('User management')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SegmentedButton<UserRole>(
              segments: const [
                ButtonSegment(value: UserRole.donor, label: Text('Donors')),
                ButtonSegment(value: UserRole.ngo, label: Text('NGOs')),
                ButtonSegment(value: UserRole.admin, label: Text('Admins')),
              ],
              selected: {_role},
              onSelectionChanged: (s) {
                setState(() => _role = s.first);
                _load();
              },
            ),
          ),
          Expanded(
            child: provider.isLoading && provider.users.isEmpty
                ? const LoadingIndicator(message: 'Loading users...')
                : provider.users.isEmpty
                    ? const EmptyState(
                        title: 'No users',
                        subtitle: 'Users with this role will appear here.',
                        icon: Icons.people_outline,
                      )
                    : ListView.builder(
                        padding: Responsive.pagePadding(context),
                        itemCount: provider.users.length,
                        itemBuilder: (_, i) {
                          final u = provider.users[i];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.surfaceVariant,
                                child: Text((u.displayName ?? u.email)[0].toUpperCase()),
                              ),
                              title: Text(u.displayName ?? u.email),
                              subtitle: Text('${u.email}${u.isActive ? '' : ' · inactive'}'),
                              trailing: Switch(
                                value: u.isActive,
                                onChanged: (active) {
                                  provider.updateUser(u.copyWith(isActive: active));
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
