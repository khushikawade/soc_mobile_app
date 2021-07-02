import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Theme.of(context).appBarTheme.iconTheme!.color,
     // padding: EdgeInsets.only(left: 0, top: 15, right: 15, bottom: 15) ,
        icon: Icon(
          Icons.keyboard_arrow_left,
          size: 45,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }
}
