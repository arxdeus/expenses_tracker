import 'package:app_database/src/mixin/uuid_mixin.dart';
import 'package:app_database/src/platform/database_vm.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'package:app_database/src/platform/database_js.dart';
import 'package:app_database/src/tables/categories.dart';
import 'package:app_database/src/tables/images.dart';
import 'package:app_database/src/tables/transactions.dart';
import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// {@template app_database}
/// The drift-managed database configuration
/// {@endtemplate}
@DriftDatabase(
  tables: [
    Transactions,
    Categories,
    Images,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// {@macro app_database}
  AppDatabase.lazy({
    String? path,
    bool logStatements = false,
    bool dropDatabase = false,
  }) : super(
          LazyDatabase(
            () => $createQueryExecutor(
              path: path,
              logStatements: logStatements,
              dropDatabase: dropDatabase,
            ),
          ),
        );

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (m) async {
        await m.createAll(); // create all tables
        await categories.insertOne(
          CategoriesCompanion.insert(
            name: 'Без категории',
            uuid: Value('internal'),
          ),
        );
      },);

  /// Creates a database from an existing [executor].
  AppDatabase.connect(super.connection);

  /// Creates an in-memory database won't persist its changes on disk.
  ///
  /// If [logStatements] is true (defaults to `false`), generated sql statements
  /// will be printed before executing. This can be useful for debugging.
  /// The optional [setup] function can be used to perform a setup just after
  /// the database is opened, before moor is fully ready. This can be used to
  /// add custom user-defined sql functions or to provide encryption keys in
  /// SQLCipher implementations.
  AppDatabase.memory({
    bool logStatements = false,
  }) : super(
          LazyDatabase(
            () => $createQueryExecutor(
              logStatements: logStatements,
              memoryDatabase: true,
            ),
          ),
        );

  @override
  int get schemaVersion => 1;
}
