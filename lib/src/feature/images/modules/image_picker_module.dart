import 'package:expenses_tracker/src/feature/images/interface/image_cache.dart';
import 'package:expenses_tracker/src/feature/images/interface/image_picker.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';

final class ImagePickerModule extends Module {
  final ImagePickerDataProviderInterface _picker;
  final FileCacheDataProviderInteface _fileCache;
  final String? _initialImage;

  late final imageLink = Store(this, _initialImage);
  late final isLoading = Store(this, false);

  late final pickImage = Trigger<()>(this);

  late final _pipeline = Pipeline.async(
    this,
    ($) => $
      ..bind(
        pickImage,
        _pickImage,
      ),
    transformer: eventTransformers.restartable,
  );

  Future<void> _pickImage(PipelineContext context, _) async {
    context.update(isLoading, true);
    final data = await _picker.readFile();
    if (data == null) return;
    if (context.isClosed) return;
    final file = await _fileCache.saveBytesStream(
      data.stream,
      data.originExtension,
    );
    if (context.isClosed) return;

    context.update(
      imageLink,
      file,
    );
    context.update(isLoading, false);
  }

  ImagePickerModule({
    required ImagePickerDataProviderInterface picker,
    required FileCacheDataProviderInteface fileCache,
    String? initialImage,
  })  : _initialImage = initialImage,
        _fileCache = fileCache,
        _picker = picker {
    Module.initialize(
      this,
      ($) => $..attach(_pipeline),
    );
  }
}
