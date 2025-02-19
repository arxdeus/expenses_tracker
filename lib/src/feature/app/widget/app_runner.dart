import 'dart:ui';

import 'package:app_core/app_core.dart';
import 'package:expenses_tracker/src/feature/balance/modules/balance_updates_module.dart';
import 'package:expenses_tracker/src/feature/dependencies/model/dependencies.dart';
import 'package:expenses_tracker/src/feature/dependencies/widget/dependencies_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';
import 'package:resources/_localization/app_localizations.dart';

class AppRunner extends StatefulWidget {
  const AppRunner({
    required this.router,
    required this.dependencies,
    super.key,
  });

  final DependenciesBase dependencies;
  final AppRouter router;

  @override
  State<AppRunner> createState() => _AppRunnerState();
}

class _AppRunnerState extends State<AppRunner> {
  late final _router = widget.router.toRouter();

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
      dependencies: widget.dependencies,
      child: ModuleScope(
        create: (context) => BalanceUpdatesModule(
          updates: DependenciesScope.of(context).transactionUpdatesDataRepository,
          fetchLatest: DependenciesScope.of(context).balanceDataProviderDatabase,
        ),
        child: MaterialApp.router(
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          locale: Locale('ru', 'RU'),
          supportedLocales: [
            Locale('ru', 'RU'),
          ],
          routerConfig: _router,
          scrollBehavior: _AllowedScrollBehavior(),
          builder: (context, child) => Material(
            type: MaterialType.transparency,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _AllowedScrollBehavior extends MaterialScrollBehavior {
  @override
  late final Set<PointerDeviceKind> dragDevices = PointerDeviceKind.values.toSet();
}
