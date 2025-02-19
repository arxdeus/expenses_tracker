import 'package:expenses_tracker/src/feature/transactions/model/transaction_details.dart';

class TransactionEntity {
  final String uuid;
  final TransactionDetails meta;

  const TransactionEntity({
    required this.uuid,
    required this.meta,
  });
}
