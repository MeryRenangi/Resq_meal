import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/navigation/feature_navigation.dart';
import 'package:resq_meal/providers/food_request_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/list_filters.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/common/search_filter_bar.dart';
import 'package:resq_meal/widgets/feature/status_badge.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodRequestProvider>().watchAllRequests();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FoodRequestProvider>();
    var filtered = ListFilters.byQuery(
      provider.requests,
      _query,
      (r) => [r.title, r.ngoName, r.status.name],
    );
    if (_statusFilter != null) {
      filtered = filtered.where((r) => r.status.name == _statusFilter).toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Request monitoring')),
      body: Column(
        children: [
          Padding(
            padding: Responsive.pagePadding(context).copyWith(bottom: 0),
            child: SearchFilterBar(
              searchController: _searchController,
              hint: 'Search requests...',
              filterChips: FoodRequestStatus.values.map((s) => s.name).toList(),
              selectedFilter: _statusFilter,
              onFilterSelected: (v) => setState(() => _statusFilter = v),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: provider.isLoading && provider.requests.isEmpty
                ? const LoadingIndicator(message: 'Loading requests...')
                : filtered.isEmpty
                    ? const EmptyState(
                        title: 'No requests',
                        subtitle: 'Food requests across the platform appear here.',
                        icon: Icons.inbox_outlined,
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () async =>
                            context.read<FoodRequestProvider>().watchAllRequests(),
                        child: ListView.builder(
                          padding: Responsive.pagePadding(context),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final r = filtered[i];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(r.title),
                                subtitle: Text('${r.ngoName} · Qty ${r.quantityNeeded}'),
                                trailing: StatusBadge(label: r.status.name),
                                onTap: () => FeatureNavigation.openRequestDetail(context, r),
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
