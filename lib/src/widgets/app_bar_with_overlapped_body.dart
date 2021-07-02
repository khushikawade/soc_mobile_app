import 'package:app/src/services/utility.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/widgets/models/custom_app_bar.dart';
import 'package:app/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class OverlappedAppBar extends StatefulWidget {
  final Widget body;
  final scaffoldKey;
  final Drawer? drawer;
  final CustomAppBar customAppBar;
  final double? topOverFlow;
  OverlappedAppBar(
      {Key? key,
      required this.body,
      this.topOverFlow,
      this.drawer,
      this.scaffoldKey,
      required this.customAppBar})
      : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<OverlappedAppBar> {
  final double _kAppBarHeight = 213.0;

  @override
  Widget build(BuildContext context) {
    double _topOverFlow = widget.topOverFlow ?? 0;

    return Scaffold(
        key: widget.scaffoldKey,
        body: Stack(
          children: [
            Container(
              color: Theme.of(context).appBarTheme.color,
              child: SizedBox(
                height: 213,
                width: Utility.displayWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 50),
                        child: widget.customAppBar.leading ?? Container()),
                    SpacerWidget(16.0),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: AppTheme.kBodyPadding),
                      child: Text(
                        widget.customAppBar.title ?? '',
                        style: TextStyle(
                            color:
                                Theme.of(context).appBarTheme.foregroundColor,
                            fontSize: AppTheme.kTitleFontSize),
                      ),
                    ),
                    SpacerWidget(3.0),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: AppTheme.kBodyPadding),
                      child: Text(widget.customAppBar.subtitle ?? '',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              color:
                                  Theme.of(context).appBarTheme.foregroundColor,
                              fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: _kAppBarHeight - _topOverFlow),
                child: widget.body)
          ],
        ));
  }
}
