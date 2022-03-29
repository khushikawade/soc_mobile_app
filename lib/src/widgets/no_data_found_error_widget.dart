import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class NoDataFoundErrorWidget extends StatelessWidget {
  bool? isCalendarPageOrientationLandscape;
  bool? isSearchpage;
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
      this.isCalendarPageOrientationLandscape,
      required this.isEvents,
      this.isSearchpage,
      this.marginTop})
      : super(key: key);

  Widget build(BuildContext context) {
    return connected == false
        ? NoInternetErrorWidget(
            issplashscreen: false,
            connected: connected,
          )
        : OrientationBuilder(builder: (context, orientation) {
            // print(isCalendarPageOrientationLandscape);
            // print("11111111111111111");
            // print(orientation);
            return ListView(
              children: [
                Container(
                  
                    margin: EdgeInsets.only(
                      top: isCalendarPageOrientationLandscape == true &&
                              Globals.deviceType == 'phone' &&
                              isSearchpage == null
                          ? MediaQuery.of(context).size.height * 0.14
                          : marginTop ??
                              MediaQuery.of(context).size.height * 0.25,
                    ),
                    alignment: Alignment.center,
                    child: (isCalendarPageOrientationLandscape == true ||
                                orientation == Orientation.landscape) &&
                            Globals.deviceType == 'phone' &&
                            isSearchpage == null
                        ? SvgPicture.asset(
                            Strings.noDataIconPath,
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height / 6,
                            width: MediaQuery.of(context).size.height / 6,
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
