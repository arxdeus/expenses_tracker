import 'package:expenses_tracker/src/shared/effects/bounceable.dart';
import 'package:flutter/material.dart';
import 'package:resources/resources.dart';

class ButtonWithShadow extends StatefulWidget {
  const ButtonWithShadow({
    required this.child,
    super.key,
    this.color,
    this.width = double.infinity,
    this.elevation = 15,
    this.onTap,
    this.gradient,
  });

  final VoidCallback? onTap;
  final Color? color;
  final LinearGradient? gradient;
  final Widget child;
  final double elevation;
  final double? width;

  factory ButtonWithShadow.defaultBlue(
    String text, {
    Key? key,
    double? width,
    VoidCallback? onTap,
    double elevation = 15,
  }) =>
      ButtonWithShadow(
        key: key,
        width: width,
        elevation: elevation,
        gradient: const LinearGradient(
          colors: [Color(0xFF0B55BB), Color(0xFF5038ED)],
        ),
        onTap: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFamily: FontFamily.euclidFlex,
            fontSize: 18,
          ),
        ),
      );

  @override
  State<ButtonWithShadow> createState() => _ButtonWithShadowState();
}

class _ButtonWithShadowState extends State<ButtonWithShadow> {
  late final _key = widget.key ?? UniqueKey();

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.ease,
        height: 52,
        alignment: Alignment.centerLeft,
        width: widget.width,
        child: Bounceable(
          onTap: widget.onTap,
          child: AbsorbPointer(
            child: Hero(
              tag: _key,
              child: PhysicalModel(
                elevation: widget.elevation,
                color: widget.color ?? Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: widget.gradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Align(
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
