import 'package:flutter/widgets.dart';
import 'package:resources/resources.dart';

extension BuildContextLocalizationExt on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this);
}
