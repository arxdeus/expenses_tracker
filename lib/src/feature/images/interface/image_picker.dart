import 'dart:typed_data';

typedef BytesWithExt = ({Uint8List bytes, String originExtension});
typedef StreamWithExt = ({Stream<Uint8List> stream, String originExtension});

abstract class ImagePickerDataProviderInterface {
  Future<BytesWithExt?> pickFile();
  Future<StreamWithExt?> readFile();
}
