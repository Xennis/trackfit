import 'package:flutter/material.dart';

/// Rows that belong together, on one card with hairlines between them.
class ListCard extends StatelessWidget {
  const ListCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
    // Keeps the ink of a tapped row inside the rounded corners.
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        for (final (index, child) in children.indexed) ...[
          if (index > 0) const Divider(indent: 16),
          child,
        ],
      ],
    ),
  );
}
