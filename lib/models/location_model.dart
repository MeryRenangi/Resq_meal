import 'package:resq_meal/core/firestore_mapper.dart';

class LocationModel {
  const LocationModel({
    required this.id,
    required this.address,
    this.label,
    this.latitude,
    this.longitude,
    this.city,
    this.notes,
    this.createdAt,
  });

  final String id;
  final String address;
  final String? label;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? notes;
  final DateTime? createdAt;

  factory LocationModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return LocationModel(
      id: id,
      address: map['address'] as String? ?? '',
      label: map['label'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      city: map['city'] as String?,
      notes: map['notes'] as String?,
      createdAt: FirestoreMapper.parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'address': address,
        if (label != null) 'label': label,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (city != null) 'city': city,
        if (notes != null) 'notes': notes,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };
}
