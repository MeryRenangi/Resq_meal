import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/qr_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/widgets/auth/auth_text_field.dart';
import 'package:resq_meal/widgets/common/app_button.dart' show AppButton, AppButtonVariant;

class QrVerifyScreen extends StatefulWidget {
  const QrVerifyScreen({super.key, required this.donationId, this.type = QrVerificationType.pickup});

  final String donationId;
  final QrVerificationType type;

  @override
  State<QrVerifyScreen> createState() => _QrVerifyScreenState();
}

class _QrVerifyScreenState extends State<QrVerifyScreen> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    await context.read<QrProvider>().generate(
          donationId: widget.donationId,
          type: widget.type,
          userId: user.id,
        );
  }

  Future<void> _verify() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final success = await context.read<QrProvider>().verifyCode(
          _codeController.text.trim().toUpperCase(),
          user.id,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Verified successfully' : context.read<QrProvider>().error ?? 'Failed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final qr = context.watch<QrProvider>();
    final code = qr.lastGenerated?.code;

    return Scaffold(
      appBar: AppBar(title: const Text('QR verification')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppButton(label: 'Generate QR code', onPressed: qr.isProcessing ? null : _generate),
          if (code != null) ...[
            const SizedBox(height: 24),
            Center(
              child: QrImageView(
                data: code,
                size: 200,
                backgroundColor: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Center(child: Text('Code: $code', style: Theme.of(context).textTheme.titleMedium)),
          ],
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          Text('Scan / enter code', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          AuthTextField(
            controller: _codeController,
            label: 'Verification code',
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Confirm verification',
            variant: AppButtonVariant.outlined,
            isLoading: qr.isProcessing,
            onPressed: qr.isProcessing ? null : _verify,
          ),
        ],
      ),
    );
  }
}
