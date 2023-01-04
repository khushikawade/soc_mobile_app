import 'dart:io' show Platform;
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/families/modal/calendar_banner_image_modal.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/calendra_icon_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import '../modal/calendar_event_list.dart';

class EventPage extends StatefulWidget {
  final bool? isAppBar;
  final String? language;
  final bool? isbuttomsheet;
  final String? appBarTitle;
  final String calendarId;

  EventPage({
    required this.isbuttomsheet,
    required this.appBarTitle,
    required this.language,
    required this.calendarId,
    this.isAppBar,
  });

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>
    with AutomaticKeepAliveClientMixin<EventPage> {
  FamilyBloc _eventBloc = FamilyBloc();
  HomeBloc _homeBloc = HomeBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final refreshKey1 = GlobalKey<RefreshIndicatorState>();
  bool? iserrorstate = false;

  final keyImage = GlobalKey();
  // String? lastMonth;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _eventBloc.add(CalendarListEvent(widget.calendarId));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _buildTabs(
    state,
    bool? currentOrientation,
  ) {
    return
        // Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
        //     Widget>[
        DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Theme.of(context)
                        .colorScheme
                        .primaryVariant, //should be : Theme.of(context).colorScheme.primary,
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
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                            height: Globals.deviceType == "phone" &&
                                    MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                ? MediaQuery.of(context).size.height * 0.75
                                : Globals.deviceType == "phone" &&
                                        MediaQuery.of(context).orientation ==
                                            Orientation.landscape
                                    ? MediaQuery.of(context).size.height * 0.65
                                    : MediaQuery.of(context).size.height * 0.85,
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.grey, width: 0.5))),
                            child: TabBarView(children: <Widget>[
                              Tab(
                                  child: new RefreshIndicator(
                                key: refreshKey,
                                child: state.futureListobj != null &&
                                        state.futureListobj!.length > 0
                                    ? buildTabBody(
                                        state.futureListobj,
                                        state,
                                      )
                                    : NoDataFoundErrorWidget(
                                        isCalendarPageOrientationLandscape:
                                            currentOrientation,
                                        isResultNotFoundMsg: false,
                                        isNews: false,
                                        isEvents: true,
                                      ),
                                onRefresh: refreshPage,
                              )),
                              Tab(
                                  child: new RefreshIndicator(
                                key: refreshKey1,
                                child: state.pastListobj != null &&
                                        state.pastListobj!.length > 0
                                    ? buildTabBody(state.pastListobj, state)
                                    : NoDataFoundErrorWidget(
                                        isCalendarPageOrientationLandscape:
                                            currentOrientation,
                                        isResultNotFoundMsg: false,
                                        isNews: false,
                                        isEvents: true,
                                      ),
                                onRefresh: refreshPage,
                              ))
                            ])),
                        Container(
                          child: BlocListener<HomeBloc, HomeState>(
                              bloc: _homeBloc,
                              listener: (context, state) async {
                                if (state is BottomNavigationBarSuccess) {
                                  AppTheme.setDynamicTheme(
                                      Globals.appSetting, context);
                                  Globals.appSetting =
                                      AppSetting.fromJson(state.obj);
                                  setState(() {});
                                }
                              },
                              child: EmptyContainer()),
                        ),
                      ],
                    ),
                  ),
                ]));
  }

  buildTabBody(
    eventsList,
    state,
  ) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        padding: !Platform.isAndroid
            ? EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1)
            : MediaQuery.of(context).orientation != Orientation.portrait
                ? EdgeInsets.only(bottom: 120)
                : EdgeInsets.only(bottom: 20),
        itemCount: eventsList!.length,
        itemBuilder: (BuildContext context, int index) {
          String key = eventsList.keys.elementAt(index);
          return _buildListNew(key, eventsList[key], context, state);
        });
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

                return BlocBuilder<FamilyBloc, FamilyState>(
                    bloc: _eventBloc,
                    builder: (BuildContext contxt, FamilyState state) {
                      if (state is FamilyLoading) {
                        return Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color:
                                  Theme.of(context).colorScheme.primaryVariant,
                            ));
                      } else if (state is CalendarListSuccess) {
                        return _buildTabs(
                          state,
                          currentOrientation,
                        );
                      } else if (state is ErrorLoading) {
                        return ErrorMsgWidget();
                      }
                      return Container();
                    });
              },
              child: Container());
        }));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    refreshKey1.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _eventBloc.add(CalendarListEvent(widget.calendarId));
    _homeBloc.add(FetchStandardNavigationBar());
  }

  Event buildEvent(CalendarEventList list) {
    return Event(
      title: list.summary ?? '',
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

  Widget _buildListNew(
      String date, List<CalendarEventList> map, context, state) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
          child: Column(
            children: [
              CachedNetworkImage(
                  imageUrl: _getCalenderBanerImages(
                      map[0].monthString.toString().toLowerCase(),
                      state.calendarBannerImageList),
                  imageBuilder: (context, imageProvider) => imageBuilder(
                      imageProvider, date, context, BoxFit.fitWidth),
                  placeholder: (context, url) => placeholderBuilder(),
                  errorWidget: (context, url, error) =>
                      errorWidgetBuilder(date: date)),
            ],
          ),
        ),
        for (CalendarEventList i in map) eventWidget(i)
      ],
    );
  }

  DateTime getDate(date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      return dateTime;
    } catch (e) {
      return DateTime.now();
    }
  }

  DateTime _methodDate(CalendarEventList i) {
    DateTime _dateTime = getDate(i.start.toString().contains('dateTime')
        ? i.start['dateTime'].toString().substring(0, 10)
        : i.start['date'].toString().substring(0, 10));
    return _dateTime;
  }

  String _getCalenderBanerImages(
      String monthString, List<CalendarBannerImageModal> bannerImagesList) {
    String? monthImageBanner;

    bannerImagesList.asMap().forEach((i, value) {
      if (bannerImagesList[i].monthC != null &&
          bannerImagesList[i].monthC!.toLowerCase() ==
              monthString.toLowerCase()) {
        monthImageBanner = bannerImagesList[i].monthImageC ?? '';
      }
    });

    return monthImageBanner ?? '';
  }

  Widget imageBuilder(ImageProvider<Object> imageProvider, String month,
      BuildContext context, BoxFit fit) {
    return AspectRatio(
      aspectRatio: 16 / 8,
      child: Container(
        padding: EdgeInsets.fromLTRB(50, 30, 0, 0),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: fit),
        ),
        child: Text(
          month,
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget placeholderBuilder() {
    return AspectRatio(
      aspectRatio: 16 / 8,
      child: Container(
          alignment: Alignment.center,
          child: ShimmerLoading(
            isLoading: true,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          )),
    );
  }

  Widget errorWidgetBuilder({required String date}) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
      child: Text(
        date,
        style:
            Theme.of(context).textTheme.headline2!.copyWith(color: Colors.red),
      ),
    );
  }

  Widget eventWidget(CalendarEventList i) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.all(10.0),
            child: CalendraIconWidget(
              color: Colors.red,
              dateTime: _methodDate(i),
            )),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10.0),
            decoration: BoxDecoration(
                color: Color(0xff000000) != Theme.of(context).backgroundColor
                    ? Theme.of(context).primaryColor.withOpacity(0.3)
                    : Color(0xFF89A7D7),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (i.summary != null)
                  TranslationWidget(
                    message: i.summary,
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) {
                      return Text(translatedMessage.toString(),
                          style: Theme.of(context).textTheme.headline2!);
                    },
                  ),
                SizedBox(
                  height: 5,
                ),
                dateAndIconWidget(i),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget dateAndIconWidget(i) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utility.convertTimestampToDateFormat(
                    DateTime.parse(i.start.toString().contains('dateTime')
                        ? i.start['dateTime'].toString().substring(0, 10)
                        : i.start['date'].toString().substring(0, 10)),
                    'dd MMM yyyy') +
                " - " +
                //Utility.convertDateFormat2
                Utility.convertTimestampToDateFormat(
                    DateTime.parse((i.end.toString().contains('dateTime')
                        ? i.end['dateTime'].toString().substring(0, 10)
                        : i.end['date'].toString().substring(0, 10))),
                    'dd MMM yyyy'),
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.02
                        : MediaQuery.of(context).size.width * 0.02,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Add2Calendar.addEvent2Cal(
                        buildEvent(i),
                      );
                    },
                    icon: Icon(
                      IconData(
                        0xe850,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg,
                      ),
                      color: Colors.red,
                    )),
              ),
              Container(
                alignment: Alignment.topCenter,
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.03
                        : MediaQuery.of(context).size.width * 0.03,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      SharePopUp obj = new SharePopUp();
                      obj.callFunction(
                          context, i.htmlLink.toString(), i.summary.toString());
                    },
                    icon: Icon(
                      IconData(0xe829,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      color: Colors.red,
                    )),
              ),
            ],
          )
        ]);
  }
}
