import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/news/ui/newdescription.dart';
import 'package:Soc/src/modules/staff_directory/staff_detail_page.dart';
import 'package:Soc/src/modules/social/ui/social_detail_page.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/backbuttonwidget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import '../overrides.dart';
import 'package:html/parser.dart' show parse;

// ignore: must_be_immutable
class SliderWidget extends StatefulWidget {
  final obj;
  int currentIndex;
  bool? isSocialPage;
  bool? isAboutSDPage;
  bool? isNewsPage;
  String date;
  bool isBottomSheet;
  String? language;
  // final iseventpage;
  bool? connected;

  SliderWidget(
      {required this.obj,
      required this.currentIndex,
      // required this.iseventpage,
      required this.date,
      required this.isBottomSheet,
      required this.language,
      this.isSocialPage,
      this.isAboutSDPage,
      this.isNewsPage});

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget>
    with AutomaticKeepAliveClientMixin {
  var _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 400);
  int pageinitialIndex = 0;
  int pageViewcurrentIndex = 0;
  int pageviewlastIndex = 10;
  static const _kCurve = Curves.ease;
  var object;
  var link;
  var link2;
  bool first = false;
  bool? isDeviceBackButton = true;
  // Item? newObj;

  @override
  void initState() {
    super.initState();
    object = widget.obj;
    first = true;
    pageinitialIndex = widget.currentIndex;
    _controller = PageController(initialPage: widget.currentIndex);
    Globals.callSnackbar = false;
    BackButtonInterceptor.add(updateAction);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    BackButtonInterceptor.remove(updateAction);
  }

  bool updateAction(bool stopDefaultButtonEvent, RouteInfo info) {
    if (isDeviceBackButton == true) {
      isDeviceBackButton = false;
      // bool isNewsPage =
      //     // widget.iseventpage == false ||
      //     widget.isSocialPage == true ? true : false;
      Navigator.of(context).pop(widget.isNewsPage == true
          ? widget.isNewsPage
          : widget.isSocialPage == true
              ? widget.isSocialPage
              : null);
      return true;
    }
    return false;
  }

  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          elevation: 0.0,
          leading:
              //  BackButton(
              //   onPressed: () {
              //     Navigator.of(context).pop(newObj);
              //   },
              // ),

              BackButtonWidget(
            isNewsPage: widget.isNewsPage == true
                ? widget.isNewsPage
                : widget.isSocialPage == true
                    ? widget.isSocialPage
                    : null,

            // widget.iseventpage == false ||
            // widget.isSocialPage == true ? true : false,
          ),
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            AppLogoWidget(
              marginLeft: 57,
            ),
          ]),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
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
              //   pageinitialIndex <= sliderIndex
              //       ? ++widget.currentIndex
              //       : --widget.currentIndex;
              //   pageViewcurrentIndex = sliderIndex;
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
              return widget.isSocialPage!
                  ? SocialDescription(
                      object: object[pageinitialIndex],
                      language: Globals.selectedLanguage,
                      index: pageinitialIndex,
                      // onChange: (Item obj) {
                      //   newObj = obj;
                      // },
                    )
                  : widget.isNewsPage!
                      ? NewsDescription(
                          obj: object[pageinitialIndex],
                          date: widget.date,
                          isBottomSheet: true,
                          language: Globals.selectedLanguage,
                          connected: widget.connected,
                        )
                      : widget.isAboutSDPage != null
                          ? AboutSDDetailPage(
                              obj: object[pageinitialIndex],
                            )
                          // : widget.iseventpage             //Removed due to new UI
                          //     ? EventDescription(
                          //         obj: object[pageinitialIndex],
                          //         isBottomSheet: true,
                          //         language: Globals.selectedLanguage,
                          //       )
                          : EmptyContainer();
            },
          ),
        )
      ]),
    );
  }

  // void htmlparser() {
  //   final doc = parse(object[0].description["__cdata"]);
  //   final element = doc.getElementById('content');
  //   debugPrint(element!.querySelectorAll('div').toString());
  // }

  @override
  bool get wantKeepAlive => true;
}
