import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/eventdescition.dart';
import 'package:Soc/src/modules/news/ui/newdescription.dart';
import 'package:Soc/src/modules/social/ui/socialeventdescription.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/backbuttonwidget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/internalbuttomnavigation.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/soicalwebview.dart';
import 'package:flutter/material.dart';
import '../overrides.dart';
import 'package:html/parser.dart' show parse;

// ignore: must_be_immutable
class SliderWidget extends StatefulWidget {
  SliderWidget(
      {required this.obj,
      required this.currentIndex,
      this.issocialpage,
      required this.iseventpage,
      required this.date,
      required this.isbuttomsheet});
  var obj;
  int currentIndex;
  bool? issocialpage;
  bool? iseventpage;
  String date;
  bool isbuttomsheet;

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;
  static const double _kLabelSpacing = 15.0;
  var _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 400);
  int pageinitialIndex = 0;
  int pageViewCurrentIndex = 0;
  int pageviewLastIndex = 10;
  static const _kCurve = Curves.ease;
  var object;
  var link;
  var link2;
  bool first = false;

  @override
  void initState() {
    super.initState();
    object = widget.obj;
    first = true;
    pageinitialIndex = widget.currentIndex;
    _controller = PageController(initialPage: widget.currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Theme.of(context).accentColor),
            elevation: 0.0,
            leading: BackButtonWidget(),
            title: SizedBox(width: 100.0, height: 60.0, child: AppLogoWidget()),
            actions: <Widget>[
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      setState(() {});
                      if (widget.currentIndex > 0) {
                        _controller.previousPage(
                            duration: _kDuration, curve: _kCurve);
                      }
                    },
                    icon: Icon(
                      const IconData(0xe80c,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      color: widget.currentIndex == 0
                          ? AppTheme.kDecativeIconColor
                          : AppTheme.kBlackColor,
                      size: Globals.deviceType == "phone" ? 18 : 26,
                    ),
                  ),
                ],
              ),
              HorzitalSpacerWidget(_kPadding / 3),
              IconButton(
                onPressed: () async {
                  setState(() {});
                  if (widget.currentIndex < object.length - 1) {
                    _controller.nextPage(duration: _kDuration, curve: _kCurve);
                  }
                },
                icon: (Icon(
                  const IconData(0xe815,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  color: widget.currentIndex == widget.obj.length - 1
                      ? AppTheme.kDecativeIconColor
                      : AppTheme.kBlackColor,
                  size: Globals.deviceType == "phone" ? 18 : 26,
                )),
              ),
              HorzitalSpacerWidget(_kPadding / 3),
            ]),
        body: Column(children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.obj.length,
              onPageChanged: (sliderIndex) {
                if (first) {
                  pageinitialIndex < sliderIndex
                      ? ++widget.currentIndex
                      : --widget.currentIndex;
                  pageViewCurrentIndex = sliderIndex;
                  first = false;
                } else {
                  if (sliderIndex > widget.currentIndex &&
                      widget.currentIndex < object.length - 1) {
                    ++widget.currentIndex;
                  } else if (sliderIndex <= widget.currentIndex &&
                      widget.currentIndex > 0) {
                    --widget.currentIndex;
                  }
                }
                setState(() {});
              },
              itemBuilder: (BuildContext context, int index) {
                return widget.issocialpage!
                    ? SocialDescription(object: object[widget.currentIndex])
                    : widget.iseventpage!
                        ? EventDescription(
                            obj: object[widget.currentIndex],
                            isbuttomsheet: true,
                          )
                        : Newdescription(
                            obj: object[widget.currentIndex],
                            date: widget.date,
                            isbuttomsheet: true,
                          );
              },
            ),
          )
        ]),
        bottomSheet: widget.isbuttomsheet && Globals.homeObjet != null
            ? InternalButtomNavigationBar()
            : null);
  }

  Widget buttomButtonsWidget(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(_kPadding),
        color: AppTheme.kBackgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              width: _KButtonSize,
              height: _KButtonSize / 2,
              child: ElevatedButton(
                onPressed: () async {
                  _buildlink();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SoicalPageWebview(
                                link: link2,
                                isSocialpage: true,
                                isbuttomsheet: true,
                              )));
                },
                child: Text("More"),
              ),
            ),
            HorzitalSpacerWidget(_kPadding / 2),
            SizedBox(
              width: _KButtonSize,
              height: _KButtonSize / 2,
              child: ElevatedButton(
                onPressed: () async {
                  SharePopUp obj = new SharePopUp();
                  String link = await _buildlink();
                  final String body =
                      "${widget.obj[widget.currentIndex].title["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", ".").replaceAll("\nn", "\n")}"
                              " " +
                          link;
                  obj.callFunction(context, body, "");
                },
                child: Text("Share"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _buildlink() async {
    link = widget.obj[widget.currentIndex].link.toString();
    RegExp exp =
        new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(link);
    matches.forEach((match) {
      link2 = link.substring(match.start, match.end);
    });
    return link2;
  }

  void htmlparser() {
    var doc = parse(object[0].description["__cdata"]);
    var element = doc.getElementById('content');
    debugPrint(element!.querySelectorAll('div').toString());
  }
}
