import 'package:resq_meal/models/qr_verification_model.dart';
import 'package:resq_meal/repositories/base_firestore_repository.dart';
import 'package:resq_meal/services/firebase_service.dart';

class QrVerificationRepository extends BaseFirestoreRepository<QrVerificationModel> {
  QrVerificationRepository(FirebaseService firebase)
      : super(
          collection: firebase.qrVerificationsCollection,
          fromMap: adaptFromMap(QrVerificationModel.fromMap),
          toMap: (q) => q.toMap(),
        );

  Future<QrVerificationModel?> getByCode(String code) async {
    final snapshot = await collection.where('code', isEqualTo: code).limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return fromMap(doc.data(), doc.id);
  }

  Stream<List<QrVerificationModel>> watchByDonation(String donationId) {
    return collection
        .where('donationId', isEqualTo: donationId)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  Future<void> markUsed(String id) async {
    await updateFields(id, {
      'isUsed': true,
      'verifiedAt': DateTime.now().toIso8601String(),
    });
  }
}
