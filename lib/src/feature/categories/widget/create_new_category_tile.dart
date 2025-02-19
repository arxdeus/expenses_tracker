import 'package:expenses_tracker/src/shared/effects/bounceable.dart';
import 'package:flutter/material.dart';
import 'package:resources/_localization/extension.dart';
import 'package:resources/resources.dart';

class CreateNewCategoryTile extends StatefulWidget {
  const CreateNewCategoryTile({
    this.onTap,
    super.key,
  });

  final VoidCallback? onTap;

  @override
  State<CreateNewCategoryTile> createState() => _CreateNewCategoryTileState();
}

class _CreateNewCategoryTileState extends State<CreateNewCategoryTile> with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);
  late final _animationController = AnimationController(
    vsync: this,
    duration: kThemeAnimationDuration,
  );
  late final _decorationAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.ease,
  ).drive(
    DecorationTween(
      begin: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(16),
      ),
      end: BoxDecoration(
        color: Colors.blueAccent.withAlpha(200),
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _isHovered.addListener(() {
      if (!mounted) return;
      final _ = switch (_isHovered.value) {
        true => _animationController.forward(),
        false => _animationController.reverse(),
      };
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => _isHovered.value = true,
        onExit: (event) => _isHovered.value = false,
        child: ValueListenableBuilder(
          valueListenable: _isHovered,
          builder: (context, isHovered, child) => DecoratedBoxTransition(
            decoration: _decorationAnimation,
            child: child!,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FittedBox(
              child: Column(
                children: [
                  Text(
                    '+',
                    style: TextStyle(
                      fontFamily: FontFamily.euclidFlex,
                      color: Colors.white,
                      fontSize: 64,
                    ),
                  ),
                  Text(
                    context.localization.createCategoryDoubleLine,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontFamily.euclidFlex,
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
