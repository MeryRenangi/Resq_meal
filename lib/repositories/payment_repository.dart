import 'package:resq_meal/models/payment_model.dart';
import 'package:resq_meal/repositories/base_firestore_repository.dart';
import 'package:resq_meal/services/firebase_service.dart';

class PaymentRepository extends BaseFirestoreRepository<PaymentModel> {
  PaymentRepository(FirebaseService firebase)
      : super(
          collection: firebase.paymentsCollection,
          fromMap: adaptFromMap(PaymentModel.fromMap),
          toMap: (p) => p.toMap(),
        );

  Stream<List<PaymentModel>> watchByUser(String userId, {int limit = 50}) {
    return collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  @override
  Stream<List<PaymentModel>> watchAll({int limit = 100}) {
    return collection
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }
}
