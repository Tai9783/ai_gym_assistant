import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/exercise_session_summary.dart';

class RecentWeightChart extends StatelessWidget {
  final List<ExerciseSessionSummary> recentWindow;

  const RecentWeightChart({super.key, required this.recentWindow});

  @override
  Widget build(BuildContext context) {
    // Chỉ lấy buổi có mức tạ thực tế hợp lệ.
    final validSessions = recentWindow.where((summary) {
      final weight = summary.actualMaxWeight;

      return summary.completedSetCount > 0 && weight != null && weight.isFinite;
    }).toList()..sort((a, b) => a.performedAt.compareTo(b.performedAt));

    // Giữ tối đa 5 buổi gần nhất.
    final sessions = validSessions.length <= 5
        ? validSessions
        : validSessions.sublist(validSessions.length - 5);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Biểu đồ mức tạ thực tế',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tối đa 5 buổi tập gần nhất',
            style: TextStyle(fontSize: 12, color: AppColors.muted),
          ),
          const SizedBox(height: 20),

          if (sessions.isEmpty)
            const Text(
              'Chưa có dữ liệu mức tạ để hiển thị.',
              style: TextStyle(color: AppColors.muted),
            )
          else ...[
            SizedBox(
              height: 160,
              width: double.infinity,
              child: CustomPaint(
                painter: _WeightChartPainter(
                  sessions.map((summary) => summary.actualMaxWeight!).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.only(left: 50, right: 12),
              child: Row(
                children: sessions.map((summary) {
                  final weight = summary.actualMaxWeight!;
                  final date = summary.performedAt;

                  return Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${weight.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}/${date.month}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  final List<double> weights;

  _WeightChartPainter(this.weights);

  @override
  void paint(Canvas canvas, Size size) {
    if (weights.isEmpty) return;

    final minWeight = weights.reduce(math.min);
    final maxWeight = weights.reduce(math.max);

    // Tạo khoảng trống phía trên và dưới dữ liệu.
    final difference = maxWeight - minWeight;
    final padding = math.max(1.0, difference * 0.35);

    final rawMin = math.max(0.0, minWeight - padding);
    final rawMax = maxWeight + padding;

    final step = _niceStep((rawMax - rawMin) / 3);

    final axisMin = (rawMin / step).floor() * step;
    final axisMax = (rawMax / step).ceil() * step;

    final tickCount = ((axisMax - axisMin) / step).round();

    // Chừa không gian cho nhãn trục Y.
    const left = 50.0;
    const top = 12.0;
    const rightPadding = 12.0;
    const bottomPadding = 12.0;

    final right = size.width - rightPadding;
    final bottom = size.height - bottomPadding;

    final chartWidth = right - left;
    final chartHeight = bottom - top;

    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    // Vẽ trục Y và nhãn mức tạ.
    for (var i = 0; i <= tickCount; i++) {
      final value = axisMin + i * step;

      final y =
          bottom - ((value - axisMin) / (axisMax - axisMin)) * chartHeight;

      canvas.drawLine(Offset(left, y), Offset(right, y), gridPaint);

      final label = _formatTick(value);

      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(fontSize: 11, color: AppColors.muted),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(left - textPainter.width - 10, y - textPainter.height / 2),
      );
    }

    // Chuyển mức tạ thành tọa độ trên biểu đồ.
    final points = List.generate(weights.length, (index) {
      final x = left + chartWidth * (index + 0.5) / weights.length;

      final y =
          bottom -
          ((weights[index] - axisMin) / (axisMax - axisMin)) * chartHeight;

      return Offset(x, y);
    });

    // Nối các điểm.
    if (points.length >= 2) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);

      for (final point in points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }

      canvas.drawPath(path, linePaint);
    }

    // Vẽ điểm biểu diễn từng buổi.
    for (final point in points) {
      canvas.drawCircle(point, 4.5, dotPaint);
    }
  }

  // Làm tròn bước chia thành các giá trị.
  double _niceStep(double rawStep) {
    final magnitude = math
        .pow(10, (math.log(rawStep) / math.ln10).floor())
        .toDouble();

    final normalized = rawStep / magnitude;

    final double nice;
    if (normalized <= 1) {
      nice = 1;
    } else if (normalized <= 2) {
      nice = 2;
    } else if (normalized <= 2.5) {
      nice = 2.5;
    } else if (normalized <= 5) {
      nice = 5;
    } else {
      nice = 10;
    }

    return nice * magnitude;
  }

  String _formatTick(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) {
    return !listEquals(oldDelegate.weights, weights);
  }
}
