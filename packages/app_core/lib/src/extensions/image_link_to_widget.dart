import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:flutter/widgets.dart';

extension FlutterImageLinkExt on ImageLink {
  ImageProvider toImageProvider() => switch (this) {
    final ImageLinkLocal imageLink => imageLink.toFileImageProvider(),
    final ImageLinkNetwork imageLink => imageLink.toNetworkImageProvider(),
    final ImageLinkAssets imageLink => imageLink.toAssetImageProvider(),
  };

  Image toImage({
    Key? key,
    double scale = 1.0,
    Widget Function(BuildContext, Widget, int?, bool)? frameBuilder,
    Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    FilterQuality filterQuality = FilterQuality.low,
    bool isAntiAlias = false,
    int? cacheWidth,
    int? cacheHeight,
  }) => switch (this) {
    final ImageLinkLocal imageLink => imageLink.toFileImage(
      scale: scale,
      filterQuality: filterQuality,
      fit: fit,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      excludeFromSemantics: excludeFromSemantics,
      opacity: opacity,
      cacheHeight: cacheHeight,
      cacheWidth: cacheWidth,
      centerSlice: centerSlice,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      width: width,
      height: height,
      repeat: repeat,
      isAntiAlias: isAntiAlias,
      semanticLabel: semanticLabel,
      gaplessPlayback: gaplessPlayback,
      key: key,
      matchTextDirection: matchTextDirection,
    ),
    final ImageLinkNetwork imageLink => imageLink.toNetworkImage(
      scale: scale,
      filterQuality: filterQuality,
      fit: fit,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      excludeFromSemantics: excludeFromSemantics,
      opacity: opacity,
      cacheHeight: cacheHeight,
      cacheWidth: cacheWidth,
      centerSlice: centerSlice,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      width: width,
      height: height,
      repeat: repeat,
      isAntiAlias: isAntiAlias,
      semanticLabel: semanticLabel,
      gaplessPlayback: gaplessPlayback,
      key: key,
      matchTextDirection: matchTextDirection,
    ),
    final ImageLinkAssets imageLink => imageLink.toAssetImage(
      scale: scale,
      filterQuality: filterQuality,
      fit: fit,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      excludeFromSemantics: excludeFromSemantics,
      opacity: opacity,
      cacheHeight: cacheHeight,
      cacheWidth: cacheWidth,
      centerSlice: centerSlice,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      width: width,
      height: height,
      repeat: repeat,
      isAntiAlias: isAntiAlias,
      semanticLabel: semanticLabel,
      gaplessPlayback: gaplessPlayback,
      key: key,
      matchTextDirection: matchTextDirection,
    ),
  };
}

extension FlutterImageLinkNetwork on ImageLinkNetwork {
  NetworkImage toNetworkImageProvider({double scale = 1.0, Map<String, String>? headers}) =>
      NetworkImage(imageUrl, scale: scale, headers: headers);

  Image toNetworkImage({
    Key? key,
    double scale = 1.0,
    Widget Function(BuildContext, Widget, int?, bool)? frameBuilder,
    Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    FilterQuality filterQuality = FilterQuality.low,
    bool isAntiAlias = false,
    Map<String, String>? headers,
    int? cacheWidth,
    int? cacheHeight,
  }) => Image.network(
    imageUrl,
    scale: scale,
    filterQuality: filterQuality,
    fit: fit,
    frameBuilder: frameBuilder,
    errorBuilder: errorBuilder,
    loadingBuilder: loadingBuilder,
    excludeFromSemantics: excludeFromSemantics,
    opacity: opacity,
    cacheHeight: cacheHeight,
    cacheWidth: cacheWidth,
    centerSlice: centerSlice,
    color: color,
    colorBlendMode: colorBlendMode,
    alignment: alignment,
    width: width,
    headers: headers,
    height: height,
    repeat: repeat,
    isAntiAlias: isAntiAlias,
    semanticLabel: semanticLabel,
    gaplessPlayback: gaplessPlayback,
    key: key,
    matchTextDirection: matchTextDirection,
  );
}

extension FlutterImageLinkAsset on ImageLinkAssets {
  AssetImage toAssetImageProvider({AssetBundle? bundle, String? package}) =>
      AssetImage(assetPath, bundle: bundle, package: package);

  Image toAssetImage({
    Key? key,
    AssetBundle? bundle,
    String? package,
    double scale = 1.0,
    Widget Function(BuildContext, Widget, int?, bool)? frameBuilder,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    FilterQuality filterQuality = FilterQuality.low,
    bool isAntiAlias = false,
    int? cacheWidth,
    int? cacheHeight,
  }) => Image.asset(
    assetPath,
    scale: scale,
    bundle: bundle,
    package: package,
    filterQuality: filterQuality,
    fit: fit,
    frameBuilder: frameBuilder,
    errorBuilder: errorBuilder,
    excludeFromSemantics: excludeFromSemantics,
    opacity: opacity,
    cacheHeight: cacheHeight,
    cacheWidth: cacheWidth,
    centerSlice: centerSlice,
    color: color,
    colorBlendMode: colorBlendMode,
    alignment: alignment,
    width: width,
    height: height,
    repeat: repeat,
    isAntiAlias: isAntiAlias,
    semanticLabel: semanticLabel,
    gaplessPlayback: gaplessPlayback,
    key: key,
    matchTextDirection: matchTextDirection,
  );
}

extension FlutterImageLinkLocal on ImageLinkLocal {
  FileImage toFileImageProvider({double scale = 1.0}) => FileImage(File(path), scale: scale);

  Image toFileImage({
    Key? key,
    double scale = 1.0,
    Widget Function(BuildContext, Widget, int?, bool)? frameBuilder,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    FilterQuality filterQuality = FilterQuality.low,
    bool isAntiAlias = false,
    int? cacheWidth,
    int? cacheHeight,
  }) => Image.file(
    File(path),
    scale: scale,
    filterQuality: filterQuality,
    fit: fit,
    frameBuilder: frameBuilder,
    errorBuilder: errorBuilder,

    excludeFromSemantics: excludeFromSemantics,
    opacity: opacity,
    cacheHeight: cacheHeight,
    cacheWidth: cacheWidth,
    centerSlice: centerSlice,
    color: color,
    colorBlendMode: colorBlendMode,
    alignment: alignment,
    width: width,
    height: height,
    repeat: repeat,
    isAntiAlias: isAntiAlias,
    semanticLabel: semanticLabel,
    gaplessPlayback: gaplessPlayback,
    key: key,
    matchTextDirection: matchTextDirection,
  );
}
