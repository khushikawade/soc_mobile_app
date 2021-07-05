import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/modules/home/ui/drawer.dart';
import 'package:app/src/widgets/customerappbar.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  StudentPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  static const double _kLabelSize = 115.0;

  // Style
  static const _ktextStyle = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Regular",
    fontSize: 14,
    color: Color(0xff2D3F98),
  );

  Widget build(BuildContext context) {
    Widget _buildRow1() {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        GestureDetector(
          onTap: () {}, // handle your image tap here
          child: Container(
            width: _kLabelSize,
            height: _kLabelSize,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/request_img.png',
                  fit: BoxFit.cover, // this is the solution for border
                  width: _kLabelSize - 25,
                  height: _kLabelSize - 25,
                ),
                Text(
                  "Request",
                  style: _ktextStyle,
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {}, // handle your image tap here
          child: Container(
            width: _kLabelSize,
            height: _kLabelSize,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/graduation.png',
                  fit: BoxFit.cover,

                  // this is the solution for border
                  width: _kLabelSize - 25,
                  height: _kLabelSize - 25,
                ),
                Text(
                  "Graduation",
                  style: _ktextStyle,
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {}, // handle your image tap here
          child: Container(
            width: _kLabelSize,
            height: _kLabelSize,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/googleclassroom.png',
                  fit: BoxFit.cover, // this is the solution for border
                  width: _kLabelSize - 25,
                  height: _kLabelSize - 25,
                ),
                Text(
                  "Google Class",
                  style: _ktextStyle,
                )
              ],
            ),
          ),
        ),
      ]);
    }

    Widget _buildList() {
      return Column(
        children: [
          _buildRow1(),
        ],
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [_buildList()],
          ),
        ),
      ),
    );
  }
}
