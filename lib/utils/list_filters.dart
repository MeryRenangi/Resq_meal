/// Client-side search and filter helpers for list screens.
abstract final class ListFilters {
  static List<T> byQuery<T>(
    List<T> items,
    String query,
    Iterable<String> Function(T item) fields,
  ) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return items;
    return items.where((item) {
      for (final field in fields(item)) {
        if (field.toLowerCase().contains(q)) return true;
      }
      return false;
    }).toList();
  }

  static List<T> paginate<T>(List<T> items, {required int page, int pageSize = 20}) {
    if (page < 1) return [];
    final start = (page - 1) * pageSize;
    if (start >= items.length) return [];
    return items.sublist(start, (start + pageSize).clamp(0, items.length));
  }
}
