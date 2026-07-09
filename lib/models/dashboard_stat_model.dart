import 'package:flutter/material.dart';

class DashboardStatModel {
  const DashboardStatModel({
    required this.id,
    required this.label,
    required this.value,
    this.unit,
    this.trend,
    this.trendUp = true,
    this.icon = Icons.insights_outlined,
  });

  final String id;
  final String label;
  final String value;
  final String? unit;
  final String? trend;
  final bool trendUp;
  final IconData icon;

  factory DashboardStatModel.fromMap(Map<String, dynamic> map) {
    return DashboardStatModel(
      id: map['id'] as String? ?? '',
      label: map['label'] as String? ?? '',
      value: map['value'] as String? ?? '0',
      unit: map['unit'] as String?,
      trend: map['trend'] as String?,
      trendUp: map['trendUp'] as bool? ?? true,
      icon: _iconFromName(map['icon'] as String?),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'label': label,
        'value': value,
        if (unit != null) 'unit': unit,
        if (trend != null) 'trend': trend,
        'trendUp': trendUp,
        'icon': icon.codePoint.toString(),
      };

  static IconData _iconFromName(String? name) => switch (name) {
        'meals' => Icons.restaurant_rounded,
        'co2' => Icons.co2_rounded,
        'people' => Icons.people_rounded,
        'pending' => Icons.pending_actions_rounded,
        'verified' => Icons.verified_rounded,
        'alert' => Icons.warning_amber_rounded,
        _ => Icons.insights_outlined,
      };
}
