// import 'package:Soc/src/widgets/app_bar.dart';
// import 'package:Soc/src/widgets/share_button.dart';
// import 'package:Soc/src/widgets/spacer_widget.dart';
// import 'package:Soc/src/widgets/weburllauncher.dart';
// import 'package:flutter/material.dart';
// import '../../overrides.dart' as overrides;

// class InformationPage extends StatefulWidget {
//   @override
//   _InformationPageState createState() => _InformationPageState();
// }

// class _InformationPageState extends State<InformationPage> {
//   static const double _kLabelSpacing = 17.0;
//   UrlLauncherWidget urlobj = new UrlLauncherWidget();

//   Widget _buildIcon() {
//     return Container(
//         child: Image.asset(
//       'assets/images/splash_bear_icon.png',
//       fit: BoxFit.fill,
//       height: 188,
//       width: 188,
//     ));
//   }

//   Widget tittleWidget() {
//     return Text(
//       "PS 456 Bronx Bears",
//       style: Theme.of(context).textTheme.headline1,
//     );
//   }

//   Widget greetingWidget() {
//     return Text(
//       "Dear User ",
//       style: Theme.of(context).textTheme.bodyText1,
//     );
//   }

//   Widget content1Widget() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           "Thank you so much for using our app.Please",
//           style: Theme.of(context).textTheme.bodyText1,
//         ),
//         Text(
//           "feel free to message us for information ,for",
//           style: Theme.of(context).textTheme.bodyText1,
//         ),
//         Text(
//           "support , or to provide feedback",
//           style: Theme.of(context).textTheme.bodyText1,
//         ),
//       ],
//     );
//   }

//   Widget content2Widget() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           "This app was created by sloved .Here is our",
//           style: Theme.of(context).textTheme.bodyText1,
//         ),
//         Text(
//           "Privacy Policy",
//           style: Theme.of(context).textTheme.bodyText1,
//         ),
//       ],
//     );
//   }

//   Widget _buildPrivacyWidget() {
//     return InkWell(
//       onTap: () {
//         urlobj.callurlLaucher(
//             context, "${overrides.Overrides.privacyPolicyUrl2}");
//       },
//       child: Text(
//         "Privacy Policy",
//         style: Theme.of(context).textTheme.bodyText1!.copyWith(
//               decoration: TextDecoration.underline,
//             ),
//       ),
//     );
//   }

//   Widget privacyWidget() {
//     return InkWell(
//       onTap: () {
//         urlobj.callurlLaucher(
//             context, "${overrides.Overrides.privacyPolicyUrl}");
//       },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             "https://www.slovedconsulting.com/privacy",
//             style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                   decoration: TextDecoration.underline,
//                 ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBarWidget(
//         appBarTitle: 'Information',
//         isSearch: false,
//         isShare: false,
//         sharedpopBodytext: '',
//         sharedpopUpheaderText: '',
//       ),
//       body: ListView(children: [
//         Container(
//             child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             _buildIcon(),
//             SpacerWidget(_kLabelSpacing),
//             tittleWidget(),
//             SpacerWidget(_kLabelSpacing),
//             greetingWidget(),
//             SpacerWidget(_kLabelSpacing),
//             content1Widget(),
//             SpacerWidget(_kLabelSpacing * 1.5),
//             content2Widget(),
//             SpacerWidget(_kLabelSpacing / 2),
//             privacyWidget(),
//             SpacerWidget(_kLabelSpacing * 7),
//             _buildPrivacyWidget(),
//           ],
//         )),
//       ]),
//       bottomSheet:
//           SafeArea(child: SizedBox(height: 100.0, child: ShareButtonWidget())),
//     );
//   }
// }

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/internalbuttomnavigation.dart';
import 'package:Soc/src/widgets/share_button.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class InformationPage extends StatefulWidget {
  String htmlText;

  bool isbuttomsheet;
  bool ishtml;
  String appbarTitle;

  @override
  InformationPage({
    Key? key,
    required this.htmlText,
    // required this.url,
    required this.isbuttomsheet,
    required this.ishtml,
    required this.appbarTitle,
  }) : super(key: key);
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  static const double _kLabelSpacing = 20.0;
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  Widget _buildContent1() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
      child: Wrap(
        children: [
          Html(
            data: widget.htmlText,
            style: {
              "table": Style(
                backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
              ),
              "tr": Style(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              "th": Style(
                padding: EdgeInsets.all(6),
                backgroundColor: Colors.grey,
              ),
              "td": Style(
                padding: EdgeInsets.all(6),
                alignment: Alignment.topLeft,
              ),
              'h5': Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
            },
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          isSearch: false,
          isShare: false,
          appBarTitle: widget.appbarTitle,
          ishtmlpage: widget.ishtml,
          sharedpopBodytext: widget.htmlText.replaceAll(exp, '').toString(),
          sharedpopUpheaderText: "Please checkout this link",
        ),
        body: ListView(children: [
          _buildContent1(),
          SizedBox(height: 100.0, child: ShareButtonWidget())
        ]),
        bottomNavigationBar: widget.isbuttomsheet && Globals.homeObjet != null
            ? InternalButtomNavigationBar()
            : null);
  }
}
