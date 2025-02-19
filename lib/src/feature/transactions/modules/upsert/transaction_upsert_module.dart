import 'package:expenses_tracker/src/feature/transactions/interface/data_repository/transaction_updates_data_repository.dart';
import 'package:expenses_tracker/src/feature/transactions/interface/transaction_interfaces.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_entity.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';
import 'package:modulisto/modulisto.dart';

typedef TransactionUpsertRequest = ({
  String? uuid,
  String description,
  Decimal rawAmount,
  String? categoryUuid,
  DateTime updatedAt,
});

enum TransactionUpsertState {
  idle,
  processing,
  error,
  successful,
}

final class TransactionUpsertModule extends Module {
  final String? transactionUuid;
  final void Function(TransactionEntity transaction)? _onTransactionFound;
  final void Function()? _onUpsertDone;

  final TransactionUpdatesDataRepositoryInterface transactionUpdatesDataRepository;
  final TransactionDataProviderGetSingleInterface transactionGetSingle;

  late final Store<TransactionUpsertState> isLoading = Store(this, TransactionUpsertState.idle);
  late final Trigger<TransactionUpsertRequest> upsertTransaction = Trigger(this);
  late final Trigger<()> _upsertDone = Trigger(this);

  late final _pipeline = Pipeline.async(
    this,
    ($) => $
      ..redirect(lifecycle.init, (_) => _prefetchTransaction(transactionUuid))
      ..bind(upsertTransaction, _upsertTransactionCall),
    transformer: eventTransformers.droppable,
  );

  late final _outgoingPipeline = Pipeline.sync(this, ($) => $..redirect(_upsertDone, (_) => _onUpsertDone?.call()));

  Future<void> _prefetchTransaction(String? uuid) async {
    if (uuid == null) return;
    final transaction = await transactionGetSingle.getById(uuid);
    _onTransactionFound?.call(transaction);
  }

  Future<void> _upsertTransactionCall(PipelineContext context, TransactionUpsertRequest request) async {
    try {
      context.update(isLoading, TransactionUpsertState.processing);
      final _ = await transactionUpdatesDataRepository.createTransaction(request);
      await Future<void>.delayed(const Duration(milliseconds: 350));

      context.update(isLoading, TransactionUpsertState.successful);
      _upsertDone();
    } on Object catch (e, _) {
      context.update(isLoading, TransactionUpsertState.error);
      rethrow;
    } finally {
      await Future<void>.delayed(const Duration(seconds: 1));

      context.update(isLoading, TransactionUpsertState.idle);
    }
  }

  TransactionUpsertModule({
    required this.transactionUpdatesDataRepository,
    required this.transactionGetSingle,
    this.transactionUuid,
    void Function()? onUpsertDone,
    void Function(TransactionEntity)? onTransactionFound,
  })  : _onUpsertDone = onUpsertDone,
        _onTransactionFound = onTransactionFound {
    Module.initialize(
      this,
      ($) => $
        ..attach(_pipeline)
        ..attach(_outgoingPipeline),
    );
  }
}
