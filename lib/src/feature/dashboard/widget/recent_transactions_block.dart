import 'package:app_core/app_core.dart';
import 'package:expenses_tracker/src/feature/app/routes.dart';
import 'package:expenses_tracker/src/feature/dashboard/widget/block_title.dart';
import 'package:expenses_tracker/src/feature/dependencies/widget/dependencies_scope.dart';
import 'package:expenses_tracker/src/feature/transactions/modules/transaction_history/transaction_history_module.dart';
import 'package:expenses_tracker/src/feature/transactions/modules/transaction_history/transaction_history_state.dart';
import 'package:expenses_tracker/src/feature/transactions/widget/no_transactions_yet.dart';
import 'package:expenses_tracker/src/feature/transactions/widget/transaction_entry_widget.dart';
import 'package:expenses_tracker/src/shared/widget/button/button_with_shadow.dart';
import 'package:flutter/material.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';
import 'package:resources/_localization/extension.dart';

class RecentTransactionsBlockWidget extends StatefulWidget {
  const RecentTransactionsBlockWidget({
    super.key,
  });

  @override
  State<RecentTransactionsBlockWidget> createState() => _RecentTransactionsBlockWidgetState();
}

class _RecentTransactionsBlockWidgetState extends State<RecentTransactionsBlockWidget> {
  late final _module = TransactionsHistoryModule(
    limit: 3,
    updates: DependenciesScope.of(context).transactionUpdatesDataRepository,
    transactionsDataProvider: DependenciesScope.of(context).transactionHistoryProvider,
  );

  @override
  void dispose() {
    _module.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        BlockTitle(
          onTap: () => Routes.history.push<void>(context),
          text: context.localization.transactions,
        ),
        StoreBuilder(
          store: _module.state,
          builder: (context, state, child) {
            final historyList = _module.historyList.value;
            return AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: switch (state) {
                TransactionHistoryState.notFound => NoTransactionsYetWidget(
                    key: UniqueKey(),
                  ),
                _ => ListView.builder(
                    key: ValueKey(historyList.isNotEmpty),
                    physics: NeverScrollableScrollPhysics(),
                    itemExtent: 52,
                    shrinkWrap: true,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    itemBuilder: (context, index) => switch (state) {
                      _ when historyList.isNotEmpty => TransactionEntryWidget(
                          entity: historyList[index],
                        ),
                      _ => ListTilePlaceholder(),
                    },
                    itemCount: state == TransactionHistoryState.loading ? 3 : historyList.length.clamp(0, 3),
                  ),
              },
            );
          },
        ),
        ButtonWithShadow.defaultBlue(
          context.localization.createTransaction,
          onTap: () => Routes.createTransaction.push<void>(context),
        ),
      ],
    );
  }
}
