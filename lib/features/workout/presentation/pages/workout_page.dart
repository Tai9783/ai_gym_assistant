import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/workout_exercise.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import '../bloc/workout_state.dart';
import '../widgets/workout_set_card.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkoutBloc>(),
      child: const _WorkoutView(),
    );
  }
}

class _WorkoutView extends StatelessWidget {
  const _WorkoutView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Gym Assistant'),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutInitial) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<WorkoutBloc>().add(
                    WorkoutStarted(
                      exercises: _buildHardcodedWorkout(),
                    ),
                  );
                },
                child: const Text('Start Workout'),
              ),
            );
          }

          if (state is WorkoutLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is WorkoutInProgress) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Workout in progress',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Session: ${state.session.id}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 24),

                for (final exercise in state.session.exercises) ...[
                  Text(
                    exercise.exerciseId,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  for (final set in exercise.sets) ...[
                    WorkoutSetCard(
                      key: ValueKey(set.id),
                      set: set,
                      onComplete: ({
                        required double actualWeight,
                        required int actualReps,
                      }) {
                        context.read<WorkoutBloc>().add(
                          ExerciseSetUpdated(
                            sessionId: state.session.id,
                            workoutExerciseId: exercise.id,
                            setId: set.id,
                            actualWeight: actualWeight,
                            actualReps: actualReps,
                            status: ExerciseSetStatus.completed,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),
                  ],

                  const SizedBox(height: 16),
                ],

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<WorkoutBloc>().add(
                        WorkoutFinished(
                          sessionId: state.session.id,
                        ),
                      );
                    },
                    child: const Text('Finish Workout'),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            );
          }

          if (state is WorkoutCompleted) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Workout completed!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Status: ${state.session.status.name}',
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Started at: ${state.session.startedAt}',
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Ended at: ${state.session.endedAt}',
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is WorkoutFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: ${state.message}',
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<WorkoutExercise> _buildHardcodedWorkout() {
    const uuid = Uuid();

    return [
      WorkoutExercise(
        id: uuid.v4(),
        exerciseId: 'bench_press',
        order: 1,
        sets: [
          ExerciseSet(
            id: uuid.v4(),
            setNumber: 1,
            suggestedWeight: 40,
            suggestedReps: 8,
            actualWeight: null,
            actualReps: null,
            status: ExerciseSetStatus.pending,
            note: null,
          ),
          ExerciseSet(
            id: uuid.v4(),
            setNumber: 2,
            suggestedWeight: 40,
            suggestedReps: 8,
            actualWeight: null,
            actualReps: null,
            status: ExerciseSetStatus.pending,
            note: null,
          ),
        ],
      ),
    ];
  }
}