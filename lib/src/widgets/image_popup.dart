import 'package:Soc/src/globals.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class ImagePopup extends StatefulWidget {
  final String imageURL;
  @override
  ImagePopup({
    Key? key,
    required this.imageURL,
  }) : super(key: key);
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
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
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
                      imageProvider: NetworkImage(widget.imageURL),
                      maxScale: PhotoViewComputedScale.covered,
                      initialScale: PhotoViewComputedScale.contained * 0.8,
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      loadingBuilder: (context, event) {
                        if (event == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
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
                          initialScale: 0.0,
                          minScale: 0.3,
                          maxScale: 10.0,
                          imageProvider: NetworkImage(
                            Globals.splashImageUrl ??
                                Globals.homeObject["App_Logo__c"],
                          ),
                        ));
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.2),
                      child: Container(
                          // margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.transparent,
                              border:
                                  Border.all(width: 2, color: Colors.white)),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.white,
                              size: Globals.deviceType == "phone" ? 28 : 36,
                            ),
                          )),
                    ),
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
