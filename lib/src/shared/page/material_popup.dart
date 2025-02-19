import 'dart:ui';

import 'package:flutter/material.dart';

class MaterialPopup<T> extends PageRoute<T> {
  MaterialPopup({
    required this.builder,
    required this.settings,
  });
  @override
  bool get opaque => false;

  final WidgetBuilder builder;

  @override
  final RouteSettings settings;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

  @override
  Color? get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      _EnterTransition(
        animation: animation,
        child: builder(context),
      );

  @override
  bool get barrierDismissible => true;
}

class BlurryMaterialPopup<T> extends MaterialPopup<T> {
  BlurryMaterialPopup({
    required super.builder,
    required super.settings,
    this.blurMaximum = 5,
  });

  final double blurMaximum;

  @override
  Color? get barrierColor => Colors.black45;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => Stack(
        fit: StackFit.expand,
        children: [
          ValueListenableBuilder(
            valueListenable: animation,
            builder: (context, value, child) {
              final blurValue = blurMaximum * value;
              return BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blurValue,
                  sigmaY: blurValue,
                ),
                child: child,
              );
            },
            child: const SizedBox.expand(),
          ),
          super.buildPage(
            context,
            animation,
            secondaryAnimation,
          ),
        ],
      );
}

class _EnterTransition extends StatelessWidget {
  const _EnterTransition({
    required this.animation,
    this.child,
  });

  final Animation<double> animation;
  final Widget? child;

  static final Animatable<double> _fadeInTransition = CurveTween(
    curve: Easing.legacyDecelerate,
  ).chain(
    CurveTween(
      curve: const Interval(0.3, 1),
    ),
  );

  static final Animatable<double> _scaleUpTransition = Tween<double>(
    begin: 0.80,
    end: 1,
  ).chain(
    CurveTween(curve: Easing.legacy),
  );

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _fadeInTransition.animate(animation),
        child: ScaleTransition(
          scale: _scaleUpTransition.animate(animation),
          child: child,
        ),
      );
}
