import 'package:flutter/foundation.dart';
import 'package:resq_meal/models/user_model.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/services/auth_service.dart';
import 'package:resq_meal/utils/firebase_auth_errors.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService) {
    final service = _authService;
    if (service != null) {
      service.authStateChanges.listen((_) => _onAuthStateChanged());
      _loadCurrentUser();
    } else {
      _isInitialized = true;
    }
  }

  final AuthService? _authService;

  UserModel? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;
  String? _successMessage;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isFirebaseReady => _authService != null;

  AuthService? get _service => _authService;

  Future<void> _loadCurrentUser() async {
    try {
      _user = await _service?.getCurrentUser();
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _onAuthStateChanged() async {
    final service = _service;
    if (service == null) return;
    if (service.currentFirebaseUser == null) {
      _user = null;
      notifyListeners();
      return;
    }
    _user = await service.getCurrentUser();
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final service = _service;
    if (service == null) {
      _errorMessage = 'Firebase is not initialized. Run flutterfire configure.';
      notifyListeners();
      return false;
    }
    return _runAuthAction(() async {
      _user = await service.signInWithEmail(email: email, password: password);
    });
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    final service = _service;
    if (service == null) {
      _errorMessage = 'Firebase is not initialized. Run flutterfire configure.';
      notifyListeners();
      return false;
    }
    return _runAuthAction(() async {
      _user = await service.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
      );
    });
  }

  Future<bool> sendPasswordReset(String email) async {
    final service = _service;
    if (service == null) {
      _errorMessage = 'Firebase is not initialized. Run flutterfire configure.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await service.sendPasswordResetEmail(email);
      _successMessage = 'Password reset email sent. Check your inbox.';
      return true;
    } catch (e) {
      _errorMessage = FirebaseAuthErrors.message(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _service?.signOut();
    _user = null;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<bool> updateProfile(UserModel updated) async {
    final service = _service;
    if (service == null) {
      _errorMessage = 'Firebase is not initialized.';
      notifyListeners();
      return false;
    }
    return _runAuthAction(() async {
      _user = await service.updateProfile(updated);
    });
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final service = _service;
    if (service == null) {
      _errorMessage = 'Firebase is not initialized.';
      notifyListeners();
      return false;
    }
    return _runAuthAction(
      () => service.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }

  Future<void> refreshUser() async {
    _user = await _service?.getCurrentUser();
    notifyListeners();
  }

  Future<bool> _runAuthAction(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await action();
      return true;
    } catch (e) {
      _errorMessage = FirebaseAuthErrors.message(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
