import 'dart:convert';

import 'package:app_database/app_database.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';

class CategoryEntryEncoder extends Converter<CategoryEntity, CategoryDBEntity> {
  const CategoryEntryEncoder();

  @override
  CategoryDBEntity convert(CategoryEntity input) => CategoryDBEntity(
        name: input.meta.name,
        imageUrl: input.meta.imageUrl,
        integerAmount: input.amount.integerValue,
        fractionalAmount: input.amount.fractionalValue,
        updatedAt: input.meta.updatedAt,
        uuid: input.uuid,
      );
}
