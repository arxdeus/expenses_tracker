import 'package:app_database/app_database.dart';
import 'package:app_database/src/mixin/update_at_mixin.dart';
import 'package:app_database/src/mixin/uuid_mixin.dart';
import 'package:app_database/src/tables/categories.dart';

@TableIndex(name: 'datetime_transaction_idx', columns: {#uuid, #updatedAt})
@TableIndex(name: 'amount_transaction_idx', columns: {#uuid, #fractionalValue, #integerValue})
@DataClassName('TransactionDBEntity')
class Transactions extends Table with UuidPrimaryKey, UpdateAtMixin {
  TextColumn get description => text()();

  IntColumn get integerValue => integer()();
  IntColumn get fractionalValue => integer().withDefault(Constant(0))();

  TextColumn get category => text().nullable().references(Categories, #uuid)();
}
