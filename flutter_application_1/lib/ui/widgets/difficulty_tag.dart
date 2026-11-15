import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../data/models/exercise_labels.dart';

Color difficultyColor(BuildContext context, String difficulty) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  switch (difficulty) {
    case 'beginner':
      return isDark ? AppColors.sageBright : AppColors.sage;
    case 'intermediate':
      return isDark ? AppColors.ochreBright : AppColors.ochre;
    case 'expert':
      return isDark ? AppColors.signalBright : AppColors.signal;
    default:
      return Theme.of(context).colorScheme.onSurfaceVariant;
  }
}

class DifficultyTag extends StatelessWidget {
  const DifficultyTag({
    super.key,
    required this.difficulty,
    this.showDot = true,
  });

  final String difficulty;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final color = difficultyColor(context, difficulty);
    final label = ExerciseLabels.difficulty(difficulty);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDot) ...[
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: AppText.microLabel.copyWith(
            color: color,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
