import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/donation_model.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/location_model.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/donation_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/validation/donation_validator.dart';
import 'package:resq_meal/utils/validators.dart';
import 'package:resq_meal/widgets/auth/auth_text_field.dart';
import 'package:resq_meal/widgets/common/app_button.dart';

class CreateDonationScreen extends StatefulWidget {
  const CreateDonationScreen({super.key, this.existing});

  final DonationModel? existing;

  @override
  State<CreateDonationScreen> createState() => _CreateDonationScreenState();
}

class _CreateDonationScreenState extends State<CreateDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController(text: 'portions');
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  FoodCategory _category = FoodCategory.preparedMeals;
  DateTime? _expiry;
  final List<File> _images = [];
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final d = widget.existing;
    if (d != null) {
      _titleController.text = d.title;
      _descriptionController.text = d.description;
      _quantityController.text = d.quantity.toString();
      _unitController.text = d.unit;
      _addressController.text = d.pickupLocation?.address ?? '';
      _notesController.text = d.notes ?? '';
      _category = d.category;
      _expiry = d.expiryAt;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final files = await _picker.pickMultiImage(imageQuality: 80);
    if (files.isEmpty) return;
    setState(() => _images.addAll(files.map((x) => File(x.path))));
  }

  Future<void> _pickExpiry() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _expiry ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_expiry ?? DateTime.now()),
    );
    if (time == null) return;
    setState(() {
      _expiry = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_expiry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expiry date')),
      );
      return;
    }

    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    final donation = DonationModel(
      id: widget.existing?.id ?? '',
      donorId: user.id,
      donorName: user.displayName ?? user.email,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      quantity: int.parse(_quantityController.text),
      unit: _unitController.text.trim(),
      status: widget.existing?.status ?? DonationStatus.available,
      expiryAt: _expiry,
      pickupLocation: LocationModel(
        id: '',
        address: _addressController.text.trim(),
      ),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      imageUrls: widget.existing?.imageUrls ?? [],
    );

    final provider = context.read<DonationProvider>();
    final success = widget.existing != null
        ? await provider.updateDonation(donation, images: _images)
        : await provider.createDonation(donation, images: _images);

    if (!mounted) return;
    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Donation submitted for admin approval'),
        ),
      );
      Navigator.of(context).pop(true);
    } else if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DonationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'New donation' : 'Edit donation'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AuthTextField(
              controller: _titleController,
              label: 'Title',
              validator: DonationValidator.validateTitle,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _descriptionController,
              label: 'Description',
              validator: DonationValidator.validateDescription,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<FoodCategory>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: FoodCategory.values
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v ?? _category),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AuthTextField(
                    controller: _quantityController,
                    label: 'Quantity',
                    keyboardType: TextInputType.number,
                    validator: DonationValidator.validateQuantity,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AuthTextField(
                    controller: _unitController,
                    label: 'Unit',
                    validator: (v) => Validators.required(v, fieldName: 'Unit'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _expiry == null ? 'Select expiry' : 'Expires: $_expiry',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
              onTap: _pickExpiry,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _addressController,
              label: 'Pickup address',
              validator: DonationValidator.validatePickupAddress,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _notesController,
              label: 'Notes (optional)',
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: Text('Add photos (${_images.length})'),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: widget.existing == null ? 'Create donation' : 'Save changes',
              isLoading: provider.isSaving,
              onPressed: provider.isSaving ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
