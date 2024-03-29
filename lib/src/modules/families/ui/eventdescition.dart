// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/families/modal/calendar_event_list.dart';
// import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/translator/translation_widget.dart';
// import 'package:Soc/src/widgets/empty_container_widget.dart';
// import 'package:Soc/src/widgets/sharepopmenu.dart';
// import 'package:Soc/src/widgets/spacer_widget.dart';
// import 'package:Soc/src/widgets/weburllauncher.dart';
// import 'package:add_2_calendar/add_2_calendar.dart';
// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class EventDescription extends StatefulWidget {
//   final obj;
//   bool? isBottomSheet;
//   String? language;
//   EventDescription(
//       {Key? key,
//       required this.obj,
//       required this.isBottomSheet,
//       required this.language})
//       : super(key: key);

//   @override
//   _EventDescriptionState createState() => _EventDescriptionState();
// }

// class _EventDescriptionState extends State<EventDescription> {
//   static const double _kPadding = 16.0;
//   static const double _KButtonSize = 95.0;
//   final refreshKey = GlobalKey<RefreshIndicatorState>();
//   final HomeBloc _homeBloc = new HomeBloc();

//   @override
//   void initState() {
//     super.initState();
//     Globals.callSnackbar = true;
//   }

//   Widget _buildItem(CalendarEventList list) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: _kPadding),
//       child: ListView(
//         padding: const EdgeInsets.only(bottom: 30.0),
//         children: [
//           SpacerWidget(_kPadding / 2),
//           TranslationWidget(
//             message: list.summary!, // titleC!,
//             toLanguage: Globals.selectedLanguage,
//             fromLanguage: "en",
//             builder: (translatedMessage) => Text(translatedMessage.toString(),
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.headline2!),
//           ),
//           SpacerWidget(_kPadding / 4),
//           divider(),
//           SpacerWidget(_kPadding / 2),
//           Container(
//             alignment: Alignment.centerLeft,
//             child: TranslationWidget(
//               message: Utility.convertDateFormat2(
//                       list.start.toString().contains('dateTime')
//                           ? list.start['dateTime'].toString().substring(0, 10)
//                           : list.start['date'].toString().substring(0, 10)) +
//                   " - " +
//                   Utility.convertDateFormat2(
//                       list.end.toString().contains('dateTime')
//                           ? list.end['dateTime'].toString().substring(0, 10)
//                           : list.end['date'].toString().substring(0, 10)),
//               toLanguage: Globals.selectedLanguage,
//               fromLanguage: "en",
//               builder: (translatedMessage) => Text(
//                 translatedMessage.toString(),
//                 style: Theme.of(context).textTheme.subtitle1!,
//               ),
//             ),
//           ),
//           SpacerWidget(_kPadding / 2),
//           Container(
//             alignment: Alignment.centerLeft,
//             child: TranslationWidget(
//               message: list.description ?? "",
//               toLanguage: Globals.selectedLanguage,
//               fromLanguage: "en",
//               builder: (translatedMessage) => Text(translatedMessage.toString(),
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.subtitle1!),
//             ),
//           ),
//           SpacerWidget(_kPadding / 2),
//           list.htmlLink != null ? _buildEventLink(list) : Container(),
//           SpacerWidget(_kPadding / 2),
//           bottomButtonWidget(widget.obj),
//         ],
//       ),
//     );
//   }

//   Widget _buildEventLink(/*CalendarEventList*/ list) {
//     return InkWell(
//       onTap: () {
//         UrlLauncherWidget obj = new UrlLauncherWidget();
//         // obj.callurlLaucher(context, list.htmlLink);
//         Utility.launchUrlOnExternalBrowser(list.htmlLink);
//       },
//       child: Text(
//         list.htmlLink ?? '-',
//         style: Theme.of(context).textTheme.headline4!.copyWith(
//               decoration: TextDecoration.underline,
//             ),
//       ),
//     );
//   }

//   Widget divider() {
//     return Container(
//       height: 0.5,
//       decoration: BoxDecoration(
//         color: Color(0xff6c75a4),
//       ),
//     );
//   }

//   Widget bottomButtonWidget(/*CalendarEventList*/ list) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: _kPadding / 2),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           list.htmlLink != null
//               ? Container(
//                   child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     minWidth: _KButtonSize,
//                     maxWidth: _KButtonSize,
//                     minHeight: _KButtonSize / 2.5,
//                     maxHeight: _KButtonSize / 2.5,
//                   ),
//                   child: ElevatedButton(
//                       onPressed: () {
//                         SharePopUp obj = new SharePopUp();
//                         obj.callFunction(context, list.htmlLink.toString(),
//                             list.summary.toString());
//                       },
//                       child: Icon(
//                         Icons.share,
//                         color: Theme.of(context).colorScheme.background,
//                       )),
//                 ))
//               : EmptyContainer(),
//           SizedBox(
//             width: _kPadding / 2,
//           ),
//           Container(
//             constraints: BoxConstraints(
//               minWidth: _KButtonSize,
//               maxWidth: _KButtonSize,
//               minHeight: _KButtonSize / 2.5,
//               maxHeight: _KButtonSize / 2.5,
//             ),
//             child: ElevatedButton(
//                 onPressed: () {
//                   Add2Calendar.addEvent2Cal(
//                     buildEvent(list),
//                   );
//                 },
//                 child: Icon(
//                   Icons.calendar_today_outlined,
//                   color: Theme.of(context).colorScheme.background,
//                 )),
//           ),
//         ],
//       ),
//     );
//   }

//   Event buildEvent(/*CalendarEventList*/ list) {
//     return Event(
//       title: list.summary!,
//       description: list.description ?? "",
//       startDate: DateTime.parse(list.start.toString().contains('dateTime')
//               ? list.start['dateTime'].toString()
//               : list.start['date'].toString().substring(0, 10))
//           .toLocal(),
//       endDate: DateTime.parse(list.end.toString().contains('dateTime')
//               ? list.end['dateTime'].toString()
//               : list.end['date'].toString().substring(0, 10))
//           .toLocal(),
//     );
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: RefreshIndicator(
//       key: refreshKey,
//       child: Column(children: <Widget>[
//         Expanded(
//           child: _buildItem(widget.obj),
//         ),
//       ]),
//       onRefresh: refreshPage,
//     ));
//   }

//   Future refreshPage() async {
//     refreshKey.currentState?.show(atTop: false);
//      await Future.delayed(Duration(seconds: 2));
//     _homeBloc.add(FetchStandardNavigationBar());
//   }
// }
