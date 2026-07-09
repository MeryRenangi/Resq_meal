import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/ngo_model.dart';
import 'package:resq_meal/services/ngo_service.dart';

class NgoProvider extends ChangeNotifier {
  NgoProvider(this._service);

  final NgoService? _service;

  NgoModel? _current;
  List<NgoModel> _verified = [];
  List<NgoModel> _pending = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  StreamSubscription<NgoModel?>? _profileSub;
  StreamSubscription<List<NgoModel>>? _verifiedSub;
  StreamSubscription<List<NgoModel>>? _pendingSub;

  NgoModel? get current => _current;
  List<NgoModel> get verifiedNgos => _verified;
  List<NgoModel> get pendingNgos => _pending;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  void watchProfile(String userId) {
    final service = _service;
    if (service == null) return;
    _profileSub?.cancel();
    _isLoading = true;
    notifyListeners();
    _profileSub = service.watchByUserId(userId).listen(
      (ngo) {
        _current = ngo;
        _isLoading = false;
        notifyListeners();
      },
      onError: _handleError,
    );
  }

  void watchVerified() {
    final service = _service;
    if (service == null) return;
    _verifiedSub?.cancel();
    _verifiedSub = service.watchVerifiedNgos().listen(
      (list) {
        _verified = list;
        notifyListeners();
      },
      onError: _handleError,
    );
  }

  void watchPendingForAdmin() {
    final service = _service;
    if (service == null) return;
    _pendingSub?.cancel();
    _pendingSub = service.watchPendingNgos().listen(
      (list) {
        _pending = list;
        notifyListeners();
      },
      onError: _handleError,
    );
  }

  Future<bool> register(NgoModel ngo) async {
    final service = _service;
    if (service == null) return false;
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await service.register(ngo);
      return true;
    } catch (e) {
      _error = e is RepositoryException ? e.message : e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> verify(String ngoId, String userId, {required bool approved}) async {
    final service = _service;
    if (service == null) return false;
    try {
      await service.verify(ngoId, userId, approved: approved);
      return true;
    } catch (e) {
      _error = e is RepositoryException ? e.message : e.toString();
      notifyListeners();
      return false;
    }
  }

  void _handleError(Object e) {
    _error = e is RepositoryException ? e.message : e.toString();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _profileSub?.cancel();
    _verifiedSub?.cancel();
    _pendingSub?.cancel();
    super.dispose();
  }
}
