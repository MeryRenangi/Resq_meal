import 'package:flutter/material.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/theme/app_colors.dart';

class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get _icon => switch (role) {
        UserRole.donor => Icons.volunteer_activism_rounded,
        UserRole.ngo => Icons.groups_rounded,
        UserRole.admin => Icons.admin_panel_settings_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceVariant : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _icon,
                  color: isSelected ? AppColors.white : AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle_rounded, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
