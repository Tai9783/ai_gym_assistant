import 'package:ai_gym_assistant/app/widgets/app_notice.dart';
import 'package:ai_gym_assistant/app/theme/app_colors.dart';

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
  static const _primary = AppColors.primary;

  late final TextEditingController _weightController;
  late final TextEditingController _repsController;

  @override
  void initState() {
    super.initState();

    _weightController = TextEditingController(
      text: widget.set.actualWeight?.toString() ?? '',
    );

    _repsController = TextEditingController(
      text: widget.set.actualReps?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _completeSet() {
    final weight = double.tryParse(
      _weightController.text.trim(),
    );

    final reps = int.tryParse(
      _repsController.text.trim(),
    );

    if (weight == null ||
        !weight.isFinite ||
        weight < 0 ||
        reps == null ||
        reps <= 0) {
      AppNotice.warning(context, 'Vui lòng nhập tạ và số reps hợp lệ');
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Set ${widget.set.setNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (!isCompleted)
                Text(
                  'Mục tiêu: ${widget.set.suggestedWeight ?? '-'} kg'
                      ' × ${widget.set.suggestedReps ?? '-'} reps',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          if (isCompleted)
            Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.set.actualWeight ?? '-'} kg'
                      ' × ${widget.set.actualReps ?? '-'} reps',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Đã xong',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType:
                    const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Tạ (kg)',
                      hintText:
                      widget.set.suggestedWeight?.toString(),
                      isDense: true,
                      border: const OutlineInputBorder(),
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: TextField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Reps',
                      hintText:
                      widget.set.suggestedReps?.toString(),
                      isDense: true,
                      border: const OutlineInputBorder(),
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton.filledTonal(
                  onPressed: _completeSet,
                  icon: const Icon(Icons.check_rounded),
                  tooltip: 'Hoàn thành set',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.selected,
                    foregroundColor: _primary,
                    minimumSize: const Size(48, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
