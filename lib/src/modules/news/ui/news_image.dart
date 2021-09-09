import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NewsImagePage extends StatefulWidget {
  
  final String imageURL;
  @override
  NewsImagePage({
    Key? key,
  
    required this.imageURL,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => NewsImagePageState();
}

class NewsImagePageState extends State<NewsImagePage>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;
  static const double _kLableSpacing = 10.0;
  static const double _kIconSize = 45.0;

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
            margin: const EdgeInsets.only(
                top: 20, left: 20.0, right: 20, bottom: 20),
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: ShapeDecoration(
                // color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child:InteractiveViewer(panEnabled: true, // Set it to false
              clipBehavior: Clip.none,
                // boundaryMargin: EdgeInsets.all(100),
                minScale: 0.5,
                maxScale: 5,
                child: CachedNetworkImage(
                            imageUrl: widget.imageURL,
                            // fit: BoxFit.fill,
                            placeholder: (context, url) => Container(
                                alignment: Alignment.center,
                                child: ShimmerLoading(
                                  isLoading: true,
                                  child: Container(
                                    width: _kIconSize * 1.4,
                                    height: _kIconSize * 1.5,
                                    color: Colors.white,
                                  ),
                                )),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
