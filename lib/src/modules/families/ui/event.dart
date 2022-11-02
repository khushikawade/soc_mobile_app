// import 'dart:io' show Platform;
// import 'package:Soc/src/globals.dart';
// import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
// import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
// import 'package:Soc/src/overrides.dart';
// import 'package:Soc/src/services/utility.dart';
// import 'package:Soc/src/styles/theme.dart';
// import 'package:Soc/src/translator/translation_widget.dart';
// import 'package:Soc/src/widgets/app_bar.dart';
// import 'package:Soc/src/widgets/calendra_icon_widget.dart';
// import 'package:Soc/src/widgets/common_feed_widget.dart';
// import 'package:Soc/src/widgets/empty_container_widget.dart';
// import 'package:Soc/src/widgets/error_widget.dart';
// import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
// import 'package:Soc/src/widgets/sharepopmenu.dart';
// import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
// import 'package:add_2_calendar/add_2_calendar.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_offline/flutter_offline.dart';
// import 'package:Soc/src/modules/home/models/app_setting.dart';
// import '../modal/calendar_event_list.dart';

// class EventPage extends StatefulWidget {
//   final bool? isAppBar;
//   final String? language;
//   final bool? isbuttomsheet;
//   final String? appBarTitle;
//   final String calendarId;

//   EventPage({
//     required this.isbuttomsheet,
//     required this.appBarTitle,
//     required this.language,
//     required this.calendarId,
//     this.isAppBar,
//   });

//   @override
//   _EventPageState createState() => _EventPageState();
// }

// class _EventPageState extends State<EventPage>
//     with AutomaticKeepAliveClientMixin<EventPage> {
//   FamilyBloc _eventBloc = FamilyBloc();
//   HomeBloc _homeBloc = HomeBloc();
//   final refreshKey = GlobalKey<RefreshIndicatorState>();
//   final refreshKey1 = GlobalKey<RefreshIndicatorState>();
//   bool? iserrorstate = false;
//   // String? lastMonth;

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     _eventBloc.add(CalendarListEvent(widget.calendarId));
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   Widget _buildTabs(
//     state,
//     bool? currentOrientation,
//   ) {
//     return
//         // Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
//         //     Widget>[
//         DefaultTabController(
//             length: 2,
//             initialIndex: 0,
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   TabBar(
//                     indicatorSize: TabBarIndicatorSize.label,
//                     labelColor: Theme.of(context)
//                         .colorScheme
//                         .primaryVariant, //should be : Theme.of(context).colorScheme.primary,
//                     indicatorColor: Theme.of(context).colorScheme.primary,
//                     unselectedLabelColor: Globals.themeType == "Dark"
//                         ? Colors.grey
//                         : Colors.black,
//                     unselectedLabelStyle: TextStyle(
//                       fontSize: 22.0,
//                       fontWeight: FontWeight.normal,
//                       color: Theme.of(context).colorScheme.primaryVariant,
//                     ),
//                     labelStyle: TextStyle(
//                       fontSize: 22.0,
//                       fontWeight: FontWeight.w500,
//                       color: Theme.of(context).colorScheme.primaryVariant,
//                     ),
//                     tabs: [
//                       TranslationWidget(
//                         message: "Upcoming",
//                         toLanguage: Globals.selectedLanguage,
//                         fromLanguage: "en",
//                         builder: (translatedMessage) => Tab(
//                           text: translatedMessage.toString(),
//                         ),
//                       ),
//                       TranslationWidget(
//                         message: "Past",
//                         toLanguage: Globals.selectedLanguage,
//                         fromLanguage: "en",
//                         builder: (translatedMessage) => Tab(
//                           text: translatedMessage.toString(),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Expanded(
//                     child: ListView(
//                       shrinkWrap: true,
//                       children: [
//                         Container(
//                             height: Globals.deviceType == "phone" &&
//                                     MediaQuery.of(context).orientation ==
//                                         Orientation.portrait
//                                 ? MediaQuery.of(context).size.height * 0.75
//                                 : Globals.deviceType == "phone" &&
//                                         MediaQuery.of(context).orientation ==
//                                             Orientation.landscape
//                                     ? MediaQuery.of(context).size.height * 0.65
//                                     : MediaQuery.of(context).size.height * 0.85,
//                             decoration: BoxDecoration(
//                                 border: Border(
//                                     top: BorderSide(
//                                         color: Colors.grey, width: 0.5))),
//                             child: TabBarView(children: <Widget>[
//                               Tab(
//                                   child: new RefreshIndicator(
//                                 key: refreshKey,
//                                 child: state.futureListobj != null &&
//                                         state.futureListobj!.length > 0
//                                     ? buildTabBody(state.futureListobj)
//                                     : NoDataFoundErrorWidget(
//                                         isCalendarPageOrientationLandscape:
//                                             currentOrientation,
//                                         isResultNotFoundMsg: false,
//                                         isNews: false,
//                                         isEvents: true,
//                                       ),
//                                 onRefresh: refreshPage,
//                               )),
//                               Tab(
//                                   child: new RefreshIndicator(
//                                 key: refreshKey1,
//                                 child: state.pastListobj != null &&
//                                         state.pastListobj!.length > 0
//                                     ? buildTabBody(state.pastListobj)
//                                     : NoDataFoundErrorWidget(
//                                         isCalendarPageOrientationLandscape:
//                                             currentOrientation,
//                                         isResultNotFoundMsg: false,
//                                         isNews: false,
//                                         isEvents: true,
//                                       ),
//                                 onRefresh: refreshPage,
//                               ))
//                             ])),
//                         Container(
//                           child: BlocListener<HomeBloc, HomeState>(
//                               bloc: _homeBloc,
//                               listener: (context, state) async {
//                                 if (state is BottomNavigationBarSuccess) {
//                                   AppTheme.setDynamicTheme(
//                                       Globals.appSetting, context);
//                                   Globals.appSetting =
//                                       AppSetting.fromJson(state.obj);
//                                   setState(() {});
//                                 }
//                               },
//                               child: EmptyContainer()),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ]));
//   }

//   buildTabBody(eventsList) {
//     return ListView.builder(
//         scrollDirection: Axis.vertical,
//         padding: !Platform.isAndroid
//             ? EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1)
//             : MediaQuery.of(context).orientation != Orientation.portrait
//                 ? EdgeInsets.only(bottom: 120)
//                 : EdgeInsets.only(bottom: 20),
//         itemCount: eventsList!.length,
//         itemBuilder: (BuildContext context, int index) {
//           String key = eventsList.keys.elementAt(index);
//           return _buildListNew(
//             key,
//             eventsList[key],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: widget.isAppBar == false
//             ? null
//             : CustomAppBarWidget(
//                 marginLeft: 30,
//                 appBarTitle: widget.appBarTitle!,
//                 isSearch: true,
//                 sharedpopBodytext: '',
//                 sharedpopUpheaderText: '',
//                 isShare: false,
//                 isCenterIcon: true,
//                 language: Globals.selectedLanguage,
//               ),
//         body: OrientationBuilder(builder: (context, orientation) {
//           bool? currentOrientation =
//               orientation == Orientation.landscape ? true : null;
//           return OfflineBuilder(
//               connectivityBuilder: (
//                 BuildContext context,
//                 ConnectivityResult connectivity,
//                 Widget child,
//               ) {
//                 final bool connected = connectivity != ConnectivityResult.none;
//                 Globals.isNetworkError = !connected;

//                 if (connected) {
//                   if (iserrorstate == true) {
//                     _eventBloc.add(CalendarListEvent(widget.calendarId));
//                     iserrorstate = false;
//                   }
//                 } else if (!connected) {
//                   iserrorstate = true;
//                 }

//                 return BlocBuilder<FamilyBloc, FamilyState>(
//                     bloc: _eventBloc,
//                     builder: (BuildContext contxt, FamilyState state) {
//                       if (state is FamilyLoading) {
//                         return Container(
//                             height: MediaQuery.of(context).size.height * 0.8,
//                             alignment: Alignment.center,
//                             child: CircularProgressIndicator(
//                               color:
//                                   Theme.of(context).colorScheme.primaryVariant,
//                             ));
//                       } else if (state is CalendarListSuccess) {
//                         return _buildTabs(
//                           state,
//                           currentOrientation,
//                         );
//                       } else if (state is ErrorLoading) {
//                         return ErrorMsgWidget();
//                       }
//                       return Container();
//                     });
//               },
//               child: Container());
//         }));
//   }

//   Future refreshPage() async {
//     refreshKey.currentState?.show(atTop: false);
//     refreshKey1.currentState?.show(atTop: false);
//     await Future.delayed(Duration(seconds: 2));
//     _eventBloc.add(CalendarListEvent(widget.calendarId));
//     _homeBloc.add(FetchStandardNavigationBar());
//   }

//   Event buildEvent(CalendarEventList list) {
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

//   Widget _buildListNew(String date, map) {
//     return Column(
//       children: [
//         Column(
//           children: [
//             Container(
//               color: Theme.of(context).colorScheme.secondary,
//               height: 6,
//             ),
//             CachedNetworkImage(
//                 imageUrl: _getCalenderBanerImages(map[0].monthString),
//                 imageBuilder: (context, imageProvider) =>
//                     imageBuilder(imageProvider, date, context, BoxFit.fitWidth),
//                 placeholder: (context, url) => placeholderBuilder(),
//                 errorWidget: (context, url, error) =>
//                     errorWidgetBuilder(date: date)),
//           ],
//         ),
//         for (CalendarEventList i in map)
//           CommonFeedWidget(
//               isSocial: false,
//               actionIcon: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       //Utility.convertDateFormat2(
//                       Utility.convertTimestampToDateFormat(
//                               DateTime.parse(
//                                   i.start.toString().contains('dateTime')
//                                       ? i.start['dateTime']
//                                           .toString()
//                                           .substring(0, 10)
//                                       : i.start['date']
//                                           .toString()
//                                           .substring(0, 10)),
//                               'dd MMM yyyy') +
//                           " - " +
//                           //Utility.convertDateFormat2
//                           Utility.convertTimestampToDateFormat(
//                               DateTime.parse((i.end
//                                       .toString()
//                                       .contains('dateTime')
//                                   ? i.end['dateTime']
//                                       .toString()
//                                       .substring(0, 10)
//                                   : i.end['date'].toString().substring(0, 10))),
//                               'dd MMM yyyy'),
//                       style: Theme.of(context).textTheme.subtitle1!.copyWith(
//                             fontWeight: FontWeight.normal,
//                           ),
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.25,
//                       height: MediaQuery.of(context).orientation ==
//                               Orientation.portrait
//                           ? MediaQuery.of(context).size.height * 0.07
//                           : MediaQuery.of(context).size.width * 0.07,
//                       padding: Globals.deviceType == "phone"
//                           ? null
//                           : EdgeInsets.only(
//                               right: MediaQuery.of(context).size.width * 0.04),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Container(
//                               padding: EdgeInsets.only(top: 6),
//                               height: Globals.deviceType == 'phone' ? 35 : 45,
//                               width: Globals.deviceType == 'phone' ? 35 : 45,
//                               child: Center(
//                                 child: IconButton(
//                                     padding: EdgeInsets.all(0),
//                                     // constraints: BoxConstraints(),
//                                     onPressed: () {
//                                       Add2Calendar.addEvent2Cal(
//                                         buildEvent(i),
//                                       );
//                                     },
//                                     icon: Icon(
//                                       IconData(
//                                         0xe850,
//                                         fontFamily: Overrides.kFontFam,
//                                         fontPackage: Overrides.kFontPkg,
//                                       ),
//                                       color: Colors.red,
//                                     )),
//                               )),
//                           Container(
//                               height: Globals.deviceType == 'phone' ? 35 : 45,
//                               width: Globals.deviceType == 'phone' ? 35 : 45,
//                               child: Center(
//                                 child: IconButton(
//                                     iconSize: 22,
//                                     padding: EdgeInsets.all(0),
//                                     // constraints: BoxConstraints(),
//                                     onPressed: () {
//                                       SharePopUp obj = new SharePopUp();
//                                       obj.callFunction(
//                                           context,
//                                           i.htmlLink.toString(),
//                                           i.summary.toString());
//                                     },
//                                     icon: Icon(
//                                       IconData(0xe829,
//                                           fontFamily: Overrides.kFontFam,
//                                           fontPackage: Overrides.kFontPkg),
//                                       color: Colors.red,
//                                     )),
//                               )),
//                         ],
//                       ),
//                     )
//                   ]),
//               title: "",
//               description: i.summary ?? '',
//               titleIcon: Container(
//                 padding: EdgeInsets.only(top: 4),
//                 child: CalendraIconWidget(
//                   color: Colors.red,
//                   dateTime: _methodDate(i),
//                 ),
//               ),
//               url: ''),
//       ],
//     );
//   }

//   DateTime getDate(date) {
//     try {
//       DateTime dateTime = DateTime.parse(date);
//       return dateTime;
//     } catch (e) {
//       return DateTime.now();
//     }
//   }

//   DateTime _methodDate(CalendarEventList i) {
//     DateTime _dateTime = getDate(i.start.toString().contains('dateTime')
//         ? i.start['dateTime'].toString().substring(0, 10)
//         : i.start['date'].toString().substring(0, 10));
//     return _dateTime;
//   }

//   _getCalenderBanerImages(String monthString) {
//     String monthImageBanner;
//     var map = {
//       'January': Globals.appSetting.januaryBannerImageC ?? '',
//       'February': Globals.appSetting.februaryBannerImageC ?? '',
//       'March': Globals.appSetting.marchBannerImageC ?? '',
//       'April': Globals.appSetting.aprilBannerImageC ?? '',
//       'May': Globals.appSetting.mayBannerImageC ?? '',
//       'June': Globals.appSetting.juneBannerImageC ?? '',
//       'July': Globals.appSetting.julyBannerImageC ?? '',
//       'August': Globals.appSetting.augustBannerImageC ?? '',
//       'September': Globals.appSetting.septemberBannerImageC ?? '',
//       'October': Globals.appSetting.octoberBannerImageC ?? '',
//       'November': Globals.appSetting.novemberBannerImageC ?? '',
//       'December': Globals.appSetting.decemberBannerImageC ?? '',
//     };
//     monthImageBanner = map[monthString] ?? '';

//     return monthImageBanner;
//   }

//   Widget imageBuilder(ImageProvider<Object> imageProvider, String month,
//       BuildContext context, BoxFit fit) {
//     return AspectRatio(
//       aspectRatio: 16 / 8,
//       child: Container(
//         padding: EdgeInsets.fromLTRB(50, 30, 0, 0),
//         alignment: Alignment.topLeft,
//         decoration: BoxDecoration(
//           image: DecorationImage(image: imageProvider, fit: fit),
//         ),
//         child: Text(
//           month,
//           style: Theme.of(context)
//               .textTheme
//               .headline2!
//               .copyWith(color: Theme.of(context).primaryColor),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }

//   Widget placeholderBuilder() {
//     return AspectRatio(
//       aspectRatio: 16 / 8,
//       child: Container(
//           alignment: Alignment.center,
//           child: ShimmerLoading(
//             isLoading: true,
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               color: Colors.white,
//             ),
//           )),
//     );
//   }

//   Widget errorWidgetBuilder({required String date}) {
//     return CachedNetworkImage(
//       imageUrl: Globals.splashImageUrl ?? Globals.appSetting.appLogoC,
//       imageBuilder: (context, imageProvider) =>
//           imageBuilder(imageProvider, date, context, BoxFit.fitHeight),
//       placeholder: (context, url) => placeholderBuilder(),
//       errorWidget: (context, url, error) => Center(
//           child: Container(
//         padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
//         child: Text(
//           date,
//           style: Theme.of(context)
//               .textTheme
//               .headline2!
//               .copyWith(color: Colors.red),
//         ),
//       )),
//     );
//   }
// }
