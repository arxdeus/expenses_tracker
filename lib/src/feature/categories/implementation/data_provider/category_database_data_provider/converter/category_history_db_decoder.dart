import 'dart:convert';

import 'package:app_database/app_database.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';

import 'package:expenses_tracker/src/feature/categories/model/category_meta.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';

class CategoryHistoryDbDecoder extends Converter<CategoryDBEntity, CategoryEntity> {
  const CategoryHistoryDbDecoder();

  @override
  CategoryEntity convert(CategoryDBEntity input) => CategoryEntity(
        uuid: input.uuid,
        amount: Decimal(
          integerValue: input.integerAmount,
          fractionalValue: input.fractionalAmount,
        ),
        meta: CategoryMeta(
          name: input.name,
          updatedAt: input.updatedAt,
          imageUrl: input.imageUrl,
        ),
      );
}
