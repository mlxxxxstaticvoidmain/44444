import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_labels.dart';
import '../../features/details/exercise_details_screen.dart';
import '../../features/favorites/favorites_controller.dart';
import '../../features/search/exercise_search_controller.dart';
import '../../features/settings/settings_controller.dart';
import '../../features/settings/settings_screen.dart';
import '../../ui/widgets/empty_state.dart';
import '../../ui/widgets/error_view.dart';
import '../../ui/widgets/exercise_tile.dart';
import '../../ui/widgets/skeleton_list.dart';
import 'widgets/filter_controls.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final ExerciseSearchController _search = getIt<ExerciseSearchController>();
  final FavoritesController _favorites = getIt<FavoritesController>();
  final SettingsController _settings = getIt<SettingsController>();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = _search.name;
    _textController.addListener(_refreshClearButton);
  }

  void _refreshClearButton() => setState(() {});

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _resetAll() {
    _textController.clear();
    _search.reset();
  }

  Future<void> _openExercise(Exercise exercise) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExerciseDetailsScreen(exercise: exercise),
      ),
    );
  }

  void _toggleFavorite(Exercise exercise) {
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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: Listenable.merge([_search, _favorites, _settings]),
      builder: (context, _) {
        return RefreshIndicator(
          onRefresh: _search.refresh,
          color: scheme.secondary,
          backgroundColor: scheme.surface,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            children: [
              Text(
                'Что тренируем сегодня?',
                style: AppText.display(33, scheme.onSurface),
              ),
              const SizedBox(height: 7),
              Text(
                'Выберите группу мышц или введите название — упражнения придут из API Ninjas.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              if (!_settings.hasApiKey) ...[
                const SizedBox(height: 16),
                _KeyBanner(onTap: () => openSettings(context)),
              ],
              const SizedBox(height: 20),
              TextField(
                controller: _textController,
                textInputAction: TextInputAction.search,
                onChanged: _search.updateName,
                onSubmitted: _search.submitName,
                decoration: InputDecoration(
                  hintText: 'Например, bench press',
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: scheme.onSurfaceVariant,
                  ),
                  suffixIcon: _textController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Очистить',
                          onPressed: () {
                            _textController.clear();
                            _search.updateName('');
                          },
                          icon: const Icon(Icons.close, size: 18),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ExerciseLabels.muscleKeys.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 7),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return FilterPill(
                        label: 'Все мышцы',
                        selected: _search.muscle == null,
                        onTap: () => _search.selectMuscle(null),
                      );
                    }
                    final key = ExerciseLabels.muscleKeys[index - 1];
                    return FilterPill(
                      label: ExerciseLabels.muscle(key),
                      selected: _search.muscle == key,
                      onTap: () => _search.selectMuscle(
                        _search.muscle == key ? null : key,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _difficultyMenu(),
                  _typeMenu(),
                  if (_search.activeFilters > 0)
                    TextButton.icon(
                      onPressed: _resetAll,
                      icon: const Icon(Icons.restore, size: 16),
                      label: const Text('Сбросить'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 34),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              _SummaryRow(search: _search),
              const SizedBox(height: 6),
              ..._buildResults(),
            ],
          ),
        );
      },
    );
  }

  Widget _difficultyMenu() {
    final current = _search.difficulty;
    final label = current == null
        ? 'любая'
        : ExerciseLabels.difficulty(current);

    return PopupMenuButton<String>(
      tooltip: 'Сложность',
      onSelected: (value) =>
          _search.selectDifficulty(value == 'any' ? null : value),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'any', child: Text('Любая сложность')),
        ...ExerciseLabels.difficultyKeys.map(
          (key) => PopupMenuItem(
            value: key,
            child: Text(ExerciseLabels.difficulty(key)),
          ),
        ),
      ],
      child: FilterSelectButton(
        label: 'Сложность',
        value: label,
        active: current != null,
      ),
    );
  }

  Widget _typeMenu() {
    final current = _search.type;
    final label = current == null ? 'любой' : ExerciseLabels.type(current);

    return PopupMenuButton<String>(
      tooltip: 'Тип упражнения',
      onSelected: (value) => _search.selectType(value == 'any' ? null : value),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'any', child: Text('Любой тип')),
        ...ExerciseLabels.typeKeys.map(
          (key) => PopupMenuItem(
            value: key,
            child: Text(ExerciseLabels.type(key)),
          ),
        ),
      ],
      child: FilterSelectButton(
        label: 'Тип',
        value: label,
        active: current != null,
      ),
    );
  }

  List<Widget> _buildResults() {
    if (_search.isLoading && _search.results.isEmpty) {
      return [SkeletonList(items: 3)];
    }

    if (_search.errorMessage != null) {
      return [
        ErrorView(
          message: _search.errorMessage!,
          statusCode: _search.errorStatus,
          onRetry: _search.refresh,
          onOpenSettings: () => openSettings(context),
        ),
      ];
    }

    if (_search.results.isNotEmpty) {
      return [
        if (_search.isLoading)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        for (final exercise in _search.results)
          ExerciseTile(
            exercise: exercise,
            isFavorite: _favorites.isFavorite(exercise.id),
            onTap: () => _openExercise(exercise),
            onToggleFavorite: () => _toggleFavorite(exercise),
          ),
      ];
    }

    if (_search.hasLoaded) {
      return [
        EmptyState(
          title: 'Ничего не нашлось',
          message: _search.activeFilters > 0
              ? 'API Ninjas не вернул упражнений по этим условиям. Уберите часть фильтров или измените название.'
              : 'Попробуйте выбрать другую группу мышц.',
          actionLabel: _search.activeFilters > 0 ? 'Сбросить фильтры' : null,
          onAction: _search.activeFilters > 0 ? _resetAll : null,
        ),
      ];
    }

    return const [SkeletonList(items: 2)];
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.search});

  final ExerciseSearchController search;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            search.summary,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
        ),
        Text(
          'до 5 на запрос',
          style: TextStyle(
            fontSize: 10.5,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _KeyBanner extends StatelessWidget {
  const _KeyBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: AppColors.signal.withValues(alpha: 0.06),
        border: Border.all(
          color: AppColors.signal.withValues(alpha: 0.35),
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        children: [
          Icon(Icons.key_outlined, size: 18, color: scheme.secondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ключ API Ninjas не задан',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Без ключа запросы к базе упражнений не выполняются.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.35,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}
