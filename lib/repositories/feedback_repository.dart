import 'package:resq_meal/models/feedback_model.dart';
import 'package:resq_meal/repositories/base_firestore_repository.dart';
import 'package:resq_meal/services/firebase_service.dart';

class FeedbackRepository extends BaseFirestoreRepository<FeedbackModel> {
  FeedbackRepository(FirebaseService firebase)
      : super(
          collection: firebase.feedbackCollection,
          fromMap: adaptFromMap(FeedbackModel.fromMap),
          toMap: (f) => f.toMap(),
        );

  Stream<List<FeedbackModel>> watchByUser(String userId) {
    return collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  @override
  Stream<List<FeedbackModel>> watchAll({int limit = 100}) {
    return collection
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }
}
