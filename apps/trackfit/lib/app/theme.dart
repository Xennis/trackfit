import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Corner radii used across the app.
abstract final class Radii {
  /// Navigation entries, chips and buttons.
  static const double small = 8;

  /// Cards, lists and input fields.
  static const double medium = 12;

  /// The content panel, dialogs and sheets.
  static const double large = 16;
}

/// Themes for light and dark mode.
///
/// Three surface levels give depth without shadows: the ground
/// (`surfaceContainer`) behind the navigation, the content (`surface`) and
/// cards (`surfaceContainerLowest`).
abstract final class AppTheme {
  static const Color _seed = Color(0xFF0B7C8A);

  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ColorScheme _colors(Brightness brightness) {
    final derived = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    if (brightness == Brightness.dark) return derived;
    // The light scheme is set by hand: the derived one tints every surface
    // the same pale blue and makes the containers glaring.
    return derived.copyWith(
      primary: _seed,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFD9EEF1),
      onPrimaryContainer: const Color(0xFF0A4A53),
      secondaryContainer: const Color(0xFFDDEBEE),
      onSecondaryContainer: const Color(0xFF12474F),
      surface: const Color(0xFFFAFCFC),
      onSurface: const Color(0xFF152124),
      onSurfaceVariant: const Color(0xFF5D6C71),
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: const Color(0xFFF4F7F8),
      surfaceContainer: const Color(0xFFEDF2F3),
      surfaceContainerHigh: const Color(0xFFE6ECEE),
      surfaceContainerHighest: const Color(0xFFDFE6E8),
      outline: const Color(0xFF8A979B),
      outlineVariant: const Color(0xFFDFE6E8),
      surfaceTint: Colors.transparent,
    );
  }

  /// Whether sizes suit a mouse and a desktop viewing distance.
  ///
  /// Material's defaults are sized for fingers on a phone and look heavy on
  /// a desktop.
  static bool get _dense => switch (defaultTargetPlatform) {
    TargetPlatform.linux ||
    TargetPlatform.macOS ||
    TargetPlatform.windows => true,
    _ => false,
  };

  static TextTheme _textTheme({required bool dense}) {
    TextStyle style(
      double size,
      double denseSize, {
      FontWeight? weight,
      double spacing = 0,
    }) => TextStyle(
      fontSize: dense ? denseSize : size,
      fontWeight: weight,
      // Material's wide letter spacing is tuned for Roboto.
      letterSpacing: spacing,
    );
    const semiBold = FontWeight.w600;
    return TextTheme(
      headlineMedium: style(28, 26, weight: semiBold, spacing: -0.5),
      headlineSmall: style(24, 22, weight: semiBold, spacing: -0.3),
      titleLarge: style(22, 19, weight: semiBold, spacing: -0.3),
      titleMedium: style(16, 14, weight: semiBold),
      titleSmall: style(14, 13, weight: semiBold),
      bodyLarge: style(16, 14),
      bodyMedium: style(14, 13),
      bodySmall: style(12, 12),
      labelLarge: style(14, 13),
      labelMedium: style(12, 12),
      labelSmall: style(11, 11),
    );
  }

  static ThemeData _build(Brightness brightness) {
    final dense = _dense;
    final colors = _colors(brightness);
    final line = BorderSide(color: colors.outlineVariant);
    RoundedRectangleBorder rounded(double radius, [BorderSide? side]) =>
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: side ?? BorderSide.none,
        );
    final buttonStyle = ButtonStyle(
      shape: WidgetStatePropertyAll(rounded(Radii.small + 2)),
    );
    OutlineInputBorder inputBorder([BorderSide side = BorderSide.none]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.medium),
          borderSide: side,
        );

    return ThemeData(
      colorScheme: colors,
      fontFamily: 'Inter',
      textTheme: _textTheme(dense: dense),
      visualDensity: dense ? VisualDensity.compact : VisualDensity.standard,
      scaffoldBackgroundColor: colors.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        scrolledUnderElevation: 0,
        toolbarHeight: dense ? 52 : null,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colors.surfaceContainerLowest,
        shape: rounded(Radii.medium, line),
      ),
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.onSurfaceVariant,
        dense: dense,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainer,
        isDense: true,
        border: inputBorder(),
        enabledBorder: inputBorder(),
        focusedBorder: inputBorder(
          BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: rounded(Radii.small),
        side: line,
        backgroundColor: colors.surfaceContainerLowest,
      ),
      filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
      textButtonTheme: TextButtonThemeData(style: buttonStyle),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(rounded(Radii.small + 2)),
          side: WidgetStatePropertyAll(line),
          visualDensity: VisualDensity.compact,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 2,
        highlightElevation: 2,
        extendedTextStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        shape: rounded(Radii.large),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        backgroundColor: colors.surface,
        indicatorColor: colors.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? colors.onPrimaryContainer
                : colors.onSurfaceVariant,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surfaceContainerLowest,
        shape: rounded(Radii.large),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Radii.large),
          ),
        ),
      ),
    );
  }
}
