import 'package:flutter/material.dart';
import 'package:standardize/standardize.dart';

import '../../l10n/generated/app_localizations.dart';

/// Lets the person pick the test a name stands for. Returns a code of the
/// chosen analyte; the unit later picks between its mass and substance code.
Future<String?> showChooseTestDialog(
  BuildContext context,
  Terminology terminology,
) => showDialog<String>(
  context: context,
  builder: (_) => _ChooseTestDialog(terminology),
);

class _ChooseTestDialog extends StatefulWidget {
  const _ChooseTestDialog(this.terminology);

  final Terminology terminology;

  @override
  State<_ChooseTestDialog> createState() => _ChooseTestDialogState();
}

class _ChooseTestDialogState extends State<_ChooseTestDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final byGroup = <String, TerminologyEntry>{};
    for (final entry in widget.terminology.entries) {
      byGroup.putIfAbsent(entry.groupId, () => entry);
    }
    final query = _query.trim().toLowerCase();
    final options =
        byGroup.values.where((entry) {
            if (query.isEmpty) return true;
            final concept = entry.concept;
            return [
              concept.displayDe,
              concept.shortName,
              concept.display,
            ].any((text) => text.toLowerCase().contains(query));
          }).toList()
          ..sort((a, b) => a.concept.displayDe.compareTo(b.concept.displayDe));

    return AlertDialog(
      title: Text(l10n.questionChooseTest),
      content: SizedBox(
        width: 420,
        height: 420,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.questionSearch,
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            Expanded(
              child: ListView(
                children: [
                  for (final entry in options)
                    ListTile(
                      title: Text(entry.concept.displayDe),
                      subtitle: Text(entry.concept.display),
                      onTap: () => Navigator.of(context).pop(entry.code),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
