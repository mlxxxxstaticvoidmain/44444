import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_text.dart';
import '../favorites/favorites_tab.dart';
import '../plan/workout_tab.dart';
import '../search/exercise_search_controller.dart';
import '../search/search_tab.dart';
import '../settings/settings_controller.dart';
import '../settings/settings_screen.dart';
import '../settings/widgets/api_key_sheet.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final ExerciseSearchController _search = getIt<ExerciseSearchController>();
  final SettingsController _settings = getIt<SettingsController>();

  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _search.load();
      _maybeShowOnboarding();
    });
  }

  Future<void> _maybeShowOnboarding() async {
    if (!mounted || _settings.hasApiKey || _settings.onboardingSeen) return;

    await _settings.markOnboardingSeen();
    if (!mounted) return;
    await showApiKeySheet(context);
  }

  void _goToSearch() => setState(() => _index = 0);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(
              onSettings: () => openSettings(context),
            ),
            Divider(height: 1, color: scheme.outlineVariant),
            Expanded(
              child: IndexedStack(
                index: _index,
                children: [
                  const SearchTab(),
                  WorkoutTab(onOpenSearch: _goToSearch),
                  FavoritesTab(onOpenSearch: _goToSearch),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: scheme.outlineVariant)),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) => setState(() => _index = value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.search),
              selectedIcon: Icon(Icons.search),
              label: 'Поиск',
            ),
            NavigationDestination(
              icon: Icon(Icons.checklist_outlined),
              selectedIcon: Icon(Icons.checklist),
              label: 'Тренировка',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_border),
              selectedIcon: Icon(Icons.bookmark),
              label: 'Избранное',
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onSettings});

  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 8, 6),
      child: Row(
        children: [
          Container(width: 5, height: 23, color: scheme.secondary),
          const SizedBox(width: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Атлас', style: AppText.display(24, scheme.onSurface)),
              const SizedBox(width: 5),
              Text(
                'упражнений',
                style: TextStyle(
                  fontSize: 11.5,
                  letterSpacing: 0.2,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: onSettings,
            tooltip: 'Настройки',
            icon: const Icon(Icons.settings_outlined, size: 21),
          ),
        ],
      ),
    );
  }
}
