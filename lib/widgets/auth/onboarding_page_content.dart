import 'package:flutter/material.dart';
import 'package:resq_meal/models/onboarding_page_model.dart';
import 'package:resq_meal/theme/app_colors.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({super.key, required this.page});

  final OnboardingPageModel page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 72, color: AppColors.primary),
          ),
          const SizedBox(height: 48),
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
