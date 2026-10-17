
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:ai_gym_assistant/features/exercise_catalog/domain/entities/exercise_definition.dart';
import 'package:ai_gym_assistant/features/profile/domain/entities/user_profile.dart';
import 'package:ai_gym_assistant/features/recommendation/data/serializers/ai_context_serializer.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/entities/ai_context.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/entities/workout_request.dart';

void main() {
  test('Should serialize AI context to JSON', () {
    final context = AiContext(
      request: WorkoutRequest(
        focus: WorkoutFocus.chest,
        exerciseIds: ['bench_press'],
        note: 'Light workout today',
      ),
      profile: const UserProfile(
        goal: 'strength',
        weightKg: 65,
        heightCm: 170,
        age: 22,
      ),
      exercises: [
        AiExerciseContext(
          exercise: ExerciseDefinition(
            id: 'bench_press',
            name: 'Bench Press',
            muscleGroup: MuscleGroup.chest,
          ),
          recent: null,
          longTerm: null,
        ),
      ],
    );

    final payload = AiContextSerializer.toJson(context);

    // Check that the payload can be encoded to JSON.
    final jsonText = jsonEncode(payload);
    final decoded =
    jsonDecode(jsonText) as Map<String, dynamic>;

    final request =
    decoded['request'] as Map<String, dynamic>;

    final profile =
    decoded['profile'] as Map<String, dynamic>;

    final exercises =
    decoded['exercises'] as List<dynamic>;

    final exercise =
    exercises.first as Map<String, dynamic>;

    expect(request['focus'], 'chest');
    expect(request['exerciseIds'], ['bench_press']);
    expect(request['note'], 'Light workout today');

    expect(profile['goal'], 'strength');
    expect(profile['weightKg'], 65);

    expect(exercises.length, 1);
    expect(
      (exercise['exercise'] as Map)['id'],
      'bench_press',
    );

    expect(exercise['recent'], isNull);
    expect(exercise['longTerm'], isNull);
  });
}
