import 'package:ai_gym_assistant/app/widgets/app_notice.dart';
import 'package:ai_gym_assistant/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../extensions/workout_focus_image.dart';
import '../extensions/workout_focus_label.dart';
import '../../features/exercise_catalog/domain/entities/exercise_definition.dart';
import '../../features/exercise_catalog/presentation/widgets/exercise_thumbnail.dart';
import '../../features/recommendation/domain/entities/workout_request.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Bảng màu thống nhất với giao diện sáng của AI Gym Assistant.
  static const Color _background = AppColors.background;
  static const Color _surface = Colors.white;
  static const Color _primary = AppColors.primary;
  static const Color _primarySoft = AppColors.selected;
  static const Color _text = AppColors.text;
  static const Color _muted = AppColors.muted;
  static const Color _border = AppColors.border;
  static const Color _tile = AppColors.tile;

  final TextEditingController _noteController = TextEditingController();

  final List<WorkoutFocus> _muscleGroups = WorkoutFocus.values;
  WorkoutFocus? _selectedMuscleGroup;
  List<ExerciseDefinition> _selectedExercises = [];

  // Giữ nguyên điều kiện tạo Workout thủ công như phiên bản cũ.
  bool get _canCreateManualWorkout =>
      _selectedMuscleGroup != null && _selectedExercises.isNotEmpty;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _surface,
        foregroundColor: _text,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        title: const Text(
          'AI Gym Assistant',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            const SizedBox(height: 24),
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Nhóm cơ', Icons.grid_view_rounded),
                  const SizedBox(height: 15),
                  _buildMuscleGroupGrid(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Bài tập cụ thể', Icons.fitness_center_rounded),
                  const SizedBox(height: 7),
                  const Text(
                    'Chọn những bài bạn muốn đưa vào buổi tập.',
                    style: TextStyle(color: _muted, fontSize: 13, height: 1.45),
                  ),
                  if (_selectedExercises.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _buildSelectedExercises(),
                  ],
                  const SizedBox(height: 14),
                  _buildChooseExerciseButton(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Ghi chú cho buổi tập', Icons.edit_note_rounded),
                  const SizedBox(height: 7),
                  const Text(
                    'Ví dụ: Hôm nay vai hơi mỏi, muốn tập nhẹ hơn.',
                    style: TextStyle(color: _muted, fontSize: 13, height: 1.45),
                  ),
                  const SizedBox(height: 13),
                  TextField(
                    controller: _noteController,
                    minLines: 3,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(color: _text, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Nhập ghi chú của bạn...',
                      hintStyle: const TextStyle(color: Color(0xFF9CA5B4)),
                      filled: true,
                      fillColor: _tile,
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(color: _border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(color: _border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(color: _primary, width: 1.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TẠO BUỔI TẬP',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.15,
            color: _primary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Hôm nay bạn muốn tập gì?',
          style: TextStyle(
            fontSize: 26,
            height: 1.18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.75,
            color: _text,
          ),
        ),
        SizedBox(height: 9),
        Text(
          'Chọn nhóm cơ hoặc bài tập cụ thể để AI đề xuất buổi tập phù hợp.',
          style: TextStyle(fontSize: 14, color: _muted, height: 1.45),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _primary, size: 19),
        const SizedBox(width: 9),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.25,
            color: _text,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border, width: 1),
      ),
      child: child,
    );
  }

  Widget _buildMuscleGroupGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Giữ 3 cột trên điện thoại phổ biến; chuyển 2 cột trên màn rất hẹp.
        final columns = constraints.maxWidth >= 276 ? 3 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _muscleGroups.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 145,
          ),
          itemBuilder: (context, index) {
            final group = _muscleGroups[index];
            final isSelected = _selectedMuscleGroup == group;

            return Semantics(
              button: true,
              selected: isSelected,
              label: 'Nhóm cơ ${group.label}',
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    color: isSelected ? _primarySoft : _tile,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected ? _primary : _border,
                      width: isSelected ? 1.8 : 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      setState(() {
                        _selectedMuscleGroup = isSelected ? null : group;
                        _selectedExercises.clear();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 8, 5, 9),
                      child: Column(
                        children: [
                          Expanded(
                            child: SvgPicture.asset(
                              group.imagePath,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              colorFilter: ColorFilter.mode(
                                isSelected ? _primary : _text,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            group.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? _primary : _text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSelectedExercises() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_selectedExercises.length} bài đã chọn',
          style: const TextStyle(
            color: _primary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ..._selectedExercises.map(
              (exercise) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: _tile,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                ExerciseThumbnail(exerciseId: exercise.id, size: 52),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    exercise.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: _text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChooseExerciseButton() {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final focus = _selectedMuscleGroup ?? WorkoutFocus.fullBody;
          final result = await context.push<List<ExerciseDefinition>>(
            '/select-exercises?group=${focus.name}',
            extra: _selectedExercises.map((exercise) => exercise.id).toList(),
          );
          if (!mounted || result == null) return;
          setState(() => _selectedExercises = result);
        },
        icon: const Icon(Icons.add_rounded, size: 19),
        label: Text(
          _selectedExercises.isEmpty ? 'Chọn bài tập' : 'Chỉnh sửa bài tập',
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: _primary,
          side: const BorderSide(color: _border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _onGeneratePressed,
              icon: const Icon(Icons.auto_awesome_rounded, size: 18),
              label: const Text('AI đề xuất', maxLines: 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 54,
            child: OutlinedButton.icon(
              onPressed: _canCreateManualWorkout
                  ? _onManualWorkoutPressed
                  : null,
              icon: const Icon(Icons.edit_note_rounded, size: 19),
              label: const Text('Tự tạo buổi tập', maxLines: 1),
              style: OutlinedButton.styleFrom(
                foregroundColor: _text,
                disabledForegroundColor: AppColors.disabledText,
                side: const BorderSide(color: _border),
                backgroundColor: _surface,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  WorkoutRequest _buildWorkoutRequest() {
    final exerciseIds = _selectedExercises
        .map((exercise) => exercise.id)
        .toSet()
        .toList();
    final note = _noteController.text.trim();

    return WorkoutRequest(
      focus: _selectedMuscleGroup ?? WorkoutFocus.fullBody,
      exerciseIds: exerciseIds,
      note: note.isEmpty ? null : note,
    );
  }

  void _onGeneratePressed() {
    if (_selectedMuscleGroup == null && _selectedExercises.isEmpty) {
      AppNotice.warning(context, 'Vui lòng chọn nhóm cơ hoặc bài tập cụ thể');
      return;
    }

    context.push('/recommendation', extra: _buildWorkoutRequest());
  }

  void _onManualWorkoutPressed() {
    if (!_canCreateManualWorkout) return;
    context.push('/manual-workout', extra: _buildWorkoutRequest());
  }
}
