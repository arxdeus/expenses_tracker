import 'package:meta/meta.dart';

enum UpdateKind {
  create,
  update,
  delete,
}

@immutable
class ObjectUpdate<T> {
  final T data;
  final UpdateKind kind;

  const ObjectUpdate({
    required this.data,
    required this.kind,
  });
}
