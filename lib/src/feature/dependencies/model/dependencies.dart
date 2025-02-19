import 'package:app_database/app_database.dart';
import 'package:expenses_tracker/src/feature/balance/implementation/data_provider/balance_data_provider_database.dart';
import 'package:expenses_tracker/src/feature/categories/interfaces/data_providers/category_data_provider.dart';
import 'package:expenses_tracker/src/feature/categories/interfaces/data_repository/category_updates_data_repository.dart';
import 'package:expenses_tracker/src/feature/images/interface/image_cache.dart';
import 'package:expenses_tracker/src/feature/images/interface/image_picker.dart';
import 'package:expenses_tracker/src/feature/transactions/interface/data_providers/transactions_data_provider.dart';
import 'package:expenses_tracker/src/feature/transactions/interface/data_repository/transaction_updates_data_repository.dart';

abstract interface class DependenciesBase {
  abstract final TransactionsDataProviderInterface transactionHistoryProvider;
  abstract final TransactionUpdatesDataRepositoryInterface transactionUpdatesDataRepository;
  abstract final FileCacheDataProviderInteface fileCacheDataProvider;
  abstract final ImagePickerDataProviderInterface imagePickerDataProvider;
  abstract final CategoriesDataProviderInterface categoriesDataProvider;
  abstract final CategoryUpdatesDataRepositoryInterface categoriesUpdatesDataRepository;
  abstract final BalanceDataProviderDatabase balanceDataProviderDatabase;
}

class Dependencies implements DependenciesBase {
  @override
  final TransactionsDataProviderInterface transactionHistoryProvider;
  @override
  final TransactionUpdatesDataRepositoryInterface transactionUpdatesDataRepository;
  @override
  final FileCacheDataProviderInteface fileCacheDataProvider;
  @override
  final ImagePickerDataProviderInterface imagePickerDataProvider;
  @override
  final CategoriesDataProviderInterface categoriesDataProvider;
  @override
  final CategoryUpdatesDataRepositoryInterface categoriesUpdatesDataRepository;

  @override
  final BalanceDataProviderDatabase balanceDataProviderDatabase;

  const Dependencies({
    required this.transactionHistoryProvider,
    required this.transactionUpdatesDataRepository,
    required this.imagePickerDataProvider,
    required this.fileCacheDataProvider,
    required this.categoriesDataProvider,
    required this.categoriesUpdatesDataRepository,
    required this.balanceDataProviderDatabase,
  });
}

class $MutableDependencies {
  late final AppDatabase appDatabase;
  late final TransactionsDataProviderInterface transactionsHistoryDataProvider;
  late final TransactionUpdatesDataRepositoryInterface transactionUpdatesDataRepository;
  late final FileCacheDataProviderInteface fileCacheDataProvider;
  late final ImagePickerDataProviderInterface imagePickerDataProvider;
  late final CategoriesDataProviderInterface categoriesDataProvider;
  late final CategoryUpdatesDataRepositoryInterface categoriesUpdatesDataRepository;
  late final BalanceDataProviderDatabase balanceDataProviderDatabase;

  Dependencies freeze() => Dependencies(
        balanceDataProviderDatabase: balanceDataProviderDatabase,
        imagePickerDataProvider: imagePickerDataProvider,
        fileCacheDataProvider: fileCacheDataProvider,
        transactionHistoryProvider: transactionsHistoryDataProvider,
        transactionUpdatesDataRepository: transactionUpdatesDataRepository,
        categoriesDataProvider: categoriesDataProvider,
        categoriesUpdatesDataRepository: categoriesUpdatesDataRepository,
      );

  $MutableDependencies();
}
