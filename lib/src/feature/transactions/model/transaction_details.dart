import 'package:meta/meta.dart';

import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';

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

  TransactionDetails copyWith({
    String? description,
    Decimal? amount,
    DateTime? updatedAt,
    CategoryEntity? category,
  }) {
    return TransactionDetails(
      description: description ?? this.description,
      amount: amount ?? this.amount,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionDetails &&
        other.description == description &&
        other.amount == amount &&
        other.updatedAt == updatedAt &&
        other.category == category;
  }

  @override
  int get hashCode {
    return Object.hash(description, amount, updatedAt, category);
  }
}
