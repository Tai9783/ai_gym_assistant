import 'package:ai_gym_assistant/app/utils/app_date_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats day, time, and day heading for display', () {
    final value = DateTime(2026, 10, 24, 15, 24);
    expect(AppDateFormatter.date(value), '24/10/2026');
    expect(AppDateFormatter.time(value), '15:24');
    expect(AppDateFormatter.dateTime(value), '24/10/2026 • 15:24');
    expect(AppDateFormatter.historyDayHeading(value), '24 tháng 10, 2026');
  });

  test('pads single-digit day, month, and time', () {
    final value = DateTime(2026, 1, 2, 3, 4);
    expect(AppDateFormatter.date(value), '02/01/2026');
    expect(AppDateFormatter.time(value), '03:04');
  });
}
