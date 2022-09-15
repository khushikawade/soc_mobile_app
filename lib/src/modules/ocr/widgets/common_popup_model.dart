// import 'package:flutter/material.dart';

// class CommonPopupModel extends StatefulWidget {
//   CommonPopupModel(
//       {required Key? key,
//       }):
//         super(key: key);
 

//   @override
//   _CommonPopupModelState createState() => _CommonPopupModelState();
// }

// class _CommonPopupModelState extends State<CommonPopupModel> {

  
// @override
//   Widget showDialog() {
//     return showDialog(
//         context: context,
//         builder: (context) =>
//             OrientationBuilder(builder: (context, orientation) {
//               return AlertDialog(
//                 backgroundColor: Colors.white,
//                 title: Center(
//                   child: Container(
//                     padding: Globals.deviceType == 'phone'
//                         ? null
//                         : const EdgeInsets.only(top: 10.0),
//                     height: Globals.deviceType == 'phone'
//                         ? null
//                         : orientation == Orientation.portrait
//                             ? MediaQuery.of(context).size.height / 15
//                             : MediaQuery.of(context).size.width / 15,
//                     width: Globals.deviceType == 'phone'
//                         ? null
//                         : orientation == Orientation.portrait
//                             ? MediaQuery.of(context).size.width / 2
//                             : MediaQuery.of(context).size.height / 2,
//                     child: TranslationWidget(
//                         message: "Confirm exit",
//                         fromLanguage: "en",
//                         toLanguage: Globals.selectedLanguage,
//                         builder: (translatedMessage) {
//                           return Text(translatedMessage.toString(),
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline1!
//                                   .copyWith(color: AppTheme.kButtonColor));
//                         }),
//                   ),
//                 ),
//                 content: TranslationWidget(
//                     message:
//                         "Do you want to exit? You will lose all the scanned assesment sheets.",
//                     fromLanguage: "en",
//                     toLanguage: Globals.selectedLanguage,
//                     builder: (translatedMessage) {
//                       return Text(translatedMessage.toString(),
//                           style: Theme.of(context)
//                               .textTheme
//                               .headline2!
//                               .copyWith(color: Colors.black));
//                     }),
//                 actions: <Widget>[
//                   Container(
//                     height: 1,
//                     width: MediaQuery.of(context).size.height,
//                     color: Colors.grey.withOpacity(0.2),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       TextButton(
//                         child: TranslationWidget(
//                             message: "No",
//                             fromLanguage: "en",
//                             toLanguage: Globals.selectedLanguage,
//                             builder: (translatedMessage) {
//                               return Text(translatedMessage.toString(),
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .headline5!
//                                       .copyWith(
//                                         color: AppTheme.kButtonColor,
//                                       ));
//                             }),
//                         onPressed: () {
//                           //Globals.iscameraPopup = false;
//                           Navigator.pop(context, false);
//                         },
//                       ),
//                       TextButton(
//                         child: TranslationWidget(
//                             message: "Yes ",
//                             fromLanguage: "en",
//                             toLanguage: Globals.selectedLanguage,
//                             builder: (translatedMessage) {
//                               return Text(translatedMessage.toString(),
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .headline5!
//                                       .copyWith(
//                                         color: Colors.red,
//                                       ));
//                             }),
//                         onPressed: () {
//                           //Globals.iscameraPopup = false;
//                           Navigator.of(context).pushAndRemoveUntil(
//                               MaterialPageRoute(
//                                   builder: (context) => HomePage()),
//                               (_) => false);
//                         },
//                       ),
//                     ],
//                   )
//                 ],
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//               );
//             }));
//   }