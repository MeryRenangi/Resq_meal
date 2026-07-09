import 'package:resq_meal/models/dashboard_activity_model.dart';
import 'package:resq_meal/models/dashboard_stat_model.dart';
import 'package:resq_meal/models/user_role.dart';

class DashboardDataModel {
  const DashboardDataModel({
    required this.role,
    required this.greeting,
    required this.summary,
    required this.stats,
    required this.activities,
    this.quickActions = const [],
  });

  final UserRole role;
  final String greeting;
  final String summary;
  final List<DashboardStatModel> stats;
  final List<DashboardActivityModel> activities;
  final List<String> quickActions;

  factory DashboardDataModel.fromMap(Map<String, dynamic> map) {
    final statsList = map['stats'] as List<dynamic>? ?? [];
    final activitiesList = map['activities'] as List<dynamic>? ?? [];
    final actionsList = map['quickActions'] as List<dynamic>? ?? [];

    return DashboardDataModel(
      role: UserRole.fromString(map['role'] as String?) ?? UserRole.donor,
      greeting: map['greeting'] as String? ?? 'Welcome',
      summary: map['summary'] as String? ?? '',
      stats: statsList
          .map((e) => DashboardStatModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      activities: activitiesList
          .map((e) => DashboardActivityModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      quickActions: actionsList.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'role': role.storageValue,
        'greeting': greeting,
        'summary': summary,
        'stats': stats.map((s) => s.toMap()).toList(),
        'activities': activities.map((a) => a.toMap()).toList(),
        'quickActions': quickActions,
      };
}
