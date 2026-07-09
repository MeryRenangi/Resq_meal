import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/report_model.dart';
import 'package:resq_meal/services/report_service.dart';

class ReportProvider extends ChangeNotifier {
  ReportProvider(this._service);

  final ReportService? _service;

  ReportModel? _report;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<ReportModel?>? _sub;

  ReportModel? get report => _report;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void watchLatest() {
    final service = _service;
    if (service == null) {
      _report = ReportModel(
        id: 'offline',
        periodLabel: 'Offline',
        totalDonations: 0,
        mealsSaved: 0,
        wasteReducedKg: 0,
        activeUsers: 0,
      );
      notifyListeners();
      return;
    }
    _sub?.cancel();
    _isLoading = true;
    notifyListeners();
    _sub = service.watchLatestReport().listen(
      (data) {
        _report = data ?? service.buildSampleInsights();
        _isLoading = false;
        notifyListeners();
      },
      onError: (Object e) {
        _report = service.buildSampleInsights();
        _error = e is RepositoryException ? e.message : e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void loadSample() {
    _report = _service?.buildSampleInsights();
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
