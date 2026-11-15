import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/theme_controller.dart';
import 'features/shell/home_shell.dart';

class AtlasApp extends StatelessWidget {
  const AtlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();

    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Атлас упражнений',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeController.mode,
          home: const HomeShell(),
        );
      },
    );
  }
}
