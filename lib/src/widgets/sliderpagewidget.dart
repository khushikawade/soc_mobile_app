import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/eventdescition.dart';
import 'package:Soc/src/modules/news/ui/newdescription.dart';
import 'package:Soc/src/modules/social/ui/socialeventdescription.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/backbuttonwidget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
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
      required this.isbuttomsheet,
      required this.language});
  final obj;
  int currentIndex;
  bool? issocialpage;
  bool? iseventpage;
  String date;
  bool isbuttomsheet;
  String? language;

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  static const double _kPadding = 16.0;
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
    Globals.callsnackbar = false;
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
                        : null,
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
                    : null,
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
                  ? SocialDescription(
                      object: object[widget.currentIndex],
                      language: Globals.selectedLanguage,
                    )
                  : widget.iseventpage!
                      ? EventDescription(
                          obj: object[widget.currentIndex],
                          isbuttomsheet: true,
                          language: Globals.selectedLanguage,
                        )
                      : Newdescription(
                          obj: object[widget.currentIndex],
                          date: widget.date,
                          isbuttomsheet: true,
                          language: Globals.selectedLanguage,
                        );
            },
          ),
        )
      ]),
    );
  }

  void htmlparser() {
    final doc = parse(object[0].description["__cdata"]);
    final element = doc.getElementById('content');
    debugPrint(element!.querySelectorAll('div').toString());
  }
}
