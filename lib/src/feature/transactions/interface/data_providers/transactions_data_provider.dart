import 'package:expenses_tracker/src/feature/transactions/interface/transaction_interfaces.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_entity.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';

abstract class TransactionsDataProviderInterface
    implements TransactionDataProviderGetManyInterface, TransactionDataProviderGetSingleInterface {
  Future<TransactionEntity> createTransaction({
    required Decimal amount,
    required String description,
    required DateTime updatedAt,
    String? categoryUuid,
  });
  Future<void> deleteTransaction(String _);
}
