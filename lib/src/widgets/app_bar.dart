import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:flutter/material.dart';

import '../overrides.dart';

class CustomAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBarWidget({Key? key, this.islinearProgress})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);
  bool? islinearProgress = false;
  @override
  final Size preferredSize;

  @override
  _CustomAppBarWidgetState createState() => _CustomAppBarWidgetState();
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  static const double _kLabelSpacing = 15.0;
  static const double _kIconSize = 50.0;
  double lineProgress = 0.0;

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
                const IconData(0xe80d,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: Color(0xff171717),
                size: 20,
              ),
            ),
          ),
        ],
      ),
      title: SizedBox(width: 100.0, height: 60.0, child: BearIconWidget()),
      bottom: PreferredSize(
        child: _progressBar(lineProgress, context),
        preferredSize: Size.fromHeight(3.0),
      ),
    );
  }

  _progressBar(double progress, BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.white70.withOpacity(0),
      value: progress == 1.0 ? 0 : progress,
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}
