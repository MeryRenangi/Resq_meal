import 'package:resq_meal/core/firestore_mapper.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/location_model.dart';

class DonationModel {
  const DonationModel({
    required this.id,
    required this.donorId,
    required this.donorName,
    required this.title,
    required this.description,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.status,
    this.imageUrls = const [],
    this.expiryAt,
    this.pickupLocation,
    this.ngoId,
    this.ngoName,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String donorId;
  final String donorName;
  final String title;
  final String description;
  final FoodCategory category;
  final int quantity;
  final String unit;
  final DonationStatus status;
  final List<String> imageUrls;
  final DateTime? expiryAt;
  final LocationModel? pickupLocation;
  final String? ngoId;
  final String? ngoName;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory DonationModel.fromMap(Map<String, dynamic> map, {required String id}) {
    final locationMap = map['pickupLocation'];
    return DonationModel(
      id: id,
      donorId: map['donorId'] as String? ?? '',
      donorName: map['donorName'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      category: FoodCategory.fromString(map['category'] as String?),
      quantity: map['quantity'] as int? ?? 0,
      unit: map['unit'] as String? ?? 'portions',
      status: DonationStatus.fromString(map['status'] as String?),
      imageUrls: List<String>.from(map['imageUrls'] as List<dynamic>? ?? []),
      expiryAt: FirestoreMapper.parseDate(map['expiryAt']),
      pickupLocation: locationMap is Map
          ? LocationModel.fromMap(Map<String, dynamic>.from(locationMap), id: '')
          : null,
      ngoId: map['ngoId'] as String?,
      ngoName: map['ngoName'] as String?,
      notes: map['notes'] as String?,
      createdAt: FirestoreMapper.parseDate(map['createdAt']),
      updatedAt: FirestoreMapper.parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'donorId': donorId,
        'donorName': donorName,
        'title': title,
        'description': description,
        'category': category.storageValue,
        'quantity': quantity,
        'unit': unit,
        'status': status.storageValue,
        'imageUrls': imageUrls,
        if (expiryAt != null) 'expiryAt': expiryAt!.toIso8601String(),
        if (pickupLocation != null) 'pickupLocation': pickupLocation!.toMap(),
        if (ngoId != null) 'ngoId': ngoId,
        if (ngoName != null) 'ngoName': ngoName,
        if (notes != null) 'notes': notes,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      };

  DonationModel copyWith({
    String? id,
    String? donorId,
    String? donorName,
    String? title,
    String? description,
    FoodCategory? category,
    int? quantity,
    String? unit,
    DonationStatus? status,
    List<String>? imageUrls,
    DateTime? expiryAt,
    LocationModel? pickupLocation,
    String? ngoId,
    String? ngoName,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DonationModel(
      id: id ?? this.id,
      donorId: donorId ?? this.donorId,
      donorName: donorName ?? this.donorName,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      imageUrls: imageUrls ?? this.imageUrls,
      expiryAt: expiryAt ?? this.expiryAt,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      ngoId: ngoId ?? this.ngoId,
      ngoName: ngoName ?? this.ngoName,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
