import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resq_meal/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onToggleObscure,
    this.inputFormatters,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onToggleObscure;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      inputFormatters: inputFormatters,
      autofillHints: autofillHints,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.primary, size: 22)
            : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
