import 'package:flutter/material.dart';

/// Unified activity entry for user activity history.
class ActivityItemModel {
  const ActivityItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.type,
    this.referenceId,
    this.icon = Icons.history,
  });

  final String id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final String type;
  final String? referenceId;
  final IconData icon;
}
