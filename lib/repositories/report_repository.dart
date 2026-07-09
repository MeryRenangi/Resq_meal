import 'package:resq_meal/models/report_model.dart';
import 'package:resq_meal/repositories/base_firestore_repository.dart';
import 'package:resq_meal/services/firebase_service.dart';

class ReportRepository extends BaseFirestoreRepository<ReportModel> {
  ReportRepository(FirebaseService firebase)
      : super(
          collection: firebase.reportsCollection,
          fromMap: adaptFromMap(ReportModel.fromMap),
          toMap: (r) => r.toMap(),
        );

  Future<ReportModel?> getLatest() async {
    final snapshot = await collection.orderBy('generatedAt', descending: true).limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return fromMap(doc.data(), doc.id);
  }

  Stream<ReportModel?> watchLatest() {
    return collection
        .orderBy('generatedAt', descending: true)
        .limit(1)
        .snapshots()
        .map((s) {
      if (s.docs.isEmpty) return null;
      final doc = s.docs.first;
      return fromMap(doc.data(), doc.id);
    });
  }
}
