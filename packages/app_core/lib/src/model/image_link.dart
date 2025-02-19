sealed class ImageLink {
  const factory ImageLink.asset(String assetPath) = ImageLinkAssets._;
  const factory ImageLink.network(String url) = ImageLinkNetwork._;
  const factory ImageLink.local(String localPath) = ImageLinkLocal._;
}

class ImageLinkAssets implements ImageLink {
  final String assetPath;

  const ImageLinkAssets._(this.assetPath);
}

class ImageLinkNetwork implements ImageLink {
  final String imageUrl;

  const ImageLinkNetwork._(this.imageUrl);
}

class ImageLinkLocal implements ImageLink {
  final String path;

  const ImageLinkLocal._(this.path);
}
