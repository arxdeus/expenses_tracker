import 'package:app_core/app_core.dart';
import 'package:app_database/app_database.dart';
import 'package:expenses_tracker/src/feature/categories/implementation/data_provider/category_database_data_provider/converter/category_entry_encoder.dart';
import 'package:expenses_tracker/src/feature/categories/implementation/data_provider/category_database_data_provider/converter/category_history_db_decoder.dart';

import 'package:expenses_tracker/src/feature/categories/interfaces/data_providers/category_data_provider.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_cursor.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';

import 'package:expenses_tracker/src/shared/model/decimal.dart';

class CategoryDatabaseDataProvider implements CategoriesDataProviderInterface {
  static const _decoder = CategoryHistoryDbDecoder();

  final AppDatabase database;
  CategoryDatabaseDataProvider({required this.database});

  @override
  Future<CategoryEntity> createCategory({
    required String name,
    String? imageUrl,
    Decimal? maxLoose,
  }) async {
    final dbEntity = await database.categories.insertReturning(
      CategoriesCompanion.insert(
        name: name,
        imageUrl: Value.absentIfNull(imageUrl),
      ),
    );
    final entity = _decoder.convert(dbEntity);
    return CategoryEntity(
      uuid: entity.uuid,
      meta: entity.meta,
      amount: Decimal(integerValue: 0),
    );
  }

  @override
  Future<void> deleteCategory(String uuid) => database.categories.deleteWhere(
        (category) => category.uuid.equals(uuid),
      );

  @override
  Stream<CategoryEntity> listCategories({
    CategoryCursor? cursor,
    int limit = 10,
  }) async* {
    final query = database.categories.select()
      ..orderBy([
        (category) => OrderingTerm.desc(category.uuid),
      ]);
    cursor?.applyClause(query);
    final stream = query.get().asStream();
    yield* stream.expand(self).map(_decoder.convert);
  }

  @override
  Future<CategoryEntity?> updateCategory(String uuid, CategoryEntity Function(CategoryEntity) update) async {
    final category = await getById(uuid);
    if (category == null) return null;
    final newCategory = update(category);
    final dbEntity = CategoryEntryEncoder().convert(newCategory);

    final _ = await database.categories.update().replace(dbEntity);
    return newCategory;
  }

  @override
  Future<CategoryEntity?> getById(String uuid) async {
    final query = database.categories.select()
      ..where(
        (category) => category.uuid.equals(uuid),
      );

    final dbEntity = await query.getSingleOrNull();
    if (dbEntity == null) return null;
    return _decoder.convert(dbEntity);
  }
}
