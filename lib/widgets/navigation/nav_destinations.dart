import 'package:flutter/material.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/routes/app_routes.dart';

class NavDestination {
  const NavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.routePath,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String routePath;
}

abstract final class NavDestinations {
  static const int tabCount = 4;

  static List<NavDestination> forRole(UserRole? role) {
    return switch (role) {
      UserRole.donor => _donor,
      UserRole.ngo => _ngo,
      UserRole.admin => _admin,
      null => _default,
    };
  }

  static const List<NavDestination> _default = [
    NavDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      routePath: AppRoutes.home,
    ),
    NavDestination(
      label: 'Explore',
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore_rounded,
      routePath: AppRoutes.explore,
    ),
    NavDestination(
      label: 'Orders',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long_rounded,
      routePath: AppRoutes.orders,
    ),
    NavDestination(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      routePath: AppRoutes.profile,
    ),
  ];

  static const List<NavDestination> _donor = [
    NavDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      routePath: AppRoutes.home,
    ),
    NavDestination(
      label: 'Explore',
      icon: Icons.map_outlined,
      selectedIcon: Icons.map_rounded,
      routePath: AppRoutes.explore,
    ),
    NavDestination(
      label: 'Donations',
      icon: Icons.volunteer_activism_outlined,
      selectedIcon: Icons.volunteer_activism_rounded,
      routePath: AppRoutes.orders,
    ),
    NavDestination(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      routePath: AppRoutes.profile,
    ),
  ];

  static const List<NavDestination> _ngo = [
    NavDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      routePath: AppRoutes.home,
    ),
    NavDestination(
      label: 'Pickups',
      icon: Icons.local_shipping_outlined,
      selectedIcon: Icons.local_shipping_rounded,
      routePath: AppRoutes.explore,
    ),
    NavDestination(
      label: 'Distribute',
      icon: Icons.inventory_2_outlined,
      selectedIcon: Icons.inventory_2_rounded,
      routePath: AppRoutes.orders,
    ),
    NavDestination(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      routePath: AppRoutes.profile,
    ),
  ];

  static const List<NavDestination> _admin = [
    NavDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      routePath: AppRoutes.home,
    ),
    NavDestination(
      label: 'Users',
      icon: Icons.people_outline_rounded,
      selectedIcon: Icons.people_rounded,
      routePath: AppRoutes.explore,
    ),
    NavDestination(
      label: 'Reports',
      icon: Icons.assessment_outlined,
      selectedIcon: Icons.assessment_rounded,
      routePath: AppRoutes.orders,
    ),
    NavDestination(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      routePath: AppRoutes.profile,
    ),
  ];

  /// Backward-compatible default list.
  static List<NavDestination> get items => _default;
}
