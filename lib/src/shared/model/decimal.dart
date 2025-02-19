// ignore_for_file: parameter_assignments

import 'dart:math' as math;

import 'package:meta/meta.dart';

@immutable
class Decimal implements Comparable<Decimal> {
  final int integerValue;
  final int fractionalValue;

  bool get isPositive => integerValue.sign == 1;

  const Decimal({
    required this.integerValue,
    this.fractionalValue = 0,
  }) : assert(
          fractionalValue >= 0,
          'amount after dot (precision) can not be negative',
        );

  factory Decimal.parse(String value) {
    final parts = value.split('.');
    if (parts.length > 2) throw ArgumentError.value(value, '$value can contain only single dot');
    final integerValue = int.parse(parts.first);
    int? fractionalValue;
    if (parts.length == 2) {
      fractionalValue = int.parse(parts.last);
    }
    return Decimal(
      integerValue: integerValue,
      fractionalValue: fractionalValue ?? 0,
    );
  }

  Decimal _summFractionals(
    int first,
    int second,
  ) {
    final originFirst = first;
    final originSecond = second;
    int firstPad = 0;
    int secondPad = 0;
    while (first != 0 || second != 0) {
      if (first != 0) {
        first = (first / 10).truncate();
        firstPad++;
      }
      if (second != 0) {
        second = (second / 10).truncate();
        secondPad++;
      }
    }
    final int maxPad = math.max(firstPad, secondPad);
    final int integralBound = math.pow(10, maxPad) as int;

    if (firstPad == secondPad) {
      return _recalculateFractional(
        originFirst + originSecond,
        integralBound,
      );
    }
    final padDiff = (firstPad - secondPad).abs();
    final mutator = math.pow(10, padDiff).truncate();
    final mutatedFractional = switch (firstPad < secondPad) {
      true => mutator * originFirst + originSecond,
      false => mutator * originSecond + originFirst,
    };
    return _recalculateFractional(mutatedFractional, integralBound);
  }

  Decimal _recalculateFractional(int resultFractional, int integralBound) {
    final integerValue = (resultFractional / integralBound).truncate();
    final fractionalValue = integerValue == 0 ? resultFractional : resultFractional - integralBound;
    return Decimal(
      integerValue: integerValue,
      fractionalValue: fractionalValue,
    );
  }

  Decimal operator +(Decimal other) {
    final additive = _summFractionals(fractionalValue, other.fractionalValue);
    final integer = integerValue + other.integerValue + additive.integerValue;
    return Decimal(
      integerValue: integer,
      fractionalValue: additive.fractionalValue,
    );
  }

  @override
  int compareTo(Decimal other) {
    final integerDiff = integerValue.compareTo(other.integerValue);
    if (integerDiff != 0) return integerDiff;
    return fractionalValue.compareTo(other.fractionalValue);
  }

  @override
  int get hashCode => integerValue.hashCode ^ fractionalValue.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Decimal && other.integerValue == integerValue && other.fractionalValue == fractionalValue;
  }

  String get _optionalFractional => fractionalValue == 0 ? '' : '.$fractionalValue';

  String toStringWithPrefix({
    String prefix = '',
    bool ignoreSign = true,
  }) =>
      '$prefix${ignoreSign ? toStringIgnoreSign() : toString()}';

  String toStringIgnoreSign() {
    final sign = integerValue.sign;
    final positiveValue = integerValue * sign;
    return '$positiveValue$_optionalFractional';
  }

  @override
  String toString() => '$integerValue$_optionalFractional';
}
