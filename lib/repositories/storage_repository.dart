import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:resq_meal/config/app_config.dart';
import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/services/firebase_service.dart';

class StorageRepository {
  StorageRepository(this._firebase);

  final FirebaseService _firebase;

  Future<String> uploadDonationImage({
    required String donationId,
    required File file,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = '${AppConfig.storageDonationsPath}/$donationId/$fileName';
      final ref = _firebase.storageRef(path);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw RepositoryException('Image upload failed: ${e.message}', cause: e);
    }
  }

  Future<String> uploadUserPhoto({
    required String userId,
    required File file,
  }) async {
    try {
      final path = '${AppConfig.storageUsersPath}/$userId/profile.jpg';
      final ref = _firebase.storageRef(path);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw RepositoryException('Photo upload failed: ${e.message}', cause: e);
    }
  }

  Future<void> deleteByUrl(String downloadUrl) async {
    try {
      await _firebase.storage.refFromURL(downloadUrl).delete();
    } on FirebaseException catch (e) {
      throw RepositoryException('Delete failed: ${e.message}', cause: e);
    }
  }
}
