import 'package:flutter/material.dart';
import 'package:resq_meal/theme/app_colors.dart';

class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({
    super.key,
    required this.data,
    this.maxHeight = 90,
  });

  final Map<String, num> data;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(child: Text('No data yet')),
      );
    }

    final maxVal = data.values.fold<num>(0, (a, b) => a > b ? a : b);
    final scale = maxVal == 0 ? 1.0 : maxVal;

    return SizedBox(
      height: maxHeight + 55,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.entries.map((e) {
          final barHeight = maxVal == 0 ? 8.0 : (e.value / scale) * maxHeight;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${e.value}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 2),
                  Flexible(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: barHeight.clamp(8, maxHeight),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.key,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}