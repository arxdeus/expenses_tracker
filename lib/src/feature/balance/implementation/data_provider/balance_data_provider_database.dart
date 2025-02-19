import 'package:app_database/app_database.dart';
import 'package:expenses_tracker/src/feature/balance/interface/data_provider/balance_data_provider.dart';
import 'package:expenses_tracker/src/feature/categories/implementation/data_provider/category_database_data_provider/converter/category_history_db_decoder.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';

class BalanceDataProviderDatabase implements BalanceDataProviderInterface {
  final AppDatabase database;

  BalanceDataProviderDatabase({
    required this.database,
  });

  @override
  Future<Decimal> fetchLatest() async {
    final list = await database.categories
        .select()
        .map(CategoryHistoryDbDecoder().convert)
        .map((category) => category.amount)
        .get();
    if (list.isEmpty) return Decimal(integerValue: 0);
    final result = list.reduce((a, b) => a + b);
    return result;
  }
}
