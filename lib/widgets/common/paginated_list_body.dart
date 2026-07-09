import 'package:flutter/material.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/list_filters.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';

/// List with client-side pagination and optional load-more.
class PaginatedListBody<T> extends StatefulWidget {
  const PaginatedListBody({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.pageSize = 20,
    this.emptyTitle = 'No items',
    this.emptySubtitle = 'Nothing to show yet.',
    this.emptyIcon = Icons.inbox_outlined,
    this.isLoading = false,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final int pageSize;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;
  final bool isLoading;

  @override
  State<PaginatedListBody<T>> createState() => _PaginatedListBodyState<T>();
}

class _PaginatedListBodyState<T> extends State<PaginatedListBody<T>> {
  int _page = 1;

  @override
  void didUpdateWidget(PaginatedListBody<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _page = 1;
    }
  }

  List<T> get _visible {
    final pages = <T>[];
    for (var p = 1; p <= _page; p++) {
      pages.addAll(ListFilters.paginate(widget.items, page: p, pageSize: widget.pageSize));
    }
    return pages;
  }

  bool get _hasMore => _visible.length < widget.items.length;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && widget.items.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (widget.items.isEmpty) {
      return EmptyState(
        title: widget.emptyTitle,
        subtitle: widget.emptySubtitle,
        icon: widget.emptyIcon,
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _visible.length,
            itemBuilder: (context, index) => widget.itemBuilder(context, _visible[index]),
          ),
        ),
        if (_hasMore)
          Padding(
            padding: const EdgeInsets.all(12),
            child: OutlinedButton(
              onPressed: () => setState(() => _page++),
              child: Text('Load more (${widget.items.length - _visible.length} remaining)'),
            ),
          ),
      ],
    );
  }
}
