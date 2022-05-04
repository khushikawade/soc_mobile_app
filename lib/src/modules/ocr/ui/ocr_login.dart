// import 'package:Soc/src/widgets/spacer_widget.dart';
// import 'package:flutter/material.dart';
// import '../../../globals.dart';
// import '../../../translator/translation_widget.dart';
// import '../../../widgets/custom_icon_widget.dart';

// class LoginSecured extends StatefulWidget {
//   LoginSecured({Key? key, this.title}) : super(key: key);
//   final String? title;
//   @override
//   _LoginSecuredPageState createState() => _LoginSecuredPageState();
// }

// class _LoginSecuredPageState extends State<LoginSecured> {
//   static const double _kIconSize = 188;
//   static const double _kLabelSpacing = 20.0;
//   FocusNode myFocusNode = new FocusNode();

//   // UI Widget
//   Widget _buildIcon() {
//     return Container(
//         height: MediaQuery.of(context).size.height * 0.25,
//         width: MediaQuery.of(context).size.width * 0.55,
//         child: CustomIconWidget(
//           iconUrl: Globals.appSetting.appLogoC,
//           darkModeIconUrl: null,
//         ));
//   }

//   Widget _buildHeading() {
//     return Text("This content has beeen locked.",
//         style: Theme.of(context)
//             .textTheme
//             .headline2!
//             .copyWith(fontWeight: FontWeight.bold));
//   }

//   Widget _buildcontent() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text("Please unlock this content to continue.",
//             style: Theme.of(context).textTheme.bodyText1!),
//         Text("If you need support accessing this page, please reach ",
//             style: Theme.of(context).textTheme.bodyText1!),
//         Text("out to Mr. Edwards.",
//             style: Theme.of(context).textTheme.bodyText1!),
//       ],
//     );
//   }

//   // Widget _buildPasswordField() {
//   //   return Padding(
//   //     padding: const EdgeInsets.all(_kLabelSpacing),
//   //     child: TextFormField(
//   //       focusNode: myFocusNode,
//   //       decoration: InputDecoration(
//   //         hintText: 'Please enter the password',
//   //         border: OutlineInputBorder(),
//   //       ),
//   //     ),
//   //   );
//   // }
//   Widget authenticate() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20),
//       child: ElevatedButton(
//         onPressed: () {},
//         child: TranslationWidget(
//           message: "Authenticate Now",
//           fromLanguage: "en",
//           toLanguage: Globals.selectedLanguage,
//           builder: (translatedMessage) => Text(translatedMessage.toString(),
//               style: Theme.of(context)
//                   .textTheme
//                   .headline3!
//                   .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
//         ),
//       ),
//     );
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(children: [
//         Center(
//             child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SpacerWidget(_kLabelSpacing * 2.0),
//             _buildIcon(),
//             SpacerWidget(_kLabelSpacing),
//             _buildHeading(),
//             SpacerWidget(_kLabelSpacing / 2),
//             _buildcontent(),
//             SpacerWidget(_kLabelSpacing),
//             // _buildPasswordField(),
//             authenticate()
//           ],
//         )),
//       ]),
//     );
//   }
// }
