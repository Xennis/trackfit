import 'package:flutter/material.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../../app/status_colors.dart';
import '../../l10n/generated/app_localizations.dart';

/// The value of a reading as printed, with its unit.
String formatPrintedValue(VObservationData reading) => [
  reading.valueText.trim(),
  reading.unitText.trim(),
].where((part) => part.isNotEmpty).join(' ');

/// Name to show: the German name of the code, else the name as printed.
String readingName(VObservationData reading) {
  final german = reading.displayDe ?? '';
  if (german.isNotEmpty) return german;
  final short = reading.shortName ?? '';
  return short.isNotEmpty ? short : reading.nameText;
}

String flagLabel(AppLocalizations l10n, Flag flag) => switch (flag) {
  Flag.none => '',
  Flag.low => l10n.flagLow,
  Flag.high => l10n.flagHigh,
  Flag.criticalLow => l10n.flagCriticalLow,
  Flag.criticalHigh => l10n.flagCriticalHigh,
  Flag.abnormal => l10n.flagAbnormal,
};

/// Arrow or mark on a soft background for an abnormal flag; an empty space
/// of the same width for a normal value, so that values stay aligned.
class FlagMark extends StatelessWidget {
  const FlagMark(this.flag, {super.key, this.size = 22});

  final Flag flag;

  /// Diameter of the mark.
  final double size;

  @override
  Widget build(BuildContext context) {
    final status = StatusColors.of(context);
    final warning = (status.warning, status.warningContainer);
    final critical = (status.critical, status.criticalContainer);
    final (icon, colors) = switch (flag) {
      Flag.none => (null, warning),
      Flag.low => (Icons.arrow_downward, warning),
      Flag.high => (Icons.arrow_upward, warning),
      Flag.criticalLow => (Icons.keyboard_double_arrow_down, critical),
      Flag.criticalHigh => (Icons.keyboard_double_arrow_up, critical),
      Flag.abnormal => (Icons.priority_high, warning),
    };
    if (icon == null) return SizedBox(width: size);
    return Tooltip(
      message: flagLabel(AppLocalizations.of(context), flag),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: colors.$2, shape: BoxShape.circle),
        child: Icon(icon, size: size * 0.7, color: colors.$1),
      ),
    );
  }
}
