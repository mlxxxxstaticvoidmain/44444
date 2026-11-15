import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = isDark ? _darkScheme : _lightScheme;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    );
    final buttonTextStyle = TextStyle(
      fontSize: 13.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
      color: scheme.onPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: base.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppText.display(22, scheme.onSurface),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        hintStyle: TextStyle(
          color: scheme.onSurfaceVariant,
          fontSize: 13.5,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: scheme.onSurface, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: scheme.error, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.primary.withValues(alpha: 0.35),
          disabledForegroundColor: scheme.onPrimary.withValues(alpha: 0.7),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          shape: buttonShape,
          textStyle: buttonTextStyle,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: buttonShape,
          textStyle: buttonTextStyle.copyWith(color: scheme.onSurface),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.onSurface,
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: scheme.onSurface),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? scheme.surfaceContainerHighest : scheme.onSurface,
        contentTextStyle: TextStyle(
          color: isDark ? scheme.onSurface : scheme.surface,
          fontSize: 13,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        insetPadding: const EdgeInsets.all(12),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primary,
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 21,
            color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
          );
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        side: BorderSide(color: scheme.outline, width: 1.4),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(scheme.onPrimary),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.secondary,
        linearTrackColor: scheme.outlineVariant,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: scheme.onSurface,
          borderRadius: BorderRadius.circular(3),
        ),
        textStyle: TextStyle(color: scheme.surface, fontSize: 12),
      ),
    );
  }

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: AppColors.signal,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.ink,
    onPrimary: AppColors.paper,
    primaryContainer: AppColors.ink,
    onPrimaryContainer: AppColors.paper,
    secondary: AppColors.signal,
    onSecondary: AppColors.white,
    secondaryContainer: const Color(0xFFF1DCD5),
    onSecondaryContainer: AppColors.ink,
    surface: AppColors.paper,
    onSurface: AppColors.ink,
    onSurfaceVariant: AppColors.inkMuted,
    surfaceContainerLowest: AppColors.paperElevated,
    surfaceContainerLow: AppColors.paperElevated,
    surfaceContainer: AppColors.paperTint,
    surfaceContainerHigh: AppColors.paperTint,
    surfaceContainerHighest: AppColors.paperTint,
    outline: const Color(0xFF8C8371),
    outlineVariant: AppColors.line,
    error: AppColors.signalDark,
    onError: AppColors.white,
    surfaceTint: Colors.transparent,
  );

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: AppColors.signal,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.chalk,
    onPrimary: AppColors.night,
    primaryContainer: AppColors.chalk,
    onPrimaryContainer: AppColors.night,
    secondary: AppColors.signalBright,
    onSecondary: AppColors.night,
    secondaryContainer: const Color(0xFF3B241D),
    onSecondaryContainer: AppColors.chalk,
    surface: AppColors.night,
    onSurface: AppColors.chalk,
    onSurfaceVariant: AppColors.nightMuted,
    surfaceContainerLowest: AppColors.night,
    surfaceContainerLow: AppColors.nightElevated,
    surfaceContainer: AppColors.nightElevated,
    surfaceContainerHigh: AppColors.nightElevated,
    surfaceContainerHighest: AppColors.nightElevated,
    outline: const Color(0xFF797264),
    outlineVariant: AppColors.nightLine,
    error: const Color(0xFFFF8C76),
    onError: AppColors.night,
    surfaceTint: Colors.transparent,
  );
}
