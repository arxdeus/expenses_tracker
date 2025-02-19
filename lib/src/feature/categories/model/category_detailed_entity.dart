import 'package:expenses_tracker/src/feature/categories/model/category_meta.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';
import 'package:meta/meta.dart';

@internal
class InternalEmptyCategory extends CategoryEntity {
  InternalEmptyCategory()
      : super(
          amount: Decimal(integerValue: 0),
          uuid: 'internal',
          meta: CategoryMeta(name: 'Без категории', updatedAt: DateTime.now()),
        );
}

@immutable
class CategoryEntity {
  final String uuid;
  final CategoryMeta meta;
  final Decimal amount;

  const CategoryEntity({
    required this.uuid,
    required this.meta,
    required this.amount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryEntity && other.uuid == uuid && other.meta == meta && other.amount == amount;
  }

  @override
  int get hashCode => Object.hash(uuid.hashCode, meta.hashCode, amount.hashCode);

  CategoryEntity copyWith({
    String? uuid,
    CategoryMeta? meta,
    Decimal? amount,
  }) {
    return CategoryEntity(
      uuid: uuid ?? this.uuid,
      meta: meta ?? this.meta,
      amount: amount ?? this.amount,
    );
  }

  @override
  String toString() => 'CategoryEntity(uuid: $uuid, meta: $meta, amount: $amount)';
}
