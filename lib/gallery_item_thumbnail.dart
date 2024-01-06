import 'package:flutter/material.dart';
import 'package:galleryimage/app_cached_network_image.dart';

import 'gallery_item_model.dart';

// to show image in Row
class GalleryItemThumbnail extends StatelessWidget {
  final GalleryItemModel galleryItem;
  final GestureTapCallback? onLongPress;
  final GestureTapCallback? onTap;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double radius;

  const GalleryItemThumbnail(
      {Key? key,
      required this.galleryItem,
      required this.onLongPress,
      required this.onTap,
      required this.radius,
      required this.loadingWidget,
      required this.errorWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Hero(
        tag: galleryItem.id,
        child: AppCachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: galleryItem.imageUrl,
          loadingWidget: loadingWidget,
          errorWidget: errorWidget,
          radius: radius,
        ),
      ),
    );
  }
}
