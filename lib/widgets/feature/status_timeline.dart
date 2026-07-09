import 'package:flutter/material.dart';
import 'package:resq_meal/theme/app_colors.dart';

class StatusTimelineStep {
  const StatusTimelineStep({required this.label, required this.isComplete, this.isActive = false});

  final String label;
  final bool isComplete;
  final bool isActive;
}

class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key, required this.steps});

  final List<StatusTimelineStep> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Dot(step: steps[i]),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    steps[i].label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: steps[i].isActive ? FontWeight.w600 : FontWeight.normal,
                          color: steps[i].isComplete || steps[i].isActive
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                  ),
                ),
              ),
            ],
          ),
          if (i < steps.length - 1)
            Padding(
              padding: const EdgeInsets.only(left: 11, top: 4, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(width: 2, height: 20, color: AppColors.border),
              ),
            ),
        ],
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.step});

  final StatusTimelineStep step;

  @override
  Widget build(BuildContext context) {
    final color = step.isComplete
        ? AppColors.success
        : step.isActive
            ? AppColors.primary
            : AppColors.border;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: step.isComplete || step.isActive ? color.withValues(alpha: 0.15) : AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: step.isComplete
          ? Icon(Icons.check, size: 14, color: color)
          : step.isActive
              ? Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                )
              : null,
    );
  }
}
