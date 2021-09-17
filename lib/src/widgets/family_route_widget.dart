// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/families/modal/family_list.dart';
// import 'package:Soc/src/modules/families/ui/contact.dart';
// import 'package:Soc/src/modules/families/ui/event.dart';
// import 'package:Soc/src/modules/families/ui/staffdirectory.dart';
// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
// import 'package:Soc/src/widgets/common_sublist.dart';
// import 'package:Soc/src/widgets/html_description.dart';
// import 'package:Soc/src/widgets/inapp_url_launcher.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// _familiyPageRoute(FamiliesList obj, index, BuildContext context) {
//   if (obj.titleC == "Contact") {
//     obj.titleC != null
//         ? Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => ContactPage(
//                       obj: widget.obj,
//                       isbuttomsheet: true,
//                       appBarTitle: obj.titleC!,
//                       language: Globals.selectedLanguage ?? "English",
//                     )))
//         : Utility.showSnackBar(_scaffoldKey, "No link available", context);
//   } else if (obj.typeC == "URL" || obj.titleC == "Afterschool Consent 2") {
//     obj.appUrlC != null
//         ? Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => InAppUrlLauncer(
//                       title: obj.titleC!,
//                       url: obj.appUrlC ?? '',
//                       isbuttomsheet: true,
//                       language: Globals.selectedLanguage,
//                     )))
//         : Utility.showSnackBar(_scaffoldKey, "No link available", context);
//   } else if (obj.typeC == "Form") {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (BuildContext context) => StaffDirectory(
//                   appBarTitle: obj.titleC!,
//                   obj: obj,
//                   isbuttomsheet: true,
//                   language: Globals.selectedLanguage,
//                 )));
//   } else if (obj.typeC == "Calendar/Events") {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (BuildContext context) => EventPage(
//                   isbuttomsheet: true,
//                   appBarTitle: obj.titleC,
//                   language: Globals.selectedLanguage,
//                 )));
//   } else if (obj.typeC == "RFT_HTML") {
//     obj.rtfHTMLC != null
//         ? Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => AboutusPage(
//                       htmlText: obj.rtfHTMLC.toString(),
//                       isbuttomsheet: true,
//                       ishtml: true,
//                       appbarTitle: obj.titleC!,
//                       language: Globals.selectedLanguage,
//                     )))
//         : Utility.showSnackBar(_scaffoldKey, "No data available", context);
//   } else if (obj.typeC == "PDF URL") {
//     obj.pdfURL != null
//         ? Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => CommonPdfViewerPage(
//                       url: obj.pdfURL,
//                       tittle: obj.titleC,
//                       isbuttomsheet: true,
//                       language: Globals.selectedLanguage,
//                     )))
//         : Utility.showSnackBar(_scaffoldKey, "No pdf available", context);
//   } else if (obj.typeC == "Sub-Menu") {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (BuildContext context) => SubListPage(
//                   appBarTitle: obj.titleC!,
//                   obj: obj,
//                   module: "family",
//                   isbuttomsheet: true,
//                   language: Globals.selectedLanguage,
//                 )));
//   } else {
//     Utility.showSnackBar(_scaffoldKey, "No data available", context);
//   }
// }
