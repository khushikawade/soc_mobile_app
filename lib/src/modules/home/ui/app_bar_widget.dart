import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/iconsmenu.dart';
import 'package:Soc/src/modules/setting/information.dart';
import 'package:Soc/src/modules/setting/setting.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/translator/lanuage_selector.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/searchbuttonwidget.dart';
import 'package:app_settings/app_settings.dart';
import 'package:bubble_showcase/bubble_showcase.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_bubble/speech_bubble.dart';
import 'package:open_apps_settings/open_apps_settings.dart';
import 'package:open_apps_settings/settings_enum.dart';

// class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
//   final double _kIconSize = Globals.deviceType == "phone" ? 35 : 45.0;

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:open_apps_settings/open_apps_settings.dart';
// import 'package:open_apps_settings/settings_enum.dart';

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
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  //final SharedPreferencesFn _sharedPref = SharedPreferencesFn();
  bool? initalscreen;

  final GlobalKey _bshowcase = GlobalKey();

  AppBarWidget({Key? key, required this.refresh, required this.marginLeft})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  Widget _buildPopupMenuWidget(BuildContext context) {
    final scaffoldKey = Scaffold.of(context);
    return PopupMenuButton<IconMenu>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      icon: Icon(
        const IconData(0xe806,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        size: Globals.deviceType == "phone" ? 20 : 28,
      ),
      onSelected: (value) {
        switch (value) {
          case IconsMenu.Information:
            Globals.appSetting.appInformationC != null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InformationPage(
                              appbarTitle: 'Information',
                              isbuttomsheet: true,
                              ishtml: true,
                            )))
                : scaffoldKey.showSnackBar(
                    SnackBar(
                      content: const Text(
                        'No Information Available',
                      ),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).size.height * 0.04),
                      padding: EdgeInsets.only(
                        left: 16,
                      ),
                      backgroundColor: Colors.black.withOpacity(0.8),
                    ),
                  );
            break;
          case IconsMenu.Setting:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingPage(
                          appbarTitle: '',
                          isbuttomsheet: true,
                        )));
            break;
          case IconsMenu.Permissions:
            AppSettings.openAppSettings();
            break;
        }
      },
      itemBuilder: (context) => IconsMenu.items
          .map((item) => PopupMenuItem<IconMenu>(
              value: item,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: _kLabelSpacing / 4, vertical: 0),
                child: Text(
                  item.text,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                ),
              )))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AppBar(
          // automaticallyImplyLeading: true,
          leadingWidth: _kIconSize,
          elevation: 0.0,
          leading: Row(
            children: [
              Globals.initalscreen == false
                  ? _showcase(setState, context)
                  : Container(
                      padding: EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        key: _bshowcase,
                        child: Image(
                          width: Globals.deviceType == "phone" ? 24 : 32,
                          height: Globals.deviceType == "phone" ? 24 : 32,
                          image: AssetImage("assets/images/gtranslate.png"),
                        ),
                        onTap: () {
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
                      )
                      // : GestureDetector(
                      //     child: Image(
                      //       width: Globals.deviceType == "phone" ? 24 : 32,
                      //       height: Globals.deviceType == "phone" ? 24 : 32,
                      //       image: AssetImage("assets/images/gtranslate.png"),
                      //     ),
                      //     onTap: () {
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
                      //   )

                      //initalscreen == false || initalscreen == null
                      //     ? BubbleShowcase(
                      //         bubbleShowcaseId: 'my_bubble_showcase',
                      //         bubbleSlides: [
                      //           _firstSlide(TextStyle()),
                      //         ],
                      //         bubbleShowcaseVersion: 1,
                      //         child: GestureDetector(
                      //           child: Image(
                      //             height: Globals.deviceType == "phone" ? 24 : 32,
                      //             image: AssetImage("assets/images/gtranslate.png"),
                      //           ),
                      //           onTap: () {
                      //             setState(() {});
                      //             LanguageSelector(context, (language) {
                      //               if (language != null) {
                      //                 setState(() {
                      //                   Globals.selectedLanguage = language;
                      //                   Globals.languageChanged.value = language;
                      //                 });
                      //                 refresh!(true);
                      //               }
                      //             });
                      //           },
                      //         ))
                      //     :
                      //     GestureDetector(
                      //   child: Image(
                      //     height: Globals.deviceType == "phone" ? 24 : 32,
                      //     image: AssetImage("assets/images/gtranslate.png"),
                      //   ),
                      //   onTap: () {
                      //     setState(() {});
                      //     LanguageSelector(context, (language) {
                      //       if (language != null) {
                      //         setState(() {
                      //           Globals.selectedLanguage = language;
                      //           Globals.languageChanged.value = language;
                      //         });
                      //         refresh!(true);
                      //       }
                      //     });
                      //   },
                      // )

                      //      Image(
                      //       key: _bshowcase,
                      //       image: AssetImage("assets/images/gtranslate.png"),
                      //     ),
                      //   )
                      // : Image(
                      //     image: AssetImage("assets/images/gtranslate.png"),
                      //   ),
                      ),
              Container(
                  padding: EdgeInsets.only(left: 10),
                  child: IconButton(
                    onPressed: () {
                      OpenAppsSettings.openAppsSettings(
                          settingsCode: SettingsCode.ACCESSIBILITY);
                    },
                    icon: Icon(
                      FontAwesomeIcons.universalAccess,
                      color: Colors.blue,
                      size: Globals.deviceType == "phone" ? 26 : 32,
                    ),
                  )),
            ],
          ),

          // leading: Row(
          //   // crossAxisAlignment: CrossAxisAlignment.center,
          //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Container(
          //       padding: EdgeInsets.only(left: 10),
          //       child: GestureDetector(
          //         child: Image(
          //           height: Globals.deviceType == "phone" ? 28 : 32,
          //           image: AssetImage("assets/images/gtranslate.png"),
          //         ),
          //         // Icon(
          //         //   IconData(0xe822,
          //         //       fontFamily: Overrides.kFontFam,
          //         //       fontPackage: Overrides.kFontPkg),
          //         //   size: Globals.deviceType == "phone" ? 32 : 40,
          //         // ),
          //         onTap: () {
          //           setState(() {});
          //           LanguageSelector(context, (language) {
          //             if (language != null) {
          //               setState(() {
          //                 Globals.selectedLanguage = language;
          //                 Globals.languageChanged.value = language;
          //               });
          //               refresh!(true);
          //             }
          //           });
          //         },
          //       ),
          //     ),
          //     Container(
          //         padding: EdgeInsets.only(left: 10),
          //         child: IconButton(
          //           onPressed: () {
          //             OpenAppsSettings.openAppsSettings(
          //                 settingsCode: SettingsCode.ACCESSIBILITY);
          //           },
          //           icon: Icon(
          //             FontAwesomeIcons.universalAccess,
          //             color: Colors.blue,
          //             size: Globals.deviceType == "phone" ? 20 : 32,
          //           ),
          //         )),
          //   ],
          // ),
          title: AppLogoWidget(
            marginLeft: marginLeft,
          ), //SizedBox(width: 100.0, height: 60.0, child: AppLogoWidget()),
          actions: <Widget>[
            SearchButtonWidget(
              language: 'English',
            ),
            _buildPopupMenuWidget(context),
          ]);
    });
  }

  Container _showcase(StateSetter setState, BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10),
        child: BubbleShowcase(
            bubbleShowcaseId: 'my_bubble_showcase',
            bubbleSlides: [
              _firstSlide(),
            ],
            bubbleShowcaseVersion: 1,
            child: GestureDetector(
              key: _bshowcase,
              child: Image(
                width: Globals.deviceType == "phone" ? 24 : 32,
                height: Globals.deviceType == "phone" ? 24 : 32,
                image: AssetImage("assets/images/gtranslate.png"),
              ),
              onTap: () {
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
            ))
        // : GestureDetector(
        //     child: Image(
        //       width: Globals.deviceType == "phone" ? 24 : 32,
        //       height: Globals.deviceType == "phone" ? 24 : 32,
        //       image: AssetImage("assets/images/gtranslate.png"),
        //     ),
        //     onTap: () {
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
        //   )

        //initalscreen == false || initalscreen == null
        //     ? BubbleShowcase(
        //         bubbleShowcaseId: 'my_bubble_showcase',
        //         bubbleSlides: [
        //           _firstSlide(TextStyle()),
        //         ],
        //         bubbleShowcaseVersion: 1,
        //         child: GestureDetector(
        //           child: Image(
        //             height: Globals.deviceType == "phone" ? 24 : 32,
        //             image: AssetImage("assets/images/gtranslate.png"),
        //           ),
        //           onTap: () {
        //             setState(() {});
        //             LanguageSelector(context, (language) {
        //               if (language != null) {
        //                 setState(() {
        //                   Globals.selectedLanguage = language;
        //                   Globals.languageChanged.value = language;
        //                 });
        //                 refresh!(true);
        //               }
        //             });
        //           },
        //         ))
        //     :
        //     GestureDetector(
        //   child: Image(
        //     height: Globals.deviceType == "phone" ? 24 : 32,
        //     image: AssetImage("assets/images/gtranslate.png"),
        //   ),
        //   onTap: () {
        //     setState(() {});
        //     LanguageSelector(context, (language) {
        //       if (language != null) {
        //         setState(() {
        //           Globals.selectedLanguage = language;
        //           Globals.languageChanged.value = language;
        //         });
        //         refresh!(true);
        //       }
        //     });
        //   },
        // )

        //      Image(
        //       key: _bshowcase,
        //       image: AssetImage("assets/images/gtranslate.png"),
        //     ),
        //   )
        // : Image(
        //     image: AssetImage("assets/images/gtranslate.png"),
        //   ),
        );
  }

  BubbleSlide _firstSlide() => RelativeBubbleSlide(
      widgetKey: _bshowcase,
      shape: const Circle(
        spreadRadius: 8,
      ),
      child: AbsoluteBubbleSlideChild(
        widget: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: SpeechBubble(
            nipLocation: NipLocation.TOP_LEFT,
            // nipHeight: 30,
            color: Colors.blue,
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(
                "Translate/Traducción/翻译/ترجمة/Traduction",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              )
            ]),
          ),
        ),
        positionCalculator: (size) => Position(
          top: 15,
          left: 10,
        ),
      ));
}



// Container _showcase1(StateSetter setState, BuildContext context) {
//   return Container(
//       padding: EdgeInsets.only(left: 10),
//       child: GestureDetector(
//         child: Image(
//           width: Globals.deviceType == "phone" ? 24 : 32,
//           height: Globals.deviceType == "phone" ? 24 : 32,
//           image: AssetImage("assets/images/gtranslate.png"),
//         ),
//         onTap: () {
//           setState(() {});
//           LanguageSelector(context, (language) {
//             if (language != null) {
//               setState(() {
//                 Globals.selectedLanguage = language;
//                 Globals.languageChanged.value = language;
//               });
            
//             }
//           });
//         },
//       ));
//}
