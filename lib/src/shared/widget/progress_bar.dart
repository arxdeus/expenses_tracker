// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';

class LinearBar extends StatelessWidget {
  /// Начальное положение линейного бара, должно быть от 0 до 1
  final double start;

  /// Текущее положение линейного бара, должно быть от 0 до 1
  final double progress;

  /// The Color of the progress bar
  final Color progressColor;

  /// The color of the background bar
  final Color backgroundColor;

  /// The stroke width of the progress bar
  final double progressStrokeWidth;

  /// The cap style of the progress bar. Defaults to square, options include
  /// StrokeCap.round, StrokeCap.square, StrokeCap.butt
  final StrokeCap progressStrokeCap;

  ///the stroke width of the background bar
  final double backgroundStrokeWidth;

  const LinearBar({
    super.key,
    this.start = 0.0,
    this.progress = 0.0,
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.progressStrokeWidth = 10.0,
    this.backgroundStrokeWidth = 10.0,
    this.progressStrokeCap = StrokeCap.square,
  });

  @override
  Widget build(BuildContext context) => CustomPaint(
        foregroundPainter: _LinearBarPainter(
          progress: progress,
          start: start,
          progressColor: progressColor,
          backgroundColor: backgroundColor,
          progressStrokeWidth: progressStrokeWidth,
          progressStrokeCap: progressStrokeCap,
          backgroundStrokeWidth: backgroundStrokeWidth,
        ),
      );
}

class _LinearBarPainter extends CustomPainter {
  final Paint _paintBackground = Paint();
  final Paint _paintProgress = Paint();
  final Color backgroundColor;
  final Color progressColor;
  final double start;
  final double progress;
  final double progressStrokeWidth;
  final StrokeCap progressStrokeCap;
  final double backgroundStrokeWidth;

  _LinearBarPainter({
    required this.start,
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.progressStrokeWidth,
    required this.progressStrokeCap,
    required this.backgroundStrokeWidth,
  }) {
    _paintBackground.color = backgroundColor;
    _paintBackground.style = PaintingStyle.stroke;
    _paintBackground.strokeCap = progressStrokeCap;
    _paintBackground.strokeWidth = backgroundStrokeWidth;
    _paintProgress.color = progressColor;
    _paintProgress.style = PaintingStyle.stroke;
    _paintProgress.strokeCap = progressStrokeCap;
    _paintProgress.strokeWidth = progressStrokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final startOffset = Offset(0, size.height / 2);
    final endOffset = Offset(size.width, size.height / 2);
    canvas.drawLine(startOffset, endOffset, _paintBackground);
    final xStart = size.width * start;
    var cappedProgress = progress;
    if (progress > 1) {
      cappedProgress = 1.0;
    }
    final xProgress = size.width * cappedProgress;
    final progressStart = Offset(xStart, size.height / 2);
    final progressEnd = Offset(xProgress, size.height / 2);

    if (progressEnd.dx > 0) {
      canvas.drawLine(
        progressStart,
        progressEnd,
        _paintProgress,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final old = oldDelegate as _LinearBarPainter;

    return old.progress != progress ||
        old.start != start ||
        old.progressColor != progressColor ||
        old.backgroundColor != backgroundColor ||
        old.progressStrokeWidth != progressStrokeWidth ||
        old.backgroundStrokeWidth != backgroundStrokeWidth ||
        old.progressStrokeCap != progressStrokeCap;
  }
}
