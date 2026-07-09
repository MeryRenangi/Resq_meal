import 'package:resq_meal/core/firestore_mapper.dart';
import 'package:resq_meal/models/enums/app_enums.dart';

class ChatModel {
  const ChatModel({
    required this.id,
    required this.participantIds,
    required this.type,
    this.participantNames = const {},
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCounts = const {},
    this.relatedDonationId,
    this.relatedRequestId,
    this.createdAt,
  });

  final String id;
  final List<String> participantIds;
  final ChatType type;
  final Map<String, String> participantNames;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final Map<String, int> unreadCounts;
  final String? relatedDonationId;
  final String? relatedRequestId;
  final DateTime? createdAt;

  factory ChatModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return ChatModel(
      id: id,
      participantIds: List<String>.from(map['participantIds'] as List<dynamic>? ?? []),
      type: ChatType.fromString(map['type'] as String?),
      participantNames: Map<String, String>.from(
        (map['participantNames'] as Map<dynamic, dynamic>?)?.map(
              (k, v) => MapEntry(k.toString(), v.toString()),
            ) ??
            {},
      ),
      lastMessage: map['lastMessage'] as String?,
      lastMessageAt: FirestoreMapper.parseDate(map['lastMessageAt']),
      unreadCounts: Map<String, int>.from(
        (map['unreadCounts'] as Map<dynamic, dynamic>?)?.map(
              (k, v) => MapEntry(k.toString(), (v as num).toInt()),
            ) ??
            {},
      ),
      relatedDonationId: map['relatedDonationId'] as String?,
      relatedRequestId: map['relatedRequestId'] as String?,
      createdAt: FirestoreMapper.parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'participantIds': participantIds,
        'type': type.storageValue,
        'participantNames': participantNames,
        if (lastMessage != null) 'lastMessage': lastMessage,
        if (lastMessageAt != null) 'lastMessageAt': lastMessageAt!.toIso8601String(),
        'unreadCounts': unreadCounts,
        if (relatedDonationId != null) 'relatedDonationId': relatedDonationId,
        if (relatedRequestId != null) 'relatedRequestId': relatedRequestId,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };
}
