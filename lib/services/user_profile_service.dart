import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resq_meal/models/user_model.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/services/firebase_service.dart';

class UserProfileService {
  UserProfileService(this._firebase);

  final FirebaseService _firebase;

  Future<UserModel> createProfile({
    required String userId,
    required String email,
    required String displayName,
    required UserRole role,
  }) async {
    final now = DateTime.now();
    final data = {
      'email': email,
      'displayName': displayName,
      'role': role.storageValue,
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    };

    await _firebase.usersCollection.doc(userId).set(data);
    return UserModel(
      id: userId,
      email: email,
      displayName: displayName,
      role: role,
      createdAt: now,
    );
  }

  Future<UserModel?> fetchProfile(String userId) async {
    final snapshot = await _firebase.usersCollection.doc(userId).get();
    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }
    return UserModel.fromMap(snapshot.data()!, id: userId);
  }

  Future<void> updateRole(String userId, UserRole role) async {
    await _firebase.usersCollection.doc(userId).set({
      'role': role.storageValue,
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<void> saveFcmToken(String userId, String token) async {
    await _firebase.usersCollection.doc(userId).set({
      'fcmToken': token,
      'fcmTokenUpdatedAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }
}