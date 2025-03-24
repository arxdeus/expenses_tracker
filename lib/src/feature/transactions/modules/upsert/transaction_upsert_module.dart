import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';
import 'package:expenses_tracker/src/feature/transactions/interface/data_repository/transaction_updates_data_repository.dart';
import 'package:expenses_tracker/src/feature/transactions/interface/transaction_interfaces.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_entity.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';
import 'package:modulisto/modulisto.dart';

typedef TransactionUpsertRequest = ({
  String? uuid,
  String description,
  Decimal rawAmount,
  CategoryEntity? categoryUuid,
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
      ..unit(lifecycle.init).redirect((_) => _prefetchTransaction(transactionUuid))
      ..unit(upsertTransaction).bind(_upsertTransactionCall),
    transformer: eventTransformers.droppable,
  );

  late final _outgoingPipeline =
      Pipeline.sync(this, ($) => $..unit(_upsertDone).redirect((_) => _onUpsertDone?.call()));

  Future<void> _prefetchTransaction(String? uuid) async {
    if (uuid == null) return;
    final transaction = await transactionGetSingle.getById(uuid);
    if (transaction == null) return;
    _onTransactionFound?.call(transaction);
  }

  Future<void> _upsertTransactionCall(
    PipelineContext context,
    TransactionUpsertRequest request,
  ) async {
    try {
      context.update(isLoading, TransactionUpsertState.processing);
      if (transactionUuid == null) {
        final _ = await transactionUpdatesDataRepository.createTransaction(
          rawAmount: request.rawAmount,
          description: request.description,
          updatedAt: request.updatedAt,
          categoryUuid: request.categoryUuid?.uuid,
        );
      } else {
        final _ = await transactionUpdatesDataRepository.updateTransaction(
          transactionUuid!,
          (old) => old.copyWith(
            meta: old.meta.copyWith(
              description: request.description,
              amount: request.rawAmount,
              category: request.categoryUuid,
            ),
          ),
        );
      }
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
    Module.initialize(this, attach: {
      _pipeline,
      _outgoingPipeline,
    });
  }
}
