import 'dart:io' show Platform;

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';

// ignore: must_be_immutable
class EventPage extends StatefulWidget {
  EventPage({
    required this.isbuttomsheet,
    required this.appBarTitle,
    required this.language,
    // required this.calendarId,
  });
  String? language;
  bool? isbuttomsheet;
  String? appBarTitle;
  // String calendarId;

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>
    with AutomaticKeepAliveClientMixin<EventPage> {
  static const double _kLabelSpacing = 15.0;
  FamilyBloc _eventBloc = FamilyBloc();
  HomeBloc _homeBloc = HomeBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool? iserrorstate = false;
  double? _ktabmargin = 50;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    // Globals.calendar_Id = widget.calendarId;
    _eventBloc.add(CalendarListEvent());

    // _ktabmargin = MediaQuery.of(context).size.height * 0.25;
  }

  Widget _buildList(list, int index, mainObj) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SliderWidget(
                      obj: mainObj,
                      // iconsName: [],
                      issocialpage: false,
                      isAboutSDPage: false,
                      iseventpage: true,
                      currentIndex: index,
                      date: '',
                      isbuttomsheet: true,
                      language: Globals.selectedLanguage,
                    )));
      },
      child: Container(
          decoration: BoxDecoration(
            border: (index % 2 == 0)
                ? Border.all(color: Theme.of(context).colorScheme.background)
                : Border.all(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(0.0),
            color: (index % 2 == 0)
                ? Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: _kLabelSpacing * 1, vertical: _kLabelSpacing / 2),
            child: Row(
              children: <Widget>[
                HorzitalSpacerWidget(_kLabelSpacing / 2),
                Container(
                  alignment: Alignment.center,
                  width: Globals.deviceType == "phone" ? 40 : 70,
                  child: Wrap(alignment: WrapAlignment.center, children: [
                    Text(
                        Utility.getMonthFromDate(
                                list.start.toString().contains('dateTime')
                                    ? list.start['dateTime']
                                        .toString()
                                        .substring(0, 10)
                                    : list.start['date']
                                        .toString()
                                        .substring(0, 10))
                            .toString()
                            .split("/")[0],
                        style: Theme.of(context).textTheme.headline5!),
                    TranslationWidget(
                      message: Utility.getMonthFromDate(list.start
                                  .toString()
                                  .contains('dateTime')
                              ? list.start['dateTime']
                                  .toString()
                                  .substring(0, 10)
                              : list.start['date'].toString().substring(0, 10))
                          .toString()
                          .split("/")[1],
                      toLanguage: Globals.selectedLanguage,
                      fromLanguage: "en",
                      builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    height: 1.5,
                                  ),
                          textAlign: TextAlign.center),
                    )
                  ]),
                ),
                HorzitalSpacerWidget(_kLabelSpacing),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TranslationWidget(
                        message: list.summary ?? "",
                        toLanguage: Globals.selectedLanguage,
                        fromLanguage: "en",
                        builder: (translatedMessage) => Container(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: Text(
                                translatedMessage.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2! //headline5
                                // .copyWith(
                                //   fontWeight: FontWeight.w500,
                                // )
                                ,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
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
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildTabs(state) {
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
                              child: new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  padding: Platform.isAndroid
                                      ? EdgeInsets.only(bottom: 20)
                                      : EdgeInsets.only(bottom: 60),
                                  itemCount: state.futureListobj!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return state.futureListobj!.length > 0
                                        ? _buildList(
                                            state.futureListobj![index],
                                            index,
                                            state.futureListobj)
                                        : NoDataFoundErrorWidget(
                                            isResultNotFoundMsg: false,
                                            isNews: false,
                                            isEvents: true,
                                          );
                                  }),
                              onRefresh: refreshPage,
                            ))
                          : NoDataFoundErrorWidget(
                              isResultNotFoundMsg: false,
                              isNews: false,
                              isEvents: true,
                            ),
                      state.pastListobj!.length > 0
                          ? Tab(
                              child: new RefreshIndicator(
                              child: new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  padding: Platform.isAndroid
                                      ? EdgeInsets.only(bottom: 20)
                                      : EdgeInsets.only(bottom: 60),
                                  itemCount: state.pastListobj!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return state.pastListobj!.length > 0
                                        ? _buildList(state.pastListobj![index],
                                            index, state.pastListobj)
                                        : NoDataFoundErrorWidget(
                                            isResultNotFoundMsg: false,
                                            isNews: false,
                                            isEvents: true,
                                          );
                                  }),
                              onRefresh: refreshPage,
                            ))
                          : NoDataFoundErrorWidget(
                              isResultNotFoundMsg: false,
                              isNews: false,
                              isEvents: true,
                            )
                    ])),
              ]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          marginLeft: 30,
          appBarTitle: widget.appBarTitle!,
          isSearch: true,
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
          isShare: false,
          isCenterIcon: true,
          language: Globals.selectedLanguage,
        ),
        body: RefreshIndicator(
          key: refreshKey,
          child: OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                final bool connected = connectivity != ConnectivityResult.none;
                Globals.isNetworkError = !connected;

                if (connected) {
                  if (iserrorstate == true) {
                    _eventBloc.add(CalendarListEvent());
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
                                  color: Theme.of(context).colorScheme.primaryVariant,
                                ));
                          } else if (state is CalendarListSuccess) {
                            return _buildTabs(state);
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
              child: Container()),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _eventBloc.add(CalendarListEvent());
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
