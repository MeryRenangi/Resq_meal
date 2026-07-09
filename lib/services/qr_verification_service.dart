import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/qr_verification_model.dart';
import 'package:resq_meal/repositories/donation_repository.dart';
import 'package:resq_meal/repositories/qr_verification_repository.dart';
import 'package:uuid/uuid.dart';

class QrVerificationService {
  QrVerificationService(this._qrRepository, this._donationRepository);

  final QrVerificationRepository _qrRepository;
  final DonationRepository _donationRepository;
  final _uuid = const Uuid();

  Stream<List<QrVerificationModel>> watchByDonation(String donationId) =>
      _qrRepository.watchByDonation(donationId);

  Future<QrVerificationModel> generateCode({
    required String donationId,
    required QrVerificationType type,
    required String createdByUserId,
    String? ngoId,
    String? receiverId,
  }) async {
    final code = _uuid.v4().substring(0, 8).toUpperCase();
    final model = QrVerificationModel(
      id: _uuid.v4(),
      code: code,
      type: type,
      donationId: donationId,
      verifiedByUserId: createdByUserId,
      ngoId: ngoId,
      receiverId: receiverId,
      createdAt: DateTime.now(),
    );
    await _qrRepository.create(model, id: model.id);
    return model;
  }

  Future<void> verifyAndConfirm({
    required String code,
    required String scannedByUserId,
  }) async {
    final record = await _qrRepository.getByCode(code);
    if (record == null) throw RepositoryException('Invalid QR code');
    if (record.isUsed) throw RepositoryException('QR code already used');

    await _qrRepository.markUsed(record.id);

    final status = record.type == QrVerificationType.pickup
        ? DonationStatus.pickedUp
        : DonationStatus.delivered;
    await _donationRepository.updateStatus(record.donationId, status);
  }
}
