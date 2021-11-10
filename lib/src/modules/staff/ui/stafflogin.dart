// import 'package:Soc/src/widgets/spacer_widget.dart';
// import 'package:flutter/material.dart';

// class StaffLoginPage extends StatefulWidget {
//   StaffLoginPage({Key? key, this.title}) : super(key: key);
//   final String? title;
//   @override
//   _StaffLoginPageState createState() => _StaffLoginPageState();
// }

// class _StaffLoginPageState extends State<StaffLoginPage> {
//   static const double _kIconSize = 188;
//   static const double _kLabelSpacing = 20.0;
//   FocusNode myFocusNode = new FocusNode();

//   // UI Widget
//   Widget _buildIcon() {
//     return Container(
//         child: Image.asset(
//       'assets/images/splash_bear_icon.png',
//       fit: BoxFit.fill,
//       height: _kIconSize,
//       width: _kIconSize,
//     ));
//   }

//   Widget _buildHeading() {
//     return Text("This content has beeen locked.",
//         style: Theme.of(context).textTheme.headline2!);
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

//   Widget _buildPasswordField() {
//     return Padding(
//       padding: const EdgeInsets.all(_kLabelSpacing),
//       child: TextFormField(
//         focusNode: myFocusNode,
//         decoration: InputDecoration(
//           hintText: 'Please enter the password',
//           border: OutlineInputBorder(),
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
//             _buildPasswordField(),
//           ],
//         )),
//       ]),
//     );
//   }
// }
