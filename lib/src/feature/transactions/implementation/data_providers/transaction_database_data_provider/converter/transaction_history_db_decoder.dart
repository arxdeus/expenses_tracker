import 'dart:convert';

import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_meta.dart';
import 'package:expenses_tracker/src/feature/transactions/implementation/data_providers/transaction_database_data_provider/model/transaction_db_with_meta.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_details.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_entity.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';
import 'package:pure/pure.dart';

class TransactionHistoryDbDecoder extends Converter<TransactionDBEntryWithCategory, TransactionEntity> {
  const TransactionHistoryDbDecoder();

  @override
  TransactionEntity convert(TransactionDBEntryWithCategory input) => TransactionEntity(
        uuid: input.entry.uuid,
        meta: TransactionDetails(
          description: input.entry.description,
          amount: Decimal(
            integerValue: input.entry.integerValue,
            fractionalValue: input.entry.fractionalValue,
          ),
          updatedAt: input.entry.updatedAt,
          category: input.category?.pipe(
            (category) => CategoryEntity(
              uuid: category.uuid,
              amount: Decimal(integerValue: 0),
              meta: CategoryMeta(
                name: category.name,
                imageUrl: input.category?.imageUrl,
                updatedAt: category.updatedAt,
              ),
            ),
          ),
        ),
      );
}
