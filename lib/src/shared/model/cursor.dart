class CursorBoundary<T, C extends Cursor<T, C>> {
  final C begin;
  final C end;

  const CursorBoundary({
    required this.begin,
    required this.end,
  });

  bool inCursorBounds(T entity) {
    final beginValue = begin.persistentCondition ?? end.isGreaterThanEntity(entity);
    final endValue = end.persistentCondition ?? !end.isGreaterThanEntity(entity);
    final value = beginValue && endValue;
    print('cursor boundary, begin: $beginValue, end: $endValue');
    print('cursor boundary, begin: $begin, end: $end');
    return value;
  }

  CursorBoundary<T, C> copyWith({
    C? begin,
    C? end,
  }) {
    return CursorBoundary(
      begin: begin ?? this.begin,
      end: end ?? this.end,
    );
  }

  @override
  String toString() => 'CursorBoundary(begin: $begin, end: $end)';
}

abstract class Cursor<T, C extends Cursor<T, C>> {
  C fromEntity(T? entity);

  bool? get persistentCondition;

  bool isGreaterThanEntity(T entity);
  bool isLowerThanEntity(T entity);
}
