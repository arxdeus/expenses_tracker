import 'package:expenses_tracker/src/shared/model/decimal.dart';

abstract class BalanceFetchLatestInterface {
  Future<Decimal> fetchLatest();
}
