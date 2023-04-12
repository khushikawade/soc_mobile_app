import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/graded_plus/ui/profile_page.dart';
import 'package:Soc/src/modules/setting/ios_accessibility_guide_page.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/lanuage_selector.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_apps_settings/open_apps_settings.dart';
import 'package:open_apps_settings/settings_enum.dart';

// ignore: must_be_immutable
class StudentPlusAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height = 60;
  final bool? isWorkPage;
  final int? titleIconCode;
  final ValueChanged? refresh;

  final ValueNotifier<String> languageChanged =
      ValueNotifier<String>("English");

  StudentPlusAppBar(
      {Key? key, this.titleIconCode, required this.refresh, this.isWorkPage})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);
  // final GlobalKey _openSettingShowCaseKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
          padding:
              EdgeInsets.only(left: StudentPlusOverrides.kSymmetricPadding),
          child: Row(
            children: [
              _translateButton(setState, context),
              // _openSettingsButton(context),
            ],
          ),
        ),

        actions: [
          FutureBuilder(
              future: getUserProfile(),
              builder: (context, AsyncSnapshot<UserInformation> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: EdgeInsets.only(
                        right: StudentPlusOverrides.kSymmetricPadding),
                    child: IconButton(
                      icon: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        child: CachedNetworkImage(
                          height: 28,
                          width: 28,
                          imageUrl: snapshot.data!.profilePicture!,
                          placeholder: (context, url) =>
                              CupertinoActivityIndicator(
                                  animating: true, radius: 10),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseAnalyticsService.addCustomAnalyticsEvent(
                            "profile");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                    hideStateSelection: true,
                                    profile: snapshot.data!,
                                  )),
                        );

                        // _showPopUp(snapshot.data!);
                        //print("profile url");
                      },
                    ),
                  );
                }
                return IconButton(icon: Container(), onPressed: (() {}));
              }),
        ],
        // leading: leading,
        leadingWidth: 110,

        title: isWorkPage == true
            ? wordScreenIconWidget()
            : titleIconCode != null
                ? allScreenIconWidget()
                : Container(),

        // Utility.textWidget(
        //   text: title,
        //   context: context,
        //   textTheme: Theme.of(context).textTheme.headline6,
        // ),

        //  Text(
        //   title,
        //   style: Theme.of(context).textTheme.headline6,
        // ),
        elevation: 0,
      );
    });
  }

  Widget _translateButton(StateSetter setState, BuildContext context) {
    return IconButton(
        // key: _bshowcase,
        onPressed: () async {
          await FirebaseAnalyticsService.addCustomAnalyticsEvent(
              "language_translate");

          setState(() {});
          LanguageSelector(context, (language) {
            if (language != null) {
              setState(() {
                Globals.selectedLanguage = language;
                Globals.languageChanged.value = language;
              });
              refresh!(true);
            }
          });
        },
        icon: Container(
          child: Image(
            width: !Overrides.STANDALONE_GRADED_APP
                ? Globals.deviceType == "phone"
                    ? 26
                    : 32
                : 28,
            height: !Overrides.STANDALONE_GRADED_APP
                ? Globals.deviceType == "phone"
                    ? 26
                    : 32
                : 28,
            image: AssetImage("assets/images/gtranslate.png"),
          ),
        ));

    //  Container(
    //   padding: EdgeInsets.only(left: 10),
    //   child: GestureDetector(
    //     key: _bshowcase,
    //     child: Image(
    //       width: Globals.deviceType == "phone" ? 26 : 32,
    //       height: Globals.deviceType == "phone" ? 26 : 32,
    //       image: AssetImage("assets/images/gtranslate.png"),
    //     ),
    //     onTap: () async {
    //       await FirebaseAnalyticsService.addCustomAnalyticsEvent(
    //           "language_translate");

    //       setState(() {});
    //       LanguageSelector(context, (language) {
    //         if (language != null) {
    //           setState(() {
    //             Globals.selectedLanguage = language;
    //             Globals.languageChanged.value = language;
    //           });
    //           refresh!(true);
    //         }
    //       });
    //     },
    //   ),
    // );
  }

  // Widget _openSettingsButton(BuildContext context) {
  //   return IconButton(
  //     iconSize: 28,
  //     onPressed: () async {
  //       await FirebaseAnalyticsService.addCustomAnalyticsEvent(
  //           "settings_drawer");
  //       if (Platform.isAndroid) {
  //         OpenAppsSettings.openAppsSettings(
  //             settingsCode: SettingsCode.ACCESSIBILITY);
  //       } else {
  //         // AppSettings.openAccessibilitySettings(asAnotherTask: true);
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (BuildContext context) =>
  //                     IosAccessibilityGuidePage()));
  //       }
  //     },
  //     icon: Icon(
  //       FontAwesomeIcons.universalAccess,
  //       color: Colors.blue,
  //       key: _openSettingShowCaseKey,
  //       size: !Overrides.STANDALONE_GRADED_APP
  //           ? Globals.deviceType == "phone"
  //               ? 25
  //               : 32
  //           : null,
  //     ),
  //   );
  // }

  Widget wordScreenIconWidget() {
    return Container(
        height: 50,
        child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: ClipRRect(
              child: Image(
                image: Image.asset(Strings.gradedPlusImage).image,
              ),
            )));
  }

  Widget allScreenIconWidget() {
    return Container(
      padding: EdgeInsets.only(right: 7),
      child: Icon(
        IconData(
          titleIconCode!,
          fontFamily: Overrides.kFontFam,
          fontPackage: Overrides.kFontPkg,
        ),
        color: AppTheme.kButtonColor,
      ),
    );
  }

  Future<UserInformation> getUserProfile() async {
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    List<UserInformation> _userInformation = await _localDb.getData();
    Globals.teacherEmailId = _userInformation[0].userEmail!;
    //print("//printing _userInformation length : ${_userInformation[0]}");
    return _userInformation[0];
  }
}