import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/donation_model.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/services/donation_service.dart';

class DonationProvider extends ChangeNotifier {
  DonationProvider(this._service);

  final DonationService? _service;

  List<DonationModel> _donations = [];
  DonationModel? _selected;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  StreamSubscription<List<DonationModel>>? _subscription;

  List<DonationModel> get donations => _donations;
  DonationModel? get selected => _selected;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  bool get isAvailable => _service != null;

  void watchDonorDonations(String donorId) {
    final service = _service;
    if (service == null) return;
    _bindStream(service.watchDonorDonations(donorId));
  }

  void watchAvailableDonations() {
    final service = _service;
    if (service == null) return;
    _bindStream(service.watchAvailableDonations());
  }

  void watchNgoDonations(String ngoId) {
    final service = _service;
    if (service == null) return;
    _bindStream(service.watchNgoDonations(ngoId));
  }

  void watchAllDonations() {
    final service = _service;
    if (service == null) return;
    _bindStream(service.watchAllDonations());
  }

  void watchPendingApprovals() {
    final service = _service;
    if (service == null) return;
    _bindStream(service.watchPendingApprovals());
  }

  void watchSingleDonation(String id) {
    final service = _service;
    if (service == null) return;
    _subscription?.cancel();
    _isLoading = true;
    notifyListeners();
    _subscription = service.watchDonation(id).map((d) => d == null ? <DonationModel>[] : [d]).listen(
      (items) {
        _donations = items;
        _selected = items.isNotEmpty ? items.first : null;
        _isLoading = false;
        notifyListeners();
      },
      onError: (Object e) {
        _error = e is RepositoryException ? e.message : e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void _bindStream(Stream<List<DonationModel>> stream) {
    _subscription?.cancel();
    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription = stream.listen(
      (items) {
        _donations = items;
        _isLoading = false;
        notifyListeners();
      },
      onError: (Object e) {
        _error = e is RepositoryException ? e.message : e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> createDonation(DonationModel donation, {List<File>? images}) async {
    final service = _service;
    if (service == null) {
      _error = 'Firebase not available';
      notifyListeners();
      return false;
    }
    return _runSave(() async {
      final id = await service.createDonation(donation, images: images);
      _selected = await service.getDonation(id);
    });
  }

  Future<bool> updateDonation(DonationModel donation, {List<File>? images}) async {
    final service = _service;
    if (service == null) return false;
    return _runSave(() => service.updateDonation(donation, newImages: images));
  }

  Future<bool> deleteDonation(String id) async {
    final service = _service;
    if (service == null) return false;
    return _runSave(() => service.deleteDonation(id));
  }

  Future<bool> updateStatus(String id, DonationStatus status, {String? notifyUserId}) async {
    final service = _service;
    if (service == null) return false;
    return _runSave(() => service.updateStatus(id, status, notifyUserId: notifyUserId));
  }

  Future<bool> acceptDonation({
    required String donationId,
    required String ngoId,
    required String ngoName,
    required String donorId,
  }) async {
    final service = _service;
    if (service == null) return false;
    return _runSave(
      () => service.acceptDonation(
        donationId: donationId,
        ngoId: ngoId,
        ngoName: ngoName,
        donorId: donorId,
      ),
    );
  }

  Future<bool> approveDonation(String id, String donorId) async {
    final service = _service;
    if (service == null) return false;
    return _runSave(() => service.approveDonation(id, donorId: donorId));
  }

  Future<bool> rejectDonation(String id, String donorId, {String? reason}) async {
    final service = _service;
    if (service == null) return false;
    return _runSave(() => service.rejectDonation(id, donorId: donorId, reason: reason));
  }

  Future<bool> schedulePickup({
    required String donationId,
    required DateTime scheduledAt,
    required String notifyUserId,
    String? notes,
  }) async {
    final service = _service;
    if (service == null) return false;
    return _runSave(
      () => service.schedulePickup(
        donationId: donationId,
        scheduledAt: scheduledAt,
        notifyUserId: notifyUserId,
        notes: notes,
      ),
    );
  }

  Future<bool> _runSave(Future<void> Function() action) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      _error = e is RepositoryException ? e.message : e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
