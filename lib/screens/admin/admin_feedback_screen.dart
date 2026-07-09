import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/providers/feedback_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/formatters.dart';
import 'package:resq_meal/utils/list_filters.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/common/search_filter_bar.dart';

class AdminFeedbackScreen extends StatefulWidget {
  const AdminFeedbackScreen({super.key});

  @override
  State<AdminFeedbackScreen> createState() => _AdminFeedbackScreenState();
}

class _AdminFeedbackScreenState extends State<AdminFeedbackScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedbackProvider>().watchAll();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedbackProvider>();
    final filtered = ListFilters.byQuery(
      provider.feedback,
      _query,
      (f) => [f.comment, '${f.rating}'],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Feedback monitoring')),
      body: Column(
        children: [
          Padding(
            padding: Responsive.pagePadding(context).copyWith(bottom: 0),
            child: SearchFilterBar(
              searchController: _searchController,
              hint: 'Search feedback...',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: provider.isLoading && provider.feedback.isEmpty
                ? const LoadingIndicator(message: 'Loading feedback...')
                : filtered.isEmpty
                    ? const EmptyState(
                        title: 'No feedback',
                        subtitle: 'User feedback will appear here.',
                        icon: Icons.rate_review_outlined,
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () async =>
                            context.read<FeedbackProvider>().watchAll(),
                        child: ListView.builder(
                          padding: Responsive.pagePadding(context),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final f = filtered[i];
                            return Card(
                              child: ListTile(
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    5,
                                    (j) => Icon(
                                      j < f.rating ? Icons.star : Icons.star_border,
                                      size: 16,
                                      color: AppColors.warning,
                                    ),
                                  ),
                                ),
                                title: Text(f.comment),
                                subtitle: Text(
                                  f.createdAt != null
                                      ? Formatters.dateTime.format(f.createdAt!)
                                      : '',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
