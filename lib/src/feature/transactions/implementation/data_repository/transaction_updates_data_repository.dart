import 'dart:async';

import 'package:expenses_tracker/src/feature/categories/interfaces/categories_interfaces.dart';
import 'package:expenses_tracker/src/feature/transactions/interface/data_providers/transactions_data_provider.dart';
import 'package:expenses_tracker/src/feature/transactions/interface/data_repository/transaction_updates_data_repository.dart';
import 'package:expenses_tracker/src/feature/transactions/interface/transaction_interfaces.dart';
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
  Future<void> createTransaction(TransactionUpdatesRequestCreate payload) async {
    final categoryUuid = payload.categoryUuid;

    final newTransaction = await transactionsDataProvider.createTransaction(
      description: payload.description,
      amount: payload.rawAmount,
      updatedAt: payload.updatedAt,
      categoryUuid: payload.categoryUuid,
    );
    if (categoryUuid != null) {
      await categoriesUpdateStatsInterface.updateCategory(
        categoryUuid,
        (old) => old.copyWith(amount: old.amount + payload.rawAmount),
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
}
