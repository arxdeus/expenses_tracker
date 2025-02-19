import 'package:app_core/app_core.dart';
import 'package:expenses_tracker/src/feature/app/routes.dart';
import 'package:expenses_tracker/src/feature/dependencies/widget/dependencies_scope.dart';
import 'package:expenses_tracker/src/feature/transactions/modules/transaction_history/transaction_history_module.dart';
import 'package:expenses_tracker/src/feature/transactions/modules/transaction_history/transaction_history_state.dart';
import 'package:expenses_tracker/src/feature/transactions/widget/no_transactions_yet.dart';
import 'package:expenses_tracker/src/feature/transactions/widget/transaction_entry_widget.dart';
import 'package:expenses_tracker/src/shared/widget/button/button_with_shadow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';
import 'package:resources/_localization/extension.dart';
import 'package:resources/resources.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// {@template transaction_detailed_history_screen}
/// TransactionDetailedHistoryScreen widget.
/// {@endtemplate}
class TransactionDetailedHistoryScreen extends StatefulWidget {
  /// {@macro transaction_detailed_history_screen}
  const TransactionDetailedHistoryScreen({
    super.key, // ignore: unused_element
  });

  @override
  State<TransactionDetailedHistoryScreen> createState() => _TransactionDetailedHistoryScreenState();
}

/// State for widget TransactionDetailedHistoryScreen.
class _TransactionDetailedHistoryScreenState extends State<TransactionDetailedHistoryScreen> {
  late final _controller = ScrollController();
  late final _module = TransactionsHistoryModule(
    updates: DependenciesScope.of(context).transactionUpdatesDataRepository,
    transactionsDataProvider: DependenciesScope.of(context).transactionHistoryProvider,
  );

  late final _dateFormatter = DateFormat.MMMMd('ru_RU');

  void _loadMore() {
    if (_module.state.value == TransactionHistoryState.idle) {
      _module.loadHistory(
        (
          limit: 15,
          categoryUuid: null,
        ),
      );
    }
  }

  void _overScrollBody() {
    const itemExtent = 60;
    if (!_controller.hasClients) return;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;

    final canLoad = currentScroll >= (maxScroll - itemExtent);

    if (canLoad) _loadMore();
  }

  @override
  void initState() {
    _controller.addListener(_overScrollBody);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Colors.grey.shade300,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ColoredBox(
                color: Colors.white,
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: _controller,
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      titleSpacing: 0,
                      // I was too lazy to create own appbar so...
                      backgroundColor: Colors.white.withAlpha(170),
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      leading: BackButton(),
                      title: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: .65,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            context.localization.transactions,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              height: 1,
                              fontFamily: FontFamily.euclidFlex,
                              color: Colors.black,
                              fontSize: 256,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: StoreBuilder(
                        store: _module.state,
                        builder: (context, state, _) {
                          final historyList = _module.historyList.value;
                          return SliverAnimatedSwitcher(
                            duration: kThemeAnimationDuration,
                            child: switch (state) {
                              TransactionHistoryState.notFound => SliverFillRemaining(
                                  hasScrollBody: false,
                                  fillOverscroll: true,
                                  child: NoTransactionsYetWidget(),
                                ),
                              _ => SliverList.separated(
                                  separatorBuilder: (context, index) {
                                    if (historyList.isEmpty) return SizedBox.shrink();
                                    final nextIndex = index + 1;
                                    if (nextIndex == historyList.length) return SizedBox.shrink();
                                    final entity = historyList[index];
                                    final nextEntity = historyList[nextIndex];
                                    if (entity.meta.updatedAt.day != nextEntity.meta.updatedAt.day ||
                                        entity.meta.updatedAt.month != nextEntity.meta.updatedAt.month) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 61, 81, 228),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            child: Text(
                                              _dateFormatter.format(entity.meta.updatedAt),
                                              style: TextStyle(
                                                fontFamily: FontFamily.euclidFlex,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return SizedBox.shrink();
                                  },
                                  key: ValueKey(historyList.isEmpty),
                                  itemBuilder: (context, index) => SizedBox(
                                    height: 52,
                                    child: switch (state) {
                                      _ when historyList.isNotEmpty => TransactionEntryWidget(
                                          entity: historyList[index],
                                        ),
                                      _ => ListTilePlaceholder(),
                                    },
                                  ),
                                  itemCount: (state == TransactionHistoryState.loading && historyList.isEmpty)
                                      ? 15
                                      : historyList.length,
                                ),
                            },
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 52,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ButtonWithShadow.defaultBlue(
                  'Создать транзакцию',
                  onTap: () => Routes.createTransaction.push<void>(context),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    _module.dispose();
    super.dispose();
  }
}
