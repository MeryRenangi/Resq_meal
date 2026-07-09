import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resq_meal/constants/storage_keys.dart';
import 'package:resq_meal/utils/ui_helpers.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _donationAlerts = true;
  bool _requestAlerts = true;
  bool _chatAlerts = true;
  bool _deliveryUpdates = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _donationAlerts = prefs.getBool(StorageKeys.notifyDonations) ?? true;
      _requestAlerts = prefs.getBool(StorageKeys.notifyRequests) ?? true;
      _chatAlerts = prefs.getBool(StorageKeys.notifyChat) ?? true;
      _deliveryUpdates = prefs.getBool(StorageKeys.notifyDelivery) ?? true;
      _loaded = true;
    });
  }

  Future<void> _save(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    if (mounted) UiHelpers.showSuccess(context, 'Notification preferences saved');
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Notification settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Donation alerts'),
            value: _donationAlerts,
            onChanged: (v) {
              setState(() => _donationAlerts = v);
              _save(StorageKeys.notifyDonations, v);
            },
          ),
          SwitchListTile(
            title: const Text('Request alerts'),
            value: _requestAlerts,
            onChanged: (v) {
              setState(() => _requestAlerts = v);
              _save(StorageKeys.notifyRequests, v);
            },
          ),
          SwitchListTile(
            title: const Text('Chat alerts'),
            value: _chatAlerts,
            onChanged: (v) {
              setState(() => _chatAlerts = v);
              _save(StorageKeys.notifyChat, v);
            },
          ),
          SwitchListTile(
            title: const Text('Delivery updates'),
            value: _deliveryUpdates,
            onChanged: (v) {
              setState(() => _deliveryUpdates = v);
              _save(StorageKeys.notifyDelivery, v);
            },
          ),
        ],
      ),
    );
  }
}
