import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';
import 'package:meta/meta.dart';

@immutable
class TransactionDetails {
  final String description;
  final Decimal amount;
  final DateTime updatedAt;
  final CategoryEntity? category;

  const TransactionDetails({
    required this.description,
    required this.amount,
    required this.updatedAt,
    required this.category,
  });

  TransactionDetails.empty()
      : description = '',
        amount = Decimal(
          integerValue: 0,
        ),
        category = null,
        updatedAt = DateTime.now();

  @override
  String toString() {
    return 'TransactionDetails(description: $description, amount: $amount, updatedAt: $updatedAt, category: $category)';
  }
}
