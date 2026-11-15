import 'package:flutter/material.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../../l10n/generated/app_localizations.dart';

/// What the person did in the edit dialog.
sealed class EditValueResult {
  const EditValueResult();
}

class SaveValue extends EditValueResult {
  const SaveValue(this.draft);
  final ObservationDraft draft;
}

class RetractValue extends EditValueResult {
  const RetractValue();
}

/// Edits a reading as printed, or adds one when [initial] is null.
Future<EditValueResult?> showEditValueDialog(
  BuildContext context, {
  ObservationDraft? initial,
}) => showDialog<EditValueResult>(
  context: context,
  builder: (_) => _EditValueDialog(initial: initial),
);

class _EditValueDialog extends StatefulWidget {
  const _EditValueDialog({this.initial});

  final ObservationDraft? initial;

  @override
  State<_EditValueDialog> createState() => _EditValueDialogState();
}

class _EditValueDialogState extends State<_EditValueDialog> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _value = TextEditingController(text: widget.initial?.value);
  late final _unit = TextEditingController(text: widget.initial?.unit);
  late final _reference = TextEditingController(
    text: widget.initial?.reference,
  );
  late final _flag = TextEditingController(text: widget.initial?.flag);

  @override
  void dispose() {
    for (final c in [_name, _value, _unit, _reference, _flag]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    Navigator.of(context).pop(
      SaveValue(
        ObservationDraft(
          name: _name.text.trim(),
          value: _value.text.trim(),
          unit: _unit.text.trim(),
          reference: _reference.text.trim(),
          flag: _flag.text.trim(),
          specimen: widget.initial?.specimen ?? '',
          panel: widget.initial?.panel ?? '',
          page: widget.initial?.page,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final editing = widget.initial != null;
    InputDecoration label(String text) =>
        InputDecoration(labelText: text, border: const OutlineInputBorder());
    return AlertDialog(
      title: Text(editing ? l10n.editValueTitle : l10n.addValueTitle),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: label(l10n.editName),
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? l10n.editNeedsName : null,
                ),
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _value,
                        decoration: label(l10n.editValue),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _unit,
                        decoration: label(l10n.editUnit),
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _reference,
                        decoration: label(l10n.editReference),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _flag,
                        decoration: label(l10n.editFlag),
                      ),
                    ),
                  ],
                ),
                if (editing)
                  Text(
                    l10n.editOriginalKept,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (editing)
          TextButton(
            onPressed: () => Navigator.of(context).pop(const RetractValue()),
            child: Text(l10n.markAsError),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.save)),
      ],
    );
  }
}
