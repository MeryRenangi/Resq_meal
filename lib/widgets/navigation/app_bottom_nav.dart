import 'package:flutter/material.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/widgets/navigation/nav_destinations.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavDestination> destinations;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.navBarBackground,
        border: Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: currentIndex.clamp(0, destinations.length - 1),
          onDestinationSelected: onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 64,
          indicatorColor: AppColors.surfaceVariant,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            for (final item in destinations)
              NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon, color: AppColors.primary),
                label: item.label,
              ),
          ],
        ),
      ),
    );
  }
}
