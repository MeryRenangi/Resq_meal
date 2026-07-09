import 'package:firebase_core/firebase_core.dart';
import 'package:resq_meal/models/dashboard_data_model.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/repositories/dashboard_repository.dart';
import 'package:resq_meal/repositories/firestore_dashboard_repository.dart';
import 'package:resq_meal/repositories/sample_dashboard_repository.dart';
import 'package:resq_meal/services/firebase_service.dart';

class DashboardService {
  DashboardService({DashboardRepository? repository, FirebaseService? firebase})
      : _repository = repository ??
            (Firebase.apps.isNotEmpty && firebase != null
                ? FirestoreDashboardRepository(firebase)
                : SampleDashboardRepository());

  final DashboardRepository _repository;

  Future<DashboardDataModel> getRoleDashboard({
    required String userId,
    required UserRole role,
    String? displayName,
  }) {
    return _repository.fetchDashboard(
      userId: userId,
      role: role,
      displayName: displayName,
    );
  }

  Future<DashboardDataModel> getHomeOverview({String? displayName}) {
    return _repository.fetchHomeOverview(displayName: displayName);
  }
}
