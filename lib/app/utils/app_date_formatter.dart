/// Formats dates for display in the app.
///
/// All methods convert the supplied DateTime to the device's local time.
/// Do not use these display strings for SQLite storage or API serialization.
abstract final class AppDateFormatter {
  static String _twoDigits(int value) => value.toString().padLeft(2, '0');

  /// Example: 24/10/2026.
  static String date(DateTime value) {
    final local = value.toLocal();
    return '${_twoDigits(local.day)}/${_twoDigits(local.month)}/${local.year}';
  }

  /// Example: 15:24.
  static String time(DateTime value) {
    final local = value.toLocal();
    return '${_twoDigits(local.hour)}:${_twoDigits(local.minute)}';
  }

  /// Example: 24/10/2026 • 15:24.
  static String dateTime(DateTime value) => '${date(value)} • ${time(value)}';

  /// Example: 24 tháng 10, 2026.
  /// Includes the year so groups from different years remain unambiguous.
  static String historyDayHeading(DateTime value) {
    final local = value.toLocal();
    return '${local.day} tháng ${local.month}, ${local.year}';
  }
}
