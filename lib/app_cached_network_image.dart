import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCachedNetworkImage extends StatelessWidget {
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double radius;
  final String imageUrl;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    required this.radius,
    this.loadingWidget,
    this.errorWidget,
    this.fit,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: _createImageWidget(context: context),
    );
  }

  Widget _createImageWidget({required BuildContext context}) {
    final uri = Uri.parse(imageUrl);
    final isFileUri = (uri.scheme == "file");
    if (isFileUri) {
      return Image.file(File(uri.path), width: width, height: height);
    } else {
      return CachedNetworkImage(
        height: height,
        width: width,
        fit: fit,
        imageUrl: imageUrl,
        placeholder: (context, url) =>
            loadingWidget ?? const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            errorWidget ?? const Icon(Icons.error),
      );
    }
  }
}
