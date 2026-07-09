import 'package:resq_meal/models/chat_model.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/message_model.dart';
import 'package:resq_meal/repositories/chat_repository.dart';
import 'package:resq_meal/services/notification_service.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  ChatService(this._repository, this._notifications);

  final ChatRepository _repository;
  final NotificationService _notifications;
  final _uuid = const Uuid();

  Stream<List<ChatModel>> watchUserChats(String userId) => _repository.watchForUser(userId);

  Stream<List<MessageModel>> watchMessages(String chatId) => _repository.watchMessages(chatId);

  Future<String> createChat({
    required List<String> participantIds,
    required Map<String, String> participantNames,
    required ChatType type,
    String? relatedDonationId,
    String? relatedRequestId,
  }) async {
    final id = _uuid.v4();
    await _repository.create(
      ChatModel(
        id: id,
        participantIds: participantIds,
        participantNames: participantNames,
        type: type,
        relatedDonationId: relatedDonationId,
        relatedRequestId: relatedRequestId,
        createdAt: DateTime.now(),
      ),
      id: id,
    );
    return id;
  }

  Future<String> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
    required List<String> otherParticipantIds,
  }) async {
    final message = MessageModel(
      id: _uuid.v4(),
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      text: text,
      createdAt: DateTime.now(),
    );
    final id = await _repository.sendMessage(message);

    for (final userId in otherParticipantIds) {
      if (userId == senderId) continue;
      await _notifications.send(
        userId: userId,
        title: senderName,
        body: text,
        type: NotificationType.chat,
        referenceId: chatId,
        referenceType: 'chat',
      );
    }

    return id;
  }
}
