import 'package:flutter/material.dart';

import '../../app/status_colors.dart';

/// A small line of the latest values, without axes.
class Sparkline extends StatelessWidget {
  const Sparkline({
    required this.values,
    this.width = 64,
    this.height = 24,
    this.highlightLast = false,
    super.key,
  });

  final List<double> values;
  final double width;
  final double height;

  /// Draws the newest value in the warning color, e.g. when it is abnormal.
  final bool highlightLast;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: width,
      height: height,
      child: values.length < 2
          ? null
          : CustomPaint(
              painter: _SparklinePainter(
                values: values,
                line: colors.primary,
                last: highlightLast
                    ? StatusColors.of(context).warning
                    : colors.primary,
              ),
            ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.values,
    required this.line,
    required this.last,
  });

  final List<double> values;
  final Color line;
  final Color last;

  @override
  void paint(Canvas canvas, Size size) {
    var min = values.first;
    var max = values.first;
    for (final v in values) {
      if (v < min) min = v;
      if (v > max) max = v;
    }
    final span = max - min == 0 ? 1.0 : max - min;
    const inset = 3.0;
    Offset at(int i) => Offset(
      inset + (size.width - 2 * inset) * i / (values.length - 1),
      inset + (size.height - 2 * inset) * (1 - (values[i] - min) / span),
    );
    final path = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < values.length; i++) {
      path.lineTo(at(i).dx, at(i).dy);
    }
    canvas
      ..drawPath(
        path,
        Paint()
          ..color = line
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      )
      ..drawCircle(at(values.length - 1), 2.5, Paint()..color = last);
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.values != values || old.line != line || old.last != last;
}
