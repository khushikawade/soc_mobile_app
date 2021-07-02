import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/modules/families/ui/family.dart';
import 'package:app/src/modules/news/ui/news.dart';
import 'package:app/src/modules/social/ui/Soical.dart';
import 'package:app/src/modules/home/ui/drawer.dart';
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
  static const _kFontFam = 'ACCELERATECustomIcons';
  static const _kFontPkg = null;

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
                    const IconData(0xe815,
                        fontFamily: _kFontFam, fontPackage: _kFontPkg),
                    size: 40.0,
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
                  const IconData(0xe812,
                      fontFamily: _kFontFam, fontPackage: _kFontPkg),
                  size: 40.0,
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
                    const IconData(0xe812,
                        fontFamily: _kFontFam, fontPackage: _kFontPkg),
                    size: 40.0,
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
                  size: 40.0,
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
                  const IconData(0xe812,
                      fontFamily: _kFontFam, fontPackage: _kFontPkg),
                  size: 40.0,
                ),
              ),
            ]),
            label: '',
          ),
        ],
        elevation: 10.0,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white,
        onTap: _onItemTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            iconTheme: IconThemeData(color: Theme.of(context).accentColor),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.donut_large,
                  size: 30,
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                  padding: EdgeInsets.zero,
                  icon: new Icon(
                    Icons.settings,
                  ),
                  onPressed: () {}),
            ]),
        body: selectedScreenBody(context, _selectedIndex),
        bottomNavigationBar: buttomNavigationWidget());
  }
}
