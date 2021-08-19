import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
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
    return InkWell(
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
        child: Container(
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
                  widget.language != null && widget.language != "English"
                      ? TranslationWidget(
                          message: Utility.convertDateFormat(
                                  list.start!.dateTime.toString())
                              .toString()
                              .substring(0, 2),
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Text(
                          Utility.convertDateFormat(
                                  list.start!.dateTime.toString())
                              .toString()
                              .substring(0, 2),
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                  // Globals.selectedLanguage != null &&
                  //         Globals.selectedLanguage != "English"
                  //     ? TranslationWidget(
                  //         message: Utility.getMonthFromDate(
                  //                 list.start!.dateTime.toString())
                  //             .toString()
                  //             .split("/")[1],
                  //         toLanguage: Globals.selectedLanguage,
                  //         fromLanguage: "en",
                  //         builder: (translatedMessage) => Text(
                  //             translatedMessage.toString(),
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .headline2!
                  //                 .copyWith(
                  //                   height: 1.5,
                  //                 ),
                  //             textAlign: TextAlign.center),
                  //       )
                  //     : Text(
                  //         Utility.getMonthFromDate(
                  //                 list.start!.dateTime.toString())
                  //             .toString()
                  //             .split("/")[1],
                  //         style:
                  //             Theme.of(context).textTheme.headline2!.copyWith(
                  //                   height: 1.5,
                  //                 ),
                  //       ),
                ]),
              ),
              HorzitalSpacerWidget(_kLabelSpacing),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Globals.selectedLanguage != null &&
              //             Globals.selectedLanguage != "English"
              //         ? TranslationWidget(
              //             message: list.summary!,
              //             toLanguage: Globals.selectedLanguage,
              //             fromLanguage: "en",
              //             builder: (translatedMessage) => Container(
              //                   width: MediaQuery.of(context).size.width * 0.50,
              //                   child: Text(
              //                     translatedMessage.toString(),
              //                     style: Theme.of(context)
              //                         .textTheme
              //                         .headline5!
              //                         .copyWith(
              //                           fontWeight: FontWeight.w500,
              //                         ),
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                 ))
              //         : Container(
              //             width: MediaQuery.of(context).size.width * 0.50,
              //             child: Text(
              //               list.summary ?? '-',
              //               style:
              //                   Theme.of(context).textTheme.headline5!.copyWith(
              //                         fontWeight: FontWeight.w500,
              //                       ),
              //               overflow: TextOverflow.ellipsis,
              //             )),
              //     SpacerWidget(_kLabelSpacing),
              //     Globals.selectedLanguage != null &&
              //             Globals.selectedLanguage != "English"
              //         ? TranslationWidget(
              //             message: Utility.convertDateFormat(
              //                     list.start!.dateTime) +
              //                 " - " +
              //                 Utility.convertDateFormat(list.endDate!.dateTime),
              //             toLanguage: Globals.selectedLanguage,
              //             fromLanguage: "en",
              //             builder: (translatedMessage) => Text(
              //               translatedMessage.toString(),
              //               style:
              //                   Theme.of(context).textTheme.headline2!.copyWith(
              //                         height: 1.5,
              //                       ),
              //             ),
              //           )
              //         : Text(
              //             Utility.convertDateFormat(list.start!.dateTime) +
              //                 " - " +
              //                 Utility.convertDateFormat(list.endDate!.dateTime),
              //             style:
              //                 Theme.of(context).textTheme.headline2!.copyWith(
              //                       height: 1.5,
              //                     ),
              //           )
              //   ],
              // ),
            ],
          ),
          // Padding(
          //     padding: const EdgeInsets.symmetric(
          //         horizontal: _kLabelSpacing * 1,
          //         vertical: _kLabelSpacing / 2),
          //     child: ListTile(
          //       visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          //       dense: true,
          //       contentPadding: EdgeInsets.all(0.0),
          //       leading: Container(
          //         alignment: Alignment.center,
          //         width: Globals.deviceType == "phone" ? 40 : 70,
          //         child: Wrap(
          //           alignment: WrapAlignment.center,
          //           children: [
          //             widget.language != null && widget.language != "English"
          //                 ? TranslationWidget(
          //                     message:
          //                         Utility.convertDateFormat(list.startDate!)
          //                             .toString()
          //                             .substring(0, 2),
          //                     toLanguage: Globals.selectedLanguage,
          //                     fromLanguage: "en",
          //                     builder: (translatedMessage) => Text(
          //                       translatedMessage.toString(),
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline5!
          //                           .copyWith(fontWeight: FontWeight.w500),
          //                       textAlign: TextAlign.center,
          //                     ),
          //                   )
          //                 : Text(
          //                     Utility.convertDateFormat(list.startDate!)
          //                         .toString()
          //                         .substring(0, 2),
          //                     style: Theme.of(context)
          //                         .textTheme
          //                         .headline5!
          //                         .copyWith(
          //                           fontWeight: FontWeight.w500,
          //                         ),
          //                   ),
          //             Globals.selectedLanguage != null &&
          //                     Globals.selectedLanguage != "English"
          //                 ? TranslationWidget(
          //                     message:
          //                         Utility.getMonthFromDate(list.startDate!)
          //                             .toString()
          //                             .split("/")[1],
          //                     toLanguage: Globals.selectedLanguage,
          //                     fromLanguage: "en",
          //                     builder: (translatedMessage) => Text(
          //                         translatedMessage.toString(),
          //                         style: Theme.of(context)
          //                             .textTheme
          //                             .headline2!
          //                             .copyWith(
          //                               height: 1.5,
          //                             ),
          //                         textAlign: TextAlign.center),
          //                   )
          //                 : Text(
          //                     Utility.getMonthFromDate(list.startDate!)
          //                         .toString()
          //                         .split("/")[1],
          //                     style: Theme.of(context)
          //                         .textTheme
          //                         .headline2!
          //                         .copyWith(
          //                           height: 1.5,
          //                         ),
          //                   ),
          //           ],
          //         ),
          //       ),
          //       title: Globals.selectedLanguage != null &&
          //               Globals.selectedLanguage != "English"
          //           ? TranslationWidget(
          //               message: list.titleC!,
          //               toLanguage: Globals.selectedLanguage,
          //               fromLanguage: "en",
          //               builder: (translatedMessage) => Text(
          //                 translatedMessage.toString(),
          //                 style:
          //                     Theme.of(context).textTheme.headline5!.copyWith(
          //                           fontWeight: FontWeight.w500,
          //                         ),
          //               ),
          //             )
          //           : Text(
          //               list.titleC ?? '-',
          //               style:
          //                   Theme.of(context).textTheme.headline5!.copyWith(
          //                         fontWeight: FontWeight.w500,
          //                       ),
          //             ),
          //       subtitle: Globals.selectedLanguage != null &&
          //               Globals.selectedLanguage != "English"
          //           ? TranslationWidget(
          //               message: Utility.convertDateFormat(list.startDate!) +
          //                   " - " +
          //                   Utility.convertDateFormat(list.endDate!),
          //               toLanguage: Globals.selectedLanguage,
          //               fromLanguage: "en",
          //               builder: (translatedMessage) => Text(
          //                 translatedMessage.toString(),
          //                 style:
          //                     Theme.of(context).textTheme.headline2!.copyWith(
          //                           height: 1.5,
          //                         ),
          //               ),
          //             )
          //           : Text(
          //               Utility.convertDateFormat(list.startDate!) +
          //                   " - " +
          //                   Utility.convertDateFormat(list.endDate!),
          //               style:
          //                   Theme.of(context).textTheme.headline2!.copyWith(
          //                         height: 1.5,
          //                       ),
          //             ),
          //     )),
        )),
      ),
    );
  }

  Widget _buildHeading(String tittle) {
    return Container(
      padding: EdgeInsets.only(
          top: _kLabelSpacing / 1.5, bottom: _kLabelSpacing / 1.5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(
            width: 0,
          ),
          color: Theme.of(context).colorScheme.primary),
      child: Padding(
        padding: const EdgeInsets.only(left: _kLabelSpacing),
        child: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English"
            ? TranslationWidget(
                message: tittle,
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontWeight: FontWeight.w500)),
              )
            : Text(tittle,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildTabs(state) {
    return Container(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                Widget>[
      SizedBox(height: 20.0),
      DefaultTabController(
          length: 2, // length of tabs
          initialIndex: 0,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Theme.of(context).colorScheme.primaryVariant,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Colors.black,
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
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Past'),
                    ],
                  ),
                ),
                Container(
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.5))),
                    child: TabBarView(children: <Widget>[
                      Container(
                        child: state.futureListobj!.length > 0
                            ? Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        padding: EdgeInsets.only(bottom: 20),
                                        itemCount: state.futureListobj!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _buildList(
                                              state.futureListobj![index],
                                              index,
                                              state.futureListobj);
                                        }),
                                  )
                                ],
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                      ),
                      Container(
                        child: state.pastListobj!.length > 0
                            ? Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        padding: EdgeInsets.only(bottom: 25.0),
                                        itemCount: state.pastListobj!.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _buildList(
                                              state.pastListobj![index],
                                              index,
                                              state.pastListobj);
                                        }),
                                  )
                                ],
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                      ),
                    ]))
              ])),
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

                if (connected) {
                  if (iserrorstate == true) {
                    _eventBloc.add(CalendarListEvent());
                    iserrorstate = false;
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return connected
                    ? Column(
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

                                  // Column(children: [
                                  //   _buildHeading("Upcoming"),
                                  //   state.futureListobj!.length > 0
                                  //       ? ListView.builder(
                                  //           scrollDirection: Axis.vertical,
                                  //           physics:
                                  //               NeverScrollableScrollPhysics(),
                                  //           itemCount:
                                  //               state.futureListobj!.length,
                                  //           shrinkWrap: true,
                                  //           itemBuilder:
                                  //               (BuildContext context,
                                  //                   int index) {
                                  //             return _buildList(
                                  //                 state.futureListobj![
                                  //                     index],
                                  //                 index,
                                  //                 state.futureListobj);
                                  //           })
                                  //       : Container(
                                  //           height: 0,
                                  //           width: 0,
                                  //         ),
                                  //   SpacerWidget(20),
                                  //   _buildHeading("Past"),
                                  //   state.pastListobj!.length > 0
                                  //       ? ListView.builder(
                                  //           scrollDirection: Axis.vertical,
                                  //           itemCount:
                                  //               state.pastListobj!.length,
                                  //           shrinkWrap: true,
                                  //           physics:
                                  //               NeverScrollableScrollPhysics(),
                                  //           itemBuilder:
                                  //               (BuildContext context,
                                  //                   int index) {
                                  //             return _buildList(
                                  //                 state.pastListobj![index],
                                  //                 index,
                                  //                 state.pastListobj);
                                  //           })
                                  //       : Container(
                                  //           height: 0,
                                  //           width: 0,
                                  //         ),
                                  // ]);
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
                              child: Container(
                                height: 0,
                                width: 0,
                              ),
                            ),
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
