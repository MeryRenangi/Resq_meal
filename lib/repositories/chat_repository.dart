import 'package:resq_meal/models/chat_model.dart';
import 'package:resq_meal/models/message_model.dart';
import 'package:resq_meal/repositories/base_firestore_repository.dart';
import 'package:resq_meal/services/firebase_service.dart';

class ChatRepository extends BaseFirestoreRepository<ChatModel> {
  ChatRepository(this._firebase)
      : super(
          collection: _firebase.chatsCollection,
          fromMap: adaptFromMap(ChatModel.fromMap),
          toMap: (c) => c.toMap(),
        );

  final FirebaseService _firebase;

  Stream<List<ChatModel>> watchForUser(String userId, {int limit = 50}) {
    return collection
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => fromMap(d.data(), d.id)).toList());
  }

  Stream<List<MessageModel>> watchMessages(String chatId, {int limit = 100}) {
    return _firebase
        .messagesCollection(chatId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => MessageModel.fromMap(d.data(), id: d.id)).toList());
  }

  Future<String> sendMessage(MessageModel message) async {
    final ref = _firebase.messagesCollection(message.chatId).doc();
    await ref.set({
      ...message.toMap(),
      'createdAt': DateTime.now().toIso8601String(),
    });
    await collection.doc(message.chatId).update({
      'lastMessage': message.text,
      'lastMessageAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
    return ref.id;
  }
}
