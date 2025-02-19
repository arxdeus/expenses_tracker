import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:expenses_tracker/src/feature/app/router.dart';
import 'package:expenses_tracker/src/feature/app/widget/app_runner.dart';
import 'package:expenses_tracker/src/feature/dependencies/initialization/initialization_dev.dart';
import 'package:flutter/material.dart';

void main() async => logger.runLogging(
      () => runZonedGuarded<void>(
        () async {
          final dependencies = await DependencyInitializationDev().init(
            deferFirstFrame: true,
            onSuccess: (dependencies, time) => print('Initialization took $time (${time.inMilliseconds} ms)'),
            onProgress: (progress, message) => print('$message ($progress%)'),
          );

          runApp(
            AppRunner(
              dependencies: dependencies,
              router: AppGoRouter(),
            ),
          );
        },
        (e, s) => logger.error(
          'Error $e during initialization',
          error: e,
          stackTrace: s,
        ),
      ),
    );
