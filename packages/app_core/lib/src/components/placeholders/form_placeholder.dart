import 'package:app_core/src/components/placeholders/shimmer.dart';
import 'package:app_core/src/components/placeholders/text_placeholder.dart';
import 'package:flutter/material.dart';

/// {@template form_placeholder}
/// FormPlaceholder widget.
/// {@endtemplate}
class FormPlaceholder extends StatelessWidget {
  /// {@macro form_placeholder}
  const FormPlaceholder({this.title = false, super.key});

  final bool title;

  @override
  Widget build(BuildContext context) => const Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(8),
        child: Shimmer(
          size: Size(64, 64),
          color: Color(0xFFBDBDBD),
          backgroundColor: Color(0xFFF5F5F5),
          cornerRadius: 24,
        ),
      ),
      SizedBox(height: 16),
      TextPlaceholder(width: 152),
      SizedBox(height: 16),
      TextPlaceholder(width: 256),
      SizedBox(height: 16),
      TextPlaceholder(width: 128),
      SizedBox(height: 16),
      TextPlaceholder(width: 64),
      SizedBox(height: 16),
      TextPlaceholder(width: 256),
      SizedBox(height: 16),
      TextPlaceholder(width: 512),
      SizedBox(height: 16),
      TextPlaceholder(width: 256),
      SizedBox(height: 16),
      TextPlaceholder(width: 128),
    ],
  );
}
