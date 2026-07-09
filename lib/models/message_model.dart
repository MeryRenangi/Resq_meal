import 'package:resq_meal/core/firestore_mapper.dart';

class MessageModel {
  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.text,
    this.imageUrl,
    this.isRead = false,
    this.createdAt,
  });

  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String text;
  final String? imageUrl;
  final bool isRead;
  final DateTime? createdAt;

  factory MessageModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return MessageModel(
      id: id,
      chatId: map['chatId'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? '',
      text: map['text'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
      isRead: map['isRead'] as bool? ?? false,
      createdAt: FirestoreMapper.parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'chatId': chatId,
        'senderId': senderId,
        'senderName': senderName,
        'text': text,
        if (imageUrl != null) 'imageUrl': imageUrl,
        'isRead': isRead,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };
}
