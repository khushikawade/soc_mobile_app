import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppsFolderPage extends StatefulWidget {
  List obj = [];
  final String folderName;
  @override
  AppsFolderPage({
    Key? key,
    required this.obj,
    required this.folderName,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => AppsFolderPageState();
}

class AppsFolderPageState extends State<AppsFolderPage>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;
  static const double _kLableSpacing = 10.0;
  List apps = [];
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

  _launchURL(obj) async {
    if (obj.deepLinkC == 'NO') {
      if (obj.appUrlC!.toString().split(":")[0] == 'http') {
        // if (await canLaunch(obj.appUrlC!)) {
        //   await launch(obj.appUrlC!);
        // } else {
        //   throw 'Could not launch ${obj.appUrlC!}';
        // }
        await Utility.launchUrlOnExternalBrowser(obj.appUrlC!);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => InAppUrlLauncer(
                      title: obj.titleC!,
                      url: obj.appUrlC!,
                      isbuttomsheet: true,
                      language: Globals.selectedLanguage,
                    )));
      }
    } else {
      // await launch(obj.appUrlC!);
      await Utility.launchUrlOnExternalBrowser(obj.appUrlC!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
            // color: Colors.red,
            margin: const EdgeInsets.only(
                top: 20, left: 20.0, right: 20, bottom: 20),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: ShapeDecoration(
                // color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20.0, right: 20, bottom: 20),
                  child: apps.length > 0
                      ? GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: _kLableSpacing,
                          mainAxisSpacing: _kLableSpacing,
                          children: List.generate(
                            apps.length,
                            (index) {
                              return apps[index].status == null ||
                                      apps[index].status == 'Show'
                                  ? InkWell(
                                      onTap: () => _launchURL(apps[index]),
                                      child: Column(
                                        children: [
                                          apps[index].appIconC != null &&
                                                  apps[index].appIconC != ''
                                              ? Container(
                                                  height: 65,
                                                  width: 65,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        apps[index].appIconC ??
                                                            '',
                                                    placeholder: (context,
                                                            url) =>
                                                        Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                ShimmerLoading(
                                                              isLoading: true,
                                                              child: Container(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                )
                                              : Container(),
                                          Globals.selectedLanguage != null &&
                                                  Globals.selectedLanguage !=
                                                      "English" &&
                                                  Globals.selectedLanguage != ""
                                              ? TranslationWidget(
                                                  message: apps[index]
                                                                  .appFolderc !=
                                                              null &&
                                                          widget.folderName ==
                                                              apps[index]
                                                                  .appFolderc
                                                      ? "${apps[index].titleC}"
                                                      : '',
                                                  fromLanguage: "en",
                                                  toLanguage:
                                                      Globals.selectedLanguage,
                                                  builder:
                                                      (translatedMessage) =>
                                                          Container(
                                                    alignment: Alignment.center,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                          translatedMessage
                                                              .toString(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText2!),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(
                                                      apps[index].appFolderc !=
                                                                  null &&
                                                              widget.folderName ==
                                                                  apps[index]
                                                                      .appFolderc
                                                          ? "${apps[index].titleC}"
                                                          : '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2!
                                                          .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primaryVariant,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ))
                                  : Container();
                            },
                          ),
                        )
                      : Center(
                          child: Container(
                              child: Globals.selectedLanguage != null &&
                                      Globals.selectedLanguage != "English" &&
                                      Globals.selectedLanguage != ""
                                  ? TranslationWidget(
                                      message: "No apps available here",
                                      fromLanguage: "en",
                                      toLanguage: Globals.selectedLanguage,
                                      builder: (translatedMessage) => Text(
                                        translatedMessage.toString(),
                                      ),
                                    )
                                  : Text("No apps available here"))),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
