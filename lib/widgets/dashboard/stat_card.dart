import 'package:flutter/material.dart';
import 'package:resq_meal/models/dashboard_stat_model.dart';
import 'package:resq_meal/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.stat});

  final DashboardStatModel stat;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(stat.icon, color: AppColors.primary, size: 20),
                ),
                const Spacer(),
                if (stat.trend != null)
                  Flexible(
                    child: Text(
                      stat.trend!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: stat.trendUp
                                ? AppColors.success
                                : AppColors.warning,
                            fontWeight: FontWeight.w600,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              stat.label,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    stat.value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (stat.unit != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    stat.unit!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}