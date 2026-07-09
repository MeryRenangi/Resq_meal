import 'package:flutter/material.dart';
import 'package:resq_meal/theme/app_colors.dart';

class AuthMessageBanner extends StatelessWidget {
  const AuthMessageBanner({
    super.key,
    required this.message,
    this.isError = true,
  });

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isError
            ? AppColors.error.withValues(alpha: 0.08)
            : AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError
              ? AppColors.error.withValues(alpha: 0.3)
              : AppColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
            size: 20,
            color: isError ? AppColors.error : AppColors.success,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isError ? AppColors.error : AppColors.success,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
