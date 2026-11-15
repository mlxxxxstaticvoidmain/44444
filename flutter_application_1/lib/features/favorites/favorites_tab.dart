import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/exercise.dart';
import '../../features/details/exercise_details_screen.dart';
import '../../features/favorites/favorites_controller.dart';
import '../../ui/widgets/empty_state.dart';
import '../../ui/widgets/exercise_tile.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key, required this.onOpenSearch});

  final VoidCallback onOpenSearch;

  Future<void> _openExercise(BuildContext context, Exercise exercise) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExerciseDetailsScreen(exercise: exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt<FavoritesController>();
    final scheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            Text(
              'Избранное',
              style: AppText.display(38, scheme.onSurface),
            ),
            const SizedBox(height: 6),
            Text(
              controller.count == 0
                  ? 'Сохранённые упражнения доступны без интернета.'
                  : exercisesCount(controller.count),
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 22),
            if (controller.count == 0)
              EmptyState(
                marker: '—',
                title: 'Пока ничего не сохранено',
                message:
                    'Нажмите на закладку в карточке упражнения — оно останется здесь, даже если пропадёт связь.',
                actionLabel: 'Найти упражнение',
                onAction: onOpenSearch,
              )
            else
              for (final exercise in controller.items)
                ExerciseTile(
                  exercise: exercise,
                  isFavorite: true,
                  onTap: () => _openExercise(context, exercise),
                  onToggleFavorite: () {
                    controller.remove(exercise.id);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            '«${exercise.name}» убрано из избранного',
                          ),
                        ),
                      );
                  },
                ),
          ],
        );
      },
    );
  }
}
