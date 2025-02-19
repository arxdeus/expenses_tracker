import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';
import 'package:expenses_tracker/src/feature/categories/widget/category_grid.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resources/_localization/extension.dart';
import 'package:resources/resources.dart';

/// {@template select_category_screen}
/// SelectCategoryScreen widget.
/// {@endtemplate}
class SelectCategoryScreen extends StatefulWidget {
  /// {@macro select_category_screen}
  const SelectCategoryScreen({
    super.key, // ignore: unused_element
  });

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

/// State for widget SelectCategoryScreen.
class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  void _onSelectCategory(CategoryEntity entity) => context.pop(entity);

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height, minHeight: 200),
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                toolbarHeight: kToolbarHeight * 1.5,
                titleSpacing: 0,
                expandedHeight: kToolbarHeight * 1.5,
                backgroundColor: Colors.white.withAlpha(170),
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                leading: BackButton(),
                title: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: .65,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      context.localization.selectCategory,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        height: 1,
                        fontFamily: FontFamily.euclidFlex,
                        color: Colors.black,
                        fontSize: 128,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: CategoryGrid(
                  onCategoryTap: _onSelectCategory,
                ),
              ),
            ],
          ),
        ),
      );
}
