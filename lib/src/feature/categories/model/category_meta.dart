import 'package:meta/meta.dart';

@immutable
class CategoryMeta {
  final String name;
  final String? imageUrl;
  final DateTime updatedAt;

  const CategoryMeta({
    required this.name,
    required this.updatedAt,
    this.imageUrl,
  });

  @override
  String toString() => 'CategoryMeta( name: $name)';
}
