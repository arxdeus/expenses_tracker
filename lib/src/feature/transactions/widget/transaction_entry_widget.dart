import 'package:app_core/app_core.dart';
import 'package:expenses_tracker/src/feature/app/routes.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:pure/pure.dart';
import 'package:resources/resources.dart';

/// {@template transaction_entry_widget}
/// TransactionEntryWidget widget.
/// {@endtemplate}
class TransactionEntryWidget extends StatelessWidget {
  /// {@macro transaction_entry_widget}
  const TransactionEntryWidget({
    required this.entity,
    super.key, // ignore: unused_element
  });

  final TransactionEntity entity;

  bool get isPositiveTransaction => !entity.meta.amount.integerValue.sign.isNegative;
  String get transactionSign => isPositiveTransaction ? r'+ $' : r'- $';

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Routes.updateTransaction.push<void>(
          context,
          pathParameters: {
            'id': entity.uuid,
          },
        ),
        child: Row(
          spacing: 8,
          children: [
            CircleAvatar(
              backgroundImage: entity.meta.category?.meta.imageUrl?.pipe(ImageLink.local).toImageProvider(),
              backgroundColor: entity.meta.category?.meta.imageUrl == null
                  ? (isPositiveTransaction ? Colors.greenAccent : Colors.redAccent).withAlpha(170)
                  : null,
              child: entity.meta.category?.meta.imageUrl == null
                  ? Icon(
                      Icons.attach_money,
                      color: isPositiveTransaction ? Colors.green : Colors.red,
                    )
                  : null,
            ),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entity.meta.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.euclidFlex,
                    ),
                  ),
                  Text(
                    entity.meta.category?.meta.name ?? 'Без категории',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: FontFamily.euclidFlex,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Text(
              entity.meta.amount.toStringWithPrefix(
                prefix: transactionSign,
              ),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: isPositiveTransaction ? Colors.green : Colors.red,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                fontFamily: FontFamily.comfortaa,
              ),
            ),
          ],
        ),
      );
}
