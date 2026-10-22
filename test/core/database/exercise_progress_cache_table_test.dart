
import 'package:ai_gym_assistant/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('creates ExerciseProgressCaches table', () async {
    final db = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );

    addTearDown(db.close);

    final tables = await db.customSelect('''
      SELECT name
      FROM sqlite_master
      WHERE type = 'table'
        AND name = 'exercise_progress_caches'
    ''').get();

    expect(tables, hasLength(1));
    expect(db.schemaVersion, 4);
  });
}
