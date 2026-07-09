import 'package:flutter/material.dart';
import 'package:resq_meal/models/dashboard_data_model.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/dashboard/activity_tile.dart';
import 'package:resq_meal/widgets/dashboard/dashboard_section_header.dart';
import 'package:resq_meal/widgets/dashboard/quick_action_chip.dart';
import 'package:resq_meal/navigation/dashboard_actions.dart';
import 'package:resq_meal/widgets/dashboard/stat_card.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({
    super.key,
    required this.data,
    this.showRoleBadge = true,
  });

  final DashboardDataModel data;
  final bool showRoleBadge;

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.gridColumns(context);
    final maxWidth = Responsive.contentMaxWidth(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SingleChildScrollView(
          padding: Responsive.pagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(data: data, showRoleBadge: showRoleBadge),
              const SizedBox(height: 24),
              DashboardSectionHeader(title: 'Overview'),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio:
                      Responsive.of(context) == ScreenSize.mobile ? 1.35 : 1.5,
                ),
                itemCount: data.stats.length,
                itemBuilder: (_, index) => StatCard(stat: data.stats[index]),
              ),
              const SizedBox(height: 28),
              if (data.quickActions.isNotEmpty) ...[
                DashboardSectionHeader(title: 'Quick actions'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final action in data.quickActions)
                      QuickActionChip(
                        label: action,
                        onTap: () =>
                            DashboardActions.handle(context, data.role, action),
                      ),
                  ],
                ),
                const SizedBox(height: 28),
              ],
              DashboardSectionHeader(
                title: 'Recent activity',
                actionLabel: 'See all',
                onAction: () {},
              ),
              const SizedBox(height: 8),
              ...data.activities.map((a) => ActivityTile(activity: a)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.data, required this.showRoleBadge});

  final DashboardDataModel data;
  final bool showRoleBadge;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showRoleBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${data.role.label} dashboard',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primaryDark,
                  ),
            ),
          ),
        if (showRoleBadge) const SizedBox(height: 12),
        Text(data.greeting, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          data.summary,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
        ),
      ],
    );
  }
}
