import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/donation_model.dart';
import 'package:resq_meal/providers/donation_provider.dart';
import 'package:resq_meal/utils/formatters.dart';
import 'package:resq_meal/utils/ui_helpers.dart';
import 'package:resq_meal/widgets/auth/auth_text_field.dart';
import 'package:resq_meal/widgets/common/app_button.dart';

class SchedulePickupScreen extends StatefulWidget {
  const SchedulePickupScreen({super.key, required this.donation});

  final DonationModel donation;

  @override
  State<SchedulePickupScreen> createState() => _SchedulePickupScreenState();
}

class _SchedulePickupScreenState extends State<SchedulePickupScreen> {
  DateTime? _scheduledAt;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 14)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (time == null) return;
    setState(() {
      _scheduledAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    if (_scheduledAt == null) {
      UiHelpers.showError(context, 'Select pickup date and time');
      return;
    }
    final provider = context.read<DonationProvider>();
    final ok = await provider.schedulePickup(
      donationId: widget.donation.id,
      scheduledAt: _scheduledAt!,
      notifyUserId: widget.donation.donorId,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      UiHelpers.showSuccess(context, 'Pickup scheduled');
      Navigator.pop(context, true);
    } else {
      UiHelpers.showError(context, provider.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DonationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule pickup')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.donation.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              _scheduledAt == null
                  ? 'Select date & time'
                  : Formatters.dateTime.format(_scheduledAt!),
            ),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickDateTime,
          ),
          const SizedBox(height: 12),
          AuthTextField(
            controller: _notesController,
            label: 'Notes (optional)',
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Confirm schedule',
            isLoading: provider.isSaving,
            onPressed: provider.isSaving ? null : _submit,
          ),
        ],
      ),
    );
  }
}
