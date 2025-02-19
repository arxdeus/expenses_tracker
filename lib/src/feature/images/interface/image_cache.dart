import 'dart:typed_data';

abstract class FileCacheDataProviderInteface {
  /// Returns key of saved file
  Future<String> saveByUrl(
    String path,
  );

  Future<String> saveBytes(
    Uint8List bytes,
    String originExtension,
  );

  Future<String> saveBytesStream(
    Stream<Uint8List> stream,
    String originExtension,
  );

  Future<String> retrieveByKey(String key);
}
