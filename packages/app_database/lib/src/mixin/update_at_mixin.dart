import 'package:app_database/app_database.dart';

mixin UpdateAtMixin on Table {
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
