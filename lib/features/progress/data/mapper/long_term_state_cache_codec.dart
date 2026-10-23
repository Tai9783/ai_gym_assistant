
import 'dart:convert';


class LongTermAggregateState {
  final int totalHitSets;
  final int totalEvaluatedSets;

  final int weightSampleCount;
  final List<double> firstWeightSamples;
  final List<double> lastWeightSamples;

  final int volumeSampleCount;
  final List<double> firstVolumeSamples;
  final List<double> lastVolumeSamples;

  const LongTermAggregateState({
    required this.totalHitSets,
    required this.totalEvaluatedSets,
    required this.weightSampleCount,
    required this.firstWeightSamples,
    required this.lastWeightSamples,
    required this.volumeSampleCount,
    required this.firstVolumeSamples,
    required this.lastVolumeSamples,
  });

  const LongTermAggregateState.empty()
      : totalHitSets = 0,
        totalEvaluatedSets = 0,
        weightSampleCount = 0,
        firstWeightSamples = const [],
        lastWeightSamples = const [],
        volumeSampleCount = 0,
        firstVolumeSamples = const [],
        lastVolumeSamples = const [];
}

class LongTermStateCacheCodec {
  const LongTermStateCacheCodec._();

  static String encode(LongTermAggregateState state) {
    return jsonEncode({
      'totalHitSets': state.totalHitSets,
      'totalEvaluatedSets': state.totalEvaluatedSets,
      'weightSampleCount': state.weightSampleCount,
      'firstWeightSamples': state.firstWeightSamples,
      'lastWeightSamples': state.lastWeightSamples,
      'volumeSampleCount': state.volumeSampleCount,
      'firstVolumeSamples': state.firstVolumeSamples,
      'lastVolumeSamples': state.lastVolumeSamples,
    });
  }

  static LongTermAggregateState decode(String jsonString) {
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    return LongTermAggregateState(
      totalHitSets: (data['totalHitSets'] as num).toInt(),
      totalEvaluatedSets:
      (data['totalEvaluatedSets'] as num).toInt(),
      weightSampleCount:
      (data['weightSampleCount'] as num).toInt(),
      firstWeightSamples:
      _decodeSamples(data['firstWeightSamples']),
      lastWeightSamples:
      _decodeSamples(data['lastWeightSamples']),
      volumeSampleCount:
      (data['volumeSampleCount'] as num).toInt(),
      firstVolumeSamples:
      _decodeSamples(data['firstVolumeSamples']),
      lastVolumeSamples:
      _decodeSamples(data['lastVolumeSamples']),
    );
  }

  static List<double> _decodeSamples(dynamic value) {
    final samples = value as List<dynamic>;

    return samples
        .map((item) => (item as num).toDouble())
        .toList();
  }
}
