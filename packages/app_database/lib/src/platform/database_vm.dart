import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:drift/native.dart' as ffi;
import 'package:flutter/foundation.dart';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;

@internal
Future<QueryExecutor> $createQueryExecutor({
  String? path,
  bool logStatements = false,
  bool dropDatabase = false,
  bool memoryDatabase = false,
}) async {
  // Put this somewhere before you open your first VmDatabase

  if (kDebugMode) {
    // Close existing instances for hot restart
    try {
      ffi.NativeDatabase.closeExistingInstances();
    } on Object catch (e, _) {
      print(
        "Can't close existing database instances, error: $e",
      );
    }
  }

  if (memoryDatabase) {
    return ffi.NativeDatabase.memory(
      logStatements: logStatements,
      /* setup: (db) {}, */
    );
  }
  io.File file;
  if (path == null) {
    try {
      final dbFolder = await pp.getApplicationDocumentsDirectory();

      file = io.File(p.join(dbFolder.path, 'app.db'));
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace('Failed to get application documents directory "$error"', stackTrace);
    }
  } else {
    file = io.File(path);
  }
  try {
    if (dropDatabase && file.existsSync()) {
      await file.delete();
    }
  } on Object catch (e, _) {
    print("Can't delete database file: $file, error: $e");
    rethrow;
  }
  /* return ffi.NativeDatabase(
    file,
    logStatements: logStatements,
    /* setup: (db) {}, */
  ); */
  return ffi.NativeDatabase.createInBackground(
    file,
    logStatements: logStatements,
    /* setup: (db) {}, */
  );
}
