import 'package:resq_meal/models/notification_model.dart';
import 'package:resq_meal/repositories/base_firestore_repository.dart';
import 'package:resq_meal/services/firebase_service.dart';

class NotificationRepository extends BaseFirestoreRepository<NotificationModel> {
  NotificationRepository(FirebaseService firebase)
      : super(
          collection: firebase.notificationsCollection,
          fromMap: adaptFromMap(NotificationModel.fromMap),
          toMap: (n) => n.toMap(),
        );

  Stream<List<NotificationModel>> watchForUser(String userId, {int limit = 50}) {
    return collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  Future<void> markRead(String id) => updateFields(id, {'isRead': true});

  Future<void> markAllRead(String userId) async {
    final snapshot = await collection.where('userId', isEqualTo: userId).where('isRead', isEqualTo: false).get();
    final batch = collection.firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}
