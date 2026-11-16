import 'package:flutter/material.dart';

/// Colors that say how a value stands, each with a soft background.
///
/// A color never carries the meaning alone: marks always add an arrow or a
/// sign.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.warning,
    required this.warningContainer,
    required this.critical,
    required this.criticalContainer,
    required this.open,
    required this.openContainer,
  });

  static const light = StatusColors(
    warning: Color(0xFFB26A00),
    warningContainer: Color(0xFFFFEFD2),
    critical: Color(0xFFB93327),
    criticalContainer: Color(0xFFFDE6E3),
    open: Color(0xFF5252CC),
    openContainer: Color(0xFFE9E9FD),
  );

  static const dark = StatusColors(
    warning: Color(0xFFF1B760),
    warningContainer: Color(0xFF3A2A0B),
    critical: Color(0xFFFF9186),
    criticalContainer: Color(0xFF431915),
    open: Color(0xFFA9A9FF),
    openContainer: Color(0xFF25254F),
  );

  /// The colors of the theme around [context].
  static StatusColors of(BuildContext context) =>
      Theme.of(context).extension<StatusColors>() ?? light;

  /// A value outside its reference range.
  final Color warning;
  final Color warningContainer;

  /// A value far outside its reference range.
  final Color critical;
  final Color criticalContainer;

  /// Something that waits for an answer.
  final Color open;
  final Color openContainer;

  @override
  StatusColors copyWith({
    Color? warning,
    Color? warningContainer,
    Color? critical,
    Color? criticalContainer,
    Color? open,
    Color? openContainer,
  }) => StatusColors(
    warning: warning ?? this.warning,
    warningContainer: warningContainer ?? this.warningContainer,
    critical: critical ?? this.critical,
    criticalContainer: criticalContainer ?? this.criticalContainer,
    open: open ?? this.open,
    openContainer: openContainer ?? this.openContainer,
  );

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return StatusColors(
      warning: mix(warning, other.warning),
      warningContainer: mix(warningContainer, other.warningContainer),
      critical: mix(critical, other.critical),
      criticalContainer: mix(criticalContainer, other.criticalContainer),
      open: mix(open, other.open),
      openContainer: mix(openContainer, other.openContainer),
    );
  }
}
