import 'dart:io' show Platform;

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/calendra_icon_widget.dart';
import 'package:Soc/src/widgets/common_feed_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';

// ignore: must_be_immutable
class EventPage extends StatefulWidget {
  bool? isAppBar;

  EventPage({
    required this.isbuttomsheet,
    required this.appBarTitle,
    required this.language,
    required this.calendarId,
    this.isAppBar,
  });
  String? language;
  bool? isbuttomsheet;
  String? appBarTitle;
  String calendarId;

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>
    with AutomaticKeepAliveClientMixin<EventPage> {
  static const double _kLabelSpacing = 15.0;
  FamilyBloc _eventBloc = FamilyBloc();
  HomeBloc _homeBloc = HomeBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final refreshKey1 = GlobalKey<RefreshIndicatorState>();
  bool? iserrorstate = false;
  double? _ktabmargin = 50;
  String? lastMonth;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();

    _eventBloc.add(CalendarListEvent(widget.calendarId));
  }

  Widget _buildList(list, int index, mainObj) {
    DateTime _dateTime = getDate(list.start.toString().contains('dateTime')
        ? list.start['dateTime'].toString().substring(0, 10)
        : list.start['date'].toString().substring(0, 10));
    // DateTime.parse();
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => SliderWidget(
      //                 obj: mainObj,
      //                 // iconsName: [],
      //                 issocialpage: false,
      //                 isAboutSDPage: false,
      //                 iseventpage: true,
      //                 currentIndex: index,
      //                 date: '',
      //                 isbuttomsheet: true,
      //                 language: Globals.selectedLanguage,
      //               )));
      // },
      child: Container(
          child: Column(
        children: [
          _buildCalendarBanner(_dateTime),
          CommonFeedWidget(
              actionIcon: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    TranslationWidget(
                      message: Utility.convertDateFormat2(
                              list.start.toString().contains('dateTime')
                                  ? list.start['dateTime']
                                      .toString()
                                      .substring(0, 10)
                                  : list.start['date']
                                      .toString()
                                      .substring(0, 10)) +
                          " - " +
                          Utility.convertDateFormat2(list.end
                                  .toString()
                                  .contains('dateTime')
                              ? list.end['dateTime'].toString().substring(0, 10)
                              : list.end['date'].toString().substring(0, 10)),
                      toLanguage: Globals.selectedLanguage,
                      fromLanguage: "en",
                      builder: (translatedMessage) => Text(
                        translatedMessage.toString(),
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontWeight: FontWeight.normal, height: 1.5),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.07
                          : MediaQuery.of(context).size.width * 0.07,
                      padding: Globals.deviceType == "phone"
                          ? null
                          : EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 6),
                              height: Globals.deviceType == 'phone' ? 35 : 45,
                              width: Globals.deviceType == 'phone' ? 35 : 45,
                              //  color: Colors.grey,
                              child: Center(
                                child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    // constraints: BoxConstraints(),
                                    onPressed: () {
                                      Add2Calendar.addEvent2Cal(
                                        buildEvent(list),
                                      );
                                    },
                                    icon: Icon(IconData(0xe850,
                                        fontFamily: Overrides.kFontFam,
                                        fontPackage: Overrides.kFontPkg))),
                              )),
                          Container(
                              height: Globals.deviceType == 'phone' ? 35 : 45,
                              width: Globals.deviceType == 'phone' ? 35 : 45,
                              //  color: Colors.grey,
                              child: Center(
                                child: IconButton(
                                    iconSize: 22,
                                    padding: EdgeInsets.all(0),
                                    // constraints: BoxConstraints(),
                                    onPressed: () {
                                      SharePopUp obj = new SharePopUp();
                                      obj.callFunction(
                                          context,
                                          list.htmlLink.toString(),
                                          list.summary.toString());
                                    },
                                    icon: Icon(IconData(0xe829,
                                        fontFamily: Overrides.kFontFam,
                                        fontPackage: Overrides.kFontPkg))),
                              )),
                        ],
                      ),
                    )
                  ])
                  //  Text('button place'),
                  // child: actionButton(list, obj, index)
                  ),
              title: "",
              description: list.summary ?? '',
              titleIcon: Container(
                padding: EdgeInsets.only(top: 4),
                child: CalendraIconWidget(
                  color: Colors.red,
                  dateTime: _dateTime,
                ),
              ),
              url: ''),
        ],
      )),
    );
  }

  Widget _buildCalendarBanner(dateTime) {
    try {
      String month = Utility.convertTimestampToDateFormat(dateTime, 'MMMM');
      if (month != lastMonth) {
        lastMonth = month;
        return Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.secondary,
              height: 6,
            ),
            Container(
              color: Theme.of(context).colorScheme.secondary,
              child: Center(
                  child: Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: Theme.of(context).colorScheme.background,
                ),
                // color:
                child: Text(
                  month,
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: Colors.red),
                ),
              )),
            ),
          ],
        );
      } else {
        // lastMonth = month;
        return Container();
      }
    } catch (e) {
      return Container();
    }
  }

  Widget _buildTabs(state, bool? currentOrientation) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
        Widget>[
      DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Theme.of(context).colorScheme.primaryVariant,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Globals.themeType == "Dark"
                        ? Colors.grey
                        : Colors.black,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ),
                    tabs: [
                      TranslationWidget(
                        message: "Upcoming",
                        toLanguage: Globals.selectedLanguage,
                        fromLanguage: "en",
                        builder: (translatedMessage) => Tab(
                          text: translatedMessage.toString(),
                        ),
                      ),
                      TranslationWidget(
                        message: "Past",
                        toLanguage: Globals.selectedLanguage,
                        fromLanguage: "en",
                        builder: (translatedMessage) => Tab(
                          text: translatedMessage.toString(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    height: Globals.deviceType == "phone"
                        ? MediaQuery.of(context).size.height * 0.75
                        : MediaQuery.of(context).size.height * 0.85,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.5))),
                    child: TabBarView(children: <Widget>[
                      state.futureListobj!.length > 0
                          ? Tab(
                              child: new RefreshIndicator(
                              key: refreshKey,
                              child: state.futureListobj!.length > 0
                                  ? new ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      padding: Platform.isAndroid
                                          ? EdgeInsets.only(bottom: 20)
                                          : EdgeInsets.only(bottom: 60),
                                      itemCount: state.futureListobj!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return _buildList(
                                            state.futureListobj![index],
                                            index,
                                            state.futureListobj);
                                      })
                                  : NoDataFoundErrorWidget(
                                      isResultNotFoundMsg: false,
                                      isNews: false,
                                      isEvents: true,
                                    ),
                              onRefresh: refreshPage,
                            ))
                          : new RefreshIndicator(
                              key: refreshKey,
                              onRefresh: refreshPage,
                              child: NoDataFoundErrorWidget(
                                isCalendarPageOrientationLandscape:
                                    currentOrientation,
                                isResultNotFoundMsg: false,
                                isNews: false,
                                isEvents: true,
                              )),
                      state.pastListobj!.length > 0
                          ? Tab(
                              child: new RefreshIndicator(
                              key: refreshKey1,
                              child: state.pastListobj!.length > 0
                                  ? new ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      padding: Platform.isAndroid
                                          ? EdgeInsets.only(bottom: 20)
                                          : EdgeInsets.only(bottom: 60),
                                      itemCount: state.pastListobj!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return _buildList(
                                            state.pastListobj![index],
                                            index,
                                            state.pastListobj);
                                        // : new RefreshIndicator(
                                        //     // key: refreshKey,
                                        //     onRefresh: refreshPage,
                                        //     child: ListView(
                                        //       children: [
                                        //         NoDataFoundErrorWidget(
                                        //           isResultNotFoundMsg: false,
                                        //           isNews: false,
                                        //           isEvents: true,
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   );
                                      })
                                  : NoDataFoundErrorWidget(
                                      isResultNotFoundMsg: false,
                                      isNews: false,
                                      isEvents: true,
                                    ),
                              onRefresh: refreshPage,
                            ))
                          : new RefreshIndicator(
                              key: refreshKey1,
                              onRefresh: refreshPage,
                              child: NoDataFoundErrorWidget(
                                isCalendarPageOrientationLandscape:
                                    currentOrientation,
                                isResultNotFoundMsg: false,
                                isNews: false,
                                isEvents: true,
                              ),
                            ),
                    ])),
              ]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.isAppBar == false
            ? null
            : CustomAppBarWidget(
                marginLeft: 30,
                appBarTitle: widget.appBarTitle!,
                isSearch: true,
                sharedpopBodytext: '',
                sharedpopUpheaderText: '',
                isShare: false,
                isCenterIcon: true,
                language: Globals.selectedLanguage,
              ),
        body: OrientationBuilder(builder: (context, orientation) {
          bool? currentOrientation =
              orientation == Orientation.landscape ? true : null;
          return OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                final bool connected = connectivity != ConnectivityResult.none;
                Globals.isNetworkError = !connected;

                if (connected) {
                  if (iserrorstate == true) {
                    _eventBloc.add(CalendarListEvent(widget.calendarId));
                    iserrorstate = false;
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return
                    //  connected
                    //     ?
                    ListView(
                  children: [
                    BlocBuilder<FamilyBloc, FamilyState>(
                        bloc: _eventBloc,
                        builder: (BuildContext contxt, FamilyState state) {
                          if (state is FamilyLoading) {
                            return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant,
                                ));
                          } else if (state is CalendarListSuccess) {
                            return _buildTabs(state, currentOrientation);
                          } else if (state is ErrorLoading) {
                            return ErrorMsgWidget();
                          }
                          return Container();
                        }),
                    Container(
                      height: 0,
                      width: 0,
                      child: BlocListener<HomeBloc, HomeState>(
                          bloc: _homeBloc,
                          listener: (context, state) async {
                            if (state is BottomNavigationBarSuccess) {
                              AppTheme.setDynamicTheme(
                                  Globals.appSetting, context);
                              Globals.appSetting =
                                  AppSetting.fromJson(state.obj);
                              // Globals.homeObject = state.obj;
                              setState(() {});
                            }
                          },
                          child: EmptyContainer()),
                    ),
                  ],
                );
                // : NoInternetErrorWidget(
                //     connected: connected, issplashscreen: false);
              },
              child: Container());
        }));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    refreshKey1.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _eventBloc.add(CalendarListEvent(widget.calendarId));
    _homeBloc.add(FetchBottomNavigationBar());
  }

  DateTime getDate(date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      return dateTime;
    } catch (e) {
      return DateTime.now();
    }
  }

  Event buildEvent(/*CalendarEventList*/ list) {
    return Event(
      title: list.summary!,
      description: list.description ?? "",
      startDate: DateTime.parse(list.start.toString().contains('dateTime')
              ? list.start['dateTime'].toString()
              : list.start['date'].toString().substring(0, 10))
          .toLocal(),
      endDate: DateTime.parse(list.end.toString().contains('dateTime')
              ? list.end['dateTime'].toString()
              : list.end['date'].toString().substring(0, 10))
          .toLocal(),
    );
  }
}
