import 'package:resq_meal/constants/storage_keys.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  static Future<LocalStorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  bool get isOnboardingComplete =>
      _prefs.getBool(StorageKeys.onboardingComplete) ?? false;

  UserRole? get selectedRole =>
      UserRole.fromString(_prefs.getString(StorageKeys.selectedRole));

  Future<void> setOnboardingComplete(bool value) =>
      _prefs.setBool(StorageKeys.onboardingComplete, value);

  Future<void> setSelectedRole(UserRole? role) async {
    if (role == null) {
      await _prefs.remove(StorageKeys.selectedRole);
    } else {
      await _prefs.setString(StorageKeys.selectedRole, role.storageValue);
    }
  }

  Future<void> clearAuthPreferences() async {
    await _prefs.remove(StorageKeys.selectedRole);
  }
}
