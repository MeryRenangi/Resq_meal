import 'package:flutter/material.dart';
import 'package:resq_meal/theme/app_colors.dart';

class QuickActionChip extends StatelessWidget {
  const QuickActionChip({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      backgroundColor: AppColors.surfaceVariant,
      side: const BorderSide(color: AppColors.border),
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primaryDark,
          ),
      onPressed: onTap ?? () {},
    );
  }
}
