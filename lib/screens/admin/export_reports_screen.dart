import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/providers/donation_provider.dart';
import 'package:resq_meal/providers/food_request_provider.dart';
import 'package:resq_meal/providers/report_provider.dart';
import 'package:resq_meal/services/export_service.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/ui_helpers.dart';
import 'package:resq_meal/widgets/layout/responsive_content.dart';

class ExportReportsScreen extends StatefulWidget {
  const ExportReportsScreen({super.key});

  @override
  State<ExportReportsScreen> createState() => _ExportReportsScreenState();
}

class _ExportReportsScreenState extends State<ExportReportsScreen> {
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonationProvider>().watchAllDonations();
      context.read<FoodRequestProvider>().watchAllRequests();
      context.read<ReportProvider>().watchLatest();
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _exporting = true);
    try {
      await action();
    } catch (e) {
      if (mounted) UiHelpers.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final export = context.read<ExportService>();
    final donations = context.watch<DonationProvider>().donations;
    final requests = context.watch<FoodRequestProvider>().requests;
    final report = context.watch<ReportProvider>().report;

    return Scaffold(
      appBar: AppBar(title: const Text('Export reports')),
      body: ResponsiveContent(
        child: ListView(
          children: [
            Text(
              'Export platform data',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Generate CSV or PDF reports from live Firestore data.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _ExportTile(
              title: 'Donations (CSV)',
              subtitle: '${donations.length} records',
              icon: Icons.table_chart_outlined,
              onExport: _exporting
                  ? null
                  : () => _run(() async {
                        final file = await export.exportDonationsCsv(donations);
                        await export.shareFile(file, subject: 'Donations export');
                        if (!context.mounted) return;
                        UiHelpers.showSuccess(context, 'Donations CSV ready');
                      }),
            ),
            _ExportTile(
              title: 'Food requests (CSV)',
              subtitle: '${requests.length} records',
              icon: Icons.inbox_outlined,
              onExport: _exporting
                  ? null
                  : () => _run(() async {
                        final file = await export.exportRequestsCsv(requests);
                        await export.shareFile(file, subject: 'Requests export');
                        if (!context.mounted) return;
                        UiHelpers.showSuccess(context, 'Requests CSV ready');
                      }),
            ),
            _ExportTile(
              title: 'Analytics summary (PDF)',
              subtitle: report?.periodLabel ?? 'Latest report',
              icon: Icons.picture_as_pdf_outlined,
              onExport: _exporting || report == null
                  ? null
                  : () => _run(() async {
                        final file = await export.exportReportPdf(report);
                        await export.shareFile(file, subject: 'ResQ Meal report');
                        if (!context.mounted) return;
                        UiHelpers.showSuccess(context, 'PDF report ready');
                      }),
            ),
            if (_exporting) ...[
              const SizedBox(height: 24),
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExportTile extends StatelessWidget {
  const _ExportTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onExport,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onExport;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: TextButton(
          onPressed: onExport,
          child: const Text('Export'),
        ),
      ),
    );
  }
}
