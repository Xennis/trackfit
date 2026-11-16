import 'package:flutter/material.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../../app/status_colors.dart';

/// Where a value stands in its reference range.
///
/// The tinted middle half of the bar is the range from [low] to [high]; the
/// dot leaves it when the value does.
class RangeBar extends StatelessWidget {
  const RangeBar({
    required this.value,
    required this.low,
    required this.high,
    this.flag = Flag.none,
    this.width = 88,
    super.key,
  });

  final double value;
  final double low;
  final double high;

  /// Colors the dot like the flag mark of the value.
  final Flag flag;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final status = StatusColors.of(context);
    return CustomPaint(
      size: Size(width, 12),
      painter: _RangeBarPainter(
        position: (value - low) / (high - low),
        track: colors.surfaceContainerHigh,
        range: colors.primary.withValues(alpha: 0.28),
        dot: switch (flag) {
          Flag.none => colors.primary,
          Flag.criticalLow || Flag.criticalHigh => status.critical,
          _ => status.warning,
        },
        dotBorder: colors.surfaceContainerLowest,
      ),
    );
  }
}

class _RangeBarPainter extends CustomPainter {
  _RangeBarPainter({
    required this.position,
    required this.track,
    required this.range,
    required this.dot,
    required this.dotBorder,
  });

  /// 0 at the lower bound of the range, 1 at the upper bound.
  final double position;
  final Color track;
  final Color range;
  final Color dot;
  final Color dotBorder;

  @override
  void paint(Canvas canvas, Size size) {
    const thickness = 6.0;
    const radius = Radius.circular(thickness / 2);
    final top = (size.height - thickness) / 2;
    RRect bar(double from, double to) => RRect.fromLTRBR(
      size.width * from,
      top,
      size.width * to,
      top + thickness,
      radius,
    );
    // Values far outside stay on the bar, just short of its ends.
    final x = size.width * (0.25 + 0.5 * position).clamp(0.06, 0.94);
    final center = Offset(x, size.height / 2);
    canvas
      ..drawRRect(bar(0, 1), Paint()..color = track)
      ..drawRRect(bar(0.25, 0.75), Paint()..color = range)
      ..drawCircle(center, 6, Paint()..color = dotBorder)
      ..drawCircle(center, 4, Paint()..color = dot);
  }

  @override
  bool shouldRepaint(_RangeBarPainter old) =>
      old.position != position ||
      old.track != track ||
      old.range != range ||
      old.dot != dot ||
      old.dotBorder != dotBorder;
}
