import 'package:flutter/material.dart';
import 'package:resq_meal/models/onboarding_page_model.dart';

abstract final class OnboardingData {
  static const List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: 'Rescue Surplus Meals',
      subtitle:
          'Connect with local restaurants and save perfectly good food before it goes to waste.',
      icon: Icons.restaurant_rounded,
    ),
    OnboardingPageModel(
      title: 'Feed Communities',
      subtitle:
          'Donors and NGOs work together to deliver meals to people who need them most.',
      icon: Icons.favorite_rounded,
    ),
    OnboardingPageModel(
      title: 'Track Your Impact',
      subtitle:
          'See meals rescued, CO₂ saved, and lives touched — all in one simple dashboard.',
      icon: Icons.insights_rounded,
    ),
  ];
}
