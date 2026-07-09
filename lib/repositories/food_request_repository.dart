import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/food_request_model.dart';
import 'package:resq_meal/repositories/base_firestore_repository.dart';
import 'package:resq_meal/services/firebase_service.dart';

class FoodRequestRepository extends BaseFirestoreRepository<FoodRequestModel> {
  FoodRequestRepository(FirebaseService firebase)
      : super(
          collection: firebase.foodRequestsCollection,
          fromMap: adaptFromMap(FoodRequestModel.fromMap),
          toMap: (r) => r.toMap(),
        );

  Stream<List<FoodRequestModel>> watchByNgo(String ngoId, {int limit = 50}) {
    return collection
        .where('ngoId', isEqualTo: ngoId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  Stream<List<FoodRequestModel>> watchByDonor(String donorId, {int limit = 50}) {
    return collection
        .where('donorId', isEqualTo: donorId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  Future<void> updateStatus(String id, FoodRequestStatus status, {String? reason}) {
    final fields = <String, dynamic>{
      'status': status.storageValue,
      if (status == FoodRequestStatus.completed)
        'completedAt': DateTime.now().toIso8601String(),
    };
    if (reason != null) fields['rejectionReason'] = reason;
    return updateFields(id, fields);
  }

  @override
  Stream<List<FoodRequestModel>> watchAll({int limit = 100}) {
    return collection
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }
}
