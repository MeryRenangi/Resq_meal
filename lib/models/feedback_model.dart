import 'package:resq_meal/core/firestore_mapper.dart';

class FeedbackModel {
  const FeedbackModel({
    required this.id,
    required this.userId,
    required this.rating,
    required this.comment,
    this.referenceId,
    this.referenceType,
    this.createdAt,
  });

  final String id;
  final String userId;
  final int rating;
  final String comment;
  final String? referenceId;
  final String? referenceType;
  final DateTime? createdAt;

  factory FeedbackModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return FeedbackModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      rating: map['rating'] as int? ?? 0,
      comment: map['comment'] as String? ?? '',
      referenceId: map['referenceId'] as String?,
      referenceType: map['referenceType'] as String?,
      createdAt: FirestoreMapper.parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'rating': rating,
        'comment': comment,
        if (referenceId != null) 'referenceId': referenceId,
        if (referenceType != null) 'referenceType': referenceType,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };
}
