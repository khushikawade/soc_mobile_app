import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/share_button.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/material.dart';
import '../../overrides.dart' as overrides;

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  static const double _kLabelSpacing = 17.0;
  UrlLauncherWidget urlobj = new UrlLauncherWidget();

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
        urlobj.callurlLaucher(
            context, "${overrides.Overrides.privacyPolicyUrl2}");
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

  Widget privacyWidget() {
    return InkWell(
      onTap: () {
        urlobj.callurlLaucher(
            context, "${overrides.Overrides.privacyPolicyUrl}");
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        appBarTitle: 'Information',
        isSearch: false,
        isShare: false,
        sharedpopBodytext: '',
        sharedpopUpheaderText: '',
      ),
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
              child: ShareButtonWidget()),
        ],
      )),
    );
  }
}
