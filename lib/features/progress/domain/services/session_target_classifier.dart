import '../entities/exercise_session_summary.dart';

enum SessionTargetResult {
  hit,
  miss,
  unknown,
}

class SessionTargetClassifier {
  SessionTargetResult classify(
      ExerciseSessionSummary summary,
      ) {
    final plannedSetCount = summary.plannedSetCount;

    final completedSetCount = summary.completedSetCount;

    final evaluatedSetCount =
        summary.targetHitSetCount +
            summary.underTargetSetCount;

    if (plannedSetCount == 0 || evaluatedSetCount == 0) {
      return SessionTargetResult.unknown;
    }

    if (summary.underTargetSetCount > 0) {
      return SessionTargetResult.miss;
    }

    if (completedSetCount < plannedSetCount) {
      return SessionTargetResult.miss;
    }

    if (evaluatedSetCount != plannedSetCount) {
      return SessionTargetResult.unknown;
    }

    return SessionTargetResult.hit;
  }
}