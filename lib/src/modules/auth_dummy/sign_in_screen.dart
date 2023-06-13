// import 'package:Soc/src/modules/auth_dummy/sign_in_button.dart';
// import 'package:Soc/src/services/google_authentication.dart';
// import 'package:flutter/material.dart';

// class SignInScreen extends StatefulWidget {
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: 16.0,
//             right: 16.0,
//             bottom: 20.0,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Row(),
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Flexible(
//                     //   flex: 1,
//                     //   child: Image.asset(
//                     //     'assets/firebase_logo.png',
//                     //     height: 160,
//                     //   ),
//                     // ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Google',
//                       style: TextStyle(
//                         color: Colors.yellow[800]!,
//                         fontSize: 40,
//                       ),
//                     ),
//                     Text(
//                       'Single Sign-On',
//                       style: TextStyle(
//                         color: Colors.orange,
//                         fontSize: 40,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               FutureBuilder(
//                 future: Authentication.initializeFirebase(context: context),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Text('Error initializing Firebase');
//                   } else if (snapshot.connectionState == ConnectionState.done) {
//                     return GoogleSignInButton();
//                   }
//                   return CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       Colors.orange,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
