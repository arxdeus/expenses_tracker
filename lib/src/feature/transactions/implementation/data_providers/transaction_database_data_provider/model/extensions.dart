import 'package:app_database/app_database.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_cursor.dart';
import 'package:pure/pure.dart';

extension WhereClauseFromCursor on TransactionCursor {
  void applyClause(SimpleSelectStatement<$TransactionsTable, TransactionDBEntity> statement) {
    statement.where(
      switch (this) {
        final TransactionCursor$Amount cursor => cursor.filter,
        final TransactionCursor$UpdatedAt cursor => cursor.filter,
      },
    );
  }
}

extension WhereClauseFromUpdatedAtCursor on TransactionCursor$UpdatedAt {
  Expression<bool> filter($TransactionsTable table) =>
      updatedAt?.pipe(Variable.new).pipe(table.updatedAt.isSmallerThan) ?? Constant(true);
}

extension WhereClauseFromAmountCursor on TransactionCursor$Amount {
  Expression<bool> filter($TransactionsTable table) => Expression.or([
        table.integerValue.isSmallerThan(Variable(integerValue)),
        Expression.and([
          table.integerValue.equalsNullable(integerValue),
          table.fractionalValue.isSmallerThan(Variable(integerValue)),
        ]),
      ]);
}
