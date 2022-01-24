import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/eventdescition.dart';
import 'package:Soc/src/modules/news/ui/newdescription.dart';
import 'package:Soc/src/modules/staff_directory/staff_detail_page.dart';
import 'package:Soc/src/modules/social/ui/socialeventdescription.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/backbuttonwidget.dart';
import 'package:flutter/material.dart';
import '../overrides.dart';
import 'package:html/parser.dart' show parse;

// ignore: must_be_immutable
class SliderWidget extends StatefulWidget {
  SliderWidget({
    required this.obj,
    required this.currentIndex,
    required this.iseventpage,
    required this.date,
    required this.isbuttomsheet,
    required this.language,
    required this.iconsName,
    this.issocialpage,
    this.isAboutSDPage,
    this.icons,
  });
  final obj;
  int currentIndex;
  bool? issocialpage;
  bool? isAboutSDPage;
  String date;
  bool isbuttomsheet;
  String? language;
  final List? icons;
  final List? iconsName;
  final iseventpage;

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
          leading: BackButtonWidget(
           
            isNewsPage:
                widget.iseventpage == false || widget.issocialpage == true
                    ? true
                    : false,
          ),
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            AppLogoWidget(
              marginLeft: 57,
            ),
          ]),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                // setState(() {});
                // if (widget.currentIndex > 0) {
                //   _controller.previousPage(
                //       duration: _kDuration, curve: _kCurve);
                // }
                if (pageinitialIndex > 0) {
                  _controller.previousPage(
                      duration: _kDuration, curve: _kCurve);
                }
              },
              icon: Icon(
                const IconData(0xe80c,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color:
                    pageinitialIndex > 0 ? null : AppTheme.kDecativeIconColor,
                size: Globals.deviceType == "phone" ? 18 : 26,
              ),
            ),
            IconButton(
              onPressed: () async {
                // setState(() {});
                // if (widget.currentIndex < object.length - 1) {
                //   _controller.nextPage(duration: _kDuration, curve: _kCurve);
                // }
                if (pageinitialIndex < widget.obj.length) {
                  _controller.nextPage(duration: _kDuration, curve: _kCurve);
                }
              },
              icon: (Icon(
                const IconData(0xe815,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: pageinitialIndex < (widget.obj.length - 1)
                    ? null
                    : AppTheme.kDecativeIconColor,
                size: Globals.deviceType == "phone" ? 18 : 26,
              )),
            ),
            SizedBox(width: 10)
          ]),
      body: Column(children: <Widget>[
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.obj.length,
            onPageChanged: (sliderIndex) {
              pageinitialIndex = sliderIndex;
              setState(() {});
              // if (first) {
              //   pageinitialIndex < sliderIndex
              //       ? ++widget.currentIndex
              //       : --widget.currentIndex;
              //   pageViewCurrentIndex = sliderIndex;
              //   first = false;
              // } else {
              //   if (sliderIndex > widget.currentIndex &&
              //       widget.currentIndex < object.length - 1) {
              //     ++widget.currentIndex;
              //   } else if (sliderIndex <= widget.currentIndex &&
              //       widget.currentIndex > 0) {
              //     --widget.currentIndex;
              //   }
              // }
            },
            itemBuilder: (BuildContext context, int index) {
              return widget.issocialpage!
                  ? SocialDescription(
                             icons: widget.icons,
                              iconsName: widget.iconsName,
                      object: object[widget.currentIndex],
                      language: Globals.selectedLanguage,
                      index: pageinitialIndex,
                    )
                  : widget.isAboutSDPage!
                      ? AboutSDDetailPage(
                          obj: object[pageinitialIndex],
                        )
                      : widget.iseventpage
                          ? EventDescription(
                              obj: object[pageinitialIndex],
                              isbuttomsheet: true,
                              language: Globals.selectedLanguage,
                            )
                          : Newdescription(
                              icons: widget.icons!,
                              iconsName: widget.iconsName,
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
