
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../exercise_catalog/domain/entities/exercise_definition.dart';
import '../../../exercise_catalog/domain/usecases/get_exercises.dart';
import '../../../recommendation/domain/entities/workout_request.dart';
import '../mappers/manual_workout_mapper.dart';
import '../models/manual_set_draft.dart';
import '../models/manual_workout_target.dart';

class ManualWorkoutPage extends StatefulWidget {
  final WorkoutRequest request;
  final GetExercises getExercises;

  const ManualWorkoutPage({
    super.key,
    required this.request,
    required this.getExercises,
  });

  @override
  State<ManualWorkoutPage> createState() => _ManualWorkoutPageState();
}

class _ManualWorkoutPageState extends State<ManualWorkoutPage> {
  static const _primaryColor = Color(0xFF009E87);
  static const _backgroundColor = Color(0xFFF7F8FA);

  final _formKey = GlobalKey<FormState>();
  final Map<String, List<ManualSetDraft>> _targets = {};

  late final Future<List<ExerciseDefinition>> _exercisesFuture;
  int _nextSetId = 0;

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _loadSelectedExercises();
  }

  Future<List<ExerciseDefinition>> _loadSelectedExercises() async {
    final allExercises = await widget.getExercises();

    final catalogById = {
      for (final exercise in allExercises) exercise.id: exercise,
    };

    final selectedIds = widget.request.exerciseIds.toSet().toList();

    final selectedExercises = selectedIds
        .map((id) => catalogById[id])
        .whereType<ExerciseDefinition>()
        .toList();

    if (selectedExercises.length != selectedIds.length) {
      throw StateError('Không tìm thấy đầy đủ bài tập đã chọn');
    }

    for (final exercise in selectedExercises) {
      _targets[exercise.id] = List.generate(
        3,
            (_) => ManualSetDraft(id: _nextSetId++),
      );
    }

    return selectedExercises;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Mục tiêu buổi tập hôm nay'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: FutureBuilder<List<ExerciseDefinition>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Không thể tải danh sách bài tập đã chọn'),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final exercises = snapshot.data!;

          if (exercises.isEmpty) {
            return const Center(
              child: Text('Bạn chưa chọn bài tập nào'),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                const Text(
                  'Thiết lập mục tiêu cho buổi tập',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${exercises.length} bài tập đã chọn',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),

                for (final exercise in exercises) ...[
                  _buildExerciseCard(exercise),
                  const SizedBox(height: 12),
                ],

                const SizedBox(height: 12),

                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: () => _startWorkout(exercises),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Bắt đầu tập'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExerciseCard(ExerciseDefinition exercise) {
    final sets = _targets[exercise.id]!;

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            for (var i = 0; i < sets.length; i++) ...[
              _buildSetRow(sets, i),
              const SizedBox(height: 12),
            ],

            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  sets.add(ManualSetDraft(id: _nextSetId++));
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm set'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetRow(List<ManualSetDraft> sets, int index) {
    final draft = sets[index];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 46,
          child: Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text('Set ${index + 1}'),
          ),
        ),

        Expanded(
          child: TextFormField(
            key: ValueKey('weight-${draft.id}'),
            initialValue: draft.weight,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Kg',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) => draft.weight = value,
            validator: (value) {
              final weight = double.tryParse(
                (value ?? '').trim().replaceAll(',', '.'),
              );

              if (weight == null || !weight.isFinite || weight < 0) {
                return 'Kg không hợp lệ';
              }

              return null;
            },
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: TextFormField(
            key: ValueKey('reps-${draft.id}'),
            initialValue: draft.reps,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Reps',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) => draft.reps = value,
            validator: (value) {
              final reps = int.tryParse((value ?? '').trim());

              if (reps == null || reps <= 0) {
                return 'Reps không hợp lệ';
              }

              return null;
            },
          ),
        ),

        IconButton(
          tooltip: 'Xóa set',
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: sets.length > 1
              ? () {
            setState(() {
              sets.removeAt(index);
            });
          }
              : null,
        ),
      ],
    );
  }


  void _startWorkout(List<ExerciseDefinition> exercises) {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final targets = <ManualExerciseTarget>[];

    for (final exercise in exercises) {
      final draftSets = _targets[exercise.id];

      if (draftSets == null || draftSets.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bài ${exercise.name} chưa có set'),
          ),
        );
        return;
      }

      final sets = <ManualSetTarget>[];

      for (var i = 0; i < draftSets.length; i++) {
        final draft = draftSets[i];

        final weight = double.tryParse(
          draft.weight.trim().replaceAll(',', '.'),
        );

        final reps = int.tryParse(draft.reps.trim());

        if (weight == null ||
            !weight.isFinite ||
            weight < 0 ||
            reps == null ||
            reps <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Mục tiêu không hợp lệ: '
                    '${exercise.name}, set ${i + 1}',
              ),
            ),
          );
          return;
        }

        sets.add(
          ManualSetTarget(
            weight: weight,
            reps: reps,
          ),
        );
      }

      targets.add(
        ManualExerciseTarget(
          exerciseId: exercise.id,
          sets: sets,
        ),
      );
    }

    if (targets.isEmpty) return;

    final workoutExercises =
    ManualWorkoutMapper.toWorkoutExercises(targets);

    context.pushReplacement(
      '/workout',
      extra: workoutExercises,
    );
  }

}

