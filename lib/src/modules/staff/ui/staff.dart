import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/event.dart';
import 'package:Soc/src/modules/families/ui/staffdirectory.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/modules/staff/models/staffmodal.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/common_sublist.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffPage extends StatefulWidget {
  StaffPage({Key? key, this.title, this.language}) : super(key: key);
  final String? title;
  final String? language;

  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  // static const double _kLabelSpacing = 16.0;
  FocusNode myFocusNode = new FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  StaffBloc _bloc = StaffBloc();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;
  var obj;
  List<StaffList> newList = [];

  @override
  void initState() {
    super.initState();
    _bloc.add(StaffPageEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  _route(StaffList obj, index) {
    if (obj.typeC == "URL") {
      obj.urlC != null
          ? _launchURL(obj)
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (obj.typeC == "RFT_HTML" ||
        obj.typeC == "HTML/RTF" ||
        obj.typeC == "RTF/HTML") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
                        // url: obj.urlC.toString(),
                        isbuttomsheet: true,
                        ishtml: true,
                        appbarTitle: obj.titleC!,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No data available", context);
    } else if (obj.typeC == "Form") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffDirectory(
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (obj.typeC == "Calendar/Events") {
      obj.calendarId != null && obj.calendarId != ""
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => EventPage(
                        isbuttomsheet: true,
                        appBarTitle: obj.titleC,
                        language: Globals.selectedLanguage,
                        // calendarId: obj.calendarId.toString(),
                      )))
          : Utility.showSnackBar(
              _scaffoldKey, "No calendar/events available", context);
    } else if (obj.typeC == "Sub-Menu") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SubListPage(
                    obj: obj,
                    module: "staff",
                    isbuttomsheet: true,
                    appBarTitle: obj.titleC!,
                    language: Globals.selectedLanguage,
                  )));
    } else {
      Utility.showSnackBar(_scaffoldKey, "No data available", context);
    }
  }

  _launchURL(obj) async {
    if (obj.urlC.toString().split(":")[0] == 'http') {
      if (await canLaunch(obj.urlC)) {
        await launch(obj.urlC);
      } else {
        throw 'Could not launch ${obj.urlC!}';
      }
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: obj.titleC,
                    url: obj.urlC,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    }
  }

  Widget _buildLeading(StaffList obj) {
    if (obj.appIconUrlC != null) {
      return CustomIconWidget(
        iconUrl: obj.appIconUrlC ??
            "https://solved-consulting-images.s3.us-east-2.amazonaws.com/Miscellaneous/default_icon.png",
      );
    } else if (obj.appIconC != null) {
      return Icon(
        IconData(
          int.parse('0x${obj.appIconC!}'),
          fontFamily: 'FontAwesomeSolid',
          fontPackage: 'font_awesome_flutter',
        ),
        color: Theme.of(context).colorScheme.primary,
        size: Globals.deviceType == "phone" ? 24 : 32,
      );
    } else {
      return CustomIconWidget(
        iconUrl:
            "https://solved-consulting-images.s3.us-east-2.amazonaws.com/Miscellaneous/default_icon.png",
      );
    }
  }

  Widget _buildListItem(StaffList obj, int index) {
    return obj.status == 'Show' || obj.status == null
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.kDividerColor2,
                width: 0.65,
              ),
              borderRadius: BorderRadius.circular(0.0),
              color: (index % 2 == 0)
                  ? Theme.of(context).colorScheme.background
                  : Theme.of(context).colorScheme.secondary,
            ),
            child: obj.titleC != null && obj.titleC!.length > 0
                ? ListTile(
                    onTap: () {
                      _route(obj, index);
                    },
                    visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                    leading: _buildLeading(obj),
                    title: Globals.selectedLanguage != null &&
                            Globals.selectedLanguage != "English" &&
                            Globals.selectedLanguage != ""
                        ? TranslationWidget(
                            message: obj.titleC.toString(),
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) => Text(
                              translatedMessage.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(),
                            ),
                          )
                        : Text(
                            obj.titleC.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(),
                          ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: Globals.deviceType == "phone" ? 12 : 20,
                      color: Theme.of(context).colorScheme.primary,
                      // color: AppTheme.kButtonbackColor,
                    ),
                  )
                : Container())
        : Container();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
          marginLeft: 30,
          refresh: (v) {
            setState(() {});
          },
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
                    iserrorstate = false;
                    _bloc.add(StaffPageEvent());
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return connected
                    ? Column(mainAxisSize: MainAxisSize.max, children: [
                        BlocBuilder<StaffBloc, StaffState>(
                            bloc: _bloc,
                            builder: (BuildContext contxt, StaffState state) {
                              if (state is StaffInitial ||
                                  state is StaffLoading) {
                                return Expanded(
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              } else if (state is StaffDataSucess) {
                                return state.obj != null &&
                                        state.obj!.length > 0
                                    ? Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: state.obj!.length,
                                          padding: EdgeInsets.only(bottom: 20),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return _buildListItem(
                                                state.obj![index], index);
                                          },
                                        ),
                                      )
                                    : Expanded(
                                        child: NoDataFoundErrorWidget(
                                        isResultNotFoundMsg: false,
                                        isNews: false,
                                        isEvents: false,
                                      ));
                              } else if (state is ErrorInStaffLoading) {
                              } else {
                                return Expanded(
                                  child: ListView(children: [ErrorMsgWidget()]),
                                );
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
                        BlocListener<StaffBloc, StaffState>(
                            bloc: _bloc,
                            listener: (context, state) async {
                              if (state is StaffDataSucess) {
                                newList.clear();
                                for (int i = 0; i < state.obj!.length; i++) {
                                  if (state.obj![i].status != "Hide") {
                                    newList.add(state.obj![i]);
                                  }
                                }
                              }
                            },
                            child: EmptyContainer()),
                      ])
                    : NoInternetErrorWidget(
                        connected: connected, issplashscreen: false);
              },
              child: Container()),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(StaffPageEvent());
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
