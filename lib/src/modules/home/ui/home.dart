import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/family.dart';
import 'package:Soc/src/modules/home/ui/iconsmenu.dart';
import 'package:Soc/src/modules/home/ui/search.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/ui/news.dart';
import 'package:Soc/src/modules/setting/information.dart';
import 'package:Soc/src/modules/setting/setting.dart';
import 'package:Soc/src/modules/social/ui/Soical.dart';
import 'package:Soc/src/modules/staff/ui/staff.dart';
import 'package:Soc/src/modules/students/ui/student.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../overrides.dart';

class HomePage extends StatefulWidget {
  final String? title;
  var homeObj;
  HomePage({Key? key, this.title, this.homeObj}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const double _kLabelSpacing = 16.0;
  static const double _kIconSize = 35.0;
  final NewsBloc _bloc = new NewsBloc();

  bool _status = false;
  var item;
  var item2;
  final ValueNotifier<bool> indicator = ValueNotifier<bool>(false);
  Timer? timer;
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
    setState(() {
      _status = prefs.getBool("enableIndicator")!;
      if (_status == true) {
        indicator.value = true;
      } else {
        indicator.value = false;
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
      ),
      onSelected: (value) {
        switch (value) {
          case IconsMenu.Information:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => InformationPage()));
            break;
          case IconsMenu.Setting:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingPage()));
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
    if (list[_selectedIndex].split("_")[0] == "Social") {
      return SocialPage();
    } else if (list[_selectedIndex].split("_")[0] == "News") {
      hideIndicator();
      return NewsPage();
    } else if (list[_selectedIndex].split("_")[0] == "Students") {
      return StudentPage();
    } else if (list[_selectedIndex].split("_")[0] == "Families") {
      return FamilyPage(
        obj: widget.homeObj,
      );
    } else if (list[_selectedIndex].split("_")[0] == "Staff") {
      return StaffPage();
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
            leading: _selectedIndex == 3
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: const Icon(IconData(0xe800,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg)),
                  )
                : Container(
                    height: 0,
                  ),
            title:
                SizedBox(width: 100.0, height: 60.0, child: BearIconWidget()),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchPage(
                                  isbuttomsheet: true,
                                )));
                  },
                  icon: Icon(
                    const IconData(0xe805,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                  )),
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
                          Text(
                            e.split("_")[0],
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          ValueListenableBuilder(
                            builder: (BuildContext context, dynamic value,
                                Widget? child) {
                              return e.split("_")[0] == "News" &&
                                      indicator.value == true
                                  ? Container(
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
                        ),
                      ),
                    ]),
                    label: '',
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
