import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_labels.dart';
import '../../features/favorites/favorites_controller.dart';
import '../../features/plan/workout_controller.dart';
import '../../ui/widgets/difficulty_tag.dart';
import '../../ui/widgets/section_heading.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  const ExerciseDetailsScreen({super.key, required this.exercise});

  final Exercise exercise;

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  final FavoritesController _favorites = getIt<FavoritesController>();
  final WorkoutController _workout = getIt<WorkoutController>();

  Exercise get exercise => widget.exercise;

  void _toggleFavorite() {
    final added = _favorites.toggle(exercise);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            added
                ? '«${exercise.name}» в избранном'
                : '«${exercise.name}» убрано из избранного',
          ),
        ),
      );
  }

  void _togglePlan() {
    final added = _workout.toggle(exercise);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            added
                ? 'Добавлено в тренировку'
                : 'Убрано из тренировки',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: Listenable.merge([_favorites, _workout]),
      builder: (context, _) {
        final isFavorite = _favorites.isFavorite(exercise.id);
        final inPlan = _workout.contains(exercise.id);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'Назад',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, size: 21),
            ),
            actions: [
              IconButton(
                tooltip: isFavorite
                    ? 'Убрать из избранного'
                    : 'Сохранить в избранное',
                onPressed: _toggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  size: 21,
                  color: isFavorite ? scheme.secondary : scheme.onSurface,
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
            children: [
              Text(
                '${ExerciseLabels.muscle(exercise.muscle)}, ${ExerciseLabels.type(exercise.type)}',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                exercise.name,
                style: AppText.display(38, scheme.onSurface),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: scheme.outlineVariant),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: DifficultyTag(difficulty: exercise.difficulty),
                  ),
                  MetaChip('API Ninjas', icon: Icons.public),
                  if (exercise.equipments.isNotEmpty)
                    MetaChip(
                      ExerciseLabels.equipment(exercise.equipments.first),
                      icon: Icons.fitness_center,
                    ),
                ],
              ),
              const SizedBox(height: 26),
              if (exercise.steps.isNotEmpty) ...[
                const SectionHeading('Техника'),
                for (var index = 0; index < exercise.steps.length; index++)
                  _StepRow(
                    number: '${index + 1}'.padLeft(2, '0'),
                    text: exercise.steps[index],
                    isLast: index == exercise.steps.length - 1,
                  ),
              ],
              if (exercise.safetyInfo != null) ...[
                const SizedBox(height: 10),
                _SafetyNote(text: exercise.safetyInfo!),
              ],
              if (exercise.equipments.isNotEmpty) ...[
                const SizedBox(height: 28),
                const SectionHeading('Инвентарь'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: exercise.equipments
                      .map(
                        (item) => MetaChip(
                          ExerciseLabels.equipment(item),
                          icon: Icons.fitness_center,
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 30),
              Divider(color: scheme.outlineVariant),
              const SizedBox(height: 10),
              Text(
                'Данные предоставлены API Ninjas. Инструкции носят справочный характер: подбирайте нагрузку под свой уровень подготовки.',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.5,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          bottomNavigationBar: _ActionBar(
            isFavorite: isFavorite,
            inPlan: inPlan,
            onToggleFavorite: _toggleFavorite,
            onTogglePlan: _togglePlan,
          ),
        );
      },
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.text,
    required this.isLast,
  });

  final String number;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 34,
              child: Text(
                number,
                style: AppText.display(20, scheme.secondary),
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: scheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyNote extends StatelessWidget {
  const _SafetyNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = Theme.of(context).brightness == Brightness.dark
        ? AppColors.sageBright
        : AppColors.sage;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        border: Border(left: BorderSide(color: accent, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, size: 16, color: accent),
              const SizedBox(width: 8),
              Text(
                'Безопасность',
                style: AppText.microLabel.copyWith(
                  color: accent,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.isFavorite,
    required this.inPlan,
    required this.onToggleFavorite,
    required this.onTogglePlan,
  });

  final bool isFavorite;
  final bool inPlan;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTogglePlan;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onToggleFavorite,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: Text(
                  isFavorite ? 'В избранном' : 'В избранное',
                  maxLines: 1,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: onTogglePlan,
                icon: Icon(
                  inPlan ? Icons.check : Icons.add,
                  size: 17,
                ),
                label: Text(inPlan ? 'В тренировке' : 'В тренировку'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
