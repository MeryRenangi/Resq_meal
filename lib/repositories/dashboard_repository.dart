import 'package:resq_meal/models/dashboard_data_model.dart';
import 'package:resq_meal/models/user_role.dart';

/// Contract for dashboard data sources (Firestore, cache, or sample).
abstract class DashboardRepository {
  Future<DashboardDataModel> fetchDashboard({
    required String userId,
    required UserRole role,
    String? displayName,
  });

  Future<DashboardDataModel> fetchHomeOverview({String? displayName});
}
