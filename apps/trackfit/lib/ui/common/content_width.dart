import 'package:flutter/material.dart';

/// Keeps lines short on wide windows: [child] is at most [maxWidth] wide and
/// stays at the start, below the title of the page.
class ContentWidth extends StatelessWidget {
  const ContentWidth({required this.child, this.maxWidth = 880, super.key});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.topStart,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
