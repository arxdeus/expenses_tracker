import 'package:expenses_tracker/src/feature/transactions/model/transaction_entity.dart';
import 'package:expenses_tracker/src/shared/model/cursor.dart';

sealed class TransactionCursor implements Cursor<TransactionEntity, TransactionCursor> {
  @override
  TransactionCursor fromEntity(TransactionEntity? entity);

  @override
  bool isGreaterThanEntity(TransactionEntity entity);

  const factory TransactionCursor.updatedAt({
    DateTime? updatedAt,
  }) = TransactionCursor$UpdatedAt;
  const factory TransactionCursor.amount({
    int? integerValue,
    int? fractionalValue,
  }) = TransactionCursor$Amount;
}

class TransactionCursor$UpdatedAt implements TransactionCursor {
  final DateTime? updatedAt;

  const TransactionCursor$UpdatedAt({this.updatedAt});

  @override
  TransactionCursor fromEntity(TransactionEntity? entity) => TransactionCursor.updatedAt(
        updatedAt: entity?.meta.updatedAt,
      );

  @override
  bool? get persistentCondition => updatedAt == null ? true : null;

  @override
  bool isGreaterThanEntity(TransactionEntity entity) {
    final entityUpdatedAt = entity.meta.updatedAt;

    if (updatedAt == null) return true;

    return entityUpdatedAt.isBefore(updatedAt!);
  }

  @override
  bool isLowerThanEntity(TransactionEntity entity) {
    final entityUpdatedAt = entity.meta.updatedAt;

    if (updatedAt == null) return false;

    return entityUpdatedAt.isAfter(updatedAt!);
  }

  @override
  String toString() => 'TransactionCursor\$UpdatedAt(updatedAt: $updatedAt)';
}

class TransactionCursor$Amount implements TransactionCursor {
  final int? integerValue;
  final int? fractionalValue;

  @override
  bool? get persistentCondition => throw UnimplementedError();

  @override
  bool isGreaterThanEntity(TransactionEntity entity) {
    final entityAmount = entity.meta.amount;
    if (entityAmount.integerValue == fractionalValue) {
      return entityAmount.fractionalValue < (integerValue ?? 0);
    }
    return entityAmount.fractionalValue < (fractionalValue ?? 0);
  }

  @override
  TransactionCursor fromEntity(TransactionEntity? entity) => TransactionCursor.amount(
        integerValue: entity?.meta.amount.integerValue,
        fractionalValue: entity?.meta.amount.fractionalValue,
      );

  const TransactionCursor$Amount({
    this.integerValue,
    this.fractionalValue,
  });

  @override
  String toString() => 'TransactionCursor\$Amount(integerValue: $integerValue, fractionalValue: $fractionalValue)';

  @override
  bool isLowerThanEntity(TransactionEntity entity) {
    // TODO: implement isLowerThanEntity
    throw UnimplementedError();
  }
}
