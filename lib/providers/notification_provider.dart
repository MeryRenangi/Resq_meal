import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/notification_model.dart';
import 'package:resq_meal/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider(this._service);

  final NotificationService? _service;

  List<NotificationModel> _items = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<NotificationModel>>? _sub;

  List<NotificationModel> get notifications => _items;
  int get unreadCount => _items.where((n) => !n.isRead).length;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void watch(String userId) {
    final service = _service;
    if (service == null) return;
    _sub?.cancel();
    _isLoading = true;
    notifyListeners();
    _sub = service.watchForUser(userId).listen(
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

  Future<void> markRead(String id) async {
    await _service?.markRead(id);
  }

  Future<void> markAllRead(String userId) async {
    await _service?.markAllRead(userId);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
