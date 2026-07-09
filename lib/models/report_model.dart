import 'package:resq_meal/core/firestore_mapper.dart';

class ReportModel {
  const ReportModel({
    required this.id,
    required this.periodLabel,
    required this.totalDonations,
    required this.mealsSaved,
    required this.wasteReducedKg,
    required this.activeUsers,
    this.monthlyStats = const {},
    this.userActivity = const {},
    this.generatedAt,
  });

  final String id;
  final String periodLabel;
  final int totalDonations;
  final int mealsSaved;
  final double wasteReducedKg;
  final int activeUsers;
  final Map<String, num> monthlyStats;
  final Map<String, num> userActivity;
  final DateTime? generatedAt;

  factory ReportModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return ReportModel(
      id: id,
      periodLabel: map['periodLabel'] as String? ?? '',
      totalDonations: map['totalDonations'] as int? ?? 0,
      mealsSaved: map['mealsSaved'] as int? ?? 0,
      wasteReducedKg: (map['wasteReducedKg'] as num?)?.toDouble() ?? 0,
      activeUsers: map['activeUsers'] as int? ?? 0,
      monthlyStats: Map<String, num>.from(
        (map['monthlyStats'] as Map<dynamic, dynamic>?)?.map(
              (k, v) => MapEntry(k.toString(), v as num),
            ) ??
            {},
      ),
      userActivity: Map<String, num>.from(
        (map['userActivity'] as Map<dynamic, dynamic>?)?.map(
              (k, v) => MapEntry(k.toString(), v as num),
            ) ??
            {},
      ),
      generatedAt: FirestoreMapper.parseDate(map['generatedAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'periodLabel': periodLabel,
        'totalDonations': totalDonations,
        'mealsSaved': mealsSaved,
        'wasteReducedKg': wasteReducedKg,
        'activeUsers': activeUsers,
        'monthlyStats': monthlyStats,
        'userActivity': userActivity,
        if (generatedAt != null) 'generatedAt': generatedAt!.toIso8601String(),
      };
}
