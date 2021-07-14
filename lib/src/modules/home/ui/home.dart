import 'package:Soc/src/modules/families/ui/family.dart';
import 'package:Soc/src/modules/home/ui/iconsmenu.dart';
import 'package:Soc/src/modules/news/ui/news.dart';
import 'package:Soc/src/modules/setting/information/ui/information.dart';
import 'package:Soc/src/modules/setting/settiings/ui/setting.dart';
import 'package:Soc/src/modules/social/ui/Soical.dart';
import 'package:Soc/src/modules/staff/ui/staff.dart';
import 'package:Soc/src/modules/students/ui/student.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

import '../../../overrides.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.title, this.obj}) : super(key: key);
  final String? title;
  var obj;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const double _kLabelSpacing = 16.0;
  static const double _kIconSize = 35.0;

  //STYLE
  // static const _kPopMenuTextStyle = TextStyle(
  //     fontFamily: "Roboto Regular", fontSize: 14, color: Color(0xff474D55));

  // Top-Section Widget

  @override
  void initState() {
    super.initState();
    if (widget.obj != null && widget.obj["Bottom_Navigation__c"] != null) {
      print(widget.obj["Bottom_Navigation__c"]);
    }
  }

  Widget _buildPopupMenuWidget() {
    return PopupMenuButton<IconMenu>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      icon: Icon(
        const IconData(0xe80c,
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

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  selectedScreenBody(context, _selectedIndex) {
    if (_selectedIndex == 0) {
      return StudentPage();
    } else if (_selectedIndex == 1) {
      return NewsPage();
    } else if (_selectedIndex == 2) {
      return StudentPage();
    } else if (_selectedIndex == 3) {
      return FamilyPage();
    } else if (_selectedIndex == 4) {
      return StaffPage();
    }
  }

  var bottomNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.explore), title: Text("Explore")),
    BottomNavigationBarItem(
        icon: Icon(Icons.account_circle), title: Text("Account")),
  ];

  Widget buttomNavigationWidget() {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Text(
                  "Social",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Icon(
                    const IconData(0xe80d,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                  ),
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(children: [
              Text(
                "News",
                style: Theme.of(context).textTheme.subtitle2,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Icon(
                  const IconData(0xe807,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  // size: 40.0,
                ),
              ),
            ]),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Text(
                  "Students",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Icon(
                    const IconData(0xe810,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                  ),
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(children: [
              Text(
                "Families",
                style: Theme.of(context).textTheme.subtitle2,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Icon(
                  const IconData(0xe801,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                ),
              ),
            ]),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(children: [
              Text(
                "Staff",
                style: Theme.of(context).textTheme.subtitle2,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Icon(
                  const IconData(0xe80e,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                ),
              ),
            ]),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          leadingWidth: _kIconSize,
          elevation: 0.0,
          leading: _selectedIndex == 3
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(IconData(0xe806,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg)),
                )
              : Container(
                  height: 0,
                ),
          title: SizedBox(width: 100.0, height: 60.0, child: BearIconWidget()),
          actions: <Widget>[
            _selectedIndex == 3
                ? Icon(
                    const IconData(0xe80b,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                  )
                : Container(
                    height: 0,
                  ),
            _buildPopupMenuWidget(),
          ]),
      body: selectedScreenBody(context, _selectedIndex),
      bottomNavigationBar: //buttomNavigationWidget()
          BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: bottomNavItems,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
