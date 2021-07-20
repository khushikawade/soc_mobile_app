import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../overrides.dart';

class EventDescription extends StatefulWidget {
  EventDescription({Key? key, required this.obj}) : super(key: key);
  final List<Item>? obj;
  @override
  _EventDescriptionState createState() => _EventDescriptionState();
}

class _EventDescriptionState extends State<EventDescription> {
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 95.0;

  // static const _knewsTextStyle = TextStyle(
  //   fontFamily: "Roboto Bold",
  //   fontSize: 16,
  //   color: AppTheme.kAccentColor,
  //   fontWeight: FontWeight.bold,
  // );
  // static const _klinkstyle = TextStyle(
  //     fontFamily: "Roboto Bold",
  //     fontSize: 15,
  //     fontWeight: FontWeight.normal,
  //     decoration: TextDecoration.underline,
  //     color: AppTheme.kAccentColor);

  // static const _kTimeStampStyle = TextStyle(
  //     fontWeight: FontWeight.normal,
  //     fontFamily: "Roboto Regular",
  //     fontSize: 13,
  //     color: AppTheme.kAccentColor);

  static const _kbuttonTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontFamily: "Roboto Regular",
      fontSize: 12,
      color: AppTheme.kFontColor1);

  Widget _buildItem() {
    return Container(
      child: Column(
        children: [
          SpacerWidget(_kPadding / 2),
          _buildHeading(),
          SpacerWidget(_kPadding / 4),
          divider(),
          SpacerWidget(_kPadding / 2),
          _buildnewTimeStamp(),
          SpacerWidget(_kPadding / 2),
          _buildEventLink(),
          SpacerWidget(_kPadding / 2),
        ],
      ),
    );
  }

  Widget _buildHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Summer Rising",
          style: Theme.of(context).textTheme.headline2,
        ),
      ],
    );
  }

  // Widget _buildnews() {
  //   return Row(
  //     children: [
  //       Container(
  //           width: MediaQuery.of(context).size.width * .88,
  //           child: Text(
  //             // REPLACE  WITH REAL  NEWS
  //             "Check out these book suggestions for your summer by  this books  you can improve our genral knowledge !",
  //             overflow: TextOverflow.ellipsis,
  //             maxLines: 3,
  //             style: _knewsTextStyle,
  //           )),
  //     ],
  //   );
  // }

  Widget _buildnewTimeStamp() {
    DateTime now = DateTime.now(); //REPLACE WITH ACTUAL DATE
    String newsTimeStamp = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kPadding),
      child: Row(
        children: [
          Container(
              child: Text(
            "${newsTimeStamp}",
            style: Theme.of(context).textTheme.subtitle1,
          )),
        ],
      ),
    );
  }

  _launchURL(url) async {
    // const url = "${overrides.Overrides.privacyPolicyUrl}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildEventLink() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () => _launchURL(
                "https://calendar.google.com/calendar/u/0/r/week/2021/7/15?eid=NmoxMTlhbTRmYzduMzZvbW8ydHNucTQyOGggYXNod2ludGhha3VyNDk4QG0&ctok=YXNod2ludGhha3VyNDk4QGdtYWlsLmNvbQ"),
            child: Container(
              width: MediaQuery.of(context).size.width * .90,
              child: Text(
                "https://calendar.google.com/calendar/u/0/r/week/2021/7/15?eid=NmoxMTlhbTRmYzduMzZvbW8ydHNucTQyOGggYXNod2ludGhha3VyNDk4QG0&ctok=YXNod2ludGhha3VyNDk4QGdtYWlsLmNvbQ",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(decoration: TextDecoration.underline),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Container(
      height: 0.5,
      decoration: BoxDecoration(
        color: Color(0xff6c75a4),
      ),
    );
  }

  Widget buttomButtonsWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _kPadding / 2),
      // color: AppTheme.kBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: _KButtonSize,
            height: _KButtonSize / 2.5,
            child: ElevatedButton(
              onPressed: () => _onShareWithEmptyOrigin(context),
              child: Text(
                "Share",
                style: _kbuttonTextStyle,
              ),
            ),
          ),
          SizedBox(
            width: _kPadding / 2,
          ),
          SizedBox(
            width: _KButtonSize,
            height: _KButtonSize / 2.5,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Save event", style: _kbuttonTextStyle),
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
              SizedBox(width: 100.0, height: 60.0, child: BearIconWidget()),
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
                    color: AppTheme.kTxtfieldBorderColor,
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
        color: AppTheme.kListBackgroundColor2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildItem(),
            // Expanded(child: Container()),
            buttomButtonsWidget(),
          ],
        ),
      ),
    );
  }

  _onShareWithEmptyOrigin(BuildContext context) async {
    RenderBox? box = context.findRenderObject() as RenderBox;
    final String body =
        "https://calendar.google.com/calendar/u/0/r/week/2021/7/15?eid=NmoxMTlhbTRmYzduMzZvbW8ydHNucTQyOGggYXNod2ludGhha3VyNDk4QG0&ctok=YXNod2ludGhha3VyNDk4QGdtYWlsLmNvbQ";
    final subject = "Event";
    await Share.share(body,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
