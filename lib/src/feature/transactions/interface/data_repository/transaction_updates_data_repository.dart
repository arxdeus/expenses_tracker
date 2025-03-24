import 'package:expenses_tracker/src/feature/transactions/interface/transaction_interfaces.dart';

typedef TransactionUpdatesRequestDeleteById = String;

abstract class TransactionUpdatesDataRepositoryInterface
    implements
        TransactionUpdatesInterface,
        TransactionUpdateSingleInterface,
        TransactionCreateInterface,
        TransactionDeleteInterface {}
