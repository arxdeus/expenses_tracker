import 'package:expenses_tracker/src/feature/transactions/interface/transaction_interfaces.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';

typedef TransactionUpdatesRequestCreate = ({
  Decimal rawAmount,
  String? uuid,
  String description,
  DateTime updatedAt,
  String? categoryUuid,
});

typedef TransactionUpdatesRequestDeleteById = String;

abstract class TransactionUpdatesDataRepositoryInterface
    implements TransactionUpdatesInterface, TransactionCreateInterface, TransactionDeleteInterface {}
