import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/food_request_model.dart';
import 'package:resq_meal/repositories/food_request_repository.dart';
import 'package:resq_meal/services/notification_service.dart';
import 'package:resq_meal/utils/validation/request_validator.dart';
import 'package:uuid/uuid.dart';

class FoodRequestService {
  FoodRequestService(this._repository, this._notifications);

  final FoodRequestRepository _repository;
  final NotificationService _notifications;
  final _uuid = const Uuid();

  Stream<List<FoodRequestModel>> watchNgoRequests(String ngoId) =>
      _repository.watchByNgo(ngoId);

  Stream<List<FoodRequestModel>> watchDonorRequests(String donorId) =>
      _repository.watchByDonor(donorId);

  Future<FoodRequestModel?> getRequest(String id) => _repository.getById(id);

  Future<String> createRequest(FoodRequestModel request) async {
    final error = RequestValidator.validateRequest(request);
    if (error != null) throw RepositoryException(error);

    final id = _uuid.v4();
    await _repository.create(
      FoodRequestModel(
        id: id,
        ngoId: request.ngoId,
        ngoName: request.ngoName,
        title: request.title,
        description: request.description,
        quantityNeeded: request.quantityNeeded,
        status: FoodRequestStatus.pending,
        donationId: request.donationId,
        donorId: request.donorId,
        createdAt: DateTime.now(),
      ),
      id: id,
    );

    if (request.donorId != null) {
      await _notifications.send(
        userId: request.donorId!,
        title: 'New food request',
        body: request.title,
        type: NotificationType.request,
        referenceId: id,
        referenceType: 'food_request',
      );
    }

    return id;
  }

  Future<void> approve(String id, {required String notifyUserId}) async {
    await _repository.updateStatus(id, FoodRequestStatus.approved);
    await _notifications.send(
      userId: notifyUserId,
      title: 'Request approved',
      body: 'Your food request has been approved',
      type: NotificationType.request,
      referenceId: id,
      referenceType: 'food_request',
    );
  }

  Future<void> reject(String id, String reason, {required String notifyUserId}) async {
    await _repository.updateStatus(id, FoodRequestStatus.rejected, reason: reason);
    await _notifications.send(
      userId: notifyUserId,
      title: 'Request rejected',
      body: reason,
      type: NotificationType.request,
      referenceId: id,
      referenceType: 'food_request',
    );
  }

  Future<void> complete(String id, {required String notifyUserId}) async {
    await _repository.updateStatus(id, FoodRequestStatus.completed);
    await _notifications.send(
      userId: notifyUserId,
      title: 'Request completed',
      body: 'Food request has been fulfilled',
      type: NotificationType.delivery,
      referenceId: id,
      referenceType: 'food_request',
    );
  }

  Future<void> deleteRequest(String id) => _repository.delete(id);

  Stream<List<FoodRequestModel>> watchAllRequests() => _repository.watchAll();
}
