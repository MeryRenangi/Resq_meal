import 'package:flutter/material.dart';
import 'package:resq_meal/theme/app_colors.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    super.key,
    required this.searchController,
    this.hint = 'Search...',
    this.filterChips = const [],
    this.selectedFilter,
    this.onFilterSelected,
    this.onChanged,
  });

  final TextEditingController searchController;
  final String hint;
  final List<String> filterChips;
  final String? selectedFilter;
  final ValueChanged<String?>? onFilterSelected;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: searchController,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      onChanged?.call('');
                    },
                  )
                : null,
          ),
        ),
        if (filterChips.isNotEmpty) ...[
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (onFilterSelected != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: const Text('All'),
                      selected: selectedFilter == null,
                      onSelected: (_) => onFilterSelected!(null),
                    ),
                  ),
                ...filterChips.map(
                  (chip) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(chip),
                      selected: selectedFilter == chip,
                      onSelected: (_) => onFilterSelected?.call(chip),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
