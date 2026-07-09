import 'package:resq_meal/models/ngo_model.dart';
import 'package:resq_meal/utils/validators.dart';

abstract final class NgoValidator {
  static String? validateOrganizationName(String? value) =>
      Validators.required(value, fieldName: 'Organization name');

  static String? validateEmail(String? value) => Validators.email(value);

  static String? validateRegistration(NgoModel ngo) {
    if (validateOrganizationName(ngo.organizationName) != null) {
      return validateOrganizationName(ngo.organizationName);
    }
    if (validateEmail(ngo.contactEmail) != null) return validateEmail(ngo.contactEmail);
    return null;
  }
}
