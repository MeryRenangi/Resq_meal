enum MealOfferStatus { available, reserved, soldOut, expired }

class MealOfferModel {
  const MealOfferModel({
    required this.id,
    required this.restaurantId,
    required this.title,
    required this.originalPrice,
    required this.discountedPrice,
    this.description,
    this.imageUrl,
    this.quantityAvailable = 0,
    this.pickupStart,
    this.pickupEnd,
    this.status = MealOfferStatus.available,
  });

  final String id;
  final String restaurantId;
  final String title;
  final String? description;
  final String? imageUrl;
  final double originalPrice;
  final double discountedPrice;
  final int quantityAvailable;
  final DateTime? pickupStart;
  final DateTime? pickupEnd;
  final MealOfferStatus status;

  double get savingsPercent =>
      originalPrice > 0 ? ((originalPrice - discountedPrice) / originalPrice) * 100 : 0;

  factory MealOfferModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return MealOfferModel(
      id: id,
      restaurantId: map['restaurantId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      imageUrl: map['imageUrl'] as String?,
      originalPrice: (map['originalPrice'] as num?)?.toDouble() ?? 0,
      discountedPrice: (map['discountedPrice'] as num?)?.toDouble() ?? 0,
      quantityAvailable: map['quantityAvailable'] as int? ?? 0,
      pickupStart: map['pickupStart'] != null
          ? DateTime.tryParse(map['pickupStart'].toString())
          : null,
      pickupEnd:
          map['pickupEnd'] != null ? DateTime.tryParse(map['pickupEnd'].toString()) : null,
      status: MealOfferStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => MealOfferStatus.available,
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        'restaurantId': restaurantId,
        'title': title,
        if (description != null) 'description': description,
        if (imageUrl != null) 'imageUrl': imageUrl,
        'originalPrice': originalPrice,
        'discountedPrice': discountedPrice,
        'quantityAvailable': quantityAvailable,
        if (pickupStart != null) 'pickupStart': pickupStart!.toIso8601String(),
        if (pickupEnd != null) 'pickupEnd': pickupEnd!.toIso8601String(),
        'status': status.name,
      };
}
