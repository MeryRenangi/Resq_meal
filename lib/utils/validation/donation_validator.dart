import 'package:resq_meal/models/donation_model.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/utils/validators.dart';

abstract final class DonationValidator {
  static String? validateTitle(String? value) => Validators.required(value, fieldName: 'Title');

  static String? validateDescription(String? value) =>
      Validators.required(value, fieldName: 'Description');

  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) return 'Quantity is required';
    final qty = int.tryParse(value);
    if (qty == null || qty < 1) return 'Enter a valid quantity (min 1)';
    return null;
  }

  static String? validateExpiry(DateTime? value) {
    if (value == null) return 'Expiry date is required';
    if (value.isBefore(DateTime.now())) return 'Expiry must be in the future';
    return null;
  }

  static String? validatePickupAddress(String? value) =>
      Validators.required(value, fieldName: 'Pickup address');

  static String? validateDonation(DonationModel donation) {
    if (validateTitle(donation.title) != null) return validateTitle(donation.title);
    if (validateDescription(donation.description) != null) {
      return validateDescription(donation.description);
    }
    if (donation.quantity < 1) return 'Quantity must be at least 1';
    if (validateExpiry(donation.expiryAt) != null) return validateExpiry(donation.expiryAt);
    if (donation.pickupLocation?.address.isEmpty ?? true) return 'Pickup address is required';
    if (donation.category == FoodCategory.other && donation.description.length < 10) {
      return 'Please provide more detail for "Other" category';
    }
    return null;
  }
}
