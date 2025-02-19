import 'dart:async';

import 'package:app_database/app_database.dart';
import 'package:expenses_tracker/src/feature/balance/implementation/data_provider/balance_data_provider_database.dart';
import 'package:expenses_tracker/src/feature/categories/implementation/data_provider/category_database_data_provider/category_database_data_provider.dart';
import 'package:expenses_tracker/src/feature/categories/implementation/data_repository/category_updates_data_repository.dart';
import 'package:expenses_tracker/src/feature/dependencies/initialization/init/initialization.dart';
import 'package:expenses_tracker/src/feature/dependencies/model/dependencies.dart';
import 'package:expenses_tracker/src/feature/images/implementation/image_cache_io.dart';
import 'package:expenses_tracker/src/feature/images/implementation/image_picker_io.dart';
import 'package:expenses_tracker/src/feature/transactions/implementation/data_providers/transaction_database_data_provider/transaction_database_data_provider.dart';
import 'package:expenses_tracker/src/feature/transactions/implementation/data_repository/transaction_updates_data_repository.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uuid/uuid.dart';

typedef AppDependency = InitializationExecutor<$MutableDependencies, DependenciesBase>;

class DependencyInitializationDev extends AppDependency {
  @override
  DependenciesBase Function($MutableDependencies $) get freeze => ($) => $.freeze();

  @override
  List<
      (
        String,
        FutureOr<void> Function(
          $MutableDependencies dependencies,
        )
      )> get initializationSteps => [
        ('App Database', (container) async => container.appDatabase = AppDatabase.lazy()),
        (
          'File Cache Data Provider',
          (container) async => container.fileCacheDataProvider = LocalCacheDatabaseDataProvider(
                database: container.appDatabase,
                genUuid: const Uuid().v4,
              ),
        ),
        (
          'Balance Data Provider',
          (container) async => container.balanceDataProviderDatabase = BalanceDataProviderDatabase(
                database: container.appDatabase,
              ),
        ),
        (
          'Transaction Data Provider',
          (container) async => container.transactionsHistoryDataProvider =
              TransactionDatabaseDataProvider(database: container.appDatabase),
        ),
        (
          'Category Data Provider',
          (container) async => container.categoriesDataProvider = CategoryDatabaseDataProvider(
                database: container.appDatabase,
              ),
        ),
        (
          'Category Updates Data Repository',
          (container) async => container.categoriesUpdatesDataRepository = CategoryUpdatesDataRepository(
                categoryDataProvider: container.categoriesDataProvider,
              ),
        ),
        (
          'Transaction Updates Data Repository',
          (container) async => container.transactionUpdatesDataRepository = TransactionsUpdatesDataRepositoryModule(
                categoriesUpdateStatsInterface: container.categoriesDataProvider,
                transactionsDataProvider: container.transactionsHistoryDataProvider,
              ),
        ),
        (
          'Image Picker Data Provider',
          (container) async => container.imagePickerDataProvider = ImagePickerReal(),
        ),
        (
          'Localization',
          (_) => initializeDateFormatting('ru_RU'),
        ),
      ];

  @override
  $MutableDependencies Function() get create => $MutableDependencies.new;
}
