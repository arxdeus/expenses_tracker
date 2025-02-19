import 'package:flutter/material.dart';

class SizeFadeExplicitTransition extends StatefulWidget {
  /// The animation to be used.

  /// The curve of the animation.
  final Curve curve;

  final Duration duration;

  final bool isExpanded;

  /// How long the [Interval] for the [SizeTransition] should be.
  ///
  /// The value must be between 0 and 1.
  ///
  /// For example a `sizeFraction` of `0.66` would result in `Interval(0.0, 0.66)`
  /// for the size animation and `Interval(0.66, 1.0)` for the opacity animation.
  final double sizeFraction;

  /// [Axis.horizontal] modifies the width,
  /// [Axis.vertical] modifies the height.
  final Axis axis;

  /// Describes how to align the child along the axis the `animation` is
  /// modifying.
  ///
  /// A value of -1.0 indicates the top when [axis] is [Axis.vertical], and the
  /// start when [axis] is [Axis.horizontal]. The start is on the left when the
  /// text direction in effect is [TextDirection.ltr] and on the right when it
  /// is [TextDirection.rtl].
  ///
  /// A value of 1.0 indicates the bottom or end, depending upon the [axis].
  ///
  /// A value of 0.0 (the default) indicates the center for either [axis] value.
  final double axisAlignment;

  /// The child widget.
  final Widget? child;
  const SizeFadeExplicitTransition({
    required this.isExpanded,
    super.key,
    this.sizeFraction = 2 / 3,
    this.curve = Curves.linear,
    this.axis = Axis.vertical,
    this.duration = kThemeAnimationDuration,
    this.axisAlignment = 0.0,
    this.child,
  }) : assert(sizeFraction >= 0.0 && sizeFraction <= 1.0, '`sizeFraction` must be in 0..1 range');

  @override
  _SizeFadeExplicitTransitionState createState() => _SizeFadeExplicitTransitionState();
}

class _SizeFadeExplicitTransitionState extends State<SizeFadeExplicitTransition> with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..forward();

  late Animation<double> size;
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();
    didUpdateWidget(widget);
  }

  @override
  void didUpdateWidget(SizeFadeExplicitTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    final curve = CurvedAnimation(parent: _animation, curve: widget.curve);
    size = CurvedAnimation(
      curve: Interval(0, widget.sizeFraction),
      parent: curve,
    );
    opacity = CurvedAnimation(
      curve: Interval(widget.sizeFraction, 1),
      parent: curve,
    );

    final _ = switch (widget.isExpanded) {
      true => _animation.forward(),
      false => _animation.reverse(),
    };
  }

  @override
  Widget build(BuildContext context) => SizeTransition(
        sizeFactor: size,
        axis: widget.axis,
        axisAlignment: widget.axisAlignment,
        child: FadeTransition(
          opacity: opacity,
          child: widget.child,
        ),
      );
}
