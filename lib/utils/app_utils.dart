import 'package:intl/intl.dart';

class AppUtils {
  static String formatCurrency(double value) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'pt_BR').format(date);
  }

  static String greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bom dia';
    if (h < 18) return 'Boa tarde';
    return 'Boa noite';
  }
}
