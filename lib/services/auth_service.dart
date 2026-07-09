import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resq_meal/models/user_model.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/services/firebase_service.dart';
import 'package:resq_meal/services/user_profile_service.dart';

class AuthService {
  AuthService(
    this._firebase, {
    UserProfileService? userProfileService,
  }) : _userProfileService = userProfileService ?? UserProfileService(_firebase);

  final FirebaseService _firebase;
  final UserProfileService _userProfileService;

  Stream<User?> get authStateChanges => _firebase.auth.authStateChanges();

  User? get currentFirebaseUser => _firebase.auth.currentUser;

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = currentFirebaseUser;
    if (firebaseUser == null) return null;

    final profile = await _userProfileService.fetchProfile(firebaseUser.uid);
    if (profile != null) return profile;

    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _firebase.auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user!;
    final profile = await _userProfileService.fetchProfile(user.uid);

    return profile ??
        UserModel(
          id: user.uid,
          email: user.email ?? email,
          displayName: user.displayName,
          photoUrl: user.photoURL,
        );
  }

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    final credential = await _firebase.auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user!;
    await user.updateDisplayName(displayName.trim());

    return _userProfileService.createProfile(
      userId: user.uid,
      email: user.email ?? email,
      displayName: displayName.trim(),
      role: role,
    );
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _firebase.auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() => _firebase.auth.signOut();

  Future<UserModel> updateProfile(UserModel user) async {
    await _firebase.usersCollection.doc(user.id).set({
      'email': user.email,
      if (user.displayName != null) 'displayName': user.displayName,
      if (user.photoUrl != null) 'photoUrl': user.photoUrl,
      if (user.phone != null) 'phone': user.phone,
      if (user.role != null) 'role': user.role!.storageValue,
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));

    final firebaseUser = currentFirebaseUser;
    if (firebaseUser != null && user.displayName != null) {
      await firebaseUser.updateDisplayName(user.displayName);
    }

    return (await getCurrentUser()) ?? user;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = currentFirebaseUser;
    if (user == null || user.email == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }
}