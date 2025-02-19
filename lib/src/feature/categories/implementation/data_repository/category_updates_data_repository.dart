import 'dart:async';

import 'package:expenses_tracker/src/feature/categories/interfaces/categories_interfaces.dart';
import 'package:expenses_tracker/src/feature/categories/interfaces/data_providers/category_data_provider.dart';
import 'package:expenses_tracker/src/feature/categories/interfaces/data_repository/category_updates_data_repository.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';
import 'package:expenses_tracker/src/shared/model/object_update.dart';

final class CategoryUpdatesDataRepository implements CategoryUpdatesDataRepositoryInterface {
  final CategoriesDataProviderInterface categoryDataProvider;

  @override
  Stream<CategoryUpdate> get categoryUpdates => _categoryUpdates.stream;
  final StreamController<CategoryUpdate> _categoryUpdates = StreamController.broadcast();

  CategoryUpdatesDataRepository({
    required this.categoryDataProvider,
  });

  @override
  Future<CategoryEntity> createCategory({
    required String name,
    String? imageUrl,
    Decimal? maxLoose,
  }) async {
    final entity = await categoryDataProvider.createCategory(
      name: name,
      imageUrl: imageUrl,
      maxLoose: maxLoose,
    );

    _categoryUpdates.add(
      ObjectUpdate(
        data: entity,
        kind: UpdateKind.create,
      ),
    );
    return entity;
  }

  @override
  Future<void> deleteCategory(String uuid) {
    throw UnimplementedError();
  }

  @override
  Future<CategoryEntity?> updateCategory(String uuid, CategoryEntity Function(CategoryEntity p1) update) async {
    final entity = await categoryDataProvider.updateCategory(uuid, update);
    if (entity == null) return null;

    _categoryUpdates.add(
      ObjectUpdate(
        data: entity,
        kind: UpdateKind.update,
      ),
    );
    return entity;
  }
}
