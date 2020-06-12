import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './gallery_Item_model.dart';

// to show image in Row 
class GalleryItemThumbnail extends StatelessWidget {
  const GalleryItemThumbnail({Key key, this.galleryItem, this.onTap})
      : super(key: key);

  final GalleryItemModel galleryItem;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryItem.id,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: galleryItem.imageUrl,
            height: 100.0,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
