import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppsFolderPage extends StatefulWidget {
  List obj = [];
  String folderName;

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

  _launchURL(obj) async {
    if (obj.deepLinkC == 'NO') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: obj.titleC!,
                    url: obj.appUrlC!,
                  )));
    } else {
      await launch(obj.appUrlC!);
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
            margin: const EdgeInsets.only(
                top: 20, left: 20.0, right: 20, bottom: 20),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 20.0, right: 20, bottom: 20),
              child: //Text("Well hello there!"),
                  apps.length > 0
                      ? GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: _kLableSpacing,
                          mainAxisSpacing: _kLableSpacing,
                          children: List.generate(
                            apps.length,
                            (index) {
                              return InkWell(
                                  onTap: () => _launchURL(apps[index]),
                                  child: Column(
                                    children: [
                                      apps[index].appIconC != null &&
                                              apps[index].appIconC != ''
                                          ? SizedBox(
                                              height: 80,
                                              width: 80,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    apps[index].appIconC ?? '',
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            )
                                          : Container(),
                                      Text(apps[index].appFolderc != null &&
                                              widget.folderName ==
                                                  apps[index].appFolderc
                                          ? "${apps[index].titleC}"
                                          : ''),
                                    ],
                                  ));
                            },
                          ),
                        )
                      : Center(
                          child:
                              Container(child: Text("No apps available here"))),
            ),
          ),
        ),
      ),
    );
  }
}