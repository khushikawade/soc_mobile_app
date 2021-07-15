import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../overrides.dart';

class SocialEventDescriptionn extends StatefulWidget {
  SocialEventDescriptionn({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _SocialEventDescriptionnState createState() =>
      _SocialEventDescriptionnState();
}

class _SocialEventDescriptionnState extends State<SocialEventDescriptionn> {
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;

  // static const _knewsTextStyle = TextStyle(
  //   fontFamily: "Roboto Bold",
  //   fontSize: 16,
  //   color: AppTheme.kAccentColor,
  //   fontWeight: FontWeight.bold,
  // );

  // static const _kTimeStampStyle = TextStyle(
  //     fontFamily: "Roboto Regular", fontSize: 13, color: AppTheme.kAccentColor);

  Widget _buildItem() {
    return Padding(
      padding: const EdgeInsets.all(_kPadding),
      child: Container(
        child: Column(
          children: [
            _buildnews(),
            SpacerWidget(_kPadding / 2),
            _buildnewTimeStamp(),
          ],
        ),
      ),
    );
  }

  Widget _buildnews() {
    return Row(
      children: [
        Container(
            width: MediaQuery.of(context).size.width * .88,
            child: Text(
              // REPLACE  WITH REAL  NEWS
              "Check out these book suggestions for your summer by  this books  you can improve our genral knowledge !",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Theme.of(context).textTheme.headline2,
            )),
      ],
    );
  }

  Widget _buildnewTimeStamp() {
    DateTime now = DateTime.now(); //REPLACE WITH ACTUAL DATE
    String newsTimeStamp = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    return Row(
      children: [
        Container(
            child: Text(
          "${newsTimeStamp}",
          style: Theme.of(context).textTheme.subtitle1,
        )),
      ],
    );
  }

  Widget buttomButtonsWidget() {
    return Container(
      padding: EdgeInsets.all(_kPadding / 2),
      color: AppTheme.kBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: _KButtonSize,
            height: _KButtonSize / 2,
            child: ElevatedButton(
              onPressed: () {
                // Route route =
                //     MaterialPageRoute(builder: (context) => MinionFlare());
                // Navigator.push(context, route);
              },
              child: Text("More"),
            ),
          ),
          SizedBox(
            width: _kPadding / 2,
          ),
          SizedBox(
            width: _KButtonSize,
            height: _KButtonSize / 2,
            child: ElevatedButton(
              onPressed: () {
                // Route route =
                //     MaterialPageRoute(builder: (context) => MinionFlare());
                // Navigator.push(context, route);
              },
              child: Text("Share"),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          elevation: 0.0,
          leading: Container(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: 100.0, height: 50.0, child: BearIconWidget()),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    const IconData(0xe80c,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: Color(0xffbcc5d4),
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(width: _kPadding),
            Icon(
              const IconData(0xe815,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
              color: AppTheme.kBlackColor,
              size: 20,
            ),
            SizedBox(width: _kPadding),
          ]),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xffF5F5F5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildItem(),
            Expanded(child: Container()),
            buttomButtonsWidget(),
          ],
        ),
      ),
    );
  }
}
