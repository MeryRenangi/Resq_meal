import 'package:resq_meal/core/firestore_mapper.dart';
import 'package:resq_meal/models/enums/app_enums.dart';

class PaymentModel {
  const PaymentModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    this.donationId,
    this.requestId,
    this.description,
    this.createdAt,
  });

  final String id;
  final String userId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final String? donationId;
  final String? requestId;
  final String? description;
  final DateTime? createdAt;

  factory PaymentModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return PaymentModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      currency: map['currency'] as String? ?? 'USD',
      status: PaymentStatus.fromString(map['status'] as String?),
      donationId: map['donationId'] as String?,
      requestId: map['requestId'] as String?,
      description: map['description'] as String?,
      createdAt: FirestoreMapper.parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'amount': amount,
        'currency': currency,
        'status': status.storageValue,
        if (donationId != null) 'donationId': donationId,
        if (requestId != null) 'requestId': requestId,
        if (description != null) 'description': description,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };
}
