import 'package:flutter/material.dart';

class CommonBackGroundImgWidget extends StatelessWidget {
  const CommonBackGroundImgWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Align(
          alignment: Alignment.topRight,
          child: Image(
            height: 250,
              color: Color(0xff000000) == Theme.of(context).backgroundColor
                  ? Colors.white
                  : Color.fromARGB(255, 0, 0, 0),
              fit: BoxFit.fitWidth,
              image: AssetImage("assets/images/ocr_background.png"))),
    );
  }
}
