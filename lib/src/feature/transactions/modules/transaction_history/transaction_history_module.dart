import 'package:expenses_tracker/src/feature/transactions/interface/transaction_interfaces.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_cursor.dart';
import 'package:expenses_tracker/src/feature/transactions/model/transaction_entity.dart';
import 'package:expenses_tracker/src/feature/transactions/modules/transaction_history/transaction_history_state.dart';
import 'package:expenses_tracker/src/shared/model/cursor.dart';
import 'package:expenses_tracker/src/shared/model/object_update.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';

typedef TransactionRequestPagination = ({
  int limit,
  String? categoryUuid,
});

typedef TransactionRequestCreate = ({
  String rawAmount,
  String currencyCode,
  DateTime updatedAt,
  String? categoryUuid,
});

typedef TransactionRequestDeleteById = String;

final class TransactionsHistoryModule extends Module {
  final TransactionDataProviderGetManyInterface _transactionsGetManyDataProvider;
  final TransactionUpdatesInterface _updates;
  final bool _useFakeDelay;
  final int _limit;

  late final Store<CursorBoundary<TransactionEntity, TransactionCursor>> _cursorBoundary = Store(
    this,
    CursorBoundary<TransactionEntity, TransactionCursor>(
      begin: TransactionCursor.updatedAt(),
      end: TransactionCursor.updatedAt(),
    ),
  );
  late final Store<List<TransactionEntity>> historyList = Store(this, const []);
  late final Store<TransactionHistoryState> state = Store(this, TransactionHistoryState.idle);

  late final Trigger<TransactionRequestPagination> loadHistory = Trigger(this);

  late final _pipeline = Pipeline.async(
    this,
    ($) => $
      ..unit(loadHistory).bind(_loadHistory)
      ..stream(_updates.transactionUpdates).bind(_handleUpdate),
    transformer: eventTransformers.sequental,
  );

  late final _syncPipeline = Pipeline.sync(
    this,
    ($) => $
      ..unit(historyList).redirect(print)
      ..unit(lifecycle.init).redirect(
        (_) => loadHistory(
          (
            categoryUuid: null,
            limit: _limit,
          ),
        ),
      ),
  );

  TransactionsHistoryModule({
    required TransactionDataProviderGetManyInterface transactionsDataProvider,
    required TransactionUpdatesInterface updates,
    bool useFakeDelay = true,
    int limit = 15,
  })  : _updates = updates,
        _useFakeDelay = useFakeDelay,
        _limit = limit,
        _transactionsGetManyDataProvider = transactionsDataProvider {
    Module.initialize(this, attach: {
      _pipeline,
      _syncPipeline,
    });
  }

  Future<void> _loadHistory(PipelineContext context, TransactionRequestPagination payload) async {
    if (state.value == TransactionHistoryState.loading) return;

    context.update(state, TransactionHistoryState.loading);
    if (_useFakeDelay) {
      await Future<void>.delayed(
        const Duration(milliseconds: 100),
      );
    }

    final newList = await _transactionsGetManyDataProvider.loadHistory(
      cursor: _cursorBoundary.value.end,
      limit: _limit,
    );
    context.update(
      _cursorBoundary,
      _cursorBoundary.value.copyWith(
        end: _cursorBoundary.value.end.fromEntity(
          newList.lastOrNull,
        ),
      ),
    );
    context.update(
      historyList,
      <TransactionEntity>[
        ...historyList.value,
        ...newList,
      ],
    );
    if (newList.length < 15) {
      context.update(
        state,
        historyList.value.isEmpty
            ? TransactionHistoryState.notFound
            : TransactionHistoryState.endOfList,
      );
      return;
    }

    context.update(state, TransactionHistoryState.idle);
  }

  List<TransactionEntity> _calculateApproxPosition(TransactionEntity newEntity) {
    final history = List.of(historyList.value);
    if (history.isEmpty) {
      history.add(newEntity);
      return history;
    }

    final boundaries = _cursorBoundary.value;
    final length = history.length;
    for (var index = 0; index < length; index++) {
      final entity = history[index];
      final condition = boundaries.begin.isGreaterThanEntity(entity);

      if (condition) {
        history.insert(index, newEntity);
        break;
      }
    }
    return history;
  }

  List<TransactionEntity> _updateList(TransactionEntity entity) {
    final list = List.of(historyList.value);
    final oldIndex = list.indexWhere((category) => category.uuid == entity.uuid);
    if (oldIndex != -1) list[oldIndex] = entity;
    return list;
  }

  Future<void> _handleUpdate(PipelineContext context, TransactionUpdate update) async {
    final entity = update.data;
    final updateKind = update.kind;

    if (_cursorBoundary.value.inCursorBounds(entity)) {
      context.update(
        historyList,
        switch (updateKind) {
          UpdateKind.create => _calculateApproxPosition(entity),
          UpdateKind.update => _updateList(entity),
          UpdateKind.delete => List.of(historyList.value)..remove(entity),
        },
      );

      context.update(state, TransactionHistoryState.idle);
    }
  }
}
