import 'package:resq_meal/models/report_model.dart';
import 'package:resq_meal/repositories/report_repository.dart';
import 'package:uuid/uuid.dart';

class ReportService {
  ReportService(this._repository);

  final ReportRepository _repository;
  final _uuid = const Uuid();

  Stream<ReportModel?> watchLatestReport() => _repository.watchLatest();

  Future<ReportModel?> getLatestReport() => _repository.getLatest();

  Future<String> saveReport(ReportModel report) async {
    final id = report.id.isNotEmpty ? report.id : _uuid.v4();
    await _repository.create(
      ReportModel(
        id: id,
        periodLabel: report.periodLabel,
        totalDonations: report.totalDonations,
        mealsSaved: report.mealsSaved,
        wasteReducedKg: report.wasteReducedKg,
        activeUsers: report.activeUsers,
        monthlyStats: report.monthlyStats,
        userActivity: report.userActivity,
        generatedAt: DateTime.now(),
      ),
      id: id,
    );
    return id;
  }

  /// Builds analytics from sample aggregates when no Firestore report exists.
  ReportModel buildSampleInsights() {
    return ReportModel(
      id: 'sample',
      periodLabel: 'This month',
      totalDonations: 342,
      mealsSaved: 4280,
      wasteReducedKg: 1860,
      activeUsers: 1240,
      monthlyStats: const {
        'Week 1': 68,
        'Week 2': 82,
        'Week 3': 91,
        'Week 4': 101,
      },
      userActivity: const {
        'donors': 540,
        'ngos': 86,
        'admins': 12,
      },
      generatedAt: DateTime.now(),
    );
  }
}
