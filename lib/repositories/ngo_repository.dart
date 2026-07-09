import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/ngo_model.dart';
import 'package:resq_meal/repositories/base_firestore_repository.dart';
import 'package:resq_meal/services/firebase_service.dart';

class NgoRepository extends BaseFirestoreRepository<NgoModel> {
  NgoRepository(FirebaseService firebase)
      : super(
          collection: firebase.ngosCollection,
          fromMap: adaptFromMap(NgoModel.fromMap),
          toMap: (n) => n.toMap(),
        );

  Future<NgoModel?> getByUserId(String userId) async {
    final snapshot =
        await collection.where('userId', isEqualTo: userId).limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return fromMap(doc.data(), doc.id);
  }

  Stream<NgoModel?> watchByUserId(String userId) {
    return collection
        .where('userId', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((s) {
      if (s.docs.isEmpty) return null;
      final doc = s.docs.first;
      return fromMap(doc.data(), doc.id);
    });
  }

  Stream<List<NgoModel>> watchVerified({int limit = 50}) {
    return collection
        .where('verificationStatus', isEqualTo: NgoVerificationStatus.verified.storageValue)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  Stream<List<NgoModel>> watchPendingVerification({int limit = 50}) {
    return collection
        .where('verificationStatus', isEqualTo: NgoVerificationStatus.pending.storageValue)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  Future<void> updateVerification(String id, NgoVerificationStatus status) {
    return updateFields(id, {'verificationStatus': status.storageValue});
  }
}
