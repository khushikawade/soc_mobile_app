import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/iconsmenu.dart';
import 'package:Soc/src/modules/schedule/ui/school_calender.dart';
import 'package:Soc/src/modules/setting/information.dart';
import 'package:Soc/src/modules/setting/ios_accessibility_guide_page.dart';
import 'package:Soc/src/modules/setting/setting.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/translator/lanuage_selector.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/searchbuttonwidget.dart';
import 'package:bubble_showcase/bubble_showcase.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:open_apps_settings/open_apps_settings.dart';
import 'package:open_apps_settings/settings_enum.dart';
import 'package:speech_bubble/speech_bubble.dart';

// ignore: must_be_immutable
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final double _kIconSize = Globals.deviceType == "phone" ? 100 : 100.0;
  final double height = 60;
  final double _kLabelSpacing = 16.0;
  final String language1 = Translations.supportedLanguages.first;
  final String language2 = Translations.supportedLanguages.last;
  final ValueNotifier<String> languageChanged =
      ValueNotifier<String>("English");
  final ValueChanged? refresh;
  final double? marginLeft;
  bool? initalscreen;
  bool? hideAccessibilityButton;
  bool? showClosebutton;
  Widget? actionButton;

  final GlobalKey _bshowcase = GlobalKey();
  final GlobalKey _openSettingShowCaseKey = GlobalKey();
  final VoidCallback? onTap;
  AppBarWidget(
      {Key? key,
      required this.refresh,
      required this.marginLeft,
      this.hideAccessibilityButton,
      this.onTap,
      this.showClosebutton,
      this.actionButton})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  Widget _buildPopupMenuWidget(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    final scaffoldKey = Scaffold.of(context);
    return PopupMenuButton<IconMenu>(
      color: Globals.themeType != 'Dark'
          ? Theme.of(context).backgroundColor
          : Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      icon: Icon(
        const IconData(0xe806,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        size: Globals.deviceType == "phone" ? 20 : 28,
      ),
      onSelected: (value) async {
        //   Utility.setFree();
        switch (value) {
          case IconsMenu.Information:
            Globals.appSetting.appInformationC != null
                ? await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InformationPage(
                              appbarTitle: 'Information',
                              isBottomSheet: true,
                              ishtml: true,
                            )))
                : Utility.showSnackBar(
                    scaffoldKey, 'No Information Available', context, null);
            break;
          case IconsMenu.Setting:
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingPage(
                          appbarTitle: '',
                          isBottomSheet: true,
                        )));

            break;
          case IconsMenu.Permissions:
            OpenAppsSettings.openAppsSettings(
                settingsCode: SettingsCode.APP_SETTINGS);
            break;
        }
        // Utility.setLocked();
      },
      itemBuilder: (context) => IconsMenu.items
          .map((item) => PopupMenuItem<IconMenu>(
              height: Globals.deviceType != "phone"
                  ? currentOrientation == Orientation.portrait
                      ? MediaQuery.of(context).size.height / 17
                      : MediaQuery.of(context).size.width / 17
                  : kMinInteractiveDimension,
              value: item,
              child: Container(
                width: Globals.deviceType != "phone"
                    ? currentOrientation == Orientation.portrait
                        ? MediaQuery.of(context).size.width / 5
                        : MediaQuery.of(context).size.height / 5
                    : null,
                padding: EdgeInsets.symmetric(
                    horizontal: _kLabelSpacing / 4, vertical: 0),
                child: TranslationWidget(
                    message: item.text,
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) {
                      return Text(
                        translatedMessage.toString(),
                        style:
                            Theme.of(context).textTheme.bodyText1!.copyWith(),
                      );
                    }),
              )))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AppBar(
          backgroundColor: Overrides.STANDALONE_GRADED_APP == true
              ? Colors.transparent
              : null,
          leadingWidth: _kIconSize,
          elevation: 0.0,
          leading: BubbleShowcase(
            counterText: null,
            enabled: !Globals.hasShowcaseInitialised.value,
            showCloseButton: false,
            bubbleShowcaseId: 'my_bubble_showcase',
            bubbleSlides: [
              _firstSlide(context),
              _openSettingsButtonSlide(context)
            ],
            bubbleShowcaseVersion: 1,
            onFinished: () {
              setState(() {
                Globals.hasShowcaseInitialised.value = true;
              });
              _promtPushNotificationPermission();
              if (refresh != null) refresh!(true);
            },
            child: Row(
              children: [
                showClosebutton == true
                    ? Container(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              size: Globals.deviceType == "phone" ? 30 : 34,
                            )),
                      )
                    : Container(),
                _translateButton(setState, context),
                hideAccessibilityButton == true
                    ? //To adjust Accessibility button apearance in the AppBar, since we are using the smae common widget in the Accessibility page and we don't wnat to show this "Accessibility Button" on the "Accessibility Page" itself.
                    Container()
                    : _openSettingsButton(context),
              ],
            ),
          ),
          titleSpacing: 0,
          title: GestureDetector(
            // splashFactory: NoSplash.splashFactory,
            onTap: onTap,
            // splashColor: Theme.of(context).backgroundColor,
            // focusColor: Theme.of(context).backgroundColor,
            child: AppLogoWidget(
              marginLeft: marginLeft,
            ),
          ),
          actions: Overrides.STANDALONE_GRADED_APP == true
              ? <Widget>[
                  actionButton!
                  // Container(
                  //   width: 30,
                  // )
                ]
              : <Widget>[
                  SearchButtonWidget(
                    language: 'English',
                  ),
                  _buildPopupMenuWidget(context),
                ]);
    });
  }

  void _promtPushNotificationPermission() async {
    if (Platform.isIOS) {
      await OneSignal.shared
          .promptUserForPushNotificationPermission(fallbackToSettings: true);
    }
    if (Platform.isAndroid) {
      await OneSignal.shared
          .promptUserForPushNotificationPermission(fallbackToSettings: true);
    }
  }

  // Future<UserInformation> getUserProfile() async {
  //   LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
  //   List<UserInformation> _userInformation = await _localDb.getData();
  //   Globals.teacherEmailId = _userInformation[0].userEmail!;
  //   //print("//printing _userInformation length : ${_userInformation[0]}");
  //   return _userInformation[0];
  // }

  Widget _translateButton(StateSetter setState, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: GestureDetector(
        key: _bshowcase,
        child: Image(
          width: Globals.deviceType == "phone" ? 26 : 32,
          height: Globals.deviceType == "phone" ? 26 : 32,
          image: AssetImage("assets/images/gtranslate.png"),
        ),
        onTap: () async {
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
      ),
    );
  }

  Widget _openSettingsButton(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 5),
        child: IconButton(
          onPressed: () async {
            await FirebaseAnalyticsService.addCustomAnalyticsEvent(
                "settings_drawer");
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
            key: _openSettingShowCaseKey,
            size: Globals.deviceType == "phone" ? 25 : 32,
          ),
        ));
  }

  BubbleSlide _firstSlide(context) => RelativeBubbleSlide(
      widgetKey: _bshowcase,
      shape: const Circle(
        spreadRadius: 8,
      ),
      passThroughMode: PassthroughMode.NONE,
      child: AbsoluteBubbleSlideChild(
        widget: Padding(
          padding: const EdgeInsets.only(top: 0.5),
          child: SpeechBubble(
            borderRadius: 8,
            nipLocation: NipLocation.TOP_LEFT,
            // nipHeight: 30,
            color: Globals.themeType == 'Dark' ? Colors.white : Colors.black87,
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(
                "Translate/Traducción/翻译/ترجمة/Traduction",
                style: TextStyle(
                  color: Globals.themeType == 'Dark'
                      ? Colors.black87
                      : Colors.white,
                  fontSize: 18.0,
                ),
              )
            ]),
          ),
        ),
        positionCalculator: (size) => Position(
            // top: Utility.displayHeight(context) * .120,
            // left: Utility.displayWidth(context) * 0.030,
            top: _calculateWidgetOffset(_bshowcase).dy + 45,
            left: _calculateWidgetOffset(_bshowcase).dx),
      ));

  BubbleSlide _openSettingsButtonSlide(context) => RelativeBubbleSlide(
      widgetKey: _openSettingShowCaseKey,
      shape: const Circle(
        spreadRadius: 8,
      ),
      passThroughMode: PassthroughMode.NONE,
      child: AbsoluteBubbleSlideChild(
        widget: Padding(
          padding: const EdgeInsets.only(top: 0.5),
          child: SpeechBubble(
            borderRadius: 2,
            nipLocation: NipLocation.TOP_LEFT,
            // nipHeight: 30,
            color: Globals.themeType == 'Dark' ? Colors.white : Colors.black87,
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(
                "Accessibility Settings",
                style: TextStyle(
                  color: Globals.themeType == 'Dark'
                      ? Colors.black87
                      : Colors.white,
                ),
              )
            ]),
          ),
        ),
        positionCalculator: (size) => Position(
          // top: Utility.displayHeight(context) * .120,
          // left: Utility.displayWidth(context) * 0.120,
          top: _calculateWidgetOffset(_openSettingShowCaseKey).dy + 45,
          left: _calculateWidgetOffset(_openSettingShowCaseKey).dx + 2,
        ),
      ));

  Offset _calculateWidgetOffset(GlobalKey key) {
    RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    return position;
  }
}
