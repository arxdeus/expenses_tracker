import 'dart:convert';

import 'package:app_database/app_database.dart';

import 'package:expenses_tracker/src/feature/transactions/model/transaction_entity.dart';

class TransactionEntryEncoder extends Converter<TransactionEntity, TransactionDBEntity> {
  const TransactionEntryEncoder();

  @override
  TransactionDBEntity convert(TransactionEntity input) => TransactionDBEntity(
        description: input.meta.description,
        uuid: input.uuid,
        fractionalValue: input.meta.amount.fractionalValue,
        integerValue: input.meta.amount.integerValue,
        updatedAt: input.meta.updatedAt,
        category: input.meta.category?.uuid,
      );
}
