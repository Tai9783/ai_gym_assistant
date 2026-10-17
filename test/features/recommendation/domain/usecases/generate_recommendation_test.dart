
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ai_gym_assistant/features/recommendation/domain/entities/ai_context.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/entities/workout_recommendation.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/entities/workout_request.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/repositories/recommendation_repository.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/usecases/generate_recommendation.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/usecases/prepare_ai_context.dart';

class MockPrepareAiContext extends Mock
    implements PrepareAiContext {}

class MockRecommendationRepository extends Mock
    implements RecommendationRepository {}

void main() {
  late MockPrepareAiContext prepareAiContext;
  late MockRecommendationRepository repository;
  late GenerateRecommendation useCase;

  setUp(() {
    prepareAiContext = MockPrepareAiContext();
    repository = MockRecommendationRepository();

    useCase = GenerateRecommendation(
      prepareAiContext,
      repository,
    );
  });

  test('Should generate recommendation from prepared context',
          () async {
        final request = WorkoutRequest(
          focus: WorkoutFocus.chest,
          exerciseIds: ['bench_press'],
          note: null,
        );

        final context = AiContext(
          request: request,
          exercises: [],
        );

        const recommendation = WorkoutRecommendation(
          exercises: [],
        );

        when(
              () => prepareAiContext(request: request),
        ).thenAnswer((_) async => context);

        when(
              () => repository.generate(context),
        ).thenAnswer((_) async => recommendation);

        final result = await useCase(request: request);

        expect(result, same(recommendation));

        verify(
              () => prepareAiContext(request: request),
        ).called(1);

        verify(
              () => repository.generate(context),
        ).called(1);
      });

  test('Should propagate repository failure', () async {
    final request = WorkoutRequest(
      focus: WorkoutFocus.chest,
      exerciseIds: ['bench_press'],
      note: null,
    );

    final context = AiContext(
      request: request,
      exercises: [],
    );

    when(
          () => prepareAiContext(request: request),
    ).thenAnswer((_) async => context);

    when(
          () => repository.generate(context),
    ).thenThrow(StateError('Gemini unavailable'));

    await expectLater(
      useCase(request: request),
      throwsA(isA<StateError>()),
    );
  });
}
