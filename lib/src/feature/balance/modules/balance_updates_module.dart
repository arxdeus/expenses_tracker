import 'package:expenses_tracker/src/feature/balance/interface/balance_interfaces.dart';
import 'package:expenses_tracker/src/feature/transactions/interface/transaction_interfaces.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_entity.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';
import 'package:expenses_tracker/src/shared/model/object_update.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';

final class BalanceUpdatesModule extends Module {
  final TransactionUpdatesInterface _updates;
  final BalanceFetchLatestInterface _fetchLatest;

  late final Store<Decimal?> state = Store(this, null);

  late final _pipeline = Pipeline.async(
    this,
    ($) => $
      ..bind(lifecycle.init, _retakeFromStats)
      ..bind(_updates.transactionUpdates, _updateBalanceOnCategory),
    transformer: eventTransformers.sequental,
  );

  Future<void> _retakeFromStats(PipelineContext context, _) async {
    final actualBalance = await _fetchLatest.fetchLatest();
    context.update(state, actualBalance);
  }

  Future<void> _updateBalanceOnCategory(PipelineContext context, ObjectUpdate<TransactionEntity> update) async {
    final stats = update.data.meta.amount;
    final currentState = state.value ?? Decimal(integerValue: 0);
    final resultBalance = currentState + stats;
    context.update(state, resultBalance);
  }

  BalanceUpdatesModule({
    required TransactionUpdatesInterface updates,
    required BalanceFetchLatestInterface fetchLatest,
  })  : _fetchLatest = fetchLatest,
        _updates = updates {
    Module.initialize(
      this,
      ($) => $..attach(_pipeline),
    );
  }
}
