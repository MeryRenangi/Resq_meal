import 'package:resq_meal/config/app_config.dart';
import 'package:resq_meal/data/sample_dashboard_data.dart';
import 'package:resq_meal/models/dashboard_data_model.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/repositories/dashboard_repository.dart';
import 'package:resq_meal/services/firebase_service.dart';
import 'package:resq_meal/utils/logger.dart';

/// Reads dashboard documents from Firestore; falls back to sample data when missing.
class FirestoreDashboardRepository implements DashboardRepository {
  FirestoreDashboardRepository(this._firebase);

  final FirebaseService _firebase;

  @override
  Future<DashboardDataModel> fetchDashboard({
    required String userId,
    required UserRole role,
    String? displayName,
  }) async {
    try {
      final snapshot = await _firebase.firestore
          .collection(AppConfig.firestoreDashboardsCollection)
          .doc(userId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return DashboardDataModel.fromMap(snapshot.data()!);
      }
    } catch (e, stack) {
      AppLogger.error('Firestore dashboard fetch failed', e, stack);
    }

    return SampleDashboardData.forRole(role, displayName: displayName);
  }

  @override
  Future<DashboardDataModel> fetchHomeOverview({String? displayName}) async {
    return SampleDashboardData.homeOverview(displayName: displayName);
  }
}
