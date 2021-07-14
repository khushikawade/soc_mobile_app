import 'package:flutter/material.dart';

class ClassName extends StatefulWidget {
  ClassName({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _ClassNameState createState() => _ClassNameState();
}

class _ClassNameState extends State<ClassName> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: Text("Family Page"),
      )),
    );
  }
}
