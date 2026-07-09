import 'package:flutter/material.dart';
import 'package:resq_meal/screens/dashboard/dashboard_host_screen.dart';
import 'package:resq_meal/screens/shell/explore_tab_screen.dart';
import 'package:resq_meal/screens/shell/orders_tab_screen.dart';
import 'package:resq_meal/screens/shell/profile_tab_screen.dart';

/// Maps bottom-nav index to the corresponding shell tab content.
class ShellTabScreen extends StatelessWidget {
  const ShellTabScreen({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    return switch (tabIndex) {
      0 => const DashboardHostScreen(),
      1 => const ExploreTabScreen(),
      2 => const OrdersTabScreen(),
      3 => const ProfileTabScreen(),
      _ => const DashboardHostScreen(),
    };
  }
}
