library galleryimage;

import 'dart:math';

import 'package:flutter/material.dart';

import 'gallery_item_model.dart';
import 'gallery_item_thumbnail.dart';
import './gallery_image_view_wrapper.dart';
import './util.dart';

class GalleryImage extends StatefulWidget {
  final List<String> imageUrls;
  final String? titleGallery;
  final int numOfShowImages;
  final bool showTitleImage;
  final double? titleImageWidth;
  final double? titleImageHeight;

  final double gridHorizontalSpacing;
  final double gridVerticalSpacing;
  final int gridColumns;
  final BorderRadius thumbnailBorderRadius;

  const GalleryImage(
      {Key? key,
      required this.imageUrls,
      this.titleGallery,
      this.numOfShowImages = 3,
      this.showTitleImage = false,
      this.titleImageWidth,
      this.titleImageHeight,
      this.gridHorizontalSpacing = 5,
      this.gridVerticalSpacing = 5,
      this.gridColumns = 3,
      this.thumbnailBorderRadius = const BorderRadius.all(Radius.circular(8))})
      : super(key: key);
  @override
  State<GalleryImage> createState() => _GalleryImageState();
}

class _GalleryImageState extends State<GalleryImage> {
  List<GalleryItemModel> galleryItems = <GalleryItemModel>[];

  @override
  void initState() {
    buildItemsList(widget.imageUrls);
    super.initState();
  }

  @override
  void didUpdateWidget(GalleryImage oldWidget) {
    // Makes the widget update properly if imageUrls get changed
    if (oldWidget.imageUrls != widget.imageUrls) {
      buildItemsList(widget.imageUrls);
    }
  }

  @override
  Widget build(BuildContext context) {
    int galleryItemsWithoutTitleImage = widget.showTitleImage
      ? galleryItems.length - 1
      : galleryItems.length;
    int galleryIndexOffset = widget.showTitleImage ? 1 : 0;

    return Padding(
        padding: const EdgeInsets.all(10),
        child: galleryItems.isEmpty
            ? getEmptyWidget()
            : Column(
          children: [
            if (widget.showTitleImage) Container(
              //width: widget.titleImageWidth,
              height: widget.titleImageHeight,
              padding: EdgeInsets.only(bottom: widget.gridVerticalSpacing),
              child: ClipRRect(
                borderRadius: widget.thumbnailBorderRadius,
                child: GalleryItemThumbnail(
                  galleryItem: galleryItems[0],
                  onTap: () {
                    openImageFullScreen(0);
                  },
                ),
              ),
            ),
            if (galleryItemsWithoutTitleImage > 0) GridView.builder(
                primary: false,
                itemCount: min(
                  galleryItemsWithoutTitleImage,
                  widget.numOfShowImages
                ),
                padding: const EdgeInsets.all(0),
                semanticChildCount: 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.gridColumns,
                  mainAxisSpacing: widget.gridVerticalSpacing,
                  crossAxisSpacing: widget.gridHorizontalSpacing,
                ),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  int finalIndex = index + galleryIndexOffset;
                  return ClipRRect(
                      borderRadius: widget.thumbnailBorderRadius,
                      // if have less than 4 image w build GalleryItemThumbnail
                      // if have mor than 4 build image number 3 with number for other images
                      child: finalIndex < galleryItems.length - 1 &&
                          index == widget.numOfShowImages - 1
                          ? buildImageNumbers(finalIndex)
                          : GalleryItemThumbnail(
                        galleryItem: galleryItems[finalIndex],
                        onTap: () {
                          openImageFullScreen(finalIndex);
                        },
                      ));
                })
          ],
        ));
  }

// build image with number for other images
  Widget buildImageNumbers(int index) {
    return GestureDetector(
      onTap: () {
        openImageFullScreen(index);
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          GalleryItemThumbnail(
            galleryItem: galleryItems[index],
          ),
          Container(
            color: Colors.black.withOpacity(.7),
            child: Center(
              child: Text(
                "+${galleryItems.length - index}",
                style: const TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

// to open gallery image in full screen
  void openImageFullScreen(final int indexOfImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImageViewWrapper(
          titleGallery: widget.titleGallery,
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: indexOfImage,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

// clear and build list
  buildItemsList(List<String> items) {
    galleryItems.clear();
    for (var item in items) {
      galleryItems.add(
        GalleryItemModel(id: item, imageUrl: item),
      );
    }
  }
}
