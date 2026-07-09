import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resq_meal/constants/storage_keys.dart';
import 'package:resq_meal/utils/ui_helpers.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _profileVisible = true;
  bool _shareActivity = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileVisible = prefs.getBool(StorageKeys.privacyProfileVisible) ?? true;
      _shareActivity = prefs.getBool(StorageKeys.privacyShareActivity) ?? false;
      _loaded = true;
    });
  }

  Future<void> _save(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    if (mounted) UiHelpers.showSuccess(context, 'Privacy settings saved');
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Profile visible to NGOs'),
            subtitle: const Text('Allow verified NGOs to see your donor profile'),
            value: _profileVisible,
            onChanged: (v) {
              setState(() => _profileVisible = v);
              _save(StorageKeys.privacyProfileVisible, v);
            },
          ),
          SwitchListTile(
            title: const Text('Share activity in reports'),
            subtitle: const Text('Include anonymized stats in platform analytics'),
            value: _shareActivity,
            onChanged: (v) {
              setState(() => _shareActivity = v);
              _save(StorageKeys.privacyShareActivity, v);
            },
          ),
        ],
      ),
    );
  }
}
