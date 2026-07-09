import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/user_model.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/services/user_management_service.dart';

class UserManagementProvider extends ChangeNotifier {
  UserManagementProvider(this._service);

  final UserManagementService? _service;

  List<UserModel> _users = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  StreamSubscription<List<UserModel>>? _sub;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  void watchByRole(UserRole role) {
    final service = _service;
    if (service == null) return;
    _sub?.cancel();
    _isLoading = true;
    notifyListeners();
    _sub = service.watchUsersByRole(role).listen(
      (list) {
        _users = list;
        _isLoading = false;
        notifyListeners();
      },
      onError: (Object e) {
        _error = e is RepositoryException ? e.message : e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> updateUser(UserModel user) async {
    final service = _service;
    if (service == null) return false;
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await service.updateUser(user);
      return true;
    } catch (e) {
      _error = e is RepositoryException ? e.message : e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<List<UserModel>> search(String query) async {
    final service = _service;
    if (service == null) return [];
    try {
      return await service.searchUsers(query);
    } catch (e) {
      _error = e is RepositoryException ? e.message : e.toString();
      notifyListeners();
      return [];
    }
  }

  Future<bool> deleteUser(String id) async {
    final service = _service;
    if (service == null) return false;
    try {
      await service.deleteUser(id);
      return true;
    } catch (e) {
      _error = e is RepositoryException ? e.message : e.toString();
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
