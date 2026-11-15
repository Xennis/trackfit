import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../../app/router.dart';
import '../../application/processing_providers.dart';
import '../../data/database_providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../common/empty_state.dart';
import '../values/value_format.dart';
import 'choose_test_dialog.dart';

/// Values the app could not assign, one question per printed name.
class OpenQuestionsPage extends ConsumerWidget {
  const OpenQuestionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final questions = ref.watch(openQuestionsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.questionsTitle)),
      body: switch (questions) {
        AsyncData(value: final list) when list.isEmpty => EmptyState(
          icon: Icons.check_circle_outline,
          title: l10n.questionsTitle,
          body: l10n.questionsEmpty,
        ),
        AsyncData(value: final list) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final question in list) ...[
              QuestionCard(question: question),
              const SizedBox(height: 12),
            ],
          ],
        ),
        AsyncError() => Center(child: Text(l10n.loadFailed)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

String _reasonText(AppLocalizations l10n, String reason) => switch (reason) {
  'engine:no-match' => l10n.questionReasonNoMatch,
  'name:ambiguous' => l10n.questionReasonAmbiguous,
  'unit:missing' => l10n.questionReasonUnitMissing,
  'unit:conflict' => l10n.questionReasonUnitConflict,
  _ => l10n.questionReasonOther,
};

/// One open question with its answers.
class QuestionCard extends ConsumerWidget {
  const QuestionCard({required this.question, super.key});

  final OpenQuestion question;

  Future<void> _answer(
    BuildContext context,
    WidgetRef ref, {
    required bool standard,
  }) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    String? code;
    if (standard) {
      final terminology = await ref.read(terminologyProvider.future);
      if (!context.mounted) return;
      code = await showChooseTestDialog(context, terminology);
      if (code == null) return;
    }
    final personId = await ref.read(currentPersonIdProvider.future);
    final count = await ref
        .read(questionAnswersProvider)
        .answer(personId: personId, nameKey: question.nameKey, code: code);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.questionAnswered(count))),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final example = question.example;
    final unitProblem = question.reason.startsWith('unit:');
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"${example.nameText}" · ${formatPrintedValue(example)}',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.questionReports(question.reportCount),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(_reasonText(l10n, question.reason)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (unitProblem && example.reportId != null)
                  FilledButton.tonal(
                    onPressed: () =>
                        context.go(Routes.report(example.reportId!)),
                    child: Text(l10n.questionOpenReport),
                  )
                else ...[
                  FilledButton(
                    onPressed: () => _answer(context, ref, standard: true),
                    child: Text(l10n.questionChooseTest),
                  ),
                  OutlinedButton(
                    onPressed: () => _answer(context, ref, standard: false),
                    child: Text(l10n.questionNotStandard),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
