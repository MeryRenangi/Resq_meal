import 'package:resq_meal/core/firestore_mapper.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/location_model.dart';

class NgoModel {
  const NgoModel({
    required this.id,
    required this.userId,
    required this.organizationName,
    required this.contactEmail,
    required this.verificationStatus,
    this.contactPhone,
    this.description,
    this.registrationNumber,
    this.logoUrl,
    this.address,
    this.serviceArea,
    this.totalDonationsReceived = 0,
    this.totalMealsDistributed = 0,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String organizationName;
  final String contactEmail;
  final NgoVerificationStatus verificationStatus;
  final String? contactPhone;
  final String? description;
  final String? registrationNumber;
  final String? logoUrl;
  final LocationModel? address;
  final String? serviceArea;
  final int totalDonationsReceived;
  final int totalMealsDistributed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory NgoModel.fromMap(Map<String, dynamic> map, {required String id}) {
    final addressMap = map['address'];
    return NgoModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      organizationName: map['organizationName'] as String? ?? '',
      contactEmail: map['contactEmail'] as String? ?? '',
      verificationStatus:
          NgoVerificationStatus.fromString(map['verificationStatus'] as String?),
      contactPhone: map['contactPhone'] as String?,
      description: map['description'] as String?,
      registrationNumber: map['registrationNumber'] as String?,
      logoUrl: map['logoUrl'] as String?,
      address: addressMap is Map
          ? LocationModel.fromMap(Map<String, dynamic>.from(addressMap), id: '')
          : null,
      serviceArea: map['serviceArea'] as String?,
      totalDonationsReceived: map['totalDonationsReceived'] as int? ?? 0,
      totalMealsDistributed: map['totalMealsDistributed'] as int? ?? 0,
      createdAt: FirestoreMapper.parseDate(map['createdAt']),
      updatedAt: FirestoreMapper.parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'organizationName': organizationName,
        'contactEmail': contactEmail,
        'verificationStatus': verificationStatus.storageValue,
        if (contactPhone != null) 'contactPhone': contactPhone,
        if (description != null) 'description': description,
        if (registrationNumber != null) 'registrationNumber': registrationNumber,
        if (logoUrl != null) 'logoUrl': logoUrl,
        if (address != null) 'address': address!.toMap(),
        if (serviceArea != null) 'serviceArea': serviceArea,
        'totalDonationsReceived': totalDonationsReceived,
        'totalMealsDistributed': totalMealsDistributed,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      };
}
