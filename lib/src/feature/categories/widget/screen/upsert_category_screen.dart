import 'package:expenses_tracker/src/feature/categories/modules/category_upsert_module.dart';
import 'package:expenses_tracker/src/feature/dependencies/widget/dependencies_scope.dart';
import 'package:expenses_tracker/src/feature/images/widget/avatar_picker.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';
import 'package:expenses_tracker/src/shared/widget/button/button_with_shadow.dart';
import 'package:expenses_tracker/src/shared/widget/icon_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';
import 'package:resources/_localization/extension.dart';
import 'package:resources/resources.dart';

/// {@template create_category_screen}
/// UpsertCategoryScreen widget.
/// {@endtemplate}
class UpsertCategoryScreen extends StatefulWidget {
  /// {@macro create_category_screen}
  const UpsertCategoryScreen({
    super.key, // ignore: unused_element
    this.uuid,
  });

  final String? uuid;

  @override
  State<UpsertCategoryScreen> createState() => _UpsertCategoryScreenState();
}

/// State for widget CreateCategoryScreen.
class _UpsertCategoryScreenState extends State<UpsertCategoryScreen> {
  late final CategoryUpsertModule _module = CategoryUpsertModule(
    categoryUuid: widget.uuid,
    categoryUpdatesDataRepository: DependenciesScope.of(context).categoriesUpdatesDataRepository,
    categoryGetSingle: DependenciesScope.of(context).categoriesDataProvider,
    onCategoryFound: (category) {
      _inputNameController.text = category.meta.name;
      _imageUrl.value = category.meta.imageUrl;
    },
    onUpsertDone: () => Future.delayed(
      Duration(milliseconds: 400),
      () {
        if (mounted) context.pop();
      },
    ),
  );

  final _inputNameController = TextEditingController();
  final _inputLimitAmountController = TextEditingController();
  final ValueNotifier<String?> _imageUrl = ValueNotifier(null);

  bool get _isEditingMode => widget.uuid != null;

  String? _nameValidator(BuildContext context, String? value) {
    final errorMsg = context.localization.errorEmptyField;
    if (value == null || value.isEmpty) return errorMsg;
  }

  String? _limitAmountValidator(BuildContext context, String? value) {
    final validNumErrorMsg = context.localization.categoryLimit;
    if (value == null || value.isEmpty) return null;
    try {
      final _ = Decimal.parse(value);
    } on Object {
      return validNumErrorMsg;
    }
  }

  void _onCreateTap(BuildContext context) {
    final isFormValid = Form.of(context).validate();
    if (isFormValid) {
      _module.upsertCategory(
        (
          uuid: widget.uuid,
          name: _inputNameController.text,
          imageUrl: _imageUrl.value,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 200),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                spacing: 16,
                children: [
                  FittedBox(
                    child: Text(
                      _isEditingMode
                          ? context.localization.editCategory
                          : context.localization.createCategory,
                      style: TextStyle(
                        height: 1,
                        fontFamily: FontFamily.euclidFlex,
                        color: Colors.black,
                        fontSize: 256,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: AvatarPicker(
                          imageNotifier: _imageUrl,
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 20,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => _nameValidator(context, value),
                          controller: _inputNameController,
                          style: TextStyle(
                            height: 1,
                            fontFamily: FontFamily.euclidFlex,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              height: 1,
                              fontFamily: FontFamily.euclidFlex,
                              color: Colors.grey,
                            ),
                            alignLabelWithHint: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color.fromARGB(255, 67, 41, 236), width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            label: Text(
                              context.localization.categoryName,
                              style: TextStyle(
                                height: 1,
                                fontFamily: FontFamily.euclidFlex,
                                color: Colors.black,
                              ),
                            ),
                            hintText: context.localization.categoryNameExample,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _inputLimitAmountController,
                    validator: (value) => _limitAmountValidator(context, value),
                    style: TextStyle(
                      height: 1,
                      fontFamily: FontFamily.comfortaa,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        height: 1,
                        fontFamily: FontFamily.euclidFlex,
                        color: Colors.grey,
                      ),
                      alignLabelWithHint: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 67, 41, 236), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      label: Text(
                        context.localization.categoryLimit,
                        style: TextStyle(
                          height: 1,
                          fontFamily: FontFamily.euclidFlex,
                          color: Colors.black,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
                      hintText: context.localization.categoryLimitHint,
                    ),
                  ),
                  StoreBuilder(
                    unit: _module.isLoading,
                    builder: (context, state, _) => ButtonWithShadow(
                      width: switch (state) {
                        CategoryUpsertState.idle => MediaQuery.sizeOf(context).width,
                        CategoryUpsertState.processing => 65,
                        _ => 200,
                      },
                      color: switch (state) {
                        CategoryUpsertState.successful => Colors.green,
                        CategoryUpsertState.error => Colors.red,
                        _ => Color(0xFF5038ED),
                      },
                      onTap: switch (state) {
                        CategoryUpsertState.idle => () => _onCreateTap(context),
                        _ => null,
                      },
                      child: switch (state) {
                        CategoryUpsertState.idle => Text(
                            _isEditingMode
                                ? context.localization.save
                                : context.localization.create,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: FontFamily.euclidFlex,
                              fontSize: 18,
                            ),
                          ),
                        CategoryUpsertState.processing => CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        CategoryUpsertState.successful => IconText(
                            text: context.localization.successful,
                            icon: Icons.check,
                          ),
                        CategoryUpsertState.error => IconText(
                            text: context.localization.error,
                            icon: Icons.error_outline_outlined,
                          ),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _module.dispose();
    _inputLimitAmountController.dispose();
    _inputNameController.dispose();
    super.dispose();
  }
}
