import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/services/backend_service_locator.dart';
import 'package:resq_meal/utils/ui_helpers.dart';
import 'package:resq_meal/utils/validators.dart';
import 'package:resq_meal/widgets/auth/auth_text_field.dart';
import 'package:resq_meal/widgets/common/app_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  File? _photoFile;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) setState(() => _photoFile = File(file.path));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (user == null) return;

    var photoUrl = user.photoUrl;
    if (_photoFile != null) {
      BackendServiceLocator? backend;
      try {
        backend = context.read<BackendServiceLocator>();
      } catch (_) {
        backend = null;
      }
      if (backend == null) {
        if (mounted) UiHelpers.showError(context, 'Firebase required to upload photo');
        return;
      }
      try {
        photoUrl = await backend.storage.uploadUserPhoto(userId: user.id, file: _photoFile!);
      } catch (_) {
        if (mounted) UiHelpers.showError(context, 'Could not upload photo');
        return;
      }
    }

    final updated = user.copyWith(
      displayName: _nameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      photoUrl: photoUrl,
    );

    final ok = await auth.updateProfile(updated);
    if (!mounted) return;
    if (ok) {
      UiHelpers.showSuccess(context, 'Profile updated');
      Navigator.pop(context);
    } else {
      UiHelpers.showError(context, auth.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickPhoto,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: _photoFile != null
                      ? FileImage(_photoFile!)
                      : user?.photoUrl != null
                          ? NetworkImage(user!.photoUrl!) as ImageProvider
                          : null,
                  child: _photoFile == null && user?.photoUrl == null
                      ? const Icon(Icons.camera_alt_outlined, size: 32)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(child: Text('Tap to change photo')),
            const SizedBox(height: 24),
            AuthTextField(
              controller: _nameController,
              label: 'Display name',
              validator: (v) => Validators.required(v, fieldName: 'Name'),
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _phoneController,
              label: 'Phone',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            Text('Email: ${user?.email ?? ''}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            AppButton(
              label: 'Save profile',
              isLoading: auth.isLoading,
              onPressed: auth.isLoading ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}
