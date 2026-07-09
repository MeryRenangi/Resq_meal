import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/food_request_model.dart';
import 'package:resq_meal/services/food_request_service.dart';

class FoodRequestProvider extends ChangeNotifier {
  FoodRequestProvider(this._service);

  final FoodRequestService? _service;

  List<FoodRequestModel> _requests = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  StreamSubscription<List<FoodRequestModel>>? _subscription;

  List<FoodRequestModel> get requests => _requests;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  void watchNgoRequests(String ngoId) {
    final service = _service;
    if (service == null) return;
    _bindStream(service.watchNgoRequests(ngoId));
  }

  void watchDonorRequests(String donorId) {
    final service = _service;
    if (service == null) return;
    _bindStream(service.watchDonorRequests(donorId));
  }

  void watchAllRequests() {
    final service = _service;
    if (service == null) return;
    _bindStream(service.watchAllRequests());
  }

  void _bindStream(Stream<List<FoodRequestModel>> stream) {
    _subscription?.cancel();
    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription = stream.listen(
      (items) {
        _requests = items;
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

  Future<bool> createRequest(FoodRequestModel request) async {
    final service = _service;
    if (service == null) return false;
    return _runSave(() => service.createRequest(request));
  }

  Future<bool> approve(String id, String notifyUserId) async {
    final service = _service;
    if (service == null) return false;
    return _runSave(() => service.approve(id, notifyUserId: notifyUserId));
  }

  Future<bool> reject(String id, String reason, String notifyUserId) async {
    final service = _service;
    if (service == null) return false;
    return _runSave(() => service.reject(id, reason, notifyUserId: notifyUserId));
  }

  Future<bool> complete(String id, String notifyUserId) async {
    final service = _service;
    if (service == null) return false;
    return _runSave(() => service.complete(id, notifyUserId: notifyUserId));
  }

  Future<bool> _runSave(Future<void> Function() action) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      _error = e is RepositoryException ? e.message : e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
