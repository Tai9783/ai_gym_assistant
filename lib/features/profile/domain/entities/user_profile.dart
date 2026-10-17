
class UserProfile {
  final String goal;
  final double? weightKg;
  final double? heightCm;
  final int? age;

  const UserProfile({
    required this.goal,
    this.weightKg,
    this.heightCm,
    this.age,
  });
}
