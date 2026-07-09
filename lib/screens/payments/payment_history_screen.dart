import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/enums/app_enums.dart';
import 'package:resq_meal/models/payment_model.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/payment_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/formatters.dart';
import 'package:resq_meal/utils/list_filters.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';
import 'package:resq_meal/widgets/common/loading_indicator.dart';
import 'package:resq_meal/widgets/common/search_filter_bar.dart';
import 'package:resq_meal/widgets/feature/status_badge.dart';
import 'package:resq_meal/widgets/layout/responsive_content.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key, this.adminView = false});

  final bool adminView;

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.adminView) {
        context.read<PaymentProvider>().watchAll();
      } else {
        final userId = context.read<AuthProvider>().user?.id;
        if (userId != null) context.read<PaymentProvider>().watchUser(userId);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PaymentModel> _filter(List<PaymentModel> payments) {
    var list = ListFilters.byQuery(
      payments,
      _query,
      (p) => [p.description ?? '', p.status.name, '${p.amount}'],
    );
    if (_statusFilter != null) {
      list = list.where((p) => p.status.name == _statusFilter).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();
    final filtered = _filter(provider.payments);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.adminView ? 'All payments' : 'Payment history'),
      ),
      body: ResponsiveContent(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: Responsive.pagePadding(context).copyWith(bottom: 0),
              child: SearchFilterBar(
                searchController: _searchController,
                hint: 'Search payments...',
                filterChips: PaymentStatus.values.map((s) => s.name).toList(),
                selectedFilter: _statusFilter,
                onFilterSelected: (v) => setState(() => _statusFilter = v),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: provider.isLoading && provider.payments.isEmpty
                  ? const LoadingIndicator(message: 'Loading payments...')
                  : filtered.isEmpty
                      ? const EmptyState(
                          title: 'No payments',
                          subtitle: 'Payment records will appear here.',
                          icon: Icons.payment_outlined,
                        )
                      : RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () async {
                            if (widget.adminView) {
                              context.read<PaymentProvider>().watchAll();
                            } else {
                              final id = context.read<AuthProvider>().user?.id;
                              if (id != null) {
                                context.read<PaymentProvider>().watchUser(id);
                              }
                            }
                          },
                          child: ListView.builder(
                            padding: Responsive.pagePadding(context),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final p = filtered[i];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.surfaceVariant,
                                    child: const Icon(Icons.payment, color: AppColors.primary),
                                  ),
                                  title: Text(
                                    Formatters.currency.format(p.amount),
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    '${p.description ?? 'Payment'} · ${p.createdAt != null ? Formatters.dateTime.format(p.createdAt!) : ''}',
                                  ),
                                  trailing: StatusBadge(label: p.status.name),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
