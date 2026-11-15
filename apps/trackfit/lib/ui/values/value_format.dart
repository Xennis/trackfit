import 'package:flutter/material.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

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

/// Arrow or mark for an abnormal flag; nothing for a normal value.
class FlagMark extends StatelessWidget {
  const FlagMark(this.flag, {super.key, this.size = 18});

  final Flag flag;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (icon, color) = switch (flag) {
      Flag.none => (null, colors.onSurface),
      Flag.low => (Icons.arrow_downward, colors.tertiary),
      Flag.high => (Icons.arrow_upward, colors.tertiary),
      Flag.criticalLow => (Icons.keyboard_double_arrow_down, colors.error),
      Flag.criticalHigh => (Icons.keyboard_double_arrow_up, colors.error),
      Flag.abnormal => (Icons.priority_high, colors.tertiary),
    };
    if (icon == null) return SizedBox(width: size);
    return Tooltip(
      message: flagLabel(AppLocalizations.of(context), flag),
      child: Icon(icon, size: size, color: color),
    );
  }
}
