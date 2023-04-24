import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommonBackgroundImgWidget extends StatelessWidget {
  const CommonBackgroundImgWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff000000) != Theme.of(context).backgroundColor
          ? Color(0xffF7F8F9)
          : Color(0xff111C20),
      child: Align(
          alignment: Alignment.topRight,
          child: Image(
              height: 250,
              color:
                  // Theme.of(context).colorScheme.primaryContainer,
                  Color(0xff000000) == Theme.of(context).backgroundColor
                      ? Colors.white
                      : Colors.black,
              fit: BoxFit.fitWidth,
              image: AssetImage("assets/images/ocr_background.png"))),
    );
  }
}
