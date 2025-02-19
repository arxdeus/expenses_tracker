import 'package:meta/meta.dart';

import 'package:expenses_tracker/src/feature/transactions/model/transaction_details.dart';

@immutable
class TransactionEntity {
  final String uuid;
  final TransactionDetails meta;

  const TransactionEntity({
    required this.uuid,
    required this.meta,
  });

  TransactionEntity copyWith({
    String? uuid,
    TransactionDetails? meta,
  }) {
    return TransactionEntity(
      uuid: uuid ?? this.uuid,
      meta: meta ?? this.meta,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionEntity && other.uuid == uuid && other.meta == meta;
  }

  @override
  int get hashCode => Object.hash(uuid, meta);
}
