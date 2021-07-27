import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';

class InternalButtomNavigationBar extends StatefulWidget {
  // InternalButtomNavigationBar({Key? key, this.title}) : super(key: key);
  // final String? title;
  @override
  _InternalButtomNavigationBarState createState() =>
      _InternalButtomNavigationBarState();
}

class _InternalButtomNavigationBarState
    extends State<InternalButtomNavigationBar> {
  int? _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = Globals.internalBottombarIndex ?? 0;
  }

  selectedpage(context, _selectedIndex) {
    if (_selectedIndex == 0) {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else if (_selectedIndex == 1) {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else if (_selectedIndex == 2) {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else if (_selectedIndex == 3) {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else if (_selectedIndex == 4) {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex!,
      items: Globals.homeObjet["Bottom_Navigation__c"]
          .split(";")
          .map<BottomNavigationBarItem>((e) => BottomNavigationBarItem(
                icon: Column(children: [
                  Text(
                    e.split("_")[0],
                    style: Theme.of(context).textTheme.subtitle2,
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
        _selectedIndex = index;
        selectedpage(context, _selectedIndex);
        Globals.outerBottombarIndex = index;
      },
    );
  }
}
