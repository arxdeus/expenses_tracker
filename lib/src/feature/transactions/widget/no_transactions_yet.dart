import 'package:flutter/material.dart';
import 'package:resources/resources.dart';

/// {@template no_transactions_yet}
/// NoTransactionsYetWidget widget.
/// {@endtemplate}
class NoTransactionsYetWidget extends StatelessWidget {
  /// {@macro no_transactions_yet}
  const NoTransactionsYetWidget({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sentiment_dissatisfied,
                size: 48,
              ),
              Text(
                'Вы ещё не создавали транзакций',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.euclidFlex,
                ),
              ),
            ],
          ),
        ),
      );
}
