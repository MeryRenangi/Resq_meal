import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:resq_meal/models/donation_model.dart';
import 'package:resq_meal/models/food_request_model.dart';
import 'package:resq_meal/models/report_model.dart';
import 'package:share_plus/share_plus.dart';

/// Exports platform data as CSV and PDF report files.
class ExportService {
  static final _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  Future<File> exportDonationsCsv(List<DonationModel> donations) async {
    final rows = [
      ['ID', 'Title', 'Donor', 'Category', 'Quantity', 'Status', 'Created'],
      ...donations.map(
        (d) => [
          d.id,
          d.title,
          d.donorName,
          d.category.label,
          '${d.quantity} ${d.unit}',
          d.status.name,
          d.createdAt != null ? _dateFormat.format(d.createdAt!) : '',
        ],
      ),
    ];
    return _writeCsv('donations_export', rows);
  }

  Future<File> exportRequestsCsv(List<FoodRequestModel> requests) async {
    final rows = [
      ['ID', 'Title', 'NGO', 'Quantity', 'Status', 'Created'],
      ...requests.map(
        (r) => [
          r.id,
          r.title,
          r.ngoName,
          '${r.quantityNeeded}',
          r.status.name,
          r.createdAt != null ? _dateFormat.format(r.createdAt!) : '',
        ],
      ),
    ];
    return _writeCsv('requests_export', rows);
  }

  Future<File> exportReportPdf(ReportModel report) async {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('ResQ Meal — Platform Report')),
          pw.Text('Period: ${report.periodLabel}'),
          pw.SizedBox(height: 12),
          pw.Text('Total donations: ${report.totalDonations}'),
          pw.Text('Meals saved: ${report.mealsSaved}'),
          pw.Text('Food waste reduced: ${report.wasteReducedKg} kg'),
          pw.Text('Active users: ${report.activeUsers}'),
          pw.SizedBox(height: 16),
          pw.Text('Monthly statistics', style: pw.TextStyle(fontSize: 16)),
          ...report.monthlyStats.entries.map(
            (e) => pw.Text('${e.key}: ${e.value}'),
          ),
        ],
      ),
    );
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/resq_meal_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await doc.save());
    return file;
  }

  Future<void> shareFile(File file, {String? subject}) async {
    await Share.shareXFiles([XFile(file.path)], subject: subject ?? 'ResQ Meal export');
  }

  Future<File> _writeCsv(String name, List<List<dynamic>> rows) async {
    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${name}_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csv);
    return file;
  }
}
