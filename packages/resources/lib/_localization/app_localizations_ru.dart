import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get transactions => 'Транзакции';

  @override
  String get editTransaction => 'Редактировать транзакцию';

  @override
  String get createTransaction => 'Создать транзакцию';

  @override
  String get editCategory => 'Редактировать категорию';

  @override
  String get createCategory => 'Создать категорию';

  @override
  String get createCategoryDoubleLine => 'Создать\nкатегорию';

  @override
  String get balance => 'Баланс';

  @override
  String get errorEmptyField => 'Поле не может быть пустым';

  @override
  String get errorWrongDecimal => 'Введите корректное значение';

  @override
  String get categoryLimit => 'Введите ограничение для категории';

  @override
  String get categoryLimitHint => 'Опционально, можно не указывать';

  @override
  String get save => 'Сохранить';

  @override
  String get create => 'Создать';

  @override
  String get selectCategory => 'Выбор категории';

  @override
  String get categoryNameExample => 'Примеры: Питание; Работа; Такси';

  @override
  String get transactionName => 'Описание транзакции';

  @override
  String get transactionNameExample => 'Пример: Пропил в баре';

  @override
  String get successful => 'Успешно';

  @override
  String get error => 'Ошибка';

  @override
  String get transactionAmount => 'Сумма транзакции';

  @override
  String get transactionAmountHint => 'Примеры: 100; -200; 2.28';

  @override
  String get categoryLabel => 'Категория:';

  @override
  String get categoryName => 'Название категории';
}
