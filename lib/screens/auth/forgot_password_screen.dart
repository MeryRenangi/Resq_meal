import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/constants/auth_strings.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/extensions.dart';
import 'package:resq_meal/utils/validators.dart';
import 'package:resq_meal/widgets/auth/auth_header.dart';
import 'package:resq_meal/widgets/auth/auth_message_banner.dart';
import 'package:resq_meal/widgets/auth/auth_text_field.dart';
import 'package:resq_meal/widgets/common/app_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    context.hideKeyboard();
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>()..clearMessages();
    await auth.sendPasswordReset(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeader(
                  title: AuthStrings.forgotPasswordTitle,
                  subtitle: AuthStrings.forgotPasswordSubtitle,
                  showLogo: false,
                ),
                const SizedBox(height: 32),
                if (auth.errorMessage != null) ...[
                  AuthMessageBanner(message: auth.errorMessage!),
                  const SizedBox(height: 16),
                ],
                if (auth.successMessage != null) ...[
                  AuthMessageBanner(
                    message: auth.successMessage!,
                    isError: false,
                  ),
                  const SizedBox(height: 16),
                ],
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.email_outlined,
                  validator: Validators.email,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: AuthStrings.sendResetLink,
                  isLoading: auth.isLoading,
                  onPressed: auth.isLoading ? null : _sendReset,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text(AuthStrings.backToLogin),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
