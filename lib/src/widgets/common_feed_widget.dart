import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommonFeedWidget extends StatefulWidget {
  final String title;
  final Widget actionIcon;
  final String url;
  final String iconLink;
  CommonFeedWidget(
      {Key? key,
      required this.title,
      required this.actionIcon,
      required this.url,
      required this.iconLink})
      : super(key: key);

  @override
  _CommonFeedWidgetState createState() => _CommonFeedWidgetState();
}

class _CommonFeedWidgetState extends State<CommonFeedWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.12,
              child: Icon(Icons.ac_unit)),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslationWidget(
                    message: widget.title,
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) {
                      return Text(
                        translatedMessage.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(fontSize: 18),
                      );
                    }),
                CachedNetworkImage(
                    imageUrl: widget.url,
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: ShimmerLoading(
                          isLoading: true,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.85,
                            color: Colors.white,
                          ),
                        )),
                    errorWidget: (context, url, error) => CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          imageUrl: Globals.splashImageUrl ??
                              // Globals.homeObject["App_Logo__c"],
                              Globals.appSetting.appLogoC,
                          placeholder: (context, url) => Container(
                              alignment: Alignment.center,
                              child: ShimmerLoading(
                                isLoading: true,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  color: Colors.white,
                                ),
                              )),
                        )),
                widget.actionIcon,
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget widgetIcon(link) {
    if (link["\$t"].contains('instagram')) {
      return ShaderMask(
          shaderCallback: (bounds) => RadialGradient(
                center: Alignment.topRight,
                transform: GradientRotation(50),
                radius: 5,
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.red,
                  Colors.yellow,
                  Color(0xffee2a7b),
                  Colors.red,
                ],
              ).createShader(bounds),
          child: Padding(
            padding: EdgeInsets.only(bottom: 1),
            child: FaIcon(
              FontAwesomeIcons.instagram,
              size: 16,
              color: Colors.white,
            ),
          ));
    } else if (link["\$t"].contains('twitter')) {
      return iconWidget(FontAwesomeIcons.twitter, Color(0xff1DA1F2));
    } else if (link["\$t"].contains('facebook')) {
      return Padding(
          padding: EdgeInsets.only(bottom: 1),
          child: iconWidget(FontAwesomeIcons.facebook, Color(0xff4267B2)));
    } else if (link["\$t"].contains('youtube')) {
      return iconWidget(FontAwesomeIcons.youtube, Color(0xffFF0000));
    }

    return Icon(
      Icons.ac_unit,
      size: 16,
    );
  }

  Widget iconWidget(icon, color) {
    return FaIcon(
      icon,
      size: 16,
      color: color,
    );
  }
}
