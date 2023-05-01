import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class NoDataFoundErrorWidget extends StatelessWidget {
  String? customText;
  String? errorMessage;
  bool? isCalendarPageOrientationLandscape;
  bool? isOcrSearch;
  bool? isSearchpage;
  bool isResultNotFoundMsg;
  bool? isNews;
  bool? isEvents;
  double? marginTop;
  bool? connected;
  bool? isScheduleFound;
  NoDataFoundErrorWidget(
      {Key? key,
      this.customText,
      required this.isResultNotFoundMsg,
      required this.isNews,
      this.errorMessage,
      this.connected,
      this.isCalendarPageOrientationLandscape,
      required this.isEvents,
      this.isSearchpage,
      this.marginTop,
      this.isScheduleFound,
      this.isOcrSearch})
      : super(key: key);

  Widget build(BuildContext context) {
    return connected == false
        ? NoInternetErrorWidget(
            isSplashScreen: false,
            connected: connected,
          )
        : OrientationBuilder(builder: (context, orientation) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView(
               
                children: [
                  Container(
                      margin: EdgeInsets.only(
                        top: isCalendarPageOrientationLandscape == true &&
                                Globals.deviceType == 'phone' &&
                                isSearchpage == null
                            ? MediaQuery.of(context).size.height * 0.14
                            : marginTop ??
                                MediaQuery.of(context).size.height * 0.20,
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
                        message: errorMessage != null && errorMessage != ''
                            ? errorMessage
                            : isNews == true
                                ? "No Message Yet"
                                : isEvents == true
                                    ? "No Event Found"
                                    : isResultNotFoundMsg == true
                                        ? "No result found"
                                        : isOcrSearch == true
                                            ? "No recent search"
                                            : isScheduleFound == true
                                                ? "Schedule not found"
                                                : "No data found",
                        toLanguage: Globals.selectedLanguage,
                        fromLanguage: "en",
                        builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                            style: Theme.of(context).textTheme.bodyText1!),
                      )),
                ],
              ),
            );
          });
  }
}
