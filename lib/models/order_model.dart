enum OrderStatus { pending, confirmed, ready, completed, cancelled }

class OrderModel {
  const OrderModel({
    required this.id,
    required this.userId,
    required this.mealOfferId,
    required this.restaurantId,
    required this.totalPrice,
    this.status = OrderStatus.pending,
    this.pickupCode,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String mealOfferId;
  final String restaurantId;
  final double totalPrice;
  final OrderStatus status;
  final String? pickupCode;
  final DateTime? createdAt;

  factory OrderModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return OrderModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      mealOfferId: map['mealOfferId'] as String? ?? '',
      restaurantId: map['restaurantId'] as String? ?? '',
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0,
      status: OrderStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      pickupCode: map['pickupCode'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'mealOfferId': mealOfferId,
        'restaurantId': restaurantId,
        'totalPrice': totalPrice,
        'status': status.name,
        if (pickupCode != null) 'pickupCode': pickupCode,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };
}
