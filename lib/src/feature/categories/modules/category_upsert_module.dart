import 'package:expenses_tracker/src/feature/categories/interfaces/categories_interfaces.dart';
import 'package:expenses_tracker/src/feature/categories/interfaces/data_repository/category_updates_data_repository.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';

typedef CategoryUpsertRequest = ({
  String? uuid,
  String name,
  String? imageUrl,
});

enum CategoryUpsertState {
  idle,
  processing,
  error,
  successful,
}

final class CategoryUpsertModule extends Module {
  final String? categoryUuid;
  final void Function(CategoryEntity category)? _onCategoryFound;
  final void Function()? _onUpsertDone;

  final CategoryUpdatesDataRepositoryInterface categoryUpdatesDataRepository;
  final CategoriesGetSingleInterface categoryGetSingle;

  late final Store<CategoryUpsertState> isLoading = Store(this, CategoryUpsertState.idle);
  late final Trigger<CategoryUpsertRequest> upsertCategory = Trigger(this);
  late final Trigger<()> _upsertDone = Trigger(this);

  late final _pipeline = Pipeline.async(
    this,
    ($) => $
      ..redirect(lifecycle.init, (_) => _prefetchCategory(categoryUuid))
      ..bind(upsertCategory, _upsertCategoryCall),
    transformer: eventTransformers.droppable,
  );

  late final _outgoingPipeline = Pipeline.sync(this, ($) => $..redirect(_upsertDone, (_) => _onUpsertDone?.call()));

  Future<void> _prefetchCategory(String? uuid) async {
    if (uuid == null) return;
    final category = await categoryGetSingle.getById(uuid);
    if (category == null) return;
    _onCategoryFound?.call(category);
  }

  Future<void> _upsertCategoryCall(PipelineContext context, CategoryUpsertRequest request) async {
    try {
      context.update(isLoading, CategoryUpsertState.processing);
      // FIXME: Someone kill me pls for this
      if (categoryUuid == null) {
        final _ = await categoryUpdatesDataRepository.createCategory(
          name: request.name,
          imageUrl: request.imageUrl,
        );
      } else {
        final _ = await categoryUpdatesDataRepository.updateCategory(
          categoryUuid!,
          (old) => old.copyWith(
            meta: old.meta.copyWith(imageUrl: request.imageUrl, name: request.name),
          ),
        );
      }

      await Future<void>.delayed(const Duration(milliseconds: 350));

      context.update(isLoading, CategoryUpsertState.successful);
      _upsertDone();
    } on Object catch (e, _) {
      context.update(isLoading, CategoryUpsertState.error);
      rethrow;
    } finally {
      await Future<void>.delayed(const Duration(seconds: 1));

      context.update(isLoading, CategoryUpsertState.idle);
    }
  }

  CategoryUpsertModule({
    required this.categoryUpdatesDataRepository,
    required this.categoryGetSingle,
    this.categoryUuid,
    void Function()? onUpsertDone,
    void Function(CategoryEntity)? onCategoryFound,
  })  : _onUpsertDone = onUpsertDone,
        _onCategoryFound = onCategoryFound {
    Module.initialize(
      this,
      ($) => $
        ..attach(_pipeline)
        ..attach(_outgoingPipeline),
    );
  }
}
