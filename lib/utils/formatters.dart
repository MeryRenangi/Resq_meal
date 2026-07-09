import 'package:intl/intl.dart';

abstract final class Formatters {
  static final NumberFormat currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  static final DateFormat shortDate = DateFormat('MMM d, yyyy');
  static final DateFormat time = DateFormat('h:mm a');
  static final DateFormat dateTime = DateFormat('MMM d, yyyy · h:mm a');

  static String formatPrice(double amount) => currency.format(amount);

  static String formatPickupWindow(DateTime? start, DateTime? end) {
    if (start == null && end == null) return 'Pickup time TBD';
    if (start != null && end != null) {
      return '${time.format(start)} – ${time.format(end)}';
    }
    final single = start ?? end!;
    return time.format(single);
  }
}
