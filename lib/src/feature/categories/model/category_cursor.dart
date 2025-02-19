import 'package:app_database/app_database.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';
import 'package:expenses_tracker/src/shared/model/cursor.dart';
import 'package:pure/pure.dart';

sealed class CategoryCursor implements Cursor<CategoryEntity, CategoryCursor> {
  const factory CategoryCursor.updatedAt({DateTime? updatedAt}) = CategoryCursor$UpdatedAt;
}

class CategoryCursor$UpdatedAt implements CategoryCursor {
  final DateTime? updatedAt;

  const CategoryCursor$UpdatedAt({this.updatedAt});

  @override
  CategoryCursor fromEntity(CategoryEntity? entity) => CategoryCursor$UpdatedAt(
        updatedAt: entity?.meta.updatedAt,
      );

  @override
  bool? get persistentCondition => updatedAt == null ? true : null;

  @override
  bool isGreaterThanEntity(CategoryEntity entity) {
    final entityUpdatedAt = entity.meta.updatedAt;

    if (updatedAt == null) return true;

    return entityUpdatedAt.isBefore(updatedAt!);
  }

  @override
  bool isLowerThanEntity(CategoryEntity entity) {
    final entityUpdatedAt = entity.meta.updatedAt;

    if (updatedAt == null) return false;

    return entityUpdatedAt.isAfter(updatedAt!);
  }

  @override
  String toString() => 'CategoryCursor\$UpdatedAt(updatedAt: $updatedAt)';
}

extension WhereClauseFromCursor on CategoryCursor {
  void applyClause(SimpleSelectStatement<$CategoriesTable, CategoryDBEntity> statement) {
    statement.where(
      switch (this) {
        final CategoryCursor$UpdatedAt cursor => cursor.filter,
      },
    );
  }
}

extension WhereClauseFromUpdatedAtCursor on CategoryCursor$UpdatedAt {
  Expression<bool> filter($CategoriesTable table) =>
      updatedAt?.pipe(Variable.new).pipe(table.updatedAt.isSmallerThan) ?? Constant(true);
}
