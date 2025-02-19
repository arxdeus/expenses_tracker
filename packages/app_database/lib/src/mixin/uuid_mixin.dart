// Tables can mix-in common definitions if needed
import 'package:app_database/app_database.dart';
import 'package:uuid/uuid.dart';

const $uuid = Uuid();

mixin UuidPrimaryKey on Table {
  TextColumn get uuid => text().clientDefault(() => $uuid.v4())();
}
