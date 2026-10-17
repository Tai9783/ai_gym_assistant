enum WorkoutFocus { chest, back, legs, shoulders, arms, fullBody }

class WorkoutRequest {
  final WorkoutFocus focus;

  final List<String> exerciseIds;

  final String? note;

  const WorkoutRequest({
    required this.focus,
    this.exerciseIds = const [],
    this.note,
  });
}
