import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/modules/home/ui/drawer.dart';
import 'package:app/src/widgets/customerappbar.dart';
import 'package:flutter/material.dart';

class StaffPage extends StatefulWidget {
  StaffPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: Text("Staff Page"),
      )),
    );
  }
}
