import 'package:resq_meal/core/firestore_mapper.dart';
import 'package:resq_meal/models/enums/app_enums.dart';

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    this.referenceId,
    this.referenceType,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final String? referenceId;
  final String? referenceType;
  final DateTime? createdAt;

  factory NotificationModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return NotificationModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      type: NotificationType.fromString(map['type'] as String?),
      isRead: map['isRead'] as bool? ?? false,
      referenceId: map['referenceId'] as String?,
      referenceType: map['referenceType'] as String?,
      createdAt: FirestoreMapper.parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'title': title,
        'body': body,
        'type': type.storageValue,
        'isRead': isRead,
        if (referenceId != null) 'referenceId': referenceId,
        if (referenceType != null) 'referenceType': referenceType,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };
}
