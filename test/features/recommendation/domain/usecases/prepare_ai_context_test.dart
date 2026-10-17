
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_gym_assistant/features/exercise_catalog/domain/entities/exercise_definition.dart';
import 'package:ai_gym_assistant/features/exercise_catalog/domain/usecases/get_exercises.dart';
import 'package:ai_gym_assistant/features/progress/domain/usecases/get_exercise_progress.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/entities/workout_request.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/services/ai_context_builder.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/usecases/prepare_ai_context.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExercises extends Mock implements GetExercises {}

class MockGetExerciseProgress extends Mock
    implements GetExerciseProgress {}

void main() {
  late MockGetExercises getExercises;
  late MockGetExerciseProgress getExerciseProgress;
  late PrepareAiContext prepareAiContext;

  late List<ExerciseDefinition> catalog;

  setUp(() {
    getExercises = MockGetExercises();
    getExerciseProgress = MockGetExerciseProgress();

    prepareAiContext = PrepareAiContext(
      getExercises,
      getExerciseProgress,
      AiContextBuilder(),
    );

    catalog = [
      ExerciseDefinition(
        id: 'bench_press',
        name: 'Bench Press',
        muscleGroup: MuscleGroup.chest,
      ),
      ExerciseDefinition(
        id: 'chest_fly',
        name: 'Chest Fly',
        muscleGroup: MuscleGroup.chest,
      ),
      ExerciseDefinition(
        id: 'squat',
        name: 'Squat',
        muscleGroup: MuscleGroup.legs,
      ),
    ];

    // Return all catalog exercises.
    when(
          () => getExercises(),
    ).thenAnswer((_) async => catalog);

    // Return no workout history.
    when(
          () => getExerciseProgress(
        exerciseId: any(named: 'exerciseId'),
      ),
    ).thenAnswer(
          (_) async => (recent: null, longTerm: null),
    );
  });

  test('Should use selected exercises', () async {
    final request = WorkoutRequest(
      focus: WorkoutFocus.chest,
      exerciseIds: ['bench_press', 'chest_fly'],
      note: 'Keep it light',
    );

    final context = await prepareAiContext(
      request: request,
    );

    expect(
      context.exercises.map((e) => e.exercise.id).toList(),
      ['bench_press', 'chest_fly'],
    );

    expect(context.request.note, 'Keep it light');

    verify(
          () => getExerciseProgress(
        exerciseId: 'bench_press',
      ),
    ).called(1);

    verify(
          () => getExerciseProgress(
        exerciseId: 'chest_fly',
      ),
    ).called(1);

    verifyNever(
          () => getExerciseProgress(
        exerciseId: 'squat',
      ),
    );
  });

  test('Should get exercises by muscle group', () async {
    final request = WorkoutRequest(
      focus: WorkoutFocus.chest,
      exerciseIds: [],
      note: null,
    );

    final context = await prepareAiContext(
      request: request,
    );

    expect(
      context.exercises.map((e) => e.exercise.id).toList(),
      ['bench_press', 'chest_fly'],
    );

    verify(
          () => getExerciseProgress(
        exerciseId: 'bench_press',
      ),
    ).called(1);

    verify(
          () => getExerciseProgress(
        exerciseId: 'chest_fly',
      ),
    ).called(1);

    verifyNever(
          () => getExerciseProgress(
        exerciseId: 'squat',
      ),
    );
  });

  test('Should use all exercises for full body', () async {
    final request = WorkoutRequest(
      focus: WorkoutFocus.fullBody,
      exerciseIds: [],
      note: null,
    );

    final context = await prepareAiContext(
      request: request,
    );

    expect(context.exercises.length, 3);

    expect(
      context.exercises.map((e) => e.exercise.id).toList(),
      ['bench_press', 'chest_fly', 'squat'],
    );
  });

  test('Should throw when exercise is not found', () async {
    final request = WorkoutRequest(
      focus: WorkoutFocus.chest,
      exerciseIds: ['unknown_exercise'],
      note: null,
    );

    await expectLater(
      prepareAiContext(request: request),
      throwsA(isA<StateError>()),
    );

    verifyNever(
          () => getExerciseProgress(
        exerciseId: any(named: 'exerciseId'),
      ),
    );
  });

  test('Should allow exercises without history', () async {
    final request = WorkoutRequest(
      focus: WorkoutFocus.chest,
      exerciseIds: ['bench_press'],
      note: null,
    );

    final context = await prepareAiContext(
      request: request,
    );

    expect(context.exercises.length, 1);

    final exerciseContext = context.exercises.first;

    expect(
      exerciseContext.exercise.id,
      'bench_press',
    );

    expect(exerciseContext.recent, isNull);
    expect(exerciseContext.longTerm, isNull);
  });

  test('Should ignore duplicate exercise IDs', () async {
    final request = WorkoutRequest(
      focus: WorkoutFocus.chest,
      exerciseIds: ['bench_press', 'bench_press'],
      note: null,
    );

    final context = await prepareAiContext(
      request: request,
    );

    expect(context.exercises.length, 1);

    verify(
          () => getExerciseProgress(
        exerciseId: 'bench_press',
      ),
    ).called(1);
  });
}
