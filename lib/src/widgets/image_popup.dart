import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePopup extends StatefulWidget {
  final bool? isOcrPage;
  final File? imageFile;
  final String imageURL;
  @override
  ImagePopup({Key? key, required this.imageURL, this.isOcrPage, this.imageFile})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => ImagePopupState();
}

class ImagePopupState extends State<ImagePopup>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 550));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });
    controller!.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                    child: PhotoView(
                      backgroundDecoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      imageProvider: widget.isOcrPage == true
                          ? FileImage(widget.imageFile!) as ImageProvider
                          : CachedNetworkImageProvider(widget.imageURL),
                      maxScale: PhotoViewComputedScale.covered,
                      initialScale: PhotoViewComputedScale.contained * 0.8,
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      loadingBuilder: (context, event) {
                        if (event == null) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }
                        return Container();
                      },
                      errorBuilder: (_, __, ___) {
                        return Center(
                            child: PhotoView(
                          backgroundDecoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          // initialScale: 0.0,
                          // minScale: 0.3,
                          // maxScale: 10.0,
                          maxScale: PhotoViewComputedScale.covered,
                          initialScale: PhotoViewComputedScale.contained * 0.8,
                          minScale: PhotoViewComputedScale.contained * 0.8,
                          imageProvider: CachedNetworkImageProvider(
                            Globals.splashImageUrl ??
                                Globals.appSetting.appLogoC,
                          ),
                        ));
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Container(
                        height: Globals.deviceType == "phone" ? 40 : null,
                        width: Globals.deviceType == "phone" ? 40 : null,
                        // margin: EdgeInsets.all(20),
                        // padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.transparent,
                            border: Border.all(width: 2, color: Colors.white)),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: Globals.deviceType == "phone" ? 25 : 30,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
