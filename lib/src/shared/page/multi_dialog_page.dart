import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:navigator_resizable/navigator_resizable.dart';

/// A declarative version of [showDialog].
///
/// Because the SDK does not provide [Page] for dialog widgets,
/// we need to define one ourselves.
class MultiPageDialogPage<T> extends Page<T> {
  const MultiPageDialogPage({
    required this.navigator,
    super.key,
  });

  final Widget navigator;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageBasedMultiPageDialogRoute<T>(page: this);
  }
}

class PageBasedMultiPageDialogRoute<T> extends PageRoute<T> {
  PageBasedMultiPageDialogRoute({
    required MultiPageDialogPage<T> page,
  }) : super(settings: page);

  MultiPageDialogPage<T> get page => settings as MultiPageDialogPage<T>;

  @override
  Color? get barrierColor => Colors.black45;

  @override
  String? get barrierLabel => null;

  @override
  bool get barrierDismissible => true;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 150);

  @override
  bool get opaque => false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _EnterTransition(
      animation: animation,
      child: MultiPageDialog(
        navigator: page.navigator,
      ),
    );
  }
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

class MultiPageDialog extends StatelessWidget {
  const MultiPageDialog({
    required this.navigator,
    super.key,
  });

  final Widget navigator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.viewPaddingOf(context).top + 24,
        right: 24,
        left: 24,
        bottom: math.max(
          MediaQuery.viewInsetsOf(context).bottom,
          MediaQuery.viewPaddingOf(context).bottom + 24,
        ),
      ),
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: NavigatorResizable(
            child: navigator,
          ),
        ),
      ),
    );
  }
}
