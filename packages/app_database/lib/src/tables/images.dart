import 'package:app_database/app_database.dart';
import 'package:app_database/src/mixin/uuid_mixin.dart';

@DataClassName('ImageCacheDBEntity')
class Images extends Table with UuidPrimaryKey {
  TextColumn get path => text()();
}
