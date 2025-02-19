import 'dart:async';
import 'dart:io';

import 'package:app_database/app_database.dart';
import 'package:expenses_tracker/src/feature/images/interface/image_cache.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalCacheDatabaseDataProvider implements FileCacheDataProviderInteface {
  final String Function() _genUuid;
  final AppDatabase _database;
  String? _initialSavePath;

  LocalCacheDatabaseDataProvider({
    required AppDatabase database,
    required String Function() genUuid,
    String? initialSavePath,
  })  : _genUuid = genUuid,
        _database = database,
        _initialSavePath = initialSavePath;

  FutureOr<String> get _cachedSavePath =>
      _initialSavePath ??
      getApplicationCacheDirectory().then(
        (value) => _initialSavePath = value.path,
      );

  @override
  Future<String> retrieveByKey(String key) async {
    final image = await (_database.images.select()..where((image) => image.uuid.equals(key))).getSingle();
    return image.path;
  }

  @override
  Future<String> saveByUrl(String path) async {
    final url = Uri.parse(path);
    if (url.host.isNotEmpty) throw ArgumentError.value(path, '$runtimeType supports only local files');

    final file = File(path);
    if (!file.existsSync()) throw StateError('$file does not exists');

    final originExtension = p.extension(path);

    return saveBytesStream(
      file.openRead().cast(),
      originExtension,
    );
  }

  @override
  Future<String> saveBytes(Uint8List bytes, String originalExtension) => saveBytesStream(
        Stream.value(bytes),
        originalExtension,
      );

  @override
  Future<String> saveBytesStream(Stream<Uint8List> stream, String originExtension) async {
    final cacheFolder = await _cachedSavePath;
    final newFilePath = StringBuffer(cacheFolder)
      ..write(p.Style.platform)
      ..write(_genUuid())
      ..write(originExtension);

    final newFile = await File(newFilePath.toString()).create();
    final newFileStream = newFile.openWrite();

    await newFileStream.addStream(stream);
    await newFileStream.flush();
    await newFileStream.close();

    final image = await _database.images.insertReturning(
      ImagesCompanion.insert(path: newFile.path),
    );

    return image.path;
  }
}
