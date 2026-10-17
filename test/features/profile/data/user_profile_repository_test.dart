
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_gym_assistant/core/database/app_database.dart'
    hide UserProfile;
import 'package:ai_gym_assistant/features/profile/data/datasources/user_profile_local_data_source.dart';
import 'package:ai_gym_assistant/features/profile/data/repositories/user_profile_repository_impl.dart';
import 'package:ai_gym_assistant/features/profile/domain/entities/user_profile.dart';
import 'package:ai_gym_assistant/features/profile/domain/usecases/get_user_profile.dart';
import 'package:ai_gym_assistant/features/profile/domain/usecases/save_user_profile.dart';

void main() {
  late AppDatabase database;
  late UserProfileRepositoryImpl repository;
  late GetUserProfile getUserProfile;
  late SaveUserProfile saveUserProfile;

  setUp(() {
    database = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );

    final localDataSource = UserProfileLocalDataSource(
      database,
    );

    repository = UserProfileRepositoryImpl(
      localDataSource,
    );

    getUserProfile = GetUserProfile(repository);
    saveUserProfile = SaveUserProfile(repository);
  });

  tearDown(() async {
    await database.close();
  });

  test('Should return null when profile does not exist', () async {
    final profile = await getUserProfile();

    expect(profile, isNull);
  });

  test('Should save and get user profile', () async {
    final profile = UserProfile(
      goal: 'muscleGain',
      weightKg: 65.5,
      heightCm: 170,
      age: 22,
    );

    await saveUserProfile(profile);

    final result = await getUserProfile();

    expect(result, isNotNull);
    expect(result!.goal, 'muscleGain');
    expect(result.weightKg, 65.5);
    expect(result.heightCm, 170);
    expect(result.age, 22);
  });

  test('Should update existing profile', () async {
    final firstProfile = UserProfile(
      goal: 'muscleGain',
      weightKg: 65,
      heightCm: 170,
      age: 22,
    );

    final updatedProfile = UserProfile(
      goal: 'strength',
      weightKg: 70,
      heightCm: 170,
      age: 22,
    );

    await saveUserProfile(firstProfile);
    await saveUserProfile(updatedProfile);

    final result = await getUserProfile();

    expect(result?.goal, 'strength');
    expect(result?.weightKg, 70);

    final rows = await database
        .select(database.userProfiles)
        .get();

    expect(rows.length, 1);
    expect(rows.first.id, 1);
  });

  test('Should allow optional fields to be null', () async {
    final profile = UserProfile(
      goal: 'fatLoss',
    );

    await saveUserProfile(profile);

    final result = await getUserProfile();

    expect(result?.goal, 'fatLoss');
    expect(result?.weightKg, isNull);
    expect(result?.heightCm, isNull);
    expect(result?.age, isNull);
  });

  test('Should clear optional fields on update', () async {
    final firstProfile = UserProfile(
      goal: 'muscleGain',
      weightKg: 65,
      heightCm: 170,
      age: 22,
    );

    final updatedProfile = UserProfile(
      goal: 'strength',
    );

    await saveUserProfile(firstProfile);
    await saveUserProfile(updatedProfile);

    final result = await getUserProfile();

    expect(result?.goal, 'strength');
    expect(result?.weightKg, isNull);
    expect(result?.heightCm, isNull);
    expect(result?.age, isNull);
  });
}
