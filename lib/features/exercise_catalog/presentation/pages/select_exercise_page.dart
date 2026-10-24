import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../recommendation/domain/entities/workout_request.dart';
import '../../domain/entities/exercise_definition.dart';
import '../bloc/exercise_catalog_bloc.dart';
import '../bloc/exercise_catalog_event.dart';
import '../bloc/exercise_catalog_state.dart';

class SelectExercisePage extends StatelessWidget {
  final List<String> initialSelectedExerciseIds;
  final String? muscleGroup;

  const SelectExercisePage({
    super.key,
    this.initialSelectedExerciseIds = const [],
    this.muscleGroup,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ExerciseCatalogBloc>()..add(const ExerciseCatalogRequested()),
      child: _SelectExerciseView(
        initialSelectedExerciseIds: initialSelectedExerciseIds,
        muscleGroup: muscleGroup,
      ),
    );
  }
}

class _SelectExerciseView extends StatefulWidget {
  final List<String> initialSelectedExerciseIds;
  final String? muscleGroup;


  const _SelectExerciseView({required this.initialSelectedExerciseIds,  required this.muscleGroup,});

  @override
  State<_SelectExerciseView> createState() => _SelectExerciseViewState();
}

class _SelectExerciseViewState extends State<_SelectExerciseView> {
  late final Set<String> _selectedExerciseIds;

  @override
  void initState() {
    super.initState();

    _selectedExerciseIds = {...widget.initialSelectedExerciseIds};
  }

  void _toggleExercise(String exerciseId) {
    setState(() {
      if (_selectedExerciseIds.contains(exerciseId)) {
        _selectedExerciseIds.remove(exerciseId);
      } else {
        _selectedExerciseIds.add(exerciseId);
      }
    });
  }

  void _confirmSelection(List<ExerciseDefinition> exercises) {
    final selectedExercises = exercises
        .where((exercise) => _selectedExerciseIds.contains(exercise.id))
        .toList();

    context.pop(selectedExercises);
  }

  String _muscleGroupLabel(MuscleGroup muscleGroup) {
    switch (muscleGroup) {
      case MuscleGroup.chest:
        return 'Ngực';

      case MuscleGroup.back:
        return 'Lưng';

      case MuscleGroup.legs:
        return 'Chân';

      case MuscleGroup.shoulders:
        return 'Vai';

      case MuscleGroup.arms:
        return 'Tay';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Chọn bài tập',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<ExerciseCatalogBloc, ExerciseCatalogState>(
        builder: (context, state) {
          if (state is ExerciseCatalogInitial ||
              state is ExerciseCatalogLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExerciseCatalogFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Không thể tải danh sách bài tập.\n${state.message}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is ExerciseCatalogLoaded) {
            final focus = WorkoutFocus.values.firstWhere(
                  (value) => value.name == widget.muscleGroup,
              orElse: () => WorkoutFocus.fullBody,
            );

            final filteredExercises = state.exercises.where((exercise) {
              if (focus == WorkoutFocus.fullBody) {
                return true;
              }

              return exercise.muscleGroup.name == focus.name;
            }).toList();

            return _buildExerciseList(filteredExercises);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildExerciseList(List<ExerciseDefinition> exercises) {
    final hasSelection = _selectedExerciseIds.isNotEmpty;

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: exercises.length,
            separatorBuilder: (_, _) {
              return const SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              final exercise = exercises[index];

              final isSelected = _selectedExerciseIds.contains(exercise.id);

              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  _toggleExercise(exercise.id);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF5B6CFF)
                          : const Color(0xFFE5E7EB),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _muscleGroupLabel(exercise.muscleGroup),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: isSelected,
                        onChanged: (_) {
                          _toggleExercise(exercise.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: hasSelection
                    ? () => _confirmSelection(exercises)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B6CFF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  hasSelection
                      ? 'Xác nhận (${_selectedExerciseIds.length})'
                      : 'Chọn bài tập',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
