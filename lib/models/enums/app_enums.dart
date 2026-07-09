enum DonationStatus {
  draft,
  available,
  reserved,
  pickedUp,
  delivered,
  expired,
  cancelled;

  String get storageValue => name;

  static DonationStatus fromString(String? value) {
    if (value == null) return DonationStatus.draft;
    return DonationStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DonationStatus.draft,
    );
  }
}

enum FoodCategory {
  preparedMeals,
  bakery,
  produce,
  dairy,
  packaged,
  beverages,
  other;

  String get label => switch (this) {
        FoodCategory.preparedMeals => 'Prepared meals',
        FoodCategory.bakery => 'Bakery',
        FoodCategory.produce => 'Produce',
        FoodCategory.dairy => 'Dairy',
        FoodCategory.packaged => 'Packaged',
        FoodCategory.beverages => 'Beverages',
        FoodCategory.other => 'Other',
      };

  String get storageValue => name;

  static FoodCategory fromString(String? value) {
    if (value == null) return FoodCategory.other;
    return FoodCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FoodCategory.other,
    );
  }
}

enum FoodRequestStatus {
  pending,
  approved,
  rejected,
  inProgress,
  completed,
  cancelled;

  String get storageValue => name;

  static FoodRequestStatus fromString(String? value) {
    if (value == null) return FoodRequestStatus.pending;
    return FoodRequestStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FoodRequestStatus.pending,
    );
  }
}

enum NgoVerificationStatus {
  pending,
  verified,
  rejected,
  suspended;

  String get storageValue => name;

  static NgoVerificationStatus fromString(String? value) {
    if (value == null) return NgoVerificationStatus.pending;
    return NgoVerificationStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NgoVerificationStatus.pending,
    );
  }
}

enum ChatType {
  donorNgo,
  ngoReceiver;

  String get storageValue => name;

  static ChatType fromString(String? value) {
    if (value == null) return ChatType.donorNgo;
    return ChatType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ChatType.donorNgo,
    );
  }
}

enum NotificationType {
  donation,
  request,
  chat,
  delivery,
  system;

  String get storageValue => name;

  static NotificationType fromString(String? value) {
    if (value == null) return NotificationType.system;
    return NotificationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationType.system,
    );
  }
}

enum QrVerificationType {
  pickup,
  delivery;

  String get storageValue => name;

  static QrVerificationType fromString(String? value) {
    if (value == null) return QrVerificationType.pickup;
    return QrVerificationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => QrVerificationType.pickup,
    );
  }
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded;

  String get storageValue => name;

  static PaymentStatus fromString(String? value) {
    if (value == null) return PaymentStatus.pending;
    return PaymentStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}
