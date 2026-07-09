import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/notification_model.dart';
import 'package:resq_meal/repositories/notification_repository.dart';
import 'package:uuid/uuid.dart';

class NotificationService {
  NotificationService(this._repository);

  final NotificationRepository _repository;
  final _uuid = const Uuid();

  Stream<List<NotificationModel>> watchForUser(String userId) =>
      _repository.watchForUser(userId);

  Future<void> markRead(String id) => _repository.markRead(id);

  Future<void> markAllRead(String userId) => _repository.markAllRead(userId);

  Future<void> send({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    String? referenceId,
    String? referenceType,
  }) async {
    final notification = NotificationModel(
      id: _uuid.v4(),
      userId: userId,
      title: title,
      body: body,
      type: type,
      referenceId: referenceId,
      referenceType: referenceType,
      createdAt: DateTime.now(),
    );
    await _repository.create(notification, id: notification.id);
  }
}
