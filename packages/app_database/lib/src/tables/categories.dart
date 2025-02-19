import 'package:app_database/app_database.dart';
import 'package:app_database/src/mixin/update_at_mixin.dart';
import 'package:app_database/src/mixin/uuid_mixin.dart';
import 'package:app_database/src/tables/images.dart';

@DataClassName('CategoryDBEntity')
class Categories extends Table with UuidPrimaryKey, UpdateAtMixin {
  TextColumn get name => text()();

  IntColumn get integerAmount => integer().withDefault(Constant(0))();
  IntColumn get fractionalAmount => integer().withDefault(Constant(0))();

  TextColumn? get imageUrl => text().nullable().references(Images, #path)();

  @override
  Set<Column<Object>>? get primaryKey => {uuid};
}
