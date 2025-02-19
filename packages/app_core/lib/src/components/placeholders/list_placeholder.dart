import 'package:app_core/src/components/placeholders/list_tile_placeholder.dart';
import 'package:flutter/material.dart';

/// {@template List_placeholder}
/// ListPlaceholder widget.
/// {@endtemplate}
class ListPlaceholder extends StatelessWidget {
  /// {@macro List_placeholder}
  const ListPlaceholder({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    spacing: 8,
    children: <Widget>[
      ListTilePlaceholder(),
      ListTilePlaceholder(),
      ListTilePlaceholder(),
      ListTilePlaceholder(),
      ListTilePlaceholder(),
      ListTilePlaceholder(),
      ListTilePlaceholder(),
      ListTilePlaceholder(),
    ],
  );
}

class ShrinkedListPlaceholder extends StatelessWidget {
  /// {@macro List_placeholder}
  const ShrinkedListPlaceholder({super.key});

  @override
  Widget build(BuildContext context) =>
      const Column(spacing: 8, children: <Widget>[ListTilePlaceholder(), ListTilePlaceholder(), ListTilePlaceholder()]);
}
