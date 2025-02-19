import 'package:app_core/app_core.dart';
import 'package:expenses_tracker/src/feature/app/routes.dart';
import 'package:expenses_tracker/src/feature/categories/model/category_detailed_entity.dart';
import 'package:expenses_tracker/src/feature/dependencies/widget/dependencies_scope.dart';
import 'package:expenses_tracker/src/feature/transactions/modules/upsert/transaction_upsert_module.dart';
import 'package:expenses_tracker/src/shared/model/decimal.dart';
import 'package:expenses_tracker/src/shared/widget/button/button_with_shadow.dart';
import 'package:expenses_tracker/src/shared/widget/icon_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';
import 'package:pure/pure.dart';
import 'package:resources/_localization/extension.dart';
import 'package:resources/resources.dart';

/// {@template create_transaction_screen}
/// CreateTransactionScreen widget.
/// {@endtemplate}
class UpsertTransactionScreen extends StatefulWidget {
  /// {@macro create_transaction_screen}
  const UpsertTransactionScreen({
    super.key, // ignore: unused_element
    this.uuid,
  });

  final String? uuid;

  @override
  State<UpsertTransactionScreen> createState() => _UpsertTransactionScreenState();
}

/// State for widget CreateTransactionScreen.
class _UpsertTransactionScreenState extends State<UpsertTransactionScreen> {
  final _inputNameController = TextEditingController();
  final _inputAmountController = TextEditingController();
  late final ValueNotifier<CategoryEntity> _selectedCategory = ValueNotifier(InternalEmptyCategory());

  bool get _isEditingMode => widget.uuid != null;

  late final _module = TransactionUpsertModule(
    transactionUuid: widget.uuid,
    transactionGetSingle: DependenciesScope.of(context).transactionHistoryProvider,
    transactionUpdatesDataRepository: DependenciesScope.of(context).transactionUpdatesDataRepository,
    onTransactionFound: (transaction) {
      _inputNameController.text = transaction.meta.description;
      _selectedCategory.value = transaction.meta.category ?? InternalEmptyCategory();
      _inputAmountController.text = transaction.meta.amount.toString();
    },
    onUpsertDone: () => Future.delayed(
      Duration(milliseconds: 400),
      () {
        if (mounted) context.pop();
      },
    ),
  );

  String? _amountValidator(BuildContext context, String? value) {
    const errorMsg = 'Введите корректную сумму транзакции';
    if (value == null) return errorMsg;
    try {
      final amount = Decimal.parse(value);
      if (amount.integerValue == 0 && amount.fractionalValue == 0) return errorMsg;
      return null;
    } on Object {
      return errorMsg;
    }
  }

  Future<void> _onSelectCategory() async {
    final category = await Routes.selectCategory.push<CategoryEntity>(context);
    if (category == null || !mounted) return;
    await Future<void>.delayed(kThemeAnimationDuration);
    if (mounted) _selectedCategory.value = category;
  }

  void _onCreateTap(BuildContext context) {
    final isFormValid = Form.of(context).validate();
    if (isFormValid) {
      _module.upsertTransaction(
        (
          uuid: widget.uuid,
          description: _inputNameController.text,
          rawAmount: Decimal.parse(_inputAmountController.text),
          categoryUuid: _selectedCategory.value.uuid,
          updatedAt: DateTime.now(),
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
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                spacing: 16,
                children: [
                  FittedBox(
                    child: Text(
                      _isEditingMode ? context.localization.editTransaction : context.localization.createTransaction,
                      style: TextStyle(
                        height: 1,
                        fontFamily: FontFamily.euclidFlex,
                        color: Colors.black,
                        fontSize: 256,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextFormField(
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
                        borderSide: BorderSide(color: Color.fromARGB(255, 67, 41, 236), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      label: Text(
                        context.localization.transactionName,
                        style: TextStyle(
                          height: 1,
                          fontFamily: FontFamily.euclidFlex,
                          color: Colors.black,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
                      hintText: context.localization.transactionNameExample,
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => _amountValidator(context, value),
                    controller: _inputAmountController,
                    style: TextStyle(
                      height: 1,
                      fontFamily: FontFamily.comfortaa,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        height: 1,
                        fontFamily: FontFamily.comfortaa,
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
                        context.localization.transactionAmount,
                        style: TextStyle(
                          height: 1,
                          fontFamily: FontFamily.euclidFlex,
                          color: Colors.black,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
                      hintText: context.localization.transactionAmountHint,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: .3,
                      child: FittedBox(
                        child: Text(
                          context.localization.categoryLabel,
                          style: TextStyle(
                            height: 1,
                            fontFamily: FontFamily.euclidFlex,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _selectedCategory,
                    builder: (context, category, _) => AnimatedSwitcher(
                      duration: kThemeAnimationDuration,
                      child: ListTile(
                        key: ValueKey(category.uuid),
                        onTap: _onSelectCategory,
                        title: Text(
                          category.meta.name,
                          style: TextStyle(
                            height: 1,
                            fontFamily: FontFamily.euclidFlex,
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: category.meta.imageUrl?.pipe(ImageLink.local).toImageProvider(),
                        ),
                      ),
                    ),
                  ),
                  StoreBuilder(
                    store: _module.isLoading,
                    builder: (context, state, _) => ButtonWithShadow(
                      width: switch (state) {
                        TransactionUpsertState.idle => MediaQuery.sizeOf(context).width,
                        TransactionUpsertState.processing => 65,
                        _ => 200,
                      },
                      color: switch (state) {
                        TransactionUpsertState.successful => Colors.green,
                        TransactionUpsertState.error => Colors.red,
                        _ => Color(0xFF5038ED),
                      },
                      onTap: switch (state) {
                        TransactionUpsertState.idle => () => _onCreateTap(context),
                        _ => null,
                      },
                      child: switch (state) {
                        TransactionUpsertState.idle => Text(
                            _isEditingMode ? context.localization.save : context.localization.create,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: FontFamily.euclidFlex,
                              fontSize: 18,
                            ),
                          ),
                        TransactionUpsertState.processing => CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        TransactionUpsertState.successful => IconText(
                            text: context.localization.successful,
                            icon: Icons.check,
                          ),
                        TransactionUpsertState.error => IconText(
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
    _selectedCategory.dispose();
    _inputAmountController.dispose();
    _inputNameController.dispose();
    super.dispose();
  }
}
