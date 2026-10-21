
enum RecommendationRateLimitReason {
  dailyLimit,
  cooldown,
  unknown,
}

class RecommendationRateLimitedException implements Exception {
  final RecommendationRateLimitReason reason;
  final DateTime? resetAt;
  final int? retryAfterSeconds;

  const RecommendationRateLimitedException({
    this.reason = RecommendationRateLimitReason.unknown,
    this.resetAt,
    this.retryAfterSeconds,
  });
}
