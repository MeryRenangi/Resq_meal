import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/ngo_model.dart';
import 'package:resq_meal/repositories/ngo_repository.dart';
import 'package:resq_meal/services/notification_service.dart';
import 'package:resq_meal/utils/validation/ngo_validator.dart';
import 'package:uuid/uuid.dart';

class NgoService {
  NgoService(this._repository, this._notifications);

  final NgoRepository _repository;
  final NotificationService _notifications;
  final _uuid = const Uuid();

  Stream<NgoModel?> watchByUserId(String userId) => _repository.watchByUserId(userId);

  Stream<List<NgoModel>> watchVerifiedNgos() => _repository.watchVerified();

  Stream<List<NgoModel>> watchPendingNgos() => _repository.watchPendingVerification();

  Future<NgoModel?> getByUserId(String userId) => _repository.getByUserId(userId);

  Future<String> register(NgoModel ngo) async {
    final error = NgoValidator.validateRegistration(ngo);
    if (error != null) throw RepositoryException(error);

    final id = _uuid.v4();
    await _repository.create(
      NgoModel(
        id: id,
        userId: ngo.userId,
        organizationName: ngo.organizationName,
        contactEmail: ngo.contactEmail,
        verificationStatus: NgoVerificationStatus.pending,
        contactPhone: ngo.contactPhone,
        description: ngo.description,
        registrationNumber: ngo.registrationNumber,
        address: ngo.address,
        serviceArea: ngo.serviceArea,
        createdAt: DateTime.now(),
      ),
      id: id,
    );
    return id;
  }

  Future<void> updateProfile(NgoModel ngo) async {
    final error = NgoValidator.validateRegistration(ngo);
    if (error != null) throw RepositoryException(error);
    await _repository.update(ngo.id, ngo);
  }

  Future<void> verify(String ngoId, String userId, {required bool approved}) async {
    final status = approved ? NgoVerificationStatus.verified : NgoVerificationStatus.rejected;
    await _repository.updateVerification(ngoId, status);
    await _notifications.send(
      userId: userId,
      title: approved ? 'NGO verified' : 'NGO registration declined',
      body: approved
          ? 'Your organization is now verified on ResQ Meal'
          : 'Please contact support for more information',
      type: NotificationType.system,
      referenceId: ngoId,
      referenceType: 'ngo',
    );
  }

  Future<void> incrementActivity(String ngoId, {int meals = 0, int donations = 0}) async {
    final ngo = await _repository.getById(ngoId);
    if (ngo == null) return;
    await _repository.updateFields(ngoId, {
      'totalMealsDistributed': ngo.totalMealsDistributed + meals,
      'totalDonationsReceived': ngo.totalDonationsReceived + donations,
    });
  }
}
