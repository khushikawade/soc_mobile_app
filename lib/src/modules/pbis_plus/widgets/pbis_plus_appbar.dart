import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/plus_common_widgets/profile_page.dart';
import 'package:Soc/src/modules/setting/ios_accessibility_guide_page.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/lanuage_selector.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_apps_settings/open_apps_settings.dart';
import 'package:open_apps_settings/settings_enum.dart';

class PBISPlusAppBar extends StatefulWidget implements PreferredSizeWidget {
  final IconData? titleIconData;
  final String title;
  final bool? backButton;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool? isGradedPlus;
  PBISPlusAppBar(
      {Key? key,
      this.titleIconData,
      this.backButton,
      required this.title,
      required this.scaffoldKey,
      this.isGradedPlus = false})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);
  @override
  final Size preferredSize;
  @override
  State<PBISPlusAppBar> createState() => _PBISPlusAppBarState();
}

class _PBISPlusAppBarState extends State<PBISPlusAppBar> {
  @override
  Widget build(BuildContext context) {
    Widget leading = Container(
      child: Row(
        children: [
          _translateButton(setState, context),
          _openAccessibility(context),
        ],
      ),
    );

    List<Widget>? actions = [
      FutureBuilder(
          future: getUserProfile(),
          builder: (context, AsyncSnapshot<UserInformation> snapshot) {
            if (snapshot.hasData) {
              return Container(
                // padding: EdgeInsets.only(right: 5.0),
                child: IconButton(
                  icon: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    child: CachedNetworkImage(
                      height: 28,
                      width: 28,
                      imageUrl: snapshot.data!.profilePicture!,
                      placeholder: (context, url) => CupertinoActivityIndicator(
                          animating: true, radius: 10),
                    ),
                  ),
                  onPressed: () async {
                    /*-------------------------User Activity Track START----------------------------*/
                    await FirebaseAnalyticsService.addCustomAnalyticsEvent(
                        "Teacher profile screen PBIS+");
                    /*-------------------------User Activity Track END----------------------------*/

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                fromGradedPlus: false,
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
    ];

    return AppBar(
      leadingWidth: 110,
      actions: actions,
      centerTitle: true,
      leading: leading,
      title: widget.isGradedPlus == true
          ? gradedLogoBuilder(context)
          : titleBuilder(context, widget.titleIconData),
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  Future<UserInformation> getUserProfile() async {
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    List<UserInformation> _userInformation = await _localDb.getData();
    Globals.teacherEmailId = _userInformation[0].userEmail!;
    //print("//printing _userInformation length : ${_userInformation[0]}");
    return _userInformation[0];
  }

  Widget _translateButton(StateSetter setState, BuildContext context) {
    return IconButton(
        // key: _bshowcase,
        onPressed: () async {
          setState(() {});
          LanguageSelector(context, (language) {
            if (language != null) {
              setState(() {
                Globals.selectedLanguage = language;
                Globals.languageChanged.value = language;
              });
              // refresh!(true);
            }
          });
          /*-------------------------User Activity Track START----------------------------*/
          FirebaseAnalyticsService.addCustomAnalyticsEvent(
              'Google Translation PBIS+'.toLowerCase().replaceAll(" ", "_"));

          Utility.updateLogs(
              activityType: 'PBIS+',
              activityId: '43',
              description: 'Google Translation',
              operationResult: 'Success');
          /*-------------------------User Activity Track END----------------------------*/
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
  }

  Widget _openAccessibility(BuildContext context) {
    return IconButton(
      iconSize: 28,
      onPressed: () async {
        if (Platform.isAndroid) {
          OpenAppsSettings.openAppsSettings(
              settingsCode: SettingsCode.ACCESSIBILITY);
        } else {
          // AppSettings.openAccessibilitySettings(asAnotherTask: true);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      IosAccessibilityGuidePage()));
        }
      },
      icon: Icon(
        FontAwesomeIcons.universalAccess,
        color: Colors.blue,
        // key: _openSettingShowCaseKey,
        size: !Overrides.STANDALONE_GRADED_APP
            ? Globals.deviceType == "phone"
                ? 25
                : 32
            : null,
      ),
    );
  }
}

Widget titleBuilder(BuildContext context, IconData? iconData) {
  return Icon(iconData, color: AppTheme.kButtonColor);
}

Widget gradedLogoBuilder(
  BuildContext context,
) {
  return Image.asset(
    Color(0xff000000) == Theme.of(context).backgroundColor
        ? "assets/images/graded+_light.png"
        : "assets/images/graded+_dark.png",
    height: Globals.deviceType == "phone"
        ? AppTheme.kIconSize * 2
        : AppTheme.kTabIconSize * 2,
    width: Globals.deviceType == "phone"
        ? AppTheme.kIconSize * 2
        : AppTheme.kTabIconSize * 2,
  );
}
