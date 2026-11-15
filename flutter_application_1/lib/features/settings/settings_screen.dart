import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_text.dart';
import '../favorites/favorites_controller.dart';
import '../plan/workout_controller.dart';
import 'settings_controller.dart';
import 'theme_controller.dart';
import 'widgets/api_key_form.dart';
import 'widgets/external_link.dart';

Future<void> openSettings(BuildContext context) {
  return Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
  );
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController _settings = getIt<SettingsController>();
  final FavoritesController _favorites = getIt<FavoritesController>();
  final WorkoutController _workout = getIt<WorkoutController>();
  final ThemeController _theme = getIt<ThemeController>();

  Future<bool> _confirm({
    required String title,
    required String message,
    required String action,
  }) async {
    final scheme = Theme.of(context).colorScheme;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: scheme.secondary),
              child: Text(action),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<void> _clearFavorites() async {
    final confirmed = await _confirm(
      title: 'Очистить избранное?',
      message: 'Сохранённые упражнения будут удалены с этого устройства.',
      action: 'Очистить',
    );
    if (confirmed) await _favorites.clear();
  }

  Future<void> _clearWorkout() async {
    final confirmed = await _confirm(
      title: 'Очистить тренировку?',
      message: 'Все упражнения и отметки о выполнении будут удалены.',
      action: 'Очистить',
    );
    if (confirmed) await _workout.clear();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Назад',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, size: 21),
        ),
        title: const Text('Настройки'),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          _settings,
          _favorites,
          _workout,
          _theme,
        ]),
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              const _SectionTitle('Доступ к API'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  border: Border.all(color: scheme.outlineVariant),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const ApiKeyForm(),
              ),
              const SizedBox(height: 26),
              const _SectionTitle('Оформление'),
              _ThemeOption(
                label: 'Светлая',
                mode: ThemeMode.light,
                current: _theme.mode,
                onChanged: _theme.setMode,
              ),
              _ThemeOption(
                label: 'Тёмная',
                mode: ThemeMode.dark,
                current: _theme.mode,
                onChanged: _theme.setMode,
              ),
              _ThemeOption(
                label: 'Как в системе',
                mode: ThemeMode.system,
                current: _theme.mode,
                onChanged: _theme.setMode,
                showDivider: false,
              ),
              const SizedBox(height: 26),
              const _SectionTitle('Локальные данные'),
              _DataRow(
                label: 'Избранное',
                count: _favorites.count,
                onClear: _favorites.count > 0 ? _clearFavorites : null,
              ),
              _DataRow(
                label: 'Тренировка',
                count: _workout.count,
                onClear: _workout.count > 0 ? _clearWorkout : null,
                showDivider: false,
              ),
              const SizedBox(height: 26),
              const _SectionTitle('О приложении'),
              _TechRow(value: 'Dio 5.11', description: 'HTTP-клиент и интерсепторы'),
              _TechRow(value: 'AuthInterceptor', description: 'заголовок X-Api-Key в каждом запросе'),
              _TechRow(value: 'PrettyDioLogger', description: 'журнал запросов в debug-режиме'),
              _TechRow(value: 'get_it', description: 'внедрение зависимостей'),
              _TechRow(value: 'API Ninjas', description: 'база упражнений, /v1/exercises'),
              const SizedBox(height: 14),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => openExternal(
                      context,
                      'https://api-ninjas.com/api/exercises',
                    ),
                    icon: const Icon(Icons.open_in_new, size: 15),
                    label: const Text('Документация API'),
                  ),
                  const Spacer(),
                  Text(
                    'версия 1.0.0',
                    style: TextStyle(
                      fontSize: 11,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 6),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(height: 1, color: scheme.outlineVariant),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.mode,
    required this.current,
    required this.onChanged,
    this.showDivider = true,
  });

  final String label;
  final ThemeMode mode;
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = mode == current;

    return Column(
      children: [
        InkWell(
          onTap: () => onChanged(mode),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 20,
                  color: selected ? scheme.secondary : scheme.outline,
                ),
                const SizedBox(width: 11),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider) Divider(height: 1, color: scheme.outlineVariant),
      ],
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.label,
    required this.count,
    required this.onClear,
    this.showDivider = true,
  });

  final String label;
  final int count;
  final VoidCallback? onClear;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 14, color: scheme.onSurface),
              ),
            ),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            TextButton(
              onPressed: onClear,
              style: TextButton.styleFrom(
                foregroundColor: scheme.secondary,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: const Size(0, 36),
              ),
              child: const Text('Очистить'),
            ),
          ],
        ),
        if (showDivider) Divider(height: 1, color: scheme.outlineVariant),
      ],
    );
  }
}

class _TechRow extends StatelessWidget {
  const _TechRow({required this.value, required this.description});

  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 122,
            child: Text(
              value,
              style: AppText.microLabel.copyWith(
                color: scheme.onSurface,
                fontSize: 11,
                letterSpacing: 0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.4,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
