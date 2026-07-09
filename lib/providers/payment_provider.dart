import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/payment_model.dart';
import 'package:resq_meal/services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentProvider(this._service);

  final PaymentService? _service;

  List<PaymentModel> _payments = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<PaymentModel>>? _sub;

  List<PaymentModel> get payments => _payments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void watchUser(String userId) {
    final service = _service;
    if (service == null) return;
    _bind(service.watchUserPayments(userId));
  }

  void watchAll() {
    final service = _service;
    if (service == null) return;
    _bind(service.watchAllPayments());
  }

  void _bind(Stream<List<PaymentModel>> stream) {
    _sub?.cancel();
    _isLoading = true;
    _error = null;
    notifyListeners();
    _sub = stream.listen(
      (list) {
        _payments = list;
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

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
