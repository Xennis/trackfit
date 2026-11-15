import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../values/series_view_model.dart';

/// Values of one series over time, with the reference range of each
/// measurement as a band.
///
/// Labs differ in their ranges, so the band follows the range printed with
/// each measurement until the next one.
class HistoryChart extends StatelessWidget {
  const HistoryChart({
    required this.points,
    required this.unit,
    this.onSelect,
    this.height = 240,
    super.key,
  });

  final List<SeriesPoint> points;
  final String unit;
  final ValueChanged<SeriesPoint>? onSelect;
  final double height;

  static double _x(DateTime date) =>
      date.millisecondsSinceEpoch / Duration.millisecondsPerDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    if (points.isEmpty) return SizedBox(height: height);

    final xs = [for (final p in points) _x(p.date)];
    final values = [
      for (final p in points) ...[p.value, ?p.refLow, ?p.refHigh],
    ];
    var minY = values.reduce(math.min);
    var maxY = values.reduce(math.max);
    final pad = (maxY - minY) == 0
        ? (maxY.abs() * 0.2 + 1)
        : (maxY - minY) * 0.15;
    minY = math.max(0, minY - pad);
    maxY = maxY + pad;
    var minX = xs.first;
    var maxX = xs.last;
    if (maxX - minX < 30) {
      minX -= 15;
      maxX += 15;
    }

    final hasBand = points.any((p) => p.refLow != null || p.refHigh != null);
    FlSpot bound(SeriesPoint p, double? v, double fallback) =>
        FlSpot(_x(p.date), v ?? fallback);
    // The last range holds until the right edge of the chart.
    List<FlSpot> band(double? Function(SeriesPoint) pick, double fallback) => [
      for (final p in points) bound(p, pick(p), fallback),
      FlSpot(maxX, pick(points.last) ?? fallback),
    ];
    final lowLine = LineChartBarData(
      spots: band((p) => p.refLow, minY),
      isStepLineChart: true,
      color: Colors.transparent,
      barWidth: 0,
      dotData: const FlDotData(show: false),
    );
    final highLine = LineChartBarData(
      spots: band((p) => p.refHigh, maxY),
      isStepLineChart: true,
      color: Colors.transparent,
      barWidth: 0,
      dotData: const FlDotData(show: false),
    );
    final valueLine = LineChartBarData(
      spots: [for (final p in points) FlSpot(_x(p.date), p.value)],
      color: colors.primary,
      barWidth: 2.5,
      isCurved: false,
      dotData: FlDotData(
        getDotPainter: (spot, percent, bar, index) {
          final flag = points[index].reading.flag;
          return FlDotCirclePainter(
            radius: 5,
            color: switch (flag) {
              Flag.none => colors.primary,
              Flag.criticalLow || Flag.criticalHigh => colors.error,
              _ => colors.tertiary,
            },
            strokeWidth: 2,
            strokeColor: colors.surface,
          );
        },
      ),
    );

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            if (hasBand) ...[lowLine, highLine],
            valueLine,
          ],
          betweenBarsData: [
            if (hasBand)
              BetweenBarsData(
                fromIndex: 0,
                toIndex: 1,
                color: colors.primaryContainer.withValues(alpha: 0.6),
              ),
          ],
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: colors.outlineVariant.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, meta) =>
                    value == meta.min || value == meta.max
                    ? const SizedBox.shrink()
                    : SideTitleWidget(
                        meta: meta,
                        child: Text(
                          formatNumber(context, value, decimals: 1),
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: math.max(1, (maxX - minX) / 4),
                getTitlesWidget: (value, meta) {
                  // fl_chart adds labels at both edges, which collide with
                  // the regular ones.
                  if (value == meta.min || value == meta.max) {
                    return const SizedBox.shrink();
                  }
                  final date = DateTime.fromMillisecondsSinceEpoch(
                    (value * Duration.millisecondsPerDay).round(),
                    isUtc: true,
                  );
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      '${date.month.toString().padLeft(2, '0')}/'
                      '${date.year % 100}',
                      style: theme.textTheme.labelSmall,
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchSpotThreshold: 24,
            getTouchedSpotIndicator: (bar, indexes) => [
              for (final _ in indexes)
                TouchedSpotIndicatorData(
                  FlLine(color: colors.outline, strokeWidth: 1),
                  const FlDotData(),
                ),
            ],
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => colors.inverseSurface,
              getTooltipItems: (spots) => [
                for (final spot in spots)
                  spot.barIndex == (hasBand ? 2 : 0)
                      ? LineTooltipItem(
                          '${formatNumber(context, spot.y)} $unit\n'
                          '${MaterialLocalizations.of(context).formatShortDate(points[spot.spotIndex].date)}',
                          TextStyle(color: colors.onInverseSurface),
                        )
                      : null,
              ],
            ),
            touchCallback: (event, response) {
              final select = onSelect;
              if (select == null || event is! FlTapUpEvent) return;
              for (final spot
                  in response?.lineBarSpots ?? const <TouchLineBarSpot>[]) {
                if (spot.barIndex == (hasBand ? 2 : 0)) {
                  select(points[spot.spotIndex]);
                  return;
                }
              }
            },
          ),
        ),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
