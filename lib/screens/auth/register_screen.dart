import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/constants/auth_strings.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/onboarding_provider.dart';
import 'package:resq_meal/routes/app_routes.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/extensions.dart';
import 'package:resq_meal/utils/validators.dart';
import 'package:resq_meal/widgets/auth/auth_header.dart';
import 'package:resq_meal/widgets/auth/auth_message_banner.dart';
import 'package:resq_meal/widgets/auth/auth_text_field.dart';
import 'package:resq_meal/widgets/common/app_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    context.hideKeyboard();
    if (!_formKey.currentState!.validate()) return;

    final role = context.read<OnboardingProvider>().selectedRole;
    if (role == null) {
      context.go(AppRoutes.roleSelection);
      return;
    }

    final auth = context.read<AuthProvider>()..clearMessages();
    final success = await auth.signUp(
      email: _emailController.text,
      password: _passwordController.text,
      displayName: _nameController.text,
      role: role,
    );

    if (!mounted) return;
    if (success) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final role = context.watch<OnboardingProvider>().selectedRole;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeader(
                  title: AuthStrings.registerTitle,
                  subtitle: AuthStrings.registerSubtitle,
                  showLogo: false,
                ),
                if (role != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.badge_outlined, size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Registering as ${role.label}',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.primaryDark,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                if (auth.errorMessage != null) ...[
                  AuthMessageBanner(message: auth.errorMessage!),
                  const SizedBox(height: 16),
                ],
                AuthTextField(
                  controller: _nameController,
                  label: 'Full name',
                  hint: 'Jane Doe',
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.person_outline_rounded,
                  autofillHints: const [AutofillHints.name],
                  validator: Validators.name,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.email_outlined,
                  autofillHints: const [AutofillHints.email],
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.lock_outline_rounded,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: Validators.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm password',
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (value) =>
                      Validators.confirmPassword(value, _passwordController.text),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Create account',
                  isLoading: auth.isLoading,
                  onPressed: auth.isLoading ? null : _register,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AuthStrings.haveAccount, style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text(AuthStrings.signIn),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
