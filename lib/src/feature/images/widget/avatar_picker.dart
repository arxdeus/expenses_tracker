import 'package:app_core/app_core.dart';
import 'package:expenses_tracker/src/feature/dependencies/widget/dependencies_scope.dart';
import 'package:expenses_tracker/src/feature/images/modules/image_picker_module.dart';
import 'package:flutter/material.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';
import 'package:pure/pure.dart';

/// {@template avatar_picker}
/// AvatarPicker widget.
/// {@endtemplate}
class AvatarPicker extends StatefulWidget {
  /// {@macro avatar_picker}
  const AvatarPicker({
    this.initialLink,
    this.onImageChanged,
    super.key, // ignore: unused_element
  });

  final String? initialLink;
  final ValueChanged<String?>? onImageChanged;

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

/// State for widget AvatarPicker.
class _AvatarPickerState extends State<AvatarPicker> {
  late final _module = ImagePickerModule(
    picker: DependenciesScope.of(context).imagePickerDataProvider,
    fileCache: DependenciesScope.of(context).fileCacheDataProvider,
    initialImage: widget.initialLink,
  );

  late final _adapter = ListenableAdapter(_module.imageLink);

  void _callback() => widget.onImageChanged?.call(_module.imageLink.value);

  @override
  void initState() {
    super.initState();
    if (widget.onImageChanged != null) {
      _adapter.addListener(_callback);
    }
  }

  @override
  Widget build(BuildContext context) => StoreBuilder(
        store: _module.imageLink,
        builder: (context, imageLink, _) => GestureDetector(
          onTap: _module.pickImage.call,
          behavior: HitTestBehavior.opaque,
          child: CircleAvatar(
            minRadius: 17,
            maxRadius: 48,
            backgroundColor: imageLink == null ? Colors.blueAccent.withAlpha(50) : null,
            foregroundImage: imageLink?.pipe(ImageLink.local).toImageProvider(),
            child: Icon(
              Icons.photo_outlined,
              color: Colors.blueAccent,
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _adapter.removeListener(_callback);
    _module.dispose();
    super.dispose();
  }
}
