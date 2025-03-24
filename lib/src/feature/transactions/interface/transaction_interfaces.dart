import 'dart:async';

import 'package:expenses_tracker/src/feature/transactions/model/transaction_cursor.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_entity.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';
import 'package:expenses_tracker/src/shared/model/object_update.dart';

typedef TransactionUpdate = ObjectUpdate<TransactionEntity>;

abstract class TransactionCreateInterface {
  FutureOr<void> createTransaction({
    required Decimal rawAmount,
    required String description,
    required DateTime updatedAt,
    String? categoryUuid,
  });
}

abstract class TransactionDeleteInterface {
  FutureOr<void> deleteTransactionById(String _);
}

abstract class TransactionUpdateSingleInterface {
  Future<TransactionEntity?> updateTransaction(
    String uuid,
    TransactionEntity Function(TransactionEntity old) update,
  );
}

abstract class TransactionUpdatesInterface {
  Stream<TransactionUpdate> get transactionUpdates;
}

abstract class TransactionDataProviderGetSingleInterface {
  Future<TransactionEntity?> getById(String id);
}

abstract class TransactionDataProviderGetManyInterface {
  Future<List<TransactionEntity>> loadHistory({
    int limit = 15,
    TransactionCursor? cursor,
    String? categoryUuid,
  });
}
