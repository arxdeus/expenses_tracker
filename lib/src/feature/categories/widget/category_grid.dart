import 'package:app_core/app_core.dart';
import 'package:expenses_tracker/src/feature/app/routes.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';
import 'package:expenses_tracker/src/feature/categories/modules/category_history/category_history_module.dart';
import 'package:expenses_tracker/src/feature/categories/modules/category_history/category_history_state.dart';
import 'package:expenses_tracker/src/feature/categories/widget/category_tile.dart';
import 'package:expenses_tracker/src/feature/categories/widget/create_new_category_tile.dart';
import 'package:expenses_tracker/src/feature/dependencies/widget/dependencies_scope.dart';
import 'package:flutter/material.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// {@template category_grid}
/// CategoryGrid widget.
/// {@endtemplate}
class CategoryGrid extends StatefulWidget {
  /// {@macro category_grid}
  const CategoryGrid({
    this.canCreateNew = false,
    this.onCategoryTap,
    super.key, // ignore: unused_element
  });

  final bool canCreateNew;
  final ValueChanged<CategoryEntity>? onCategoryTap;

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

/// State for widget CategoryGrid.
class _CategoryGridState extends State<CategoryGrid> {
  late final _module = CategoriesHistoryModule(
    categoriesDataProvider: DependenciesScope.of(context).categoriesDataProvider,
    updates: DependenciesScope.of(context).categoriesUpdatesDataRepository,
  );

  late final int _additive = widget.canCreateNew ? 1 : 0;

  @override
  void dispose() {
    _module.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StoreBuilder(
        store: _module.state,
        builder: (context, state, _) {
          return StoreBuilder(
            store: _module.historyList,
            builder: (context, historyList, _) => SliverAnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: SliverGrid.builder(
                key: ValueKey(historyList.isEmpty),
                itemCount: state == CategoryHistoryState.loading ? 4 : historyList.length + _additive,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 280),
                itemBuilder: (context, index) {
                  final isAdditiveTile = _additive > 0 && index == historyList.length;
                  return Padding(
                    padding: EdgeInsets.all(4),
                    child: state == CategoryHistoryState.loading
                        ? SizedBox(
                            child: LayoutBuilder(
                              builder: (context, constraints) => Shimmer(
                                alignment: Alignment.centerLeft,
                                size: constraints.biggest,
                                color: const Color(0xFFBDBDBD),
                                backgroundColor: const Color(0xFFF5F5F5),
                              ),
                            ),
                          )
                        : isAdditiveTile
                            ? CreateNewCategoryTile(
                                onTap: () => Routes.createCategory.push<void>(context),
                              )
                            : CategoryTileWidget(
                                categoryEntity: historyList[index],
                                onCategoryTap: widget.onCategoryTap,
                              ),
                  );
                },
              ),
            ),
          );
        },
      );
}
