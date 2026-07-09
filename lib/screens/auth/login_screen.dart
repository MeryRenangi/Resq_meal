import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/constants/auth_strings.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/routes/app_routes.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/extensions.dart';
import 'package:resq_meal/utils/validators.dart';
import 'package:resq_meal/widgets/auth/auth_header.dart';
import 'package:resq_meal/widgets/auth/auth_message_banner.dart';
import 'package:resq_meal/widgets/auth/auth_text_field.dart';
import 'package:resq_meal/widgets/common/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    context.hideKeyboard();
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>()..clearMessages();
    final success = await auth.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    if (success) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeader(
                  title: AuthStrings.loginTitle,
                  subtitle: AuthStrings.loginSubtitle,
                ),
                const SizedBox(height: 32),
                if (auth.errorMessage != null) ...[
                  AuthMessageBanner(message: auth.errorMessage!),
                  const SizedBox(height: 16),
                ],
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
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.lock_outline_rounded,
                  autofillHints: const [AutofillHints.password],
                  validator: Validators.password,
                  onToggleObscure: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: const Text(AuthStrings.forgotPassword),
                  ),
                ),
                const SizedBox(height: 8),
                AppButton(
                  label: AuthStrings.signIn,
                  isLoading: auth.isLoading,
                  onPressed: auth.isLoading ? null : _signIn,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AuthStrings.noAccount, style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.register),
                      child: const Text(AuthStrings.signUp),
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
