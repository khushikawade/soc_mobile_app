// // import 'dart:async';

// // import 'package:app/src/modules/home/ui/home.dart';

// // import 'package:app/src/overrides.dart';
// // import 'package:app/src/services/custom_flutter_icons.dart';
// // import 'package:app/src/services/utility.dart';
// // import 'package:app/src/widgets/common_button_widget.dart';
// // import 'package:app/src/widgets/inapp_url_launcher.dart';
// // import 'package:app/src/widgets/spacer_widget.dart';
// // import 'package:flutter/material.dart';

// // import '../../../styles/theme.dart';

// // class LoginPage1 extends StatefulWidget {
// //   // final String? msg;
// //   // final bool? isInitial;
// //   // LoginPage1({Key? key, this.msg, this.isInitial}) : super(key: key);
// //   @override
// //   _LoginPage1State createState() => _LoginPage1State();
// // }



// // class _LoginPage1State extends State<LoginPage1> {


// //   Widget _buildEmailField() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         _inputLabel(AppTranslations.of(context)!.text('username'), 0),
// //         Material(
// //           elevation: 2,
// //           borderRadius: BorderRadius.circular(AppTheme.kBorderRadius),
// //           shadowColor: Colors.white,
// //           child: TextFormField(
// //             focusNode: _usernameFocus,
// //             onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
// //             keyboardType: TextInputType.emailAddress,
// //             validator: (value) => value!.isEmpty
// //                 ? (AppTranslations.of(context)!
// //                     .text('username_validation_error'))
// //                 : null,
// //             onSaved: (value) => username = value,
// //             // style: Theme.of(context).textTheme.caption,
// //             style: Theme.of(context).textTheme.caption,
// //             decoration: InputDecoration(
// //               hintText: AppTranslations.of(context)!.text('username_hint'),
// //             ),
// //           ),
// //         )
// //       ],
// //     );
// //   }

//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Scaffold(
//           body: Container(
//             child: Column(
//               children: [
//                 Container(child: Text("Lo")),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
