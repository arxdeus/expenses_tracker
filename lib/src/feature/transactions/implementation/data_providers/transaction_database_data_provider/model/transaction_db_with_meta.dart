import 'package:app_database/app_database.dart';
import 'package:meta/meta.dart';

@immutable
class TransactionDBEntryWithCategory {
  const TransactionDBEntryWithCategory(
    this.entry,
    this.category,
  );

  final TransactionDBEntity entry;
  final CategoryDBEntity? category;
}
