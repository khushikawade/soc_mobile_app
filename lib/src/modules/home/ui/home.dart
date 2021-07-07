import 'package:app/src/modules/families/ui/family.dart';
import 'package:app/src/modules/home/ui/iconsmenu.dart';
import 'package:app/src/modules/news/ui/news.dart';
import 'package:app/src/modules/setting/information/ui/information.dart';
import 'package:app/src/modules/setting/settiings/ui/setting.dart';
import 'package:app/src/modules/social/ui/Soical.dart';
import 'package:app/src/modules/staff/ui/staff.dart';
import 'package:app/src/modules/students/ui/student.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/widgets/customerappbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const double _kLabelSpacing = 16.0;
  static const _kFontFam = 'SOC_CustomIcons';
  static const _kFontPkg = null;

  //STYLE
  static const _kPopMenuTextStyle = TextStyle(
      fontFamily: "Roboto Regular", fontSize: 14, color: Color(0xff474D55));

  // Top-Section Widget
  Widget myPopMenuWidget() {
    return PopupMenuButton<IconMenu>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      icon: Icon(
        const IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg),
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
            break;
        }
      },
      itemBuilder: (context) => IconsMenu.items
          .map((item) => PopupMenuItem<IconMenu>(
              value: item,
              child: ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                dense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                title: Text(
                  item.text,
                  style: _kPopMenuTextStyle,
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
      return SocialPage();
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

  Widget buttomNavigationWidget() {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 0,
        backgroundColor: AppTheme.kBackgroundColor,
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
                    const IconData(0xe807,
                        fontFamily: _kFontFam, fontPackage: _kFontPkg),
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
                  const IconData(0xe801,
                      fontFamily: _kFontFam, fontPackage: _kFontPkg),
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
                    const IconData(0xe80a,
                        fontFamily: _kFontFam, fontPackage: _kFontPkg),
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
                  const IconData(0xe812,
                      fontFamily: _kFontFam, fontPackage: _kFontPkg),
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
                  const IconData(0xe808,
                      fontFamily: _kFontFam, fontPackage: _kFontPkg),
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
            iconTheme: IconThemeData(color: Theme.of(context).accentColor),
            elevation: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  const IconData(0xe80e,
                      fontFamily: _kFontFam, fontPackage: _kFontPkg),
                ),
              ],
            ),
            actions: <Widget>[
              myPopMenuWidget(),
            ]),
        body: selectedScreenBody(context, _selectedIndex),
        bottomNavigationBar: buttomNavigationWidget());
  }
}
