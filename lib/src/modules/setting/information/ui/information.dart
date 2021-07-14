import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/share_button.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../overrides.dart' as overrides;

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  static const double _kLabelSpacing = 17.0;

  //Style
  // static const _kheadingStyle = TextStyle(
  //     fontFamily: "Roboto Bold",
  //     fontWeight: FontWeight.bold,
  //     fontSize: 22,
  //     color: Color(0xff2D3F98));

  // static const _ktextStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto",
  //   fontSize: 14,
  //   fontWeight: FontWeight.normal,
  //   color: Color(0xff2D3F98),
  // );

  // static const _klinkStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto",
  //   fontSize: 14,
  //   fontWeight: FontWeight.normal,
  //   decoration: TextDecoration.underline,
  //   color: Color(0xff2D3F98),
  // );

  //TOP SECTION START
  _launchURL(url) async {
    // const url = "${overrides.Overrides.privacyPolicyUrl}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
          style: Theme.of(context).textTheme.headline1,
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
          style: Theme.of(context).textTheme.bodyText1,
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
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "feel free to message us for information ,for",
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "support , or to provide feedback",
              style: Theme.of(context).textTheme.bodyText1,
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
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Privacy Policy",
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
      ],
    );
  }

  Widget _buildPrivacyWidget() {
    return InkWell(
      onTap: () {
        _launchURL("${overrides.Overrides.privacyPolicyUrl2}");
      },
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Privacy Policy",
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    decoration: TextDecoration.underline,
                  ),
            )
          ]),
    );
  }

// Middle Section END

// BUTTOM SECTION START
  Widget privacyWidget() {
    return InkWell(
      onTap: () {
        _launchURL("${overrides.Overrides.privacyPolicyUrl}");
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "https://www.slovedconsulting.com/privacy",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  decoration: TextDecoration.underline,
                ),
          )
        ],
      ),
    );
  }

// BUTTOM SECTION END
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIcon(),
          SpacerWidget(_kLabelSpacing),
          tittleWidget(),
          SpacerWidget(_kLabelSpacing),
          greetingWidget(),
          SpacerWidget(_kLabelSpacing),
          content1Widget(),
          SpacerWidget(_kLabelSpacing * 1.5),
          content2Widget(),
          SpacerWidget(_kLabelSpacing / 2),
          privacyWidget(),
          Expanded(child: Container()),
          _buildPrivacyWidget(),
          SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              height: 100.0,
              child: ButtonWidget()),
        ],
      )),
    );
  }
}
