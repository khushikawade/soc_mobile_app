import 'package:app/src/modules/families/ui/aboutus.dart';
import 'package:app/src/modules/families/ui/event.dart';
import 'package:app/src/modules/families/ui/family.dart';
import 'package:app/src/modules/families/ui/forms.dart';
import 'package:app/src/modules/families/ui/resource.dart';
import 'package:app/src/modules/families/ui/stafflist.dart';
import 'package:app/src/modules/home/ui/iconsmenu.dart';
import 'package:app/src/modules/news/ui/news.dart';
import 'package:app/src/modules/setting/information/ui/information.dart';
import 'package:app/src/modules/setting/settiings/ui/setting.dart';
import 'package:app/src/modules/social/ui/Soical.dart';
import 'package:app/src/modules/staff/ui/staff.dart';
import 'package:app/src/modules/students/ui/student.dart';
import 'package:app/src/modules/user/ui/login.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/widgets/app_bar.dart';
import 'package:app/src/widgets/customerappbar.dart';
import 'package:app/src/widgets/models/custom_app_bar.dart';
import 'package:flutter/material.dart';

class FamilyPage2 extends StatefulWidget {
  FamilyPage2({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  _FamilyPage2State createState() => _FamilyPage2State();
}

class _FamilyPage2State extends State<FamilyPage2> {
  int _selectedIndex = 0;
  static const double _kLabelSpacing = 16.0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    //initDynamicLinks();
  }

  //STYLE
  static const _kPopMenuTextStyle = TextStyle(
      fontFamily: "Roboto Regular", fontSize: 14, color: Color(0xff474D55));

  // Top-Section Widget

  // void _onItemTap(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  selectedScreenBody(context, _selectedIndex) {
    if (_selectedIndex == 0) {
      return AboutusPage();
    } else if (_selectedIndex == 1) {
      return LoginPage();
    } else if (_selectedIndex == 2) {
      return EventPage();
    } else if (_selectedIndex == 3) {
      return FormPage();
    } else if (_selectedIndex == 4) {
      return StaffListPage();
    } else if (_selectedIndex == 5) {
      return Container();
    } else if (_selectedIndex == 6) {
      return Container();
    } else if (_selectedIndex == 7) {
      return Container();
    } else if (_selectedIndex == 8) {
      return Container();
    } else if (_selectedIndex == 9) {
      return Resources();
    } else if (_selectedIndex == 10) {
      return Container();
    } else if (_selectedIndex == 11) {
      return Container();
    } else if (_selectedIndex == 12) {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: selectedScreenBody(context, _selectedIndex),
    );
  }
}
