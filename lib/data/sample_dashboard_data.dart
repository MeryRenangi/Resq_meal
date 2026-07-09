import 'package:flutter/material.dart';
import 'package:resq_meal/models/dashboard_activity_model.dart';
import 'package:resq_meal/models/dashboard_data_model.dart';
import 'package:resq_meal/models/dashboard_stat_model.dart';
import 'package:resq_meal/models/user_role.dart';

abstract final class SampleDashboardData {
  static DashboardDataModel forRole(UserRole role, {String? displayName}) {
    final name = displayName?.split(' ').first ?? 'there';
    return switch (role) {
      UserRole.donor => _donor(name),
      UserRole.ngo => _ngo(name),
      UserRole.admin => _admin(name),
    };
  }

  static DashboardDataModel _donor(String name) {
    final now = DateTime.now();
    return DashboardDataModel(
      role: UserRole.donor,
      greeting: 'Hello, $name',
      summary: 'You\'ve helped rescue 47 meals this month. Keep it up!',
      stats: const [
        DashboardStatModel(
          id: 'meals_donated',
          label: 'Meals Donated',
          value: '47',
          trend: '+12%',
          icon: Icons.restaurant_rounded,
        ),
        DashboardStatModel(
          id: 'co2_saved',
          label: 'CO₂ Saved',
          value: '18.4',
          unit: 'kg',
          trend: '+8%',
          icon: Icons.co2_rounded,
        ),
        DashboardStatModel(
          id: 'active_listings',
          label: 'Active Listings',
          value: '3',
          icon: Icons.inventory_2_outlined,
        ),
        DashboardStatModel(
          id: 'ngos_reached',
          label: 'NGOs Reached',
          value: '6',
          trend: '+2',
          icon: Icons.groups_rounded,
        ),
      ],
      activities: [
        DashboardActivityModel(
          id: '1',
          title: 'Lunch boxes donated',
          subtitle: 'Green Bowl Café · 12 meals',
          timestamp: now.subtract(const Duration(hours: 2)),
          status: 'Picked up',
        ),
        DashboardActivityModel(
          id: '2',
          title: 'New listing created',
          subtitle: 'Bakery surplus · 8 portions',
          timestamp: now.subtract(const Duration(days: 1)),
          status: 'Available',
        ),
        DashboardActivityModel(
          id: '3',
          title: 'NGO confirmed pickup',
          subtitle: 'Hope Kitchen NGO',
          timestamp: now.subtract(const Duration(days: 2)),
          status: 'Scheduled',
        ),
      ],
      quickActions: const ['New donation', 'View listings', 'Find NGOs'],
    );
  }

  static DashboardDataModel _ngo(String name) {
    final now = DateTime.now();
    return DashboardDataModel(
      role: UserRole.ngo,
      greeting: 'Hello, $name',
      summary: '8 pickups scheduled today. 124 meals ready for distribution.',
      stats: const [
        DashboardStatModel(
          id: 'pickups_today',
          label: 'Pickups Today',
          value: '8',
          trend: '2 pending',
          trendUp: false,
          icon: Icons.local_shipping_outlined,
        ),
        DashboardStatModel(
          id: 'meals_distributed',
          label: 'Meals Distributed',
          value: '1.2k',
          unit: 'month',
          trend: '+15%',
          icon: Icons.restaurant_rounded,
        ),
        DashboardStatModel(
          id: 'volunteers',
          label: 'Active Volunteers',
          value: '24',
          icon: Icons.people_rounded,
        ),
        DashboardStatModel(
          id: 'donors',
          label: 'Partner Donors',
          value: '18',
          trend: '+3',
          icon: Icons.volunteer_activism_rounded,
        ),
      ],
      activities: [
        DashboardActivityModel(
          id: '1',
          title: 'Pickup from Sunrise Bakery',
          subtitle: '24 pastries · 10:30 AM',
          timestamp: now.subtract(const Duration(hours: 1)),
          status: 'In transit',
        ),
        DashboardActivityModel(
          id: '2',
          title: 'Distribution completed',
          subtitle: 'Riverside Shelter · 40 meals',
          timestamp: now.subtract(const Duration(hours: 5)),
          status: 'Done',
        ),
        DashboardActivityModel(
          id: '3',
          title: 'New donor partnership',
          subtitle: 'Urban Harvest Restaurant',
          timestamp: now.subtract(const Duration(days: 1)),
          status: 'Approved',
        ),
      ],
      quickActions: const ['Schedule pickup', 'Log distribution', 'Request volunteers'],
    );
  }

  static DashboardDataModel _admin(String name) {
    final now = DateTime.now();
    return DashboardDataModel(
      role: UserRole.admin,
      greeting: 'Hello, $name',
      summary: 'Platform health is strong. 3 items need your review.',
      stats: const [
        DashboardStatModel(
          id: 'total_users',
          label: 'Total Users',
          value: '2.4k',
          trend: '+5.2%',
          icon: Icons.people_rounded,
        ),
        DashboardStatModel(
          id: 'meals_rescued',
          label: 'Meals Rescued',
          value: '18.7k',
          unit: 'all time',
          trend: '+320',
          icon: Icons.restaurant_rounded,
        ),
        DashboardStatModel(
          id: 'pending_approvals',
          label: 'Pending Approvals',
          value: '3',
          trendUp: false,
          icon: Icons.pending_actions_rounded,
        ),
        DashboardStatModel(
          id: 'active_ngos',
          label: 'Active NGOs',
          value: '86',
          trend: '+4',
          icon: Icons.verified_rounded,
        ),
      ],
      activities: [
        DashboardActivityModel(
          id: '1',
          title: 'NGO registration review',
          subtitle: 'Community Plate Alliance',
          timestamp: now.subtract(const Duration(minutes: 30)),
          status: 'Pending',
        ),
        DashboardActivityModel(
          id: '2',
          title: 'Flagged listing resolved',
          subtitle: 'Duplicate post removed',
          timestamp: now.subtract(const Duration(hours: 3)),
          status: 'Resolved',
        ),
        DashboardActivityModel(
          id: '3',
          title: 'Weekly report generated',
          subtitle: 'Meals rescued up 12%',
          timestamp: now.subtract(const Duration(days: 1)),
          status: 'Sent',
        ),
      ],
      quickActions: const ['Review approvals', 'User management', 'Export report'],
    );
  }

  static DashboardDataModel homeOverview({String? displayName}) {
    final name = displayName?.split(' ').first ?? 'there';
    final now = DateTime.now();
    return DashboardDataModel(
      role: UserRole.donor,
      greeting: 'Welcome, $name',
      summary: 'ResQ Meal connects donors, NGOs, and admins to fight food waste.',
      stats: const [
        DashboardStatModel(
          id: 'platform_meals',
          label: 'Meals Rescued',
          value: '18.7k',
          trend: '+12%',
          icon: Icons.restaurant_rounded,
        ),
        DashboardStatModel(
          id: 'platform_co2',
          label: 'CO₂ Prevented',
          value: '4.2',
          unit: 'tons',
          icon: Icons.co2_rounded,
        ),
        DashboardStatModel(
          id: 'active_donors',
          label: 'Active Donors',
          value: '540',
          icon: Icons.volunteer_activism_rounded,
        ),
        DashboardStatModel(
          id: 'active_ngos',
          label: 'Partner NGOs',
          value: '86',
          icon: Icons.groups_rounded,
        ),
      ],
      activities: [
        DashboardActivityModel(
          id: '1',
          title: 'City-wide rescue drive',
          subtitle: '320 meals collected today',
          timestamp: now.subtract(const Duration(hours: 4)),
          status: 'Live',
        ),
        DashboardActivityModel(
          id: '2',
          title: 'New NGO onboarded',
          subtitle: 'Fresh Start Foundation',
          timestamp: now.subtract(const Duration(days: 1)),
          status: 'Active',
        ),
      ],
      quickActions: const ['Explore map', 'Learn more', 'Get started'],
    );
  }
}
