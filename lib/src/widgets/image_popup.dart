import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

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
  // static const double _kLableSpacing = 10.0;
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
            // margin: const EdgeInsets.only(
            //     top: 20, left: 20.0, right: 20, bottom: 20),
            // height: MediaQuery.of(context).size.height * 0.6,
            decoration: ShapeDecoration(
                // color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SpacerWidget(30),
                  InteractiveViewer(
                    panEnabled: true, // Set it to false
                    clipBehavior: Clip.none,
                    // boundaryMargin: EdgeInsets.all(100),
                    minScale: 0.5,
                    maxScale: 5,
                    child: CustomIconWidget(
                      iconUrl: widget.imageURL,
                      height: Utility.displayHeight(context) *
                          (AppTheme.kDetailPageImageHeightFactor / 100),
                    ),
                  ),
                  SpacerWidget(40),
                  Container(
                      // margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.transparent,
                          border: Border.all(width: 2, color: Colors.white)),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
