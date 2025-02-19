import 'package:expenses_tracker/src/feature/images/interface/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class ImagePickerReal implements ImagePickerDataProviderInterface {
  Future<XFile?> _pickXFile() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);

    return xfile;
  }

  @override
  Future<BytesWithExt?> pickFile() async {
    final xfile = await _pickXFile();
    if (xfile == null) return null;
    final originExtension = p.extension(xfile.path);
    final bytes = await xfile.readAsBytes();
    return (
      bytes: bytes,
      originExtension: originExtension,
    );
  }

  @override
  Future<StreamWithExt?> readFile() async {
    final xfile = await _pickXFile();
    if (xfile == null) return null;
    final originExtension = p.extension(xfile.path);
    final stream = xfile.openRead();
    return (
      stream: stream,
      originExtension: originExtension,
    );
  }
}
