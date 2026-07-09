import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/feedback_provider.dart';
import 'package:resq_meal/utils/ui_helpers.dart';
import 'package:resq_meal/utils/validators.dart';
import 'package:resq_meal/widgets/auth/auth_text_field.dart';
import 'package:resq_meal/widgets/common/app_button.dart';
import 'package:resq_meal/widgets/layout/responsive_content.dart';

class SubmitFeedbackScreen extends StatefulWidget {
  const SubmitFeedbackScreen({
    super.key,
    this.referenceId,
    this.referenceType,
  });

  final String? referenceId;
  final String? referenceType;

  @override
  State<SubmitFeedbackScreen> createState() => _SubmitFeedbackScreenState();
}

class _SubmitFeedbackScreenState extends State<SubmitFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    final ok = await context.read<FeedbackProvider>().submit(
          userId: user.id,
          rating: _rating,
          comment: _commentController.text,
          referenceId: widget.referenceId,
          referenceType: widget.referenceType,
        );
    if (!mounted) return;
    if (ok) {
      UiHelpers.showSuccess(context, 'Thank you for your feedback');
      Navigator.pop(context);
    } else {
      UiHelpers.showError(context, context.read<FeedbackProvider>().error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedbackProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Feedback & ratings')),
      body: ResponsiveContent(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Rate your experience', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    icon: Icon(
                      i < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 36,
                    ),
                    onPressed: () => setState(() => _rating = i + 1),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _commentController,
                label: 'Your feedback',
                validator: (v) => Validators.required(v, fieldName: 'Feedback'),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Submit feedback',
                isLoading: provider.isSaving,
                onPressed: provider.isSaving ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
