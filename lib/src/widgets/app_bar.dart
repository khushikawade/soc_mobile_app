import 'package:app/src/overrides.dart';
import 'package:app/src/styles/theme.dart';
import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBarWidget({Key? key})
      : preferredSize = Size.fromHeight(40.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarWidgetState createState() => _CustomAppBarWidgetState();
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  static const double _kLabelSpacing = 15.0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: _kLabelSpacing / 2,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              const IconData(0xe80d,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
              color: Color(0xff171717),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
