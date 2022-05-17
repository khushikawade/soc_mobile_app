import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/staff/ui/staff.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';

import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomOcrAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  CustomOcrAppBarWidget({
    Key? key,
    required this.isBackButton,
    this.isTitle
  })  : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  bool? isBackButton;
  bool? isTitle;

  @override
  final Size preferredSize;

  @override
  _CustomOcrAppBarWidgetState createState() => _CustomOcrAppBarWidgetState();
}

class _CustomOcrAppBarWidgetState extends State<CustomOcrAppBarWidget> {
  static const double _kLabelSpacing = 15.0;
  double lineProgress = 0.0;
  SharePopUp shareobj = new SharePopUp();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      
      leading: widget.isBackButton == true
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                IconData(0xe80d,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: AppTheme.kButtonColor,
              ),
            )
          : null,
      actions: [
        Container(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                setState(() {
                  Globals.hideBottomNavbar = false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StaffPage()),
                );
              },
              icon: Icon(
                IconData(0xe874,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: AppTheme.kButtonColor,
              ),
            )),
      ],
    );
  }
}
