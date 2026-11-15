import 'package:trackfit_core/trackfit_core.dart';

import 'coding.dart';
import 'resolver.dart';

/// A mapping a person confirmed: this printed name is this test, or no
/// standard test at all.
class ConfirmedAlias {
  const ConfirmedAlias({required this.nameKey, this.unitUcum = '', this.code});

  final String nameKey;

  /// '' applies to every unit.
  final String unitUcum;

  /// LOINC code; null means "not a standard test".
  final String? code;
}

/// Asks the confirmed aliases first, then the resolver.
///
/// An alias names the analyte. The printed unit still picks between its
/// mass and substance codes, so one answer covers both.
class AliasCoder implements Coder {
  AliasCoder(this.lexical, Iterable<ConfirmedAlias> aliases)
    : _aliases = {
        for (final alias in aliases) (alias.nameKey, alias.unitUcum): alias,
      };

  final LexicalCoder lexical;
  final Map<(String, String), ConfirmedAlias> _aliases;

  @override
  String get release => lexical.release;

  @override
  CodingResult code({
    required String nameKey,
    required String unitUcum,
    required ValueKind valueKind,
  }) {
    final alias = _aliases[(nameKey, unitUcum)] ?? _aliases[(nameKey, '')];
    if (alias == null) {
      return lexical.code(
        nameKey: nameKey,
        unitUcum: unitUcum,
        valueKind: valueKind,
      );
    }
    final code = alias.code;
    if (code == null) {
      return const CodingResult.uncoded(
        CodingOutcome.refused,
        'alias:not-standard',
        rule: 'alias:person',
      );
    }
    final entry = lexical.terminology.entry(code);
    if (entry == null) {
      return const CodingResult.uncoded(
        CodingOutcome.needsInput,
        'alias:unknown-code',
        rule: 'alias:person',
      );
    }
    return lexical.codeInGroup(
      entry.groupId,
      unitUcum: unitUcum,
      valueKind: valueKind,
      rule: 'alias:person',
    );
  }
}
