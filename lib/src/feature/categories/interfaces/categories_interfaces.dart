import 'package:expenses_tracker/src/feature/categories/model/category_cursor.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';

import 'package:expenses_tracker/src/shared/model/decimal.dart';
import 'package:expenses_tracker/src/shared/model/object_update.dart';

typedef CategoryUpdate = ObjectUpdate<CategoryEntity>;

abstract class CategoriesCreateInterface {
  Future<CategoryEntity> createCategory({
    required String name,
    String? imageUrl,
    Decimal? maxLoose,
  });
}

abstract class CategoriesDeleteInterface {
  Future<void> deleteCategory(String uuid);
}

abstract class CategoryUpdatesStreamInterface {
  Stream<CategoryUpdate> get categoryUpdates;
}

abstract class CategoriesGetManyInterface {
  Stream<CategoryEntity> listCategories({
    CategoryCursor cursor,
    int limit = 10,
  });
}

abstract class CategoriesGetSingleInterface {
  Future<CategoryEntity?> getById(String uuid);
}

abstract class CategoriesUpdateInterface {
  Future<CategoryEntity?> updateCategory(
    String uuid,
    CategoryEntity Function(CategoryEntity) update,
  );
}
