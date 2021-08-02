import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/family.dart';
import 'package:Soc/src/modules/home/ui/iconsmenu.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/ui/news.dart';
import 'package:Soc/src/modules/setting/information.dart';
import 'package:Soc/src/modules/setting/setting.dart';
import 'package:Soc/src/modules/social/ui/soical.dart';
import 'package:Soc/src/modules/staff/ui/staff.dart';
import 'package:Soc/src/modules/students/ui/student.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/translator/lanuage_selector.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/searchbuttonwidget.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../overrides.dart';

class HomePage extends StatefulWidget {
  final String? title;
  final homeObj;
  String? language;
  HomePage({Key? key, this.title, this.homeObj, this.language})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const double _kLabelSpacing = 16.0;
  static const double _kIconSize = 35.0;
  final NewsBloc _bloc = new NewsBloc();
  String language1 = Translations.supportedLanguages.first;
  String language2 = Translations.supportedLanguages.last;

  bool _status = false;
  var item;
  var item2;
  final ValueNotifier<bool> indicator = ValueNotifier<bool>(false);
  final ValueNotifier<String> languageChanged =
      ValueNotifier<String>("English");
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();
  Timer? timer;
  String? selectedLanguage;
  @override
  void initState() {
    super.initState();

    _bloc.initPushState(context);
    _selectedIndex = Globals.outerBottombarIndex ?? 0;
    timer =
        Timer.periodic(Duration(seconds: 5), (Timer t) => getindicatorValue());
  }

  getindicatorValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedLanguage = await _sharedPref.getString('selected_language');
    setState(() {
      _status = prefs.getBool("enableIndicator")!;
      if (_status == true) {
        indicator.value = true;
      } else {
        indicator.value = false;
      }

      if (selectedLanguage != null) {
        languageChanged.value = selectedLanguage!;
      }
    });
  }

  Widget _buildPopupMenuWidget() {
    return PopupMenuButton<IconMenu>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      icon: Icon(
        const IconData(0xe806,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: AppTheme.kIconColor2,
        size: Globals.deviceType == "phone" ? 20 : 28,
      ),
      onSelected: (value) {
        switch (value) {
          case IconsMenu.Information:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InformationPage(
                          htmlText: Globals.homeObjet["App_Information__c"],
                          isbuttomsheet: true,
                          ishtml: true,
                          appbarTitle: "Information",
                          language: selectedLanguage,
                        )));
            break;
          case IconsMenu.Setting:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingPage(
                          language: selectedLanguage,
                          isbuttomsheet: true,
                          appbarTitle: "Setting",
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
                padding: const EdgeInsets.symmetric(
                    horizontal: _kLabelSpacing / 4, vertical: 0),
                child: Text(
                  item.text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Color(0xff474D55)),
                ),
              )))
          .toList(),
    );
  }

  hideIndicator() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("enableIndicator", false);
  }

  selectedScreenBody(context, _selectedIndex, list) {
    if (list[_selectedIndex].split("_")[0].contains("Social")) {
      return SocialPage(
        language: selectedLanguage,
      );
    } else if (list[_selectedIndex].split("_")[0].contains("News")) {
      hideIndicator();
      return NewsPage(
        language: selectedLanguage,
      );
    } else if (list[_selectedIndex].split("_")[0].contains("Student")) {
      return StudentPage(
        language: selectedLanguage,
      );
    } else if (list[_selectedIndex].split("_")[0].contains("Famil")) {
      return FamilyPage(
        obj: widget.homeObj,
        language: selectedLanguage,
      );
    } else if (list[_selectedIndex].split("_")[0].contains("Staff")) {
      return StaffPage(
        language: selectedLanguage,
      );
    }
  }

  _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: AppTheme.kBackgroundColor,
              title: Text(
                "Do you want to exit the app?",
                style: Theme.of(context).textTheme.headline2,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    "No",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                TextButton(
                  onPressed: () => exit(0),
                  child: Text(
                    "Yes",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
        appBar: new AppBar(
            leadingWidth: _kIconSize,
            elevation: 0.0,
            leading:
                // _selectedIndex == 3
                //     ?
                GestureDetector(
              onTap: () {
                LanguageSelector(context, item, (language) {
                  if (language != null) {
                    setState(() {
                      selectedLanguage = language;
                      languageChanged.value = language;
                    });
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: const Icon(IconData(0xe800,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg)),
              ),
            ),
            title: SizedBox(width: 100.0, height: 60.0, child: AppLogoWidget()),
            actions: <Widget>[
              SearchButtonWidget(
                language: selectedLanguage,
              ),
              _buildPopupMenuWidget(),
            ]),
        body: selectedScreenBody(context, _selectedIndex,
            Globals.homeObjet["Bottom_Navigation__c"].split(";")),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          items: Globals.homeObjet["Bottom_Navigation__c"]
              .split(";")
              .map<BottomNavigationBarItem>((e) => BottomNavigationBarItem(
                    icon: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                            builder: (BuildContext context, dynamic value,
                                Widget? child) {
                              return

                                  // selectedLanguage != null ||
                                  //         langadded.value != "English"
                                  //     ? TranslationWidget(
                                  //         message: e.split("_")[0],
                                  //         toLanguage: langadded.value,
                                  //         builder: (translatedMessage) => Text(
                                  //           translatedMessage,
                                  //           textAlign: TextAlign.center,
                                  //           style: Theme.of(context)
                                  //               .textTheme
                                  //               .subtitle2,
                                  //         ),
                                  //       )
                                  //     :

                                  Wrap(
                                children: [
                                  Text(
                                    e.split("_")[0],
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                ],
                              );
                            },
                            valueListenable: languageChanged,
                            child: Container(),
                          ),
                          ValueListenableBuilder(
                            builder: (BuildContext context, dynamic value,
                                Widget? child) {
                              return e.split("_")[0] == "News" &&
                                      indicator.value == true
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      height: 8,
                                      width: 8,
                                      margin: EdgeInsets.only(left: 3),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle),
                                    )
                                  : Container();
                            },
                            valueListenable: indicator,
                            child: Container(),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Icon(
                          IconData(int.parse(e.split("_")[1]),
                              fontFamily: Overrides.kFontFam,
                              fontPackage: Overrides.kFontPkg),
                          size: Globals.deviceType == "phone" ? 24 : 32,
                        ),
                      ),
                    ]),
                    label: '', //'${e.split("_")[0]}',
                  ))
              .toList(),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              Globals.internalBottombarIndex = index;
            });
          },
        ),
      ),
    );
  }
}
