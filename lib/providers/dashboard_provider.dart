import 'package:flutter/foundation.dart';
import 'package:resq_meal/models/dashboard_data_model.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardProvider(this._dashboardService);

  final DashboardService _dashboardService;

  DashboardDataModel? _roleDashboard;
  DashboardDataModel? _homeOverview;
  bool _isLoading = false;
  String? _errorMessage;

  DashboardDataModel? get roleDashboard => _roleDashboard;
  DashboardDataModel? get homeOverview => _homeOverview;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadRoleDashboard({
    required String userId,
    required UserRole role,
    String? displayName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _roleDashboard = await _dashboardService.getRoleDashboard(
        userId: userId,
        role: role,
        displayName: displayName,
      );
    } catch (e) {
      _errorMessage = 'Failed to load dashboard';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHomeOverview({String? displayName}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _homeOverview = await _dashboardService.getHomeOverview(displayName: displayName);
    } catch (e) {
      _errorMessage = 'Failed to load overview';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _roleDashboard = null;
    _homeOverview = null;
    _errorMessage = null;
    notifyListeners();
  }
}
