import 'package:flutter/material.dart';
import 'package:resq_meal/theme/app_colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.primaryLight.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          Text(title, style: theme.titleLarge, textAlign: TextAlign.center),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: theme.bodyMedium, textAlign: TextAlign.center),
          ],
          if (action != null) ...[
            const SizedBox(height: 24),
            action!,
          ],
        ],
      ),
    );
  }
}
