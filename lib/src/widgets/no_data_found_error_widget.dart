import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class NoDataFoundErrorWidget extends StatelessWidget {
  bool isResultNotFoundMsg;
  bool? isNews;
  bool? isEvents;
  double? marginTop;
  bool? connected;
  NoDataFoundErrorWidget(
      {Key? key,
      required this.isResultNotFoundMsg,
      required this.isNews,
      this.connected,
      required this.isEvents,
      this.marginTop})
      : super(key: key);

  Widget build(BuildContext context) {
    return connected == false
        ? NoInternetErrorWidget(
            issplashscreen: false,
            connected: connected,
          )
        : OrientationBuilder(builder: (context, orientation) {
            return Column(
              children: [
                Container(
                    margin: EdgeInsets.only(
                      top: orientation == Orientation.landscape &&
                              Globals.deviceType == 'phone'
                          ? MediaQuery.of(context).size.height * 0.12
                          : marginTop ??
                              MediaQuery.of(context).size.height * 0.25,
                    ),
                    alignment: Alignment.center,
                    child: orientation == Orientation.landscape &&
                            Globals.deviceType == 'phone'
                        ? SvgPicture.asset(
                            Strings.noDataIconPath,
                            fit: BoxFit.cover,
                            height: 80,
                            width: 80,
                          )
                        : SvgPicture.asset(
                            Strings.noDataIconPath,
                            fit: BoxFit.cover,
                          )),
                SpacerWidget(12),
                Container(
                    alignment: Alignment.center,
                    child: TranslationWidget(
                      message: isNews!
                          ? "No Message Yet"
                          : isEvents!
                              ? "No Event Found"
                              : isResultNotFoundMsg
                                  ? "No result found"
                                  : "No data found",
                      toLanguage: Globals.selectedLanguage,
                      fromLanguage: "en",
                      builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                          style: Theme.of(context).textTheme.bodyText1!),
                    )),
              ],
            );
          });
  }
}
