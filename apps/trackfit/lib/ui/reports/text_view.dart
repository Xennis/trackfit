import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../common/empty_state.dart';
import 'report_providers.dart';

/// The recognized text of a report, page by page.
class TextView extends ConsumerStatefulWidget {
  const TextView({required this.reportId, super.key});

  final int reportId;

  @override
  ConsumerState<TextView> createState() => _TextViewState();
}

class _TextViewState extends ConsumerState<TextView> {
  bool _raw = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = ref.watch(reportPagesProvider(widget.reportId)).value;
    if (pages == null) return const Center(child: CircularProgressIndicator());
    if (pages.isEmpty) {
      return EmptyState(
        icon: Icons.notes_outlined,
        title: l10n.reportTabText,
        body: l10n.reportTextEmpty,
      );
    }
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(l10n.reportTextRendered)),
              ButtonSegment(value: true, label: Text(l10n.reportTextRaw)),
            ],
            selected: {_raw},
            onSelectionChanged: (value) => setState(() => _raw = value.first),
          ),
        ),
        for (final page in pages) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                l10n.reportPageLabel(page.reportPageIx + 1),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const Expanded(child: Divider(indent: 12)),
              IconButton(
                tooltip: l10n.reportCopyPage,
                icon: const Icon(Icons.copy_outlined, size: 20),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await Clipboard.setData(ClipboardData(text: page.markdown));
                  messenger.showSnackBar(
                    SnackBar(content: Text(l10n.reportCopied)),
                  );
                },
              ),
            ],
          ),
          if (_raw)
            SelectableText(
              page.markdown,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
              ),
            )
          else
            MarkdownBody(data: page.markdown, selectable: true),
        ],
      ],
    );
  }
}
