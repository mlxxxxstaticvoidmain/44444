import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_labels.dart';
import '../../data/models/workout_entry.dart';
import '../../features/details/exercise_details_screen.dart';
import '../../features/plan/workout_controller.dart';
import '../../ui/widgets/empty_state.dart';

class WorkoutTab extends StatelessWidget {
  const WorkoutTab({super.key, required this.onOpenSearch});

  final VoidCallback onOpenSearch;

  Future<void> _openExercise(BuildContext context, Exercise exercise) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExerciseDetailsScreen(exercise: exercise),
      ),
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    WorkoutController controller,
  ) async {
    final scheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          title: const Text('Очистить тренировку?'),
          content: const Text(
            'Все упражнения и отметки о выполнении будут удалены.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: scheme.secondary),
              child: const Text('Очистить'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt<WorkoutController>();
    final scheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            Text(
              'Тренировка',
              style: AppText.display(38, scheme.onSurface),
            ),
            const SizedBox(height: 6),
            Text(
              controller.isEmpty
                  ? 'Соберите план из упражнений, найденных в базе.'
                  : '${exercisesCount(controller.count)}, выполнено ${controller.doneCount}',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: scheme.onSurfaceVariant,
              ),
            ),
            if (!controller.isEmpty) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: controller.progress,
                  minHeight: 3,
                  backgroundColor: scheme.outlineVariant,
                  color: scheme.secondary,
                ),
              ),
            ],
            const SizedBox(height: 22),
            if (controller.isEmpty)
              EmptyState(
                marker: '—',
                title: 'План пока пуст',
                message:
                    'Откройте упражнение и нажмите «В тренировку». Порядок и отметки сохранятся на устройстве.',
                actionLabel: 'Перейти к поиску',
                onAction: onOpenSearch,
              )
            else ...[
              for (var index = 0; index < controller.entries.length; index++)
                _WorkoutRow(
                  entry: controller.entries[index],
                  onToggleDone: () =>
                      controller.toggleDone(controller.entries[index].exercise.id),
                  onRemove: () =>
                      controller.remove(controller.entries[index].exercise.id),
                  onOpen: () => _openExercise(
                    context,
                    controller.entries[index].exercise,
                  ),
                  showDivider: index != controller.entries.length - 1,
                ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => _confirmClear(context, controller),
                  icon: const Icon(Icons.delete_outline, size: 17),
                  label: const Text('Очистить тренировку'),
                  style: TextButton.styleFrom(
                    foregroundColor: scheme.secondary,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _WorkoutRow extends StatelessWidget {
  const _WorkoutRow({
    required this.entry,
    required this.onToggleDone,
    required this.onRemove,
    required this.onOpen,
    required this.showDivider,
  });

  final WorkoutEntry entry;
  final VoidCallback onToggleDone;
  final VoidCallback onRemove;
  final VoidCallback onOpen;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final done = entry.isDone;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onToggleDone,
                tooltip: done
                    ? 'Снять отметку о выполнении'
                    : 'Отметить выполненным',
                icon: Icon(
                  done
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 22,
                  color: done ? scheme.secondary : scheme.outline,
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: InkWell(
                  onTap: onOpen,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.exercise.name,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                            color: done
                                ? scheme.onSurfaceVariant
                                : scheme.onSurface,
                            decoration:
                                done ? TextDecoration.lineThrough : null,
                            decorationColor: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ExerciseLabels.metaLine(entry.exercise),
                          style: TextStyle(
                            fontSize: 11,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: onRemove,
                tooltip: 'Убрать из тренировки',
                icon: Icon(
                  Icons.close,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: scheme.outlineVariant),
      ],
    );
  }
}
