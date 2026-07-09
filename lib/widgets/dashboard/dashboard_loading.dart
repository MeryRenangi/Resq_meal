import 'package:flutter/material.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';

class DashboardLoading extends StatelessWidget {
  const DashboardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.gridColumns(context);
    return ListView(
      padding: Responsive.pagePadding(context),
      children: [
        Container(
          height: 24,
          width: 140,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 32,
          width: 220,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.35,
          ),
          itemCount: 4,
          itemBuilder: (_, _) => Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ],
    );
  }
}
