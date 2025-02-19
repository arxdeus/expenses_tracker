import 'package:app_core/app_core.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';
import 'package:expenses_tracker/src/shared/effects/bounceable.dart';
import 'package:flutter/material.dart';
import 'package:pure/pure.dart';
import 'package:resources/resources.dart';

class CategoryTileWidget extends StatefulWidget {
  const CategoryTileWidget({
    required this.categoryEntity,
    this.onCategoryTap,
    super.key,
  });

  final CategoryEntity categoryEntity;
  final ValueChanged<CategoryEntity>? onCategoryTap;

  @override
  State<CategoryTileWidget> createState() => _CategoryTileWidgetState();
}

class _CategoryTileWidgetState extends State<CategoryTileWidget> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  bool get isPositiveTransaction => !widget.categoryEntity.amount.integerValue.sign.isNegative;
  String get transactionSign => isPositiveTransaction ? r'$' : r'-$';

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      child: MouseRegion(
        onEnter: (_) => _isHovered.value = true,
        onExit: (event) => _isHovered.value = false,
        child: ValueListenableBuilder(
          valueListenable: _isHovered,
          builder: (context, isHovered, child) => AnimatedPhysicalModel(
            shadowColor: Colors.grey,
            duration: kThemeChangeDuration,
            elevation: isHovered ? 12 : 0,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: child!,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: FittedBox(
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      foregroundImage: widget.categoryEntity.meta.imageUrl?.pipe(ImageLink.local).toImageProvider(),
                      child: Icon(
                        Icons.shopping_bag,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    child: Text(
                      widget.categoryEntity.meta.name,
                      style: TextStyle(
                        fontFamily: FontFamily.euclidFlex,
                        fontWeight: FontWeight.w800,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: FittedBox(
                    child: Text(
                      widget.categoryEntity.amount.toStringWithPrefix(
                        prefix: transactionSign,
                      ),
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: isPositiveTransaction ? Colors.green : Colors.redAccent,
                        fontFamily: FontFamily.comfortaa,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () => widget.onCategoryTap?.call(widget.categoryEntity),
    );
  }
}
