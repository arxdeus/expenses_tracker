import 'package:app_core/src/components/components.dart';
import 'package:flutter/material.dart';

/// {@template list_tile_placeholder}
/// ListTilePlaceholder widget.
/// {@endtemplate}
class ListTilePlaceholder extends StatelessWidget {
  /// {@macro list_tile_placeholder}
  const ListTilePlaceholder({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) {
    // Shaders constrains required tight sizes, it doesn't works with Flexible/Expanded
    final width = MediaQuery.sizeOf(context).width;
    return Row(
      spacing: 8,
      children: [
        CircleAvatar(
          child: Shimmer(
            size: Size(64, 64),
            color: Color(0xFFBDBDBD),
            backgroundColor: Color(0xFFF5F5F5),
            cornerRadius: 24,
          ),
        ),
        SizedBox(
          width: width / 1.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [TextPlaceholder(height: 12), TextPlaceholder(height: 12)],
          ),
        ),
        Spacer(),
        TextPlaceholder(width: width / 7, height: 24),
      ],
    );
  }
}
