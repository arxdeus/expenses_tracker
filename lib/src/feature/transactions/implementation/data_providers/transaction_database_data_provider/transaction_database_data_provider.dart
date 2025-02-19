import 'package:app_core/app_core.dart';
import 'package:app_database/app_database.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_meta.dart';
import 'package:expenses_tracker/src/feature/transactions/implementation/data_providers/transaction_database_data_provider/converter/transaction_entry_encoder.dart';
import 'package:expenses_tracker/src/feature/transactions/implementation/data_providers/transaction_database_data_provider/converter/transaction_history_db_decoder.dart';
import 'package:expenses_tracker/src/feature/transactions/implementation/data_providers/transaction_database_data_provider/model/extensions.dart';
import 'package:expenses_tracker/src/feature/transactions/implementation/data_providers/transaction_database_data_provider/model/transaction_db_with_meta.dart';
import 'package:expenses_tracker/src/feature/transactions/interface/data_providers/transactions_data_provider.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_cursor.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_details.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_entity.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';

class TransactionDatabaseDataProvider implements TransactionsDataProviderInterface {
  static const _decoder = TransactionHistoryDbDecoder();

  final AppDatabase database;
  TransactionDatabaseDataProvider({required this.database});

  @override
  Future<TransactionEntity> createTransaction({
    required Decimal amount,
    required String description,
    required DateTime updatedAt,
    String? categoryUuid,
  }) async {
    final dbEntity = await database.into(database.transactions).insertReturning(
          TransactionsCompanion.insert(
            description: description,
            integerValue: amount.integerValue,
            fractionalValue: Value.absentIfNull(amount.fractionalValue),
            category: Value(categoryUuid),
            updatedAt: Value(updatedAt),
          ),
        );
    print(dbEntity);
    CategoryEntity? category;

    categorySetter:
    if (categoryUuid != null) {
      final categoryQuery = database.categories.select()..where((category) => category.uuid.equals(categoryUuid));
      final result = await categoryQuery.getSingleOrNull();
      if (result == null) break categorySetter;

      category = CategoryEntity(
        uuid: categoryUuid,
        amount: amount,
        meta: CategoryMeta(
          updatedAt: result.updatedAt,
          name: result.name,
          imageUrl: result.imageUrl,
        ),
      );
    }

    return TransactionEntity(
      uuid: dbEntity.uuid,
      meta: TransactionDetails(
        description: dbEntity.description,
        amount: Decimal(
          integerValue: dbEntity.integerValue,
          fractionalValue: dbEntity.fractionalValue,
        ),
        updatedAt: dbEntity.updatedAt,
        category: category,
      ),
    );
  }

  @override
  Future<void> deleteTransaction(String request) async {
    final _ = await (database.delete(database.transactions)
          ..where(
            (transaction) => transaction.uuid.equals(request),
          ))
        .go();
  }

  @override
  Future<List<TransactionEntity>> loadHistory({
    int limit = 15,
    TransactionCursor? cursor,
    String? categoryUuid,
  }) async {
    final query = database.transactions.select()
      ..limit(limit)
      ..orderBy([
        (transaction) => OrderingTerm.desc(transaction.updatedAt),
        (transaction) => OrderingTerm.desc(transaction.uuid),
      ]);

    if (cursor != null) {
      cursor.applyClause(query);
    }

    final joinedQuery = query.join([
      leftOuterJoin(
        database.categories,
        database.categories.uuid.equalsExp(database.transactions.category),
      ),
    ]);

    final mappedQuery = joinedQuery.map((rows) {
      return TransactionDBEntryWithCategory(
        rows.readTable(database.transactions),
        rows.readTableOrNull(database.categories),
      );
    });
    final list = await mappedQuery.get().asStream().expand(self).map(_decoder.convert).toList();
    return list;
  }

  @override
  Future<TransactionEntity?> getById(String id) async {
    final query = (database.transactions.select()..where((transaction) => transaction.uuid.equals(id))).join([
      leftOuterJoin(
        database.categories,
        database.categories.uuid.equalsExp(database.transactions.category),
      ),
    ]).map((rows) {
      return TransactionDBEntryWithCategory(
        rows.readTable(database.transactions),
        rows.readTableOrNull(database.categories),
      );
    });
    final dbEntity = await query.getSingle();

    return _decoder.convert(dbEntity);
  }

  @override
  Future<TransactionEntity?> updateTransaction(
    String uuid,
    TransactionEntity Function(TransactionEntity old) update,
  ) async {
    final transaction = await getById(uuid);
    if (transaction == null) return null;

    final newTransaction = update(transaction);
    final dbEntity = TransactionEntryEncoder().convert(newTransaction);

    final _ = await database.transactions.update().replace(dbEntity);
    return newTransaction;
  }
}
