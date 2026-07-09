import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/qr_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/ui_helpers.dart';
import 'package:resq_meal/widgets/auth/auth_text_field.dart';
import 'package:resq_meal/widgets/common/app_button.dart';

/// QR scanner UI — manual code entry (camera scanning can be added via mobile_scanner).
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key, this.type = QrVerificationType.pickup});

  final QrVerificationType type;

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      UiHelpers.showError(context, 'Enter a verification code');
      return;
    }
    final ok = await context.read<QrProvider>().verifyCode(code, user.id);
    if (!mounted) return;
    if (ok) {
      UiHelpers.showSuccess(context, '${widget.type.name} verified successfully');
      Navigator.pop(context, true);
    } else {
      UiHelpers.showError(context, context.read<QrProvider>().error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final qr = context.watch<QrProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Scan ${widget.type.name} QR')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 2),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner_rounded, size: 64, color: AppColors.primary),
                  SizedBox(height: 8),
                  Text('Enter code below or use device camera in production build'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          AuthTextField(
            controller: _codeController,
            label: 'Verification code',
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: widget.type == QrVerificationType.pickup ? 'Verify pickup' : 'Verify delivery',
            isLoading: qr.isProcessing,
            onPressed: qr.isProcessing ? null : _verify,
          ),
        ],
      ),
    );
  }
}
