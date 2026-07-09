import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/providers/notification_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';

/// Compact real-time notification banner for dashboards.
class RealtimeNotificationStrip extends StatelessWidget {
  const RealtimeNotificationStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final unread = provider.notifications.where((n) => !n.isRead).take(3).toList();

    if (unread.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.primary.withValues(alpha: 0.08),
      child: InkWell(
        onTap: () => FeatureNavigation.openNotifications(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.notifications_active, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${provider.notifications.where((n) => !n.isRead).length} new notifications',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      unread.first.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
