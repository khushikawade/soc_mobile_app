import 'package:app/src/overrides.dart';
import 'package:app/src/services/utility.dart';
import 'package:app/src/widgets/app_bar.dart';
import 'package:app/src/widgets/customerappbar.dart';
import 'package:flutter/material.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  static const double _kLabelSpacing = 17.0;

  //Style
  static const _kheadingStyle = TextStyle(
      fontFamily: "Roboto Bold",
      fontWeight: FontWeight.bold,
      fontSize: 22,
      color: Color(0xff2D3F98));

  static const _ktextStyle = TextStyle(
    height: 1.5,
    fontFamily: "Roboto",
    fontSize: 14,
    color: Color(0xff2D3F98),
  );

  //TOP SECTION START
  Widget _buildIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            child: Image.asset(
          'assets/images/splash_bear_icon.png',
          fit: BoxFit.fill,
          height: 188,
          width: 188,
        )),
      ],
    );
  }

  Widget tittleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "PS 456 Bronx Bears",
          style: _kheadingStyle,
        )
      ],
    );
  }

  Widget greetingWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Dear User ",
          style: _ktextStyle,
        )
      ],
    );
  }
  //TOP SECTION END

// Middle Section START
  Widget content1Widget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Thank you so much for using our app.Please",
              style: _ktextStyle,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "feel free to message us for information ,for",
              style: _ktextStyle,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "support , or to provide feedback",
              style: _ktextStyle,
            )
          ],
        ),
      ],
    );
  }

  Widget content2Widget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "This app was created by sloved .Here is our",
              style: _ktextStyle,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Privacy Policy",
              style: _ktextStyle,
            )
          ],
        ),
      ],
    );
  }

// Middle Section END

// BUTTOM SECTION START
  Widget privacyWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "https://www.slovedconsulting.com/privacy",
          style: _ktextStyle,
        )
      ],
    );
  }

  Widget buttomButtonsWidget() {
    return Padding(
      padding: const EdgeInsets.all(_kLabelSpacing),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                // Route route =
                //     MaterialPageRoute(builder: (context) => MinionFlare());
                // Navigator.push(context, route);
              },
              child: Text("Share this app"),
            ),
          ),
          SizedBox(
            width: _kLabelSpacing / 2,
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("I need support"),
            ),
          ),
        ],
      ),
    );
  }

// BUTTOM SECTION END
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: ListView(children: [
        Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIcon(),
            SizedBox(
              height: _kLabelSpacing,
            ),
            tittleWidget(),
            SizedBox(
              height: _kLabelSpacing,
            ),
            greetingWidget(),
            SizedBox(
              height: _kLabelSpacing,
            ),
            content1Widget(),
            SizedBox(
              height: _kLabelSpacing * 1.5,
            ),
            content2Widget(),
            SizedBox(
              height: _kLabelSpacing / 2,
            ),
            privacyWidget(),
            SizedBox(
              height: Utility.displayWidth(context) * 0.40,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: buttomButtonsWidget(),
            ),
          ],
        )),
      ]),
    );
  }
}
