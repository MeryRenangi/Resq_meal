import 'package:resq_meal/core/firestore_mapper.dart';
import 'package:resq_meal/models/enums/app_enums.dart';

class QrVerificationModel {
  const QrVerificationModel({
    required this.id,
    required this.code,
    required this.type,
    required this.donationId,
    required this.verifiedByUserId,
    this.ngoId,
    this.receiverId,
    this.isUsed = false,
    this.verifiedAt,
    this.createdAt,
  });

  final String id;
  final String code;
  final QrVerificationType type;
  final String donationId;
  final String verifiedByUserId;
  final String? ngoId;
  final String? receiverId;
  final bool isUsed;
  final DateTime? verifiedAt;
  final DateTime? createdAt;

  factory QrVerificationModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return QrVerificationModel(
      id: id,
      code: map['code'] as String? ?? '',
      type: QrVerificationType.fromString(map['type'] as String?),
      donationId: map['donationId'] as String? ?? '',
      verifiedByUserId: map['verifiedByUserId'] as String? ?? '',
      ngoId: map['ngoId'] as String?,
      receiverId: map['receiverId'] as String?,
      isUsed: map['isUsed'] as bool? ?? false,
      verifiedAt: FirestoreMapper.parseDate(map['verifiedAt']),
      createdAt: FirestoreMapper.parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'code': code,
        'type': type.storageValue,
        'donationId': donationId,
        'verifiedByUserId': verifiedByUserId,
        if (ngoId != null) 'ngoId': ngoId,
        if (receiverId != null) 'receiverId': receiverId,
        'isUsed': isUsed,
        if (verifiedAt != null) 'verifiedAt': verifiedAt!.toIso8601String(),
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };
}
