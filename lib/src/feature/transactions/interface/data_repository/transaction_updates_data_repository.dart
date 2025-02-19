import 'package:expenses_tracker/src/feature/transactions/interface/transaction_interfaces.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';

typedef TransactionUpdatesRequestDeleteById = String;

abstract class TransactionUpdatesDataRepositoryInterface
    implements
        TransactionUpdatesInterface,
        TransactionUpdateSingleInterface,
        TransactionCreateInterface,
        TransactionDeleteInterface {}
