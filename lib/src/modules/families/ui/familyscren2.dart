import 'package:Soc/src/modules/families/Submodule/aboutus/ui/aboutus.dart';
import 'package:Soc/src/modules/families/Submodule/contact/ui/contact.dart';
import 'package:Soc/src/modules/families/Submodule/event/ui/event.dart';
import 'package:Soc/src/modules/families/Submodule/form/ui/forms.dart';
import 'package:Soc/src/modules/families/Submodule/nyc/ui/nycresource.dart';
import 'package:Soc/src/modules/families/Submodule/resource/ui/resource.dart';
import 'package:Soc/src/modules/families/Submodule/staff/ui/stafflist.dart';
import 'package:Soc/src/modules/user/ui/login.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/models/webview.dart';
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
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyWebView(
                    url:
                        "https://pub.dev/packages/flutter_webview_plugin/install",
                    title: "THIS",
                  )));
      // MyWebView(
      //   url: "https://pub.dev/packages/flutter_webview_plugin/install",
      //   title: "THIS",
      // );
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
      return ContactPage();
    } else if (_selectedIndex == 12) {
      return NycResource();
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
