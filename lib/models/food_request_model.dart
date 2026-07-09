import 'package:resq_meal/core/firestore_mapper.dart';
import 'package:resq_meal/models/enums/app_enums.dart';

class FoodRequestModel {
  const FoodRequestModel({
    required this.id,
    required this.ngoId,
    required this.ngoName,
    required this.title,
    required this.description,
    required this.quantityNeeded,
    required this.status,
    this.donationId,
    this.donorId,
    this.receiverId,
    this.receiverName,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  final String id;
  final String ngoId;
  final String ngoName;
  final String title;
  final String description;
  final int quantityNeeded;
  final FoodRequestStatus status;
  final String? donationId;
  final String? donorId;
  final String? receiverId;
  final String? receiverName;
  final String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  factory FoodRequestModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return FoodRequestModel(
      id: id,
      ngoId: map['ngoId'] as String? ?? '',
      ngoName: map['ngoName'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      quantityNeeded: map['quantityNeeded'] as int? ?? 0,
      status: FoodRequestStatus.fromString(map['status'] as String?),
      donationId: map['donationId'] as String?,
      donorId: map['donorId'] as String?,
      receiverId: map['receiverId'] as String?,
      receiverName: map['receiverName'] as String?,
      rejectionReason: map['rejectionReason'] as String?,
      createdAt: FirestoreMapper.parseDate(map['createdAt']),
      updatedAt: FirestoreMapper.parseDate(map['updatedAt']),
      completedAt: FirestoreMapper.parseDate(map['completedAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'ngoId': ngoId,
        'ngoName': ngoName,
        'title': title,
        'description': description,
        'quantityNeeded': quantityNeeded,
        'status': status.storageValue,
        if (donationId != null) 'donationId': donationId,
        if (donorId != null) 'donorId': donorId,
        if (receiverId != null) 'receiverId': receiverId,
        if (receiverName != null) 'receiverName': receiverName,
        if (rejectionReason != null) 'rejectionReason': rejectionReason,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
        if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
      };
}
