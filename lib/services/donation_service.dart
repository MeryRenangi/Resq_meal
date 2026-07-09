import 'dart:io';

import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/donation_model.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/repositories/donation_repository.dart';
import 'package:resq_meal/repositories/storage_repository.dart';
import 'package:resq_meal/services/notification_service.dart';
import 'package:resq_meal/utils/validation/donation_validator.dart';
import 'package:uuid/uuid.dart';

class DonationService {
  DonationService(this._repository, this._storage, this._notifications);

  final DonationRepository _repository;
  final StorageRepository _storage;
  final NotificationService _notifications;
  final _uuid = const Uuid();

  Stream<List<DonationModel>> watchDonorDonations(String donorId) =>
      _repository.watchByDonor(donorId);

  Stream<List<DonationModel>> watchAvailableDonations() => _repository.watchAvailable();

  Stream<List<DonationModel>> watchNgoDonations(String ngoId) => _repository.watchByNgo(ngoId);

  Stream<DonationModel?> watchDonation(String id) => _repository.watchById(id);

  Future<DonationModel?> getDonation(String id) => _repository.getById(id);

  Future<String> createDonation(DonationModel donation, {List<File>? images}) async {
    final error = DonationValidator.validateDonation(donation);
    if (error != null) throw RepositoryException(error);

    final id = _uuid.v4();
    var imageUrls = <String>[];
    if (images != null && images.isNotEmpty) {
      imageUrls = await _uploadImages(id, images);
    }

    final toSave = donation.copyWith(
      id: id,
      status: DonationStatus.draft,
      imageUrls: imageUrls,
    );
    await _repository.create(toSave, id: id);

    if (donation.ngoId != null) {
      await _notifications.send(
        userId: donation.ngoId!,
        title: 'New donation available',
        body: '${donation.title} — ${donation.quantity} ${donation.unit}',
        type: NotificationType.donation,
        referenceId: id,
        referenceType: 'donation',
      );
    }

    return id;
  }

  Future<void> updateDonation(DonationModel donation, {List<File>? newImages}) async {
    final error = DonationValidator.validateDonation(donation);
    if (error != null) throw RepositoryException(error);

    var imageUrls = donation.imageUrls;
    if (newImages != null && newImages.isNotEmpty) {
      final uploaded = await _uploadImages(donation.id, newImages);
      imageUrls = [...imageUrls, ...uploaded];
    }

    await _repository.update(
      donation.id,
      donation.copyWith(imageUrls: imageUrls, updatedAt: DateTime.now()),
    );
  }

  Future<void> deleteDonation(String id) => _repository.delete(id);

  Future<void> updateStatus(String id, DonationStatus status, {String? notifyUserId}) async {
    await _repository.updateStatus(id, status);
    if (notifyUserId != null) {
      await _notifications.send(
        userId: notifyUserId,
        title: 'Donation status updated',
        body: 'Status: ${status.name}',
        type: NotificationType.delivery,
        referenceId: id,
        referenceType: 'donation',
      );
    }
  }

  Future<void> acceptDonation({
    required String donationId,
    required String ngoId,
    required String ngoName,
    required String donorId,
  }) async {
    await _repository.updateFields(donationId, {
      'ngoId': ngoId,
      'ngoName': ngoName,
      'status': DonationStatus.reserved.storageValue,
      'updatedAt': DateTime.now().toIso8601String(),
    });
    await _notifications.send(
      userId: donorId,
      title: 'Donation accepted',
      body: '$ngoName accepted your donation',
      type: NotificationType.donation,
      referenceId: donationId,
      referenceType: 'donation',
    );
  }

  Future<void> schedulePickup({
    required String donationId,
    required DateTime scheduledAt,
    required String notifyUserId,
    String? notes,
  }) async {
    final scheduleNote = 'Pickup scheduled: ${scheduledAt.toIso8601String()}';
    final combinedNotes = notes == null || notes.isEmpty ? scheduleNote : '$notes\n$scheduleNote';
    await _repository.updateFields(donationId, {
      'status': DonationStatus.reserved.storageValue,
      'notes': combinedNotes,
      'updatedAt': DateTime.now().toIso8601String(),
    });
    await _notifications.send(
      userId: notifyUserId,
      title: 'Pickup scheduled',
      body: scheduleNote,
      type: NotificationType.delivery,
      referenceId: donationId,
      referenceType: 'donation',
    );
  }

  Stream<List<DonationModel>> watchAllDonations() => _repository.watchAll();

  Stream<List<DonationModel>> watchPendingApprovals() =>
      _repository.watchByStatus(DonationStatus.draft);

  Future<void> approveDonation(String id, {required String donorId}) async {
    await _repository.updateStatus(id, DonationStatus.available);
    await _notifications.send(
      userId: donorId,
      title: 'Donation approved',
      body: 'Your donation is now visible to NGOs',
      type: NotificationType.donation,
      referenceId: id,
      referenceType: 'donation',
    );
  }

  Future<void> rejectDonation(String id, {required String donorId, String? reason}) async {
    final fields = <String, dynamic>{
      'status': DonationStatus.cancelled.storageValue,
      'updatedAt': DateTime.now().toIso8601String(),
    };
    if (reason != null) fields['notes'] = reason;
    await _repository.updateFields(id, fields);
    await _notifications.send(
      userId: donorId,
      title: 'Donation not approved',
      body: reason ?? 'Your donation was not approved by admin',
      type: NotificationType.donation,
      referenceId: id,
      referenceType: 'donation',
    );
  }

  Future<List<String>> _uploadImages(String donationId, List<File> images) async {
    final urls = <String>[];
    for (final file in images) {
      urls.add(await _storage.uploadDonationImage(donationId: donationId, file: file));
    }
    return urls;
  }
}
