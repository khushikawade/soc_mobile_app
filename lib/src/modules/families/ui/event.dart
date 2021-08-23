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
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

// ignore: must_be_immutable
class EventPage extends StatefulWidget {
  EventPage(
      {required this.isbuttomsheet,
      required this.appBarTitle,
      required this.language});
  String? language;
  bool? isbuttomsheet;
  String? appBarTitle;

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  static const double _kLabelSpacing = 15.0;
  FamilyBloc _eventBloc = FamilyBloc();
  HomeBloc _homeBloc = HomeBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool? iserrorstate = false;

  @override
  void initState() {
    super.initState();
    _eventBloc.add(CalendarListEvent());
  }

  Widget _buildList(list, int index, mainObj) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SliderWidget(
                      obj: mainObj,
                      issocialpage: false,
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
                    Globals.selectedLanguage != null &&
                            Globals.selectedLanguage != "English"
                        ? TranslationWidget(
                            message: Utility.getMonthFromDate(
                                    list.start.toString().contains('dateTime')
                                        ? list.start['dateTime']
                                            .toString()
                                            .substring(0, 10)
                                        : list.start['date']
                                            .toString()
                                            .substring(0, 10))
                                .toString()
                                .split("/")[1],
                            toLanguage: Globals.selectedLanguage,
                            fromLanguage: "en",
                            builder: (translatedMessage) => Text(
                                translatedMessage.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                      height: 1.5,
                                    ),
                                textAlign: TextAlign.center),
                          )
                        : Text(
                            Utility.getMonthFromDate(
                                    list.start.toString().contains('dateTime')
                                        ? list.start['dateTime']
                                            .toString()
                                            .substring(0, 10)
                                        : list.start['date']
                                            .toString()
                                            .substring(0, 10))
                                .toString()
                                .split("/")[1],
                            style:
                                Theme.of(context).textTheme.headline2!.copyWith(
                                      height: 1.5,
                                    ),
                          ),
                  ]),
                ),
                HorzitalSpacerWidget(_kLabelSpacing),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Globals.selectedLanguage != null &&
                            Globals.selectedLanguage != "English"
                        ? TranslationWidget(
                            message: list.summary!,
                            toLanguage: Globals.selectedLanguage,
                            fromLanguage: "en",
                            builder: (translatedMessage) => Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  child: Text(
                                    translatedMessage.toString(),
                                    style:
                                        Theme.of(context).textTheme.headline2!
                                    // .copyWith(
                                    //   fontWeight: FontWeight.w500,
                                    // )
                                    ,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: Text(
                              list.summary ?? '-',
                              style: Theme.of(context).textTheme.headline5!
                              // .copyWith(
                              //   fontWeight: FontWeight.w500,
                              // )
                              ,
                              overflow: TextOverflow.ellipsis,
                            )),
                    Globals.selectedLanguage != null &&
                            Globals.selectedLanguage != "English"
                        ? TranslationWidget(
                            message: Utility.convertDateFormat(list.start!) +
                                " - " +
                                Utility.convertDateFormat(list.end!),
                            toLanguage: Globals.selectedLanguage,
                            fromLanguage: "en",
                            builder: (translatedMessage) => Text(
                              translatedMessage.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      height: 1.5),
                            ),
                          )
                        : Text(
                            Utility.convertDateFormat(list.startDate!) +
                                " - " +
                                Utility.convertDateFormat(list.endDate!),
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(
                                    fontWeight: FontWeight.normal, height: 1.5),
                          ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildTabs(state) {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
          DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: TabBar(
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor:
                            Theme.of(context).colorScheme.primaryVariant,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        unselectedLabelColor: Colors.black,
                        unselectedLabelStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                        automaticIndicatorColorAdjustment: true,
                        tabs: [
                          Tab(text: 'Upcoming', ),
                          Tab(text: 'Past'),
                        ],
                      ),
                    ),
                    Container(
                        height: Globals.deviceType == "phone"
                            ? MediaQuery.of(context).size.height * 0.798
                            : MediaQuery.of(context).size.height * 0.8,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.grey, width: 0.5))),
                        child: TabBarView(children: <Widget>[
                          Tab(
                              child: new RefreshIndicator(
                            child: new ListView.builder(
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.only(bottom: 35),
                                itemCount: state.futureListobj!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildList(state.futureListobj![index],
                                      index, state.futureListobj);
                                }),
                            onRefresh: refreshPage,
                          )),
                          Tab(
                              child: new RefreshIndicator(
                            child: new ListView.builder(
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.only(bottom: 35),
                                itemCount: state.pastListobj!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildList(state.pastListobj![index],
                                      index, state.pastListobj);
                                }),
                            onRefresh: refreshPage,
                          ))
                        ])),
                  ]))
        ]));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          appBarTitle: widget.appBarTitle!,
          isSearch: true,
          isShare: false,
          sharedpopUpheaderText: "",
          sharedpopBodytext: "",
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

                return connected
                    ? ListView(
                        children: [
                          BlocBuilder<FamilyBloc, FamilyState>(
                              bloc: _eventBloc,
                              builder:
                                  (BuildContext contxt, FamilyState state) {
                                if (state is FamilyLoading) {
                                  return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator());
                                } else if (state is CalendarListSuccess) {
                                  return _buildTabs(state);
                                } else if (state is ErrorLoading) {
                                  return ListView(
                                      shrinkWrap: true,
                                      children: [ErrorMsgWidget()]);
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
                                    Globals.homeObjet = state.obj;
                                    setState(() {});
                                  }
                                },
                                child: EmptyContainer()),
                          ),
                        ],
                      )
                    : NoInternetErrorWidget(
                        connected: connected, issplashscreen: false);
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
