sealed class ProgressEvent {
  const ProgressEvent();
}

final class ProgressLoadRequested extends ProgressEvent {
  const ProgressLoadRequested();
}

final class ProgressExerciseSelected extends ProgressEvent {
  final String exerciseId;

  const ProgressExerciseSelected(this.exerciseId);
}
