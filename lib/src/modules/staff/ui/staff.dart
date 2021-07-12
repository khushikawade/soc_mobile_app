import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/modules/home/ui/drawer.dart';
import 'package:app/src/widgets/customerappbar.dart';
import 'package:app/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class StaffPage extends StatefulWidget {
  StaffPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  static const double _kIconSize = 188;
  static const double _kLabelSpacing = 20.0;
  FocusNode myFocusNode = new FocusNode();

  //STYLE
  // static const _kheadingStyle = TextStyle(
  //     fontFamily: "Roboto Bold",
  //     fontWeight: FontWeight.bold,
  //     fontSize: 16,
  //     color: Color(0xff2D3F98));

  static const _ktextStyle = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Regular",
    fontSize: 14,
    color: Color(0xff2D3F98),
  );

  // UI Widget
  Widget _buildIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            child: Image.asset(
          'assets/images/splash_bear_icon.png',
          fit: BoxFit.fill,
          height: _kIconSize,
          width: _kIconSize,
        )),
      ],
    );
  }

  Widget _buildHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "This content has beeen locked.",
          style: Theme.of(context).textTheme.headline2,
        )
      ],
    );
  }

  Widget _buildcontent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Please unlock this content to continue.",
              style: _ktextStyle,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "If you need support accessing this page, please reach ",
              style: _ktextStyle,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "out to Mr. Edwards.",
              style: _ktextStyle,
            )
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.all(_kLabelSpacing),
      child: TextFormField(
        focusNode: myFocusNode,
        decoration: InputDecoration(
          labelText: 'Please enter the password',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpacerWidget(_kLabelSpacing * 2.0),
            _buildIcon(),
            SpacerWidget(_kLabelSpacing),
            _buildHeading(),
            SpacerWidget(_kLabelSpacing / 2),
            _buildcontent(),
            SpacerWidget(_kLabelSpacing),
            _buildPasswordField(),
          ],
        )),
      ]),
    );
  }
}
