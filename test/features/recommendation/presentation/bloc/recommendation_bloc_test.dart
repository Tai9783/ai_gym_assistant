
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ai_gym_assistant/features/recommendation/domain/entities/workout_recommendation.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/entities/workout_request.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/usecases/generate_recommendation.dart';
import 'package:ai_gym_assistant/features/recommendation/presentation/bloc/recommendation_bloc.dart';
import 'package:ai_gym_assistant/features/recommendation/presentation/bloc/recommendation_event.dart';
import 'package:ai_gym_assistant/features/recommendation/presentation/bloc/recommendation_state.dart';

class MockGenerateRecommendation extends Mock
    implements GenerateRecommendation {}

void main() {
  late MockGenerateRecommendation generateRecommendation;

  setUp(() {
    generateRecommendation = MockGenerateRecommendation();
  });

  final request = WorkoutRequest(
    focus: WorkoutFocus.chest,
    exerciseIds: ['bench_press'],
    note: null,
  );

  const recommendation = WorkoutRecommendation(
    exercises: [
      RecommendedExercise(
        exerciseId: 'bench_press',
        sets: [
          RecommendedSet(
            suggestedWeight: 40,
            suggestedReps: 10,
          ),
        ],
      ),
    ],
  );

  test('Should emit loading and loaded on success', () async {
    when(
          () => generateRecommendation(request: request),
    ).thenAnswer((_) async => recommendation);

    final bloc = RecommendationBloc(generateRecommendation);
    addTearDown(bloc.close);

    // Listen before adding the event.
    final expectation = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<RecommendationLoading>(),
        isA<RecommendationLoaded>()
            .having(
              (state) => state.request,
          'request',
          same(request),
        )
            .having(
              (state) => state.recommendation,
          'recommendation',
          same(recommendation),
        ),
      ]),
    );

    bloc.add(RecommendationGenerateRequested(request));

    await expectation;

    verify(
          () => generateRecommendation(request: request),
    ).called(1);
  });

  test('Should emit loading and failure on error', () async {
    when(
          () => generateRecommendation(request: request),
    ).thenThrow(Exception('Gemini error'));

    final bloc = RecommendationBloc(generateRecommendation);
    addTearDown(bloc.close);

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<RecommendationLoading>(),
        isA<RecommendationFailure>(),
      ]),
    );

    bloc.add(RecommendationGenerateRequested(request));

    await expectation;

    verify(
          () => generateRecommendation(request: request),
    ).called(1);
  });
}
