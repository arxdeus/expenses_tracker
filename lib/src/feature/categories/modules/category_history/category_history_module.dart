import 'package:expenses_tracker/src/feature/categories/interfaces/categories_interfaces.dart';
import 'package:expenses_tracker/src/feature/categories/interfaces/data_repository/category_updates_data_repository.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_cursor.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';
import 'package:expenses_tracker/src/feature/categories/modules/category_history/category_history_state.dart';
import 'package:expenses_tracker/src/shared/model/cursor.dart';
import 'package:expenses_tracker/src/shared/model/object_update.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';

typedef CategoryRequestPagination = ({
  int limit,
  String? categoryUuid,
});

typedef CategoryRequestCreate = ({
  String rawAmount,
  String currencyCode,
  DateTime updatedAt,
  String? categoryUuid,
});

typedef CategoryRequestDeleteById = String;

final class CategoriesHistoryModule extends Module {
  final CategoriesGetManyInterface _categoriesGetManyDataProvider;
  final CategoryUpdatesDataRepositoryInterface _updates;
  final bool _useFakeDelay;
  final int _limit;

  late final Store<CursorBoundary<CategoryEntity, CategoryCursor>> _cursorBoundary = Store(
    this,
    CursorBoundary(
      begin: CategoryCursor.updatedAt(),
      end: CategoryCursor.updatedAt(),
    ),
  );
  late final Store<List<CategoryEntity>> historyList = Store(this, const []);
  late final Store<CategoryHistoryState> state = Store(this, CategoryHistoryState.idle);

  late final Trigger<CategoryRequestPagination> loadHistory = Trigger(this);

  late final _pipeline = Pipeline.async(
    this,
    ($) => $
      ..unit(loadHistory).bind(_loadHistory)
      ..stream(_updates.categoryUpdates).bind(_handleUpdate),
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

  CategoriesHistoryModule({
    required CategoriesGetManyInterface categoriesDataProvider,
    required CategoryUpdatesDataRepositoryInterface updates,
    bool useFakeDelay = true,
    int limit = 15,
  })  : _updates = updates,
        _useFakeDelay = useFakeDelay,
        _limit = limit,
        _categoriesGetManyDataProvider = categoriesDataProvider {
    Module.initialize(
      this,
      attach: {
        _pipeline,
        _syncPipeline,
      },
    );
  }

  Future<void> _loadHistory(PipelineContext context, CategoryRequestPagination payload) async {
    if (state.value == CategoryHistoryState.loading) return;

    context.update(state, CategoryHistoryState.loading);
    if (_useFakeDelay) {
      await Future<void>.delayed(
        const Duration(milliseconds: 100),
      );
    }

    final newList = await _categoriesGetManyDataProvider
        .listCategories(
          limit: _limit,
        )
        .toList();
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
      <CategoryEntity>[
        ...historyList.value,
        ...newList,
      ],
    );
    if (newList.length < 15) {
      context.update(
        state,
        historyList.value.isEmpty ? CategoryHistoryState.notFound : CategoryHistoryState.endOfList,
      );
      return;
    }

    context.update(state, CategoryHistoryState.idle);
  }

  List<CategoryEntity> _calculateApproxPosition(CategoryEntity newEntity) {
    final history = List.of(historyList.value);
    // FIXME
    if (history.length < 2) {
      history.add(newEntity);
      return history;
    }

    final boundaries = _cursorBoundary.value;
    final length = history.length;
    for (var index = 0; index < length; index++) {
      final entity = history[index];
      final condition = boundaries.end.isGreaterThanEntity(entity);

      if (condition) {
        history.insert(index, newEntity);
        break;
      }
    }
    return history;
  }

  List<CategoryEntity> _updateList(CategoryEntity entity) {
    final list = List.of(historyList.value);
    final oldIndex = list.indexWhere((category) => category.uuid == entity.uuid);
    if (oldIndex != -1) list[oldIndex] = entity;
    return list;
  }

  void _handleUpdate(PipelineContext context, CategoryUpdate update) {
    final entity = update.data;
    final updateKind = update.kind;
    if (_cursorBoundary.value.inCursorBounds(entity)) {
      context.update(
        historyList,
        switch (updateKind) {
          UpdateKind.create => _calculateApproxPosition(entity),
          UpdateKind.delete => List.of(historyList.value)..remove(entity),
          UpdateKind.update => _updateList(entity),
        },
      );
      context.update(state, state.value);
    }
  }
}
