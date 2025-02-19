import 'dart:async';

import 'package:expenses_tracker/src/feature/categories/interfaces/categories_interfaces.dart';
import 'package:expenses_tracker/src/feature/transactions/interface/data_providers/transactions_data_provider.dart';
import 'package:expenses_tracker/src/feature/transactions/interface/data_repository/transaction_updates_data_repository.dart';
import 'package:expenses_tracker/src/feature/transactions/interface/transaction_interfaces.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_entity.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';
import 'package:expenses_tracker/src/shared/model/object_update.dart';

final class TransactionsUpdatesDataRepositoryModule implements TransactionUpdatesDataRepositoryInterface {
  final TransactionsDataProviderInterface transactionsDataProvider;
  final CategoriesUpdateInterface categoriesUpdateStatsInterface;

  @override
  Stream<TransactionUpdate> get transactionUpdates => _transactionUpdates.stream;
  final StreamController<TransactionUpdate> _transactionUpdates = StreamController.broadcast();

  TransactionsUpdatesDataRepositoryModule({
    required this.transactionsDataProvider,
    required this.categoriesUpdateStatsInterface,
  });

  @override
  Future<void> createTransaction({
    required Decimal rawAmount,
    required String description,
    required DateTime updatedAt,
    String? categoryUuid,
  }) async {
    final newTransaction = await transactionsDataProvider.createTransaction(
      description: description,
      amount: rawAmount,
      updatedAt: updatedAt,
      categoryUuid: categoryUuid,
    );
    if (categoryUuid != null) {
      await categoriesUpdateStatsInterface.updateCategory(
        categoryUuid,
        (old) => old.copyWith(amount: old.amount + rawAmount),
      );
    }

    _transactionUpdates.add(
      TransactionUpdate(
        data: newTransaction,
        kind: UpdateKind.create,
      ),
    );
  }

  @override
  Future<void> deleteTransactionById(String _) {
    // TODO: implement deleteTransaction
    throw UnimplementedError();
  }

  @override
  Future<TransactionEntity?> updateTransaction(
    String uuid,
    TransactionEntity Function(TransactionEntity old) update,
  ) async {
    final entity = await transactionsDataProvider.updateTransaction(uuid, update);
    if (entity == null) return null;

    _transactionUpdates.add(
      ObjectUpdate(
        data: entity,
        kind: UpdateKind.update,
      ),
    );
    return entity;
  }
}
