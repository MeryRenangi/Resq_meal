import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/donation_model.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/food_request_model.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/food_request_provider.dart';
import 'package:resq_meal/providers/ngo_provider.dart';
import 'package:resq_meal/utils/ui_helpers.dart';
import 'package:resq_meal/utils/validation/request_validator.dart';
import 'package:resq_meal/widgets/auth/auth_text_field.dart';
import 'package:resq_meal/widgets/common/app_button.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key, this.donation});

  final DonationModel? donation;

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    final d = widget.donation;
    _titleController = TextEditingController(text: d != null ? 'Request: ${d.title}' : '');
    _descriptionController = TextEditingController(text: d?.description ?? '');
    _quantityController = TextEditingController(text: d?.quantity.toString() ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    final ngo = context.read<NgoProvider>().current;
    final ngoName = ngo?.organizationName ?? user.displayName ?? 'NGO';

    final request = FoodRequestModel(
      id: '',
      ngoId: user.id,
      ngoName: ngoName,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      quantityNeeded: int.parse(_quantityController.text),
      status: FoodRequestStatus.pending,
      donationId: widget.donation?.id,
      donorId: widget.donation?.donorId,
    );

    final provider = context.read<FoodRequestProvider>();
    final ok = await provider.createRequest(request);
    if (!mounted) return;
    if (ok) {
      UiHelpers.showSuccess(context, 'Request created');
      Navigator.of(context).pop(true);
    } else {
      UiHelpers.showError(context, provider.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FoodRequestProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create request')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.donation != null)
              Card(
                child: ListTile(
                  title: Text(widget.donation!.title),
                  subtitle: Text('Linked donation'),
                ),
              ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _titleController,
              label: 'Title',
              validator: RequestValidator.validateTitle,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _descriptionController,
              label: 'Description',
              validator: RequestValidator.validateDescription,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _quantityController,
              label: 'Quantity needed',
              keyboardType: TextInputType.number,
              validator: RequestValidator.validateQuantity,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Submit request',
              isLoading: provider.isSaving,
              onPressed: provider.isSaving ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
