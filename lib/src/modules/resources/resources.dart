
import 'package:Soc/src/modules/about/bloc/about_bloc.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';

class ResourcesPage extends StatefulWidget {
  final obj;
  final searchObj;
  ResourcesPage({
    Key? key,
    this.obj,
    this.searchObj,
  }) : super(key: key);

  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  // static const double _kLabelSpacing = 10.0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AboutBloc _bloc = AboutBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  bool? iserrorstate = false;
  List<AboutStaffDirectoryEvent> newList = [];

  @override
  void initState() {
    super.initState();
    _bloc.add(AboutStaffDirectoryEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(AboutStaffDirectoryEvent());
    _homeBloc.add(FetchBottomNavigationBar());
  }


  Widget _buildLeading() {
    // if (obj.appIconUrlC != null) {
    //   return CustomIconWidget(
    //     iconUrl: obj.appIconUrlC ??
    //         "https://solved-consulting-images.s3.us-east-2.amazonaws.com/Miscellaneous/default_icon.png",
    //   );
    // } else if (obj.appIconC != null) {
    //   return Icon(
    //     IconData(
    //       int.parse('0x${obj.appIconC!}'),
    //       fontFamily: 'FontAwesomeSolid',
    //       fontPackage: 'font_awesome_flutter',
    //     ),
    //     color: Theme.of(context).colorScheme.primary,
    //     size: Globals.deviceType == "phone" ? 24 : 32,
    //   );
    // } else {
      return CustomIconWidget(
        iconUrl:
            "https://solved-consulting-images.s3.us-east-2.amazonaws.com/Miscellaneous/default_icon.png",
      );
    // }
  }

  // _launchURL(obj) async {
  //   if (obj.appUrlC.toString().split(":")[0] == 'http') {
  //     // if (await canLaunch(obj.appUrlC)) {
  //     //   await launch(obj.appUrlC);
  //     // } else {
  //     //   throw 'Could not launch ${obj.appUrlC!}';
  //     // }
  //     await Utility.launchUrlOnExternalBrowser(obj.appUrlC);
  //   } else {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (BuildContext context) => InAppUrlLauncer(
  //                   title: obj.titleC,
  //                   url: obj.appUrlC,
  //                   isbuttomsheet: true,
  //                   language: Globals.selectedLanguage,
  //                 )));
  //   }
  // }

  Widget _buildList( int index) {
    return Container(
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
      child: ListTile(
        onTap: () {
          // _familiyPageRoute(obj, index);
        },
        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
        // contentPadding:
        //     EdgeInsets.only(left: _kLabelSpacing, right: _kLabelSpacing / 2),
        leading: _buildLeading(),
        title: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English" &&
                Globals.selectedLanguage != ""
            ? TranslationWidget(
                message: "About list item",// obj.titleC,
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) {
                  return Text(translatedMessage.toString(),
                      style: Theme.of(context).textTheme.bodyText2!);
                })
            : Text( "About list item",//obj.titleC.toString(),
                style: Theme.of(context).textTheme.bodyText1!),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: Globals.deviceType == "phone" ? 12 : 20,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
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
                  _bloc.add(AboutStaffDirectoryEvent());
                  iserrorstate = false;
                }
              } else if (!connected) {
                iserrorstate = true;
              }

              return connected
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ListView.builder(
                                            padding: EdgeInsets.only(bottom: 45),
                                            scrollDirection: Axis.vertical,
                                            itemCount: 10,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return _buildList(
                                                  index);
                                            },
                                          ),
                        ),
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
                        // BlocListener<AboutBloc, AboutState>(
                        //     bloc: _bloc,
                        //     listener: (context, state) async {
                        //       if (state is AboutDataSucess) {
                        //         newList.clear();
                        //         for (int i = 0; i < state.obj!.length; i++) {
                        //           if (state.obj![i].status != "Hide") {
                        //             newList.add(state.obj![i]);
                        //           }
                        //         }
                        //       }
                        //     },
                        //     child: EmptyContainer()),
                      ],
                    )
                  : NoInternetErrorWidget(
                      connected: connected, issplashscreen: false);
            },
            child: Container()),
        onRefresh: refreshPage,
      ),
    );
  }
}
