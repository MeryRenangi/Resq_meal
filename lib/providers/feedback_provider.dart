import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/feedback_model.dart';
import 'package:resq_meal/services/feedback_service.dart';

class FeedbackProvider extends ChangeNotifier {
  FeedbackProvider(this._service);

  final FeedbackService? _service;

  List<FeedbackModel> _items = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  StreamSubscription<List<FeedbackModel>>? _sub;

  List<FeedbackModel> get feedback => _items;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  void watchUser(String userId) {
    final service = _service;
    if (service == null) return;
    _bind(service.watchUserFeedback(userId));
  }

  void watchAll() {
    final service = _service;
    if (service == null) return;
    _bind(service.watchAllFeedback());
  }

  void _bind(Stream<List<FeedbackModel>> stream) {
    _sub?.cancel();
    _isLoading = true;
    _error = null;
    notifyListeners();
    _sub = stream.listen(
      (list) {
        _items = list;
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

  Future<bool> submit({
    required String userId,
    required int rating,
    required String comment,
    String? referenceId,
    String? referenceType,
  }) async {
    final service = _service;
    if (service == null) return false;
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await service.submitFeedback(
        userId: userId,
        rating: rating,
        comment: comment,
        referenceId: referenceId,
        referenceType: referenceType,
      );
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
    _sub?.cancel();
    super.dispose();
  }
}
