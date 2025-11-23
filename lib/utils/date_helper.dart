import 'package:intl/intl.dart';

class DateHelper {
  /// Parse a date string with the given [format].
  /// Returns null if parsing fails.
  static DateTime? parse(String dateString, {String format = 'yyyy-MM-ddTHH:mm:ss'}) {
    try {
      final formatter = DateFormat(format);
      return formatter.parse(dateString);
    } catch (_) {
      return null;
    }
  }

  /// Parse ISO8601 date string.
  static DateTime? parseIso8601(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }

  /// Format a DateTime to a string with the given [format].
  /// Returns empty string if [dateTime] is null.
  static String format(DateTime? dateTime, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    if (dateTime == null) return '';
    final formatter = DateFormat(format);
    return formatter.format(dateTime);
  }

  /// Format DateTime to a localized string.
  /// Example: DateHelper.formatLocalized(DateTime.now(), 'MMMM d, y')
  static String formatLocalized(DateTime dateTime, String locale, {String format = 'yMd'}) {
    final formatter = DateFormat(format, locale);
    return formatter.format(dateTime);
  }
}
