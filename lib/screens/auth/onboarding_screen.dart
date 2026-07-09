import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/constants/auth_strings.dart';
import 'package:resq_meal/constants/onboarding_data.dart';
import 'package:resq_meal/providers/onboarding_provider.dart';
import 'package:resq_meal/routes/app_routes.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/widgets/auth/onboarding_page_content.dart';
import 'package:resq_meal/widgets/common/app_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    await context.read<OnboardingProvider>().completeOnboarding();
    if (!mounted) return;
    context.go(AppRoutes.roleSelection);
  }

  void _onNext() {
    if (_currentPage < OnboardingData.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == OnboardingData.pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: Text(
                  AuthStrings.onboardingSkip,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: OnboardingData.pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (_, index) => OnboardingPageContent(
                  page: OnboardingData.pages[index],
                ),
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: OnboardingData.pages.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: AppColors.border,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: AppButton(
                label: isLastPage
                    ? AuthStrings.onboardingGetStarted
                    : AuthStrings.onboardingNext,
                onPressed: _onNext,
                icon: isLastPage ? Icons.arrow_forward_rounded : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
