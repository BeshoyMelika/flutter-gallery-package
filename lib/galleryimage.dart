library galleryimage;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoWidget extends StatefulWidget {
  final List<String> imageUrls;

  const GalleryPhotoWidget(this.imageUrls);
  @override
  _GalleryPhotoWidgetState createState() => _GalleryPhotoWidgetState();
}

class _GalleryPhotoWidgetState extends State<GalleryPhotoWidget> {
  List<GalleryItemModel> galleryItems = <GalleryItemModel>[];
  @override
  void initState() {
    buildItems(widget.imageUrls);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: galleryItems.isEmpty
            ? Container()
            : GridView.builder(
                primary: false,
                itemCount: galleryItems.length > 3 ? 3 : galleryItems.length,
                padding: EdgeInsets.all(0),
                semanticChildCount: 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 5),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: galleryItems.length > 3 && index == 2
                          ? GestureDetector(
                              onTap: () {
                                open(context, index);
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
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 40),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GalleryItemThumbnail(
                              galleryItem: galleryItems[index],
                              onTap: () {
                                open(context, index);
                              },
                            ));
                }));
  }

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  buildItems(List<String> items) {
    items.forEach((item) {
      galleryItems.add(
        GalleryItemModel(id: item, resource: item),
      );
    });
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    @required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<GalleryItemModel> galleryItems;
  final Axis scrollDirection;
  @override
  _GalleryPhotoViewWrapperState createState() =>
      _GalleryPhotoViewWrapperState();
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GALLERY"),
      ),
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: _buildItem,
          itemCount: widget.galleryItems.length,
          loadingBuilder: widget.loadingBuilder,
          backgroundDecoration: widget.backgroundDecoration,
          pageController: widget.pageController,
          // onPageChanged: onPageChanged,
          scrollDirection: widget.scrollDirection,
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final GalleryItemModel item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions.customChild(
      child: Container(
        child: CachedNetworkImage(
          imageUrl: item.resource,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 8,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }
}

class GalleryItemModel {
  GalleryItemModel({this.id, this.resource});

  final String id;
  final String resource;
}

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
            imageUrl: galleryItem.resource,
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
