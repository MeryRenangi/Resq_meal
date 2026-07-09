import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/constants/app_constants.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/navigation_provider.dart';
import 'package:resq_meal/providers/onboarding_provider.dart';
import 'package:resq_meal/routes/app_router.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/widgets/navigation/app_bottom_nav.dart';
import 'package:resq_meal/widgets/navigation/nav_destinations.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  UserRole? _role(BuildContext context) {
    return context.watch<AuthProvider>().user?.role ??
        context.watch<OnboardingProvider>().selectedRole;
  }

  String _shellTitle(UserRole? role, int index) {
    final destinations = NavDestinations.forRole(role);
    if (index >= 0 && index < destinations.length) {
      return destinations[index].label;
    }
    return AppConstants.appName;
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final currentIndex = navigationShell.currentIndex;
    final role = _role(context);
    final destinations = NavDestinations.forRole(role);
    final tabTitle = _shellTitle(role, currentIndex);

    if (navProvider.currentIndex != currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        syncNavIndexFromShell(context, currentIndex);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.eco_rounded, color: AppColors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentIndex == 0 ? AppConstants.appName : tabTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (currentIndex == 0 && role != null)
                    Text(
                      '${role.label} dashboard',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => FeatureNavigation.openNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => FeatureNavigation.openChats(context),
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        destinations: destinations,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
          context.read<NavigationProvider>().setIndex(index);
        },
      ),
    );
  }
}
