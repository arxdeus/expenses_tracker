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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryMeta && other.name == name && other.imageUrl == imageUrl && other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(name, imageUrl, updatedAt);

  CategoryMeta copyWith({
    String? name,
    String? imageUrl,
    DateTime? updatedAt,
  }) {
    return CategoryMeta(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
