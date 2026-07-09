import 'package:flutter/foundation.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/services/local_storage_service.dart';

class OnboardingProvider extends ChangeNotifier {
  OnboardingProvider(this._storage);

  final LocalStorageService _storage;

  bool _isInitialized = false;
  bool _onboardingComplete = false;
  UserRole? _selectedRole;

  bool get isInitialized => _isInitialized;
  bool get isOnboardingComplete => _onboardingComplete;
  bool get hasSelectedRole => _selectedRole != null;
  UserRole? get selectedRole => _selectedRole;

  Future<void> initialize() async {
    _onboardingComplete = _storage.isOnboardingComplete;
    _selectedRole = _storage.selectedRole;
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingComplete = true;
    await _storage.setOnboardingComplete(true);
    notifyListeners();
  }

  Future<void> selectRole(UserRole role) async {
    _selectedRole = role;
    await _storage.setSelectedRole(role);
    notifyListeners();
  }

  Future<void> clearSelectedRole() async {
    _selectedRole = null;
    await _storage.setSelectedRole(null);
    notifyListeners();
  }
}
