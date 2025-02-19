import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import '_localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ru')
  ];

  /// No description provided for @transactions.
  ///
  /// In ru, this message translates to:
  /// **'Транзакции'**
  String get transactions;

  /// No description provided for @editTransaction.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать транзакцию'**
  String get editTransaction;

  /// No description provided for @createTransaction.
  ///
  /// In ru, this message translates to:
  /// **'Создать транзакцию'**
  String get createTransaction;

  /// No description provided for @editCategory.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать категорию'**
  String get editCategory;

  /// No description provided for @createCategory.
  ///
  /// In ru, this message translates to:
  /// **'Создать категорию'**
  String get createCategory;

  /// No description provided for @createCategoryDoubleLine.
  ///
  /// In ru, this message translates to:
  /// **'Создать\nкатегорию'**
  String get createCategoryDoubleLine;

  /// No description provided for @balance.
  ///
  /// In ru, this message translates to:
  /// **'Баланс'**
  String get balance;

  /// No description provided for @errorEmptyField.
  ///
  /// In ru, this message translates to:
  /// **'Поле не может быть пустым'**
  String get errorEmptyField;

  /// No description provided for @errorWrongDecimal.
  ///
  /// In ru, this message translates to:
  /// **'Введите корректное значение'**
  String get errorWrongDecimal;

  /// No description provided for @categoryLimit.
  ///
  /// In ru, this message translates to:
  /// **'Введите ограничение для категории'**
  String get categoryLimit;

  /// No description provided for @categoryLimitHint.
  ///
  /// In ru, this message translates to:
  /// **'Опционально, можно не указывать'**
  String get categoryLimitHint;

  /// No description provided for @save.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;

  /// No description provided for @create.
  ///
  /// In ru, this message translates to:
  /// **'Создать'**
  String get create;

  /// No description provided for @selectCategory.
  ///
  /// In ru, this message translates to:
  /// **'Выбор категории'**
  String get selectCategory;

  /// No description provided for @categoryNameExample.
  ///
  /// In ru, this message translates to:
  /// **'Примеры: Питание; Работа; Такси'**
  String get categoryNameExample;

  /// No description provided for @transactionName.
  ///
  /// In ru, this message translates to:
  /// **'Описание транзакции'**
  String get transactionName;

  /// No description provided for @transactionNameExample.
  ///
  /// In ru, this message translates to:
  /// **'Пример: Пропил в баре'**
  String get transactionNameExample;

  /// No description provided for @successful.
  ///
  /// In ru, this message translates to:
  /// **'Успешно'**
  String get successful;

  /// No description provided for @error.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка'**
  String get error;

  /// No description provided for @transactionAmount.
  ///
  /// In ru, this message translates to:
  /// **'Сумма транзакции'**
  String get transactionAmount;

  /// No description provided for @transactionAmountHint.
  ///
  /// In ru, this message translates to:
  /// **'Примеры: 100; -200; 2.28'**
  String get transactionAmountHint;

  /// No description provided for @categoryLabel.
  ///
  /// In ru, this message translates to:
  /// **'Категория:'**
  String get categoryLabel;

  /// No description provided for @categoryName.
  ///
  /// In ru, this message translates to:
  /// **'Название категории'**
  String get categoryName;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
