import 'package:flutter/material.dart';

class ExerciseThumbnail extends StatelessWidget {
  final String exerciseId;
  final double size;

  const ExerciseThumbnail({
    super.key,
    required this.exerciseId,
    this.size = 76,
  });

  @override
  Widget build(BuildContext context) {
    final path = 'assets/images/exercises/$exerciseId.png';

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.fitness_center, color: Color(0xFF667085)),
          );
        },
      ),
    );
  }
}
