import 'package:intl/intl.dart';

class CustomDateUtils {
  CustomDateUtils._();

  /// Returns 7 Nov 2024
  static String format(DateTime? date) {
    if (date == null) return '';

    return DateFormat('d MMM yyyy').format(date);
  }

  /// Returns 7 Nov 2024
  static String? formatOrNull(DateTime? date) {
    if (date == null) return null;

    return DateFormat('d MMM yyyy').format(date);
  }
}
