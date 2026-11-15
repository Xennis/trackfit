import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

/// Asks for confirmation. Returns whether values should be deleted too, or
/// null when the person cancelled.
Future<bool?> showDeleteReportDialog(
  BuildContext context, {
  required bool hasValues,
}) => showDialog<bool>(
  context: context,
  builder: (context) => _DeleteReportDialog(hasValues: hasValues),
);

class _DeleteReportDialog extends StatefulWidget {
  const _DeleteReportDialog({required this.hasValues});

  final bool hasValues;

  @override
  State<_DeleteReportDialog> createState() => _DeleteReportDialogState();
}

class _DeleteReportDialogState extends State<_DeleteReportDialog> {
  bool _deleteValues = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.reportDeleteTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.reportDeleteBody),
          if (widget.hasValues)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _deleteValues,
              onChanged: (value) => setState(() => _deleteValues = value!),
              title: Text(l10n.reportDeleteValues),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(widget.hasValues && _deleteValues),
          child: Text(l10n.delete),
        ),
      ],
    );
  }
}
