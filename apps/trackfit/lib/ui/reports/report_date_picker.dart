import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../../application/set_report_date.dart';

/// Lets the person pick the date of [report].
Future<void> pickReportDate(
  BuildContext context,
  WidgetRef ref,
  ReportRow report,
) async {
  final current = report.reportDate == null
      ? null
      : DateTime.parse(report.reportDate!);
  final picked = await showDatePicker(
    context: context,
    initialDate: current ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );
  if (picked == null) return;
  await setReportDate(ref, report.id, picked);
}
