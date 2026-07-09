import 'package:resq_meal/models/food_request_model.dart';
import 'package:resq_meal/utils/validators.dart';

abstract final class RequestValidator {
  static String? validateTitle(String? value) => Validators.required(value, fieldName: 'Title');

  static String? validateDescription(String? value) =>
      Validators.required(value, fieldName: 'Description');

  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) return 'Quantity is required';
    final qty = int.tryParse(value);
    if (qty == null || qty < 1) return 'Enter a valid quantity';
    return null;
  }

  static String? validateRequest(FoodRequestModel request) {
    if (validateTitle(request.title) != null) return validateTitle(request.title);
    if (validateDescription(request.description) != null) {
      return validateDescription(request.description);
    }
    if (request.quantityNeeded < 1) return 'Quantity needed must be at least 1';
    return null;
  }
}
