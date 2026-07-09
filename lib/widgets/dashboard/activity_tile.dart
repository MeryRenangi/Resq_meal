import 'package:flutter/material.dart';
import 'package:resq_meal/models/dashboard_activity_model.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/formatters.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({super.key, required this.activity});

  final DashboardActivityModel activity;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.history_rounded, color: AppColors.primary, size: 22),
        ),
        title: Text(activity.title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(activity.subtitle),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (activity.status != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  activity.status!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            const SizedBox(height: 4),
            Text(
              _formatTime(activity.timestamp),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return Formatters.shortDate.format(time);
  }
}
