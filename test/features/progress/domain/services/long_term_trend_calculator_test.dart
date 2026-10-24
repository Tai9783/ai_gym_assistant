import 'package:ai_gym_assistant/features/progress/domain/entities/progress_trend.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/long_term_trend_calculator.dart';

void main() {
  late LongTermTrendCalculator calculator;

  setUp(() {
    calculator = LongTermTrendCalculator();
  });

  test('should calculate increasing trend with fewer than 10 values', () {
    final weights = <double>[40, 42.5, 45, 47.5, 50];

    final result = calculator.calculate(
      chronologicalValues: weights,
      thresholdRatio: 0.05,
    );

    expect(result, ProgressTrend.increasing);
  });
  test('should compare only the first 5 and last 5 values', () {
    final weights = <double>[40, 40, 40, 40, 40, 100, 10, 50, 50, 50, 50, 50];

    final result = calculator.calculate(
      chronologicalValues: weights,
      thresholdRatio: 0.05,
    );

    expect(result, ProgressTrend.increasing);
  });
  test('should return stable when change is within threshold', () {
    final weights = <double>[40, 40, 41, 41];

    final result = calculator.calculate(
      chronologicalValues: weights,
      thresholdRatio: 0.05,
    );

    expect(result, ProgressTrend.stable);
  });
  test('should return decreasing when change exceeds negative threshold', () {
    final weights = <double>[50, 50, 45, 45];

    final result = calculator.calculate(
      chronologicalValues: weights,
      thresholdRatio: 0.05,
    );
    expect(result, ProgressTrend.decreasing);
  });
  test('should return insufficientData when fewer than 2 values exist', () {
    final emptyWeights = <double>[];
    final singleWeight = <double>[40];

    final emptyResult = calculator.calculate(
      chronologicalValues: emptyWeights,
      thresholdRatio: 0.05,
    );

    final singleResult = calculator.calculate(
      chronologicalValues: singleWeight,
      thresholdRatio: 0.05,
    );

    expect(emptyResult, ProgressTrend.insufficientData);
    expect(singleResult, ProgressTrend.insufficientData);
  });
  test('should calculate trend with exactly 2 values', () {
    final result = calculator.calculate(
      chronologicalValues: <double>[40, 50],
      thresholdRatio: 0.05,
    );

    expect(result, ProgressTrend.increasing);
  });

  test('should use all values when there are 9 values', () {
    final weights = <double>[40, 40, 40, 40, 30, 50, 50, 50, 50];

    final result = calculator.calculate(
      chronologicalValues: weights,
      thresholdRatio: 0.05,
    );

    expect(result, ProgressTrend.increasing);
  });

  test('should split exactly 10 values into two groups of 5', () {
    final weights = <double>[60, 60, 60, 60, 60, 50, 50, 50, 50, 50];

    final result = calculator.calculate(
      chronologicalValues: weights,
      thresholdRatio: 0.05,
    );

    expect(result, ProgressTrend.decreasing);
  });

  test('should return stable when change equals the threshold', () {
    final increasingBoundary = calculator.calculate(
      chronologicalValues: <double>[40, 40, 42, 42],
      thresholdRatio: 0.05,
    );

    final decreasingBoundary = calculator.calculate(
      chronologicalValues: <double>[40, 40, 38, 38],
      thresholdRatio: 0.05,
    );

    expect(increasingBoundary, ProgressTrend.stable);

    expect(decreasingBoundary, ProgressTrend.stable);
  });

  test('should calculate volume trends using a 10 percent threshold', () {
    final stableResult = calculator.calculate(
      chronologicalValues: <double>[1000, 1000, 1080, 1080],
      thresholdRatio: 0.10,
    );

    final increasingResult = calculator.calculate(
      chronologicalValues: <double>[1000, 1000, 1200, 1200],
      thresholdRatio: 0.10,
    );

    final decreasingResult = calculator.calculate(
      chronologicalValues: <double>[1000, 1000, 850, 850],
      thresholdRatio: 0.10,
    );

    expect(stableResult, ProgressTrend.stable);
    expect(increasingResult, ProgressTrend.increasing);
    expect(decreasingResult, ProgressTrend.decreasing);
  });

  test('should return insufficientData when early average is zero', () {
    final result = calculator.calculate(
      chronologicalValues: <double>[0, 0, 40, 40],
      thresholdRatio: 0.05,
    );

    expect(result, ProgressTrend.insufficientData);
  });
}
