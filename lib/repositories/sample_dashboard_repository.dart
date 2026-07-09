import 'package:resq_meal/data/sample_dashboard_data.dart';
import 'package:resq_meal/models/dashboard_data_model.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/repositories/dashboard_repository.dart';

/// Local sample data repository for offline development and tests.
class SampleDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardDataModel> fetchDashboard({
    required String userId,
    required UserRole role,
    String? displayName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return SampleDashboardData.forRole(role, displayName: displayName);
  }

  @override
  Future<DashboardDataModel> fetchHomeOverview({String? displayName}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return SampleDashboardData.homeOverview(displayName: displayName);
  }
}
