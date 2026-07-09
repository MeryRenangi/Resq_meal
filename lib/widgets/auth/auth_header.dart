import 'package:flutter/material.dart';
import 'package:resq_meal/theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showLogo = true,
  });

  final String title;
  final String? subtitle;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLogo) ...[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.eco_rounded, color: AppColors.white, size: 32),
          ),
          const SizedBox(height: 24),
        ],
        Text(title, style: theme.headlineMedium),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: theme.bodyMedium),
        ],
      ],
    );
  }
}
