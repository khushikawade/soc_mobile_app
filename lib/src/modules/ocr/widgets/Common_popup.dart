import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_list.dart';
import 'package:Soc/src/modules/google_classroom/ui/graded_landing_page.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:open_apps_settings/open_apps_settings.dart';
import 'package:open_apps_settings/settings_enum.dart';
import '../../../services/utility.dart';

class CommonPopupWidget extends StatefulWidget {
  final Orientation? orientation;
  final BuildContext? context;
  final String? message;
  final String? title;
  final bool? isAccessDenied;
  final bool? isLogout;
  CommonPopupWidget(
      {Key? key,
      required this.orientation,
      required this.context,
      required this.message,
      required this.title,
      this.isLogout,
      this.isAccessDenied})
      : super(key: key);

  @override
  State<CommonPopupWidget> createState() => _CommonPopupWidgetState();
}

class _CommonPopupWidgetState extends State<CommonPopupWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Container(
          padding: Globals.deviceType == 'phone'
              ? null
              : const EdgeInsets.only(top: 10.0),
          height: Globals.deviceType == 'phone' ? null : 50,
          width: Globals.deviceType == 'phone'
              ? null
              : widget.orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width / 2
                  : MediaQuery.of(context).size.height / 2,
          child: TranslationWidget(
              message: widget.title,
              fromLanguage: "en",
              toLanguage: Globals.selectedLanguage,
              builder: (translatedMessage) {
                return Text(translatedMessage.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(color: AppTheme.kButtonColor));
              }),
        ),
      ),
      content: TranslationWidget(
          message: widget.message,
          fromLanguage: "en",
          toLanguage: Globals.selectedLanguage,
          builder: (translatedMessage) {
            return Linkify(
                onOpen: (link) => Utility.launchUrlOnExternalBrowser(link.url),
                options: LinkifyOptions(humanize: false),
                textAlign: TextAlign.center,
                linkStyle: TextStyle(
                  color: Colors.blue,
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Colors.black),
                text: translatedMessage.toString());
          }),
      actions: <Widget>[
        Container(
          height: 1,
          width: MediaQuery.of(context).size.height,
          color: Colors.grey.withOpacity(0.2),
        ),
        widget.isLogout == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textButtonWidget(
                      title: 'Yes',
                      onPressed: () async {
                        await UserGoogleProfile.clearUserProfile();
                        await GoogleClassroom.clearClassroomCourses();
                        Utility.updateLoges(
                            // ,
                            // sessionId: Globals.sessionId,
                            activityId: '3',
                            description: 'User profile logout',
                            operationResult: 'Success');
                        // If app is running as the standalone Graded+ app, it should navigate to the Graded+ landing page.
                        if (Overrides.STANDALONE_GRADED_APP) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => GradedLandingPage(
                                        isFromLogoutPage: true,
                                      )),
                              (_) => false);
                        } else {
                          // If app is running as the regular school app, it should navigate to the Home page(Staff section).
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        isFromOcrSection: true,
                                      )),
                              (_) => false);
                        }
                      }),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  textButtonWidget(
                      title: 'No',
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: TextButton(
                      child: TranslationWidget(
                          message: "Got It",
                          fromLanguage: "en",
                          toLanguage: Globals.selectedLanguage,
                          builder: (translatedMessage) {
                            return Text(translatedMessage.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                      color: AppTheme.kButtonColor,
                                    ));
                          }),
                      onPressed: () async {
                        if (widget.isAccessDenied == true) {
                          //To pop 2 times to navigate back to the home screen in case of camera access denied
                          int count = 0;
                          Navigator.of(context).popUntil((_) {
                            if (Platform.isAndroid) {
                              return count++ >= 3;
                            } else {
                              return count++ >= 2;
                            }
                          });

                          //To open the app setting for permission access
                          OpenAppsSettings.openAppsSettings(
                              settingsCode: SettingsCode.APP_SETTINGS);
                        } else if (widget.isLogout == true) {
                          UserGoogleProfile.clearUserProfile();
                          GoogleClassroom.clearClassroomCourses();
                          Utility.updateLoges(
                              // ,
                              // sessionId: Globals.sessionId,
                              activityId: '3',
                              description: 'User profile logout',
                              operationResult: 'Success');
                          // If app is running as the standalone Graded+ app, it should navigate to the Graded+ landing page.
                          if (Overrides.STANDALONE_GRADED_APP) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => GradedLandingPage(
                                          isFromLogoutPage: true,
                                        )),
                                (_) => false);
                          } else {
                            // If app is running as the regular school app, it should navigate to the Home page(Staff section).
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                          isFromOcrSection: true,
                                        )),
                                (_) => false);
                          }
                        } else {
                          //Globals.iscameraPopup = false;
                          Navigator.pop(context, false);
                        }
                      },
                    ),
                  ),
                ],
              ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget textButtonWidget(
      {required String title, required void Function()? onPressed}) {
    return TextButton(
      child: TranslationWidget(
          message: title,
          fromLanguage: "en",
          toLanguage: Globals.selectedLanguage,
          builder: (translatedMessage) {
            return Text(translatedMessage.toString(),
                style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: title == 'Yes' && widget.isLogout == true
                          ? Colors.red
                          : AppTheme.kButtonColor,
                    ));
          }),
      onPressed: onPressed,

      //  () async {
      //   if (widget.isAccessDenied == true) {
      //     //To pop 2 times to navigate back to the home screen in case of camera access denied
      //     int count = 0;
      //     Navigator.of(context).popUntil((_) {
      //       if (Platform.isAndroid) {
      //         return count++ >= 3;
      //       } else {
      //         return count++ >= 2;
      //       }
      //     });

      //     //To open the app setting for permission access
      //     OpenAppsSettings.openAppsSettings(
      //         settingsCode: SettingsCode.APP_SETTINGS);
      //   } else if (widget.isLogout == true) {
      //
      //   } else {
      //     //Globals.iscameraPopup = false;
      //     Navigator.pop(context, false);
      //   }
      // },
    );
  }
}
