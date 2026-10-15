import 'package:flutter/material.dart';

import '../../domain/entities/exercise_set.dart';

class WorkoutSetCard extends StatefulWidget {
  final ExerciseSet set;
  final void Function({
  required double actualWeight,
  required int actualReps,
  }) onComplete;

  const WorkoutSetCard({
    super.key,
    required this.set,
    required this.onComplete,
  });

  @override
  State<WorkoutSetCard> createState() => _WorkoutSetCardState();
}

class _WorkoutSetCardState extends State<WorkoutSetCard> {
  late final TextEditingController _weightController;
  late final TextEditingController _repsController;

  @override
  void initState() {
    super.initState();

    _weightController = TextEditingController(
      text: widget.set.actualWeight?.toString() ??
          widget.set.suggestedWeight?.toString() ??
          '',
    );

    _repsController = TextEditingController(
      text: widget.set.actualReps?.toString() ??
          widget.set.suggestedReps?.toString() ??
          '',
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _completeSet() {
    final weight = double.tryParse(_weightController.text);
    final reps = int.tryParse(_repsController.text);

    if (weight == null || reps == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid weight and reps'),
        ),
      );
      return;
    }

    widget.onComplete(
      actualWeight: weight,
      actualReps: reps,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted =
        widget.set.status == ExerciseSetStatus.completed;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set ${widget.set.setNumber}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Suggested: '
                  '${widget.set.suggestedWeight ?? '-'} kg × '
                  '${widget.set.suggestedReps ?? '-'} reps',
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _weightController,
              enabled: !isCompleted,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Weight',
                suffixText: 'kg',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _repsController,
              enabled: !isCompleted,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Reps',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCompleted ? null : _completeSet,
                child: Text(
                  isCompleted ? 'Completed' : 'Complete Set',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}