import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/qr_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/widgets/common/app_button.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';

class QrDisplayScreen extends StatefulWidget {
  const QrDisplayScreen({
    super.key,
    required this.donationId,
    this.type = QrVerificationType.pickup,
  });

  final String donationId;
  final QrVerificationType type;

  @override
  State<QrDisplayScreen> createState() => _QrDisplayScreenState();
}

class _QrDisplayScreenState extends State<QrDisplayScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _generate());
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

  @override
  Widget build(BuildContext context) {
    final qr = context.watch<QrProvider>();
    final code = qr.lastGenerated?.code;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.type.name} QR code')),
      body: qr.isProcessing && code == null
          ? const LoadingIndicator(message: 'Generating QR code...')
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Show this code at ${widget.type.name}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                if (code != null)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: QrImageView(data: code, size: 220),
                    ),
                  ),
                const SizedBox(height: 16),
                if (code != null)
                  Center(
                    child: Text(
                      code,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            letterSpacing: 2,
                            color: AppColors.primaryDark,
                          ),
                    ),
                  ),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Regenerate',
                  variant: AppButtonVariant.outlined,
                  onPressed: qr.isProcessing ? null : _generate,
                ),
              ],
            ),
    );
  }
}
