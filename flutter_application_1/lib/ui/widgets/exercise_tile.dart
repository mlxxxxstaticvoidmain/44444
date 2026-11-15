import 'package:flutter/material.dart';

import '../../data/models/exercise.dart';
import '../../data/models/exercise_labels.dart';
import 'difficulty_tag.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({
    super.key,
    required this.exercise,
    required this.onTap,
    required this.isFavorite,
    required this.onToggleFavorite,
    this.showDivider = true,
  });

  final Exercise exercise;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final equipment = ExerciseLabels.equipmentLine(exercise);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          ExerciseLabels.metaLine(exercise),
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontSize: 12.5,
                          ),
                        ),
                        if (equipment.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            equipment,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant
                                  .withValues(alpha: 0.8),
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: DifficultyTag(difficulty: exercise.difficulty),
                      ),
                      IconButton(
                        onPressed: onToggleFavorite,
                        tooltip: isFavorite
                            ? 'Убрать из избранного'
                            : 'Сохранить в избранное',
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 38,
                          minHeight: 38,
                        ),
                        icon: Icon(
                          isFavorite
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          size: 20,
                          color: isFavorite
                              ? scheme.secondary
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: scheme.outlineVariant),
      ],
    );
  }
}
