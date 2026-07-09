import 'package:flutter/foundation.dart';
import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/qr_verification_model.dart';
import 'package:resq_meal/services/qr_verification_service.dart';

class QrProvider extends ChangeNotifier {
  QrProvider(this._service);

  final QrVerificationService? _service;

  QrVerificationModel? _lastGenerated;
  bool _isProcessing = false;
  String? _error;
  String? _success;

  QrVerificationModel? get lastGenerated => _lastGenerated;
  bool get isProcessing => _isProcessing;
  String? get error => _error;
  String? get success => _success;

  Future<QrVerificationModel?> generate({
    required String donationId,
    required QrVerificationType type,
    required String userId,
    String? ngoId,
  }) async {
    final service = _service;
    if (service == null) return null;
    _isProcessing = true;
    _error = null;
    notifyListeners();
    try {
      _lastGenerated = await service.generateCode(
        donationId: donationId,
        type: type,
        createdByUserId: userId,
        ngoId: ngoId,
      );
      return _lastGenerated;
    } catch (e) {
      _error = e is RepositoryException ? e.message : e.toString();
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<bool> verifyCode(String code, String userId) async {
    final service = _service;
    if (service == null) return false;
    _isProcessing = true;
    _error = null;
    _success = null;
    notifyListeners();
    try {
      await service.verifyAndConfirm(code: code, scannedByUserId: userId);
      _success = 'Verification successful';
      return true;
    } catch (e) {
      _error = e is RepositoryException ? e.message : e.toString();
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
