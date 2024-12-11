import 'package:intl/intl.dart';

class Formatter {
  static String formatPrice(num price) {
    final numberFormat = NumberFormat("#,##,###.##");
    return numberFormat.format(price);
  }

  // String formatDate(DateTime date) {
  //   // Format the date to "dd MMM yyyy" format
  //   return DateFormat('dd MMM yyyy').format(date);
  // }
}
