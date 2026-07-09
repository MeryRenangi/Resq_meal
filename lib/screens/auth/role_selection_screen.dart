import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/constants/auth_strings.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/providers/onboarding_provider.dart';
import 'package:resq_meal/routes/app_routes.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/widgets/auth/auth_header.dart';
import 'package:resq_meal/widgets/auth/role_card.dart';
import 'package:resq_meal/widgets/common/app_button.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selectedRole;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedRole ??= context.read<OnboardingProvider>().selectedRole;
  }

  Future<void> _continue() async {
    final role = _selectedRole;
    if (role == null) return;

    await context.read<OnboardingProvider>().selectRole(role);
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                title: AuthStrings.roleSelectionTitle,
                subtitle: AuthStrings.roleSelectionSubtitle,
                showLogo: false,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  itemCount: UserRole.values.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final role = UserRole.values[index];
                    return RoleCard(
                      role: role,
                      isSelected: _selectedRole == role,
                      onTap: () => setState(() => _selectedRole = role),
                    );
                  },
                ),
              ),
              AppButton(
                label: 'Continue',
                onPressed: _selectedRole != null ? _continue : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
