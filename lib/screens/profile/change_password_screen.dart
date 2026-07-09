import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/utils/ui_helpers.dart';
import 'package:resq_meal/utils/validators.dart';
import 'package:resq_meal/widgets/auth/auth_text_field.dart';
import 'package:resq_meal/widgets/common/app_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_newController.text != _confirmController.text) {
      UiHelpers.showError(context, 'Passwords do not match');
      return;
    }
    final auth = context.read<AuthProvider>();
    final ok = await auth.changePassword(
      currentPassword: _currentController.text,
      newPassword: _newController.text,
    );
    if (!mounted) return;
    if (ok) {
      UiHelpers.showSuccess(context, 'Password updated');
      Navigator.pop(context);
    } else {
      UiHelpers.showError(context, auth.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Change password')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AuthTextField(
              controller: _currentController,
              label: 'Current password',
              obscureText: true,
              validator: (v) => Validators.required(v, fieldName: 'Current password'),
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _newController,
              label: 'New password',
              obscureText: true,
              validator: Validators.password,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _confirmController,
              label: 'Confirm new password',
              obscureText: true,
              validator: (v) => Validators.required(v, fieldName: 'Confirm password'),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Update password',
              isLoading: auth.isLoading,
              onPressed: auth.isLoading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
