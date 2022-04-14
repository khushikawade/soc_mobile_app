import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class OpenExternalBrowser extends StatefulWidget {
  final bool? connected;
  final String? url;
  OpenExternalBrowser({
    Key? key,
    this.connected,
    required this.url,
  }) : super(key: key);

  @override
  State<OpenExternalBrowser> createState() => _OpenExternalBrowserState();
}

class _OpenExternalBrowserState extends State<OpenExternalBrowser> {
    static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;
  
  Widget build(BuildContext context) {
    return widget.connected == false
        ? NoInternetErrorWidget(
            issplashscreen: false,
            connected: widget.connected,
          )
        : OrientationBuilder(builder: (context, orientation) {
            return ListView(
              children: [
                Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.35),
                    alignment: Alignment.center,
                    child: TranslationWidget(
                      message: "Unable to open the URL",
                      toLanguage: Globals.selectedLanguage,
                      fromLanguage: "en",
                      builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                          style: Theme.of(context).textTheme.bodyText1!),
                    )),
                SpacerWidget(12),
                Container(
                  padding: EdgeInsets.all(_kPadding / 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // mainAxisSize: MainAxisSize.,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(
                          minWidth: _KButtonSize,
                          maxWidth: 230.0,
                          minHeight: _KButtonSize / 2,
                          maxHeight: _KButtonSize / 2,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            launchUrl(widget.url);
                          },
                          child: TranslationWidget(
                            message: "Open in external browser",
                            toLanguage: Globals.selectedLanguage,
                            fromLanguage: "en",
                            builder: (translatedMessage) => Text(
                              translatedMessage.toString(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
  }

  launchUrl(url) async {
    await Utility.launchUrlOnExternalBrowser(url);
  }


}
