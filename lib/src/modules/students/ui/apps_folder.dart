import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/marquee.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../../../widgets/no_data_found_error_widget.dart';
import '../models/student_app.dart';

// ignore: must_be_immutable
class AppsFolderPage extends StatefulWidget {
  List<StudentApp> obj = [];
  final String folderName;
  final scaffoldKey;
  @override
  AppsFolderPage(
      {Key? key, required this.obj, required this.folderName, this.scaffoldKey})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => AppsFolderPageState();
}

class AppsFolderPageState extends State<AppsFolderPage>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;
  static const double _kLableSpacing = 10.0;
  List<StudentApp> apps = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.obj.length; i++) {
      if (widget.obj[i].appFolderc != null &&
          widget.obj[i].appFolderc == widget.folderName) {
        apps.add(widget.obj[i]);
      }
    }

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _launchURL(StudentApp obj) async {
    if (obj.appUrlC.toString().split(":")[0] == 'http' ||
        obj.deepLinkC == 'YES'  ) {
      await Utility.launchUrlOnExternalBrowser(obj.appUrlC!);
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: obj.titleC!,
                    url: obj.appUrlC!,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        // elevation: 99,
        // shadowColor: Colors.red,
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
            margin: const EdgeInsets.only(
                top: 20, left: 20.0, right: 20, bottom: 20),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                // backgroundColor: Colors.white,
                body: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20.0, right: 20, bottom: 20),
                    child: apps.length > 0
                        ? GridView.count(
                            crossAxisCount: MediaQuery.of(context)
                                            .orientation ==
                                        Orientation.portrait &&
                                    Globals.deviceType == "phone"
                                ? 3
                                : (MediaQuery.of(context).orientation ==
                                            Orientation.landscape &&
                                        Globals.deviceType == "phone")
                                    ? 4
                                    : MediaQuery.of(context).orientation ==
                                                Orientation.portrait &&
                                            Globals.deviceType != "phone"
                                        ? 4
                                        : MediaQuery.of(context).orientation ==
                                                    Orientation.landscape &&
                                                Globals.deviceType != "phone"
                                            ? 5
                                            : 3,
                            crossAxisSpacing: _kLableSpacing,
                            mainAxisSpacing: _kLableSpacing,
                            children: List.generate(
                              apps.length,
                              (index) {
                                return InkWell(
                                    onTap: () {
                                      apps[index].appUrlC != null &&
                                              apps[index].appUrlC != ''
                                          ? _launchURL(apps[index])
                                          : Utility.showSnackBar(
                                              widget.scaffoldKey,
                                              "No URL available",
                                              context,40);
                                    },
                                    child: Column(
                                      children: [
                                        apps[index].appIconC != null &&
                                                apps[index].appIconC != ''
                                            ? Container(
                                                height: 65,
                                                width: 65,
                                                child: CustomIconWidget(
                                                  iconUrl: apps[index]
                                                          .appIconC ??
                                                      Overrides
                                                          .folderDefaultImage,
                                                  darkModeIconUrl:
                                                      apps[index].darkModeIconC,
                                                ))
                                            : Container(),
                                        Container(
                                            child: TranslationWidget(
                                          message:
                                              apps[index].appFolderc != null &&
                                                      widget.folderName ==
                                                          apps[index].appFolderc
                                                  ? "${apps[index].titleC}"
                                                  : '',
                                          fromLanguage: "en",
                                          toLanguage: Globals.selectedLanguage,
                                          builder: (translatedMessage) =>
                                              Container(
                                            child: MediaQuery.of(context)
                                                            .orientation ==
                                                        Orientation.portrait &&
                                                    translatedMessage
                                                            .toString()
                                                            .length >
                                                        11
                                                ? Expanded(
                                                    child: MarqueeWidget(
                                                    pauseDuration:
                                                        Duration(seconds: 1),
                                                    child: Text(
                                                      translatedMessage
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                              fontSize:
                                                                  Globals.deviceType ==
                                                                          "phone"
                                                                      ? 16
                                                                      : 24),
                                                    ),
                                                  )

                                                    //  Marquee(
                                                    //   text: translatedMessage
                                                    //       .toString(),
                                                    //   style: Theme.of(context)
                                                    //       .textTheme
                                                    //       .bodyText1!
                                                    //       .copyWith(
                                                    //           fontSize:
                                                    //               Globals.deviceType ==
                                                    //                       "phone"
                                                    //                   ? 16
                                                    //                   : 24),
                                                    //   scrollAxis:
                                                    //       Axis.horizontal,
                                                    //   velocity: 30.0,
                                                    //   crossAxisAlignment:
                                                    //       CrossAxisAlignment
                                                    //           .start,
                                                    //   blankSpace: 50,
                                                    //   pauseAfterRound:
                                                    //       Duration(seconds: 5),
                                                    //   showFadingOnlyWhenScrolling:
                                                    //       true,
                                                    //   startPadding: 10.0,
                                                    //   accelerationDuration:
                                                    //       Duration(seconds: 1),
                                                    //   accelerationCurve:
                                                    //       Curves.linear,
                                                    //   decelerationDuration:
                                                    //       Duration(
                                                    //           milliseconds:
                                                    //               500),
                                                    //   decelerationCurve:
                                                    //       Curves.easeOut,
                                                    // ),
                                                    )
                                                : MediaQuery.of(context)
                                                                .orientation ==
                                                            Orientation
                                                                .landscape &&
                                                        translatedMessage
                                                                .toString()
                                                                .length >
                                                            18
                                                    ? Expanded(
                                                        child: MarqueeWidget(
                                                        pauseDuration: Duration(
                                                            seconds: 1),
                                                        child: Text(
                                                          translatedMessage
                                                              .toString(),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  fontSize:
                                                                      Globals.deviceType ==
                                                                              "phone"
                                                                          ? 16
                                                                          : 24),
                                                        ),
                                                      )

                                                        //    Marquee(
                                                        //   text: translatedMessage
                                                        //       .toString(),
                                                        //   style: Theme.of(context)
                                                        //       .textTheme
                                                        //       .bodyText1!
                                                        //       .copyWith(
                                                        //           fontSize: Globals
                                                        //                       .deviceType ==
                                                        //                   "phone"
                                                        //               ? 16
                                                        //               : 24),
                                                        //   scrollAxis:
                                                        //       Axis.horizontal,
                                                        //   velocity: 30.0,
                                                        //   crossAxisAlignment:
                                                        //       CrossAxisAlignment
                                                        //           .start,

                                                        //   blankSpace:
                                                        //       50, //MediaQuery.of(context).size.width
                                                        //   // velocity: 100.0,
                                                        //   pauseAfterRound:
                                                        //       Duration(
                                                        //           seconds: 5),
                                                        //   showFadingOnlyWhenScrolling:
                                                        //       true,
                                                        //   startPadding: 10.0,
                                                        //   accelerationDuration:
                                                        //       Duration(
                                                        //           seconds: 1),
                                                        //   accelerationCurve:
                                                        //       Curves.linear,
                                                        //   decelerationDuration:
                                                        //       Duration(
                                                        //           milliseconds:
                                                        //               500),
                                                        //   decelerationCurve:
                                                        //       Curves.easeOut,
                                                        // )

                                                        )
                                                    : SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                            translatedMessage
                                                                .toString(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .copyWith(
                                                                    fontSize: Globals.deviceType ==
                                                                            "phone"
                                                                        ? 16
                                                                        : 24)),
                                                      ),
                                          ),
                                        )),
                                      ],
                                    ));
                              },
                            ),
                          )
                        : NoDataFoundErrorWidget(
                            marginTop: MediaQuery.of(context).size.height / 10,
                            isResultNotFoundMsg: false,
                            isNews: false,
                            isEvents: false,
                            // connected: connected,
                          )
                    // Center(
                    //     child: Container(
                    //         child: TranslationWidget(
                    //     message: "No apps available here",
                    //     fromLanguage: "en",
                    //     toLanguage: Globals.selectedLanguage,
                    //     builder: (translatedMessage) => Text(
                    //       translatedMessage.toString(),
                    //     ),
                    //   ))),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
