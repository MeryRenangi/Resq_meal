import 'package:resq_meal/models/donation_model.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/repositories/base_firestore_repository.dart';
import 'package:resq_meal/services/firebase_service.dart';

class DonationRepository extends BaseFirestoreRepository<DonationModel> {
  DonationRepository(FirebaseService firebase)
      : super(
          collection: firebase.donationsCollection,
          fromMap: adaptFromMap(DonationModel.fromMap),
          toMap: (d) => d.toMap(),
        );

  Stream<List<DonationModel>> watchByDonor(String donorId, {int limit = 50}) {
    return collection
        .where('donorId', isEqualTo: donorId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  Stream<List<DonationModel>> watchAvailable({int limit = 50}) {
    return collection
        .where('status', isEqualTo: DonationStatus.available.storageValue)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  Stream<List<DonationModel>> watchByNgo(String ngoId, {int limit = 50}) {
    return collection
        .where('ngoId', isEqualTo: ngoId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  Future<void> updateStatus(String id, DonationStatus status) {
    return updateFields(id, {'status': status.storageValue});
  }

  Stream<List<DonationModel>> watchByStatus(DonationStatus status, {int limit = 50}) {
    return collection
        .where('status', isEqualTo: status.storageValue)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  @override
  Stream<List<DonationModel>> watchAll({int limit = 100}) {
    return collection
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }
}
