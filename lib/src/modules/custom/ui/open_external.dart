import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class UrlNotSecure extends StatefulWidget {
  bool? connected;
  String? url;
  UrlNotSecure({
    Key? key,
    this.connected,
    required this.url,
  }) : super(key: key);

  @override
  State<UrlNotSecure> createState() => _UrlNotSecureState();
}

class _UrlNotSecureState extends State<UrlNotSecure> {
  Widget build(BuildContext context) {
    return widget.connected == false
        ? NoInternetErrorWidget(
            issplashscreen: false,
            connected: widget.connected,
          )
        : OrientationBuilder(builder: (context, orientation) {
            // print(isCalendarPageOrientationLandscape);
            // print("11111111111111111");
            // print(orientation);
            return ListView(
              children: [
                Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.35),
                    alignment: Alignment.center,
                    child: TranslationWidget(
                      message: "Provided URL is not Secure",
                      toLanguage: Globals.selectedLanguage,
                      fromLanguage: "en",
                      builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                          style: Theme.of(context).textTheme.bodyText1!),
                    )),
                SpacerWidget(12),
                Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.35),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text('aahjsdags'),
                      onPressed: () {},
                    ))
              ],
            );
          });
  }

  launchUrl(url) async {
    await Utility.launchUrlOnExternalBrowser(url);
  }
}
