import 'package:flutter/material.dart';
import 'package:resq_meal/theme/app_colors.dart';

class DashboardSectionHeader extends StatelessWidget {
  const DashboardSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionLabel!,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
          ),
      ],
    );
  }
}
