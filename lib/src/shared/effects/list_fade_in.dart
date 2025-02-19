import 'package:flutter/material.dart';

class ListFadeInWidget extends StatefulWidget {
  final Widget child;
  final int? index;
  const ListFadeInWidget({
    required this.child,
    super.key,
    this.index,
  });

  @override
  _OpacityState createState() => _OpacityState();
}

class _OpacityState extends State<ListFadeInWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    duration: kThemeAnimationDuration,
    vsync: this,
  )..forward();

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: controller,
        child: widget.child,
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
