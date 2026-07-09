import 'package:resq_meal/models/user_model.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/repositories/base_firestore_repository.dart';
import 'package:resq_meal/services/firebase_service.dart';

class UserRepository extends BaseFirestoreRepository<UserModel> {
  UserRepository(FirebaseService firebase)
      : super(
          collection: firebase.usersCollection,
          fromMap: adaptFromMap(UserModel.fromMap),
          toMap: (user) => user.toMap(),
        );

  Stream<List<UserModel>> watchByRole(UserRole role, {int limit = 50}) {
    return collection
        .where('role', isEqualTo: role.storageValue)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  Future<List<UserModel>> searchByEmailPrefix(String query, {int limit = 20}) async {
    if (query.isEmpty) return [];
    final snapshot = await collection
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isLessThan: '$query\uf8ff')
        .limit(limit)
        .get();
    return snapshot.docs.map((d) => fromMap(d.data(), d.id)).toList();
  }
}
