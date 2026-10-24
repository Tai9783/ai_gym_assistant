import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/exercise_catalog/domain/entities/exercise_definition.dart';
import '../../features/recommendation/domain/entities/workout_request.dart';
import '../extensions/workout_focus_label.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _noteController = TextEditingController();

  final List<WorkoutFocus> _muscleGroups =
      WorkoutFocus.values;

  WorkoutFocus? _selectedMuscleGroup;

  List<ExerciseDefinition> _selectedExercises = [];
  bool get _canCreateManualWorkout =>
      _selectedMuscleGroup != null &&
          _selectedExercises.isNotEmpty;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF7F8FA);
    const cardColor = Colors.white;
    const primaryColor = Color(0xFF5B6CFF);
    const textColor = Color(0xFF1F2430);
    const subTextColor = Color(0xFF6B7280);
    const borderColor = Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cardColor,
        foregroundColor: textColor,
        title: const Text(
          'AI Gym Assistant',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hôm nay bạn muốn tập gì?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Chọn nhóm cơ hoặc chọn bài tập cụ thể để AI đề xuất buổi tập phù hợp.',
              style: TextStyle(fontSize: 15, height: 1.5, color: subTextColor),
            ),

            const SizedBox(height: 24),

            // Nhóm cơ
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nhóm cơ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _muscleGroups.map((group) {
                      final isSelected = _selectedMuscleGroup == group;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedMuscleGroup == group) {
                              _selectedMuscleGroup = null;
                            } else {
                              _selectedMuscleGroup = group;
                            }

                            _selectedExercises.clear();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryColor.withValues(alpha: 0.10)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? primaryColor : borderColor,
                            ),
                          ),
                          child: Text(
                            group.label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? primaryColor : textColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bài tập cụ thể
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.fitness_center_outlined,
                        size: 20,
                        color: primaryColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Bài tập cụ thể',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Bạn có thể tự chọn bài tập muốn đưa vào buổi tập.',
                    style: TextStyle(fontSize: 14, color: subTextColor),
                  ),

                  const SizedBox(height: 14),

                  if (_selectedExercises.isNotEmpty) ...[
                    ..._selectedExercises.map(
                      (exercise) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          leading: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFFEEF2FF),
                            child: Icon(
                              Icons.fitness_center,
                              color: primaryColor,
                              size: 18,
                            ),
                          ),
                          title: Text(
                            exercise.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final result = await context.push<List<ExerciseDefinition>>(
                            '/select-exercises?group=${(_selectedMuscleGroup ?? WorkoutFocus.fullBody).name}',
                          extra: _selectedExercises
                              .map((exercise) => exercise.id)
                              .toList(),
                        );

                        if (result != null) {
                          setState(() {
                            _selectedExercises = result;
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: Text(
                        _selectedExercises.isEmpty
                            ? 'Chọn bài tập'
                            : 'Chỉnh sửa bài tập',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Ghi chú
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.edit_note_outlined,
                        size: 22,
                        color: primaryColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Ghi chú cho buổi tập',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Ví dụ: Hôm nay vai hơi mỏi, muốn tập nhẹ hơn, ưu tiên bài dễ kiểm soát...',
                    style: TextStyle(
                      fontSize: 14,
                      color: subTextColor,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: _noteController,
                    minLines: 4,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Nhập ghi chú của bạn...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Workout actions
            Row(
              children: [
                // AI Workout
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _onGeneratePressed,
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      label: const Text(
                        'AI đề xuất',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Manual Workout
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _canCreateManualWorkout
                          ? _onManualWorkoutPressed
                          : null,
                      icon: const Icon(Icons.edit_note, size: 20),
                      label: const Text(
                        'Tự tạo buổi tập',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF009E87),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFE6F2EF),
                        disabledForegroundColor: const Color(0xFF8CAAA2),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: child,
    );
  }

  WorkoutRequest _buildWorkoutRequest() {
    final focus =
        _selectedMuscleGroup ?? WorkoutFocus.fullBody;

    final exerciseIds = _selectedExercises
        .map((exercise) => exercise.id)
        .toSet()
        .toList();

    final note = _noteController.text.trim();

    return WorkoutRequest(
      focus: focus,
      exerciseIds: exerciseIds,
      note: note.isEmpty ? null : note,
    );
  }
  void _onGeneratePressed() {
    if (_selectedMuscleGroup == null &&
        _selectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng chọn nhóm cơ hoặc bài tập cụ thể',
          ),
        ),
      );
      return;
    }

    final request = _buildWorkoutRequest();

    context.push(
      '/recommendation',
      extra: request,
    );
  }
  void _onManualWorkoutPressed() {
    if (!_canCreateManualWorkout) return;

    final request = _buildWorkoutRequest();

    context.push(
      '/manual-workout',
      extra: request,
    );
  }
}
