import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:flutter/material.dart';

import '../overrides.dart';

class CustomAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBarWidget({Key? key})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarWidgetState createState() => _CustomAppBarWidgetState();
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  static const double _kLabelSpacing = 15.0;
  static const double _kIconSize = 50.0;

  @override
  Widget build(BuildContext context) {
    return // here the desired height
        AppBar(
      elevation: 0.0,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 10),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                const IconData(0xe813,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: Color(0xff171717),
                size: 20,
              ),
            ),
          ),
        ],
      ),
      title: SizedBox(width: 100.0, height: 50.0, child: BearIconWidget()),
    );
  }
}
