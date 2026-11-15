import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../../l10n/generated/app_localizations.dart';

/// Title of a report: its title, else its date, else a placeholder.
String reportTitle(BuildContext context, ReportRow report) {
  if (report.title.isNotEmpty) return report.title;
  final date = report.reportDate;
  if (date != null) {
    return formatDay(context, DateTime.parse(date));
  }
  return AppLocalizations.of(context).reportUntitled;
}

String reportStatusLabel(AppLocalizations l10n, ReportStatus status) =>
    switch (status) {
      ReportStatus.pending => l10n.reportStatusPending,
      ReportStatus.ocr => l10n.reportStatusOcr,
      ReportStatus.extracting => l10n.reportStatusExtracting,
      ReportStatus.review => l10n.reportStatusReview,
      ReportStatus.done => l10n.reportStatusDone,
      ReportStatus.failed => l10n.reportStatusFailed,
    };

bool isProcessing(ReportStatus status) => switch (status) {
  ReportStatus.pending || ReportStatus.ocr || ReportStatus.extracting => true,
  _ => false,
};

/// A calendar day with year, in the language of the app, e.g. `14.03.2025`.
String formatDay(BuildContext context, DateTime day) =>
    DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(day);
