import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/students/bloc/student_bloc.dart';
import 'package:Soc/src/modules/students/models/student_app.dart';
import 'package:Soc/src/modules/students/ui/apps_folder.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:marquee/marquee.dart';

class StudentPage extends StatefulWidget {
  final homeObj;

  StudentPage({Key? key, this.homeObj}) : super(key: key);
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  static const double _kLableSpacing = 12.0;
  int? gridLength;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;

  StudentBloc _bloc = StudentBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(StudentPageEvent());
  }

  _launchURL(StudentApp obj, subList) async {
    if (obj.appUrlC != null) {
      if (obj.appUrlC == 'app_folder' || obj.isFolder == true) {
        showDialog(
          context: context,
          builder: (_) => AppsFolderPage(
            obj: subList,
            folderName: obj.titleC!,
          ),
        );
      } else {
        if (obj.deepLinkC == 'NO') {
          if (obj.toString().split(":")[0] == 'http') {
            await Utility.launchUrlOnExternalBrowser(obj.appUrlC!);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => InAppUrlLauncer(
                          title: obj.titleC!,
                          url: obj.appUrlC!,
                          isbuttomsheet: true,
                          language: Globals.selectedLanguage,
                        )));
          }
        } else {
          try {
            // await launch(obj.appUrlC!);
            await Utility.launchUrlOnExternalBrowser(obj.appUrlC!);
          } catch (e) {}
          // if (await canLaunch(obj.appUrlC!)) {
          //   await launch(obj.appUrlC!);
          // } else {
          //   throw 'Could not launch ${obj.appUrlC}';
          // }
        }
      }
    } else {
      Utility.showSnackBar(_scaffoldKey, "No URL available", context);
    }
  }

  Widget _buildGrid(List<StudentApp> list, List<StudentApp> subList) {
    return list.length > 0
        ? //new OrientationBuilder(builder: (context, orientation) {
        //  print(orientation);
        GridView.count(
            padding: const EdgeInsets.only(bottom: AppTheme.klistPadding),
            childAspectRatio:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 1
                    : 3 / 2,
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait &&
                        Globals.deviceType == "phone"
                    ? 3
                    : (MediaQuery.of(context).orientation ==
                                Orientation.landscape &&
                            Globals.deviceType == "phone")
                        ? 4
                        : MediaQuery.of(context).orientation ==
                                    Orientation.portrait &&
                                Globals.deviceType != "phone"
                            ? 4
                            : MediaQuery.of(context).orientation ==
                                        Orientation.landscape &&
                                    Globals.deviceType != "phone"
                                ? 5
                                : 3,
            crossAxisSpacing: _kLableSpacing * 1.2,
            mainAxisSpacing: _kLableSpacing * 1.2,
            children: List.generate(
              list.length,
              (index) {
                return list[index].status == null ||
                        list[index].status == 'Show'
                    ? Container(
                        padding: EdgeInsets.only(
                          top: Globals.deviceType == "phone"
                              ? MediaQuery.of(context).size.height * 0.001
                              : MediaQuery.of(context).size.height * 0.01,
                        ),
                        child: GestureDetector(
                            onTap: () => _launchURL(list[index], subList),
                            child: Column(
                              // mainAxisAlignment:MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                list[index].appIconC != null &&
                                        list[index].appIconC != ''
                                    ? Container(
                                        height: 80,
                                        width: 80,
                                        child: CustomIconWidget(
                                            iconUrl: list[index].appIconC ??
                                                Overrides.folderDefaultImage))
                                    : EmptyContainer(),
                                Container(
                                    child: TranslationWidget(
                                  message: "${list[index].titleC}",
                                  fromLanguage: "en",
                                  toLanguage: Globals.selectedLanguage,
                                  builder: (translatedMessage) => Container(
                                    // alignment: Alignment.center,
                                    // padding: EdgeInsets.symmetric(horizontal: 10),
                                    // width: orientation == Orientation.portrait?MediaQuery.of(context).size.width*0.3:null,
                                    child: MediaQuery.of(context).orientation ==
                                                Orientation.portrait &&
                                            translatedMessage
                                                    .toString()
                                                    .length >
                                                11
                                        ? Expanded(
                                            child: Marquee(
                                              text:
                                                  translatedMessage.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      fontSize:
                                                          Globals.deviceType ==
                                                                  "phone"
                                                              ? 16
                                                              : 24),
                                              scrollAxis: Axis.horizontal,
                                              velocity: 30.0,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              blankSpace: 50,
                                              //MediaQuery.of(context).size.width
                                              // velocity: 100.0,
                                              pauseAfterRound:
                                                  Duration(seconds: 5),
                                              showFadingOnlyWhenScrolling: true,
                                              startPadding: 10.0,
                                              accelerationDuration:
                                                  Duration(seconds: 1),
                                              accelerationCurve: Curves.linear,
                                              decelerationDuration:
                                                  Duration(milliseconds: 500),
                                              decelerationCurve: Curves.easeOut,
                                            ),
                                          )
                                        : MediaQuery.of(context).orientation ==
                                                    Orientation.landscape &&
                                                translatedMessage
                                                        .toString()
                                                        .length >
                                                    18
                                            ? Expanded(
                                                child: Marquee(
                                                text: translatedMessage
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        fontSize:
                                                            Globals.deviceType ==
                                                                    "phone"
                                                                ? 16
                                                                : 24),
                                                scrollAxis: Axis.horizontal,
                                                velocity: 30.0,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,

                                                blankSpace:
                                                    50, //MediaQuery.of(context).size.width
                                                // velocity: 100.0,
                                                pauseAfterRound:
                                                    Duration(seconds: 5),
                                                showFadingOnlyWhenScrolling:
                                                    true,
                                                startPadding: 10.0,
                                                accelerationDuration:
                                                    Duration(seconds: 1),
                                                accelerationCurve:
                                                    Curves.linear,
                                                decelerationDuration:
                                                    Duration(milliseconds: 500),
                                                decelerationCurve:
                                                    Curves.easeOut,
                                              ))
                                            : SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                    translatedMessage
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                            fontSize:
                                                                Globals.deviceType ==
                                                                        "phone"
                                                                    ? 16
                                                                    : 24)),
                                              ),
                                  ),
                                )

                                    // ),)))
                                    ),
                              ],
                            )),
                      )
                    : Container();
              },
            ),
          ) //;
        // })
        : Center(
            child: TranslationWidget(
              message: "No apps available here",
              fromLanguage: "en",
              toLanguage: Globals.selectedLanguage,
              builder: (translatedMessage) => Text(translatedMessage.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1!),
            ),
          );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _bloc.add(StudentPageEvent());
    _homeBloc.add(FetchBottomNavigationBar());
  }

  Widget _body() {
    return RefreshIndicator(
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
                _bloc.add(StudentPageEvent());
              }
            } else if (!connected) {
              iserrorstate = true;
            }

            return new Stack(fit: StackFit.expand, children: [
              connected
                  ? BlocBuilder<StudentBloc, StudentState>(
                      bloc: _bloc,
                      builder: (BuildContext contxt, StudentState state) {
                        if (state is StudentInitial || state is Loading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is StudentDataSucess) {
                          return state.obj != null && state.obj!.length > 0
                              ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child:
                                      _buildGrid(state.obj!, state.subFolder!))
                              :
                              // ListView(children: [
                              NoDataFoundErrorWidget(
                                  isResultNotFoundMsg: false,
                                  isNews: false,
                                  isEvents: false,
                                );
                          // ]);
                        } else if (state is StudentError) {
                          return ListView(children: [ErrorMsgWidget()]);
                        }
                        return Container();
                      })
                  : NoInternetErrorWidget(
                      connected: connected, issplashscreen: false),
              Container(
                height: 0,
                width: 0,
                child: BlocListener<HomeBloc, HomeState>(
                    bloc: _homeBloc,
                    listener: (context, state) async {
                      if (state is BottomNavigationBarSuccess) {
                        AppTheme.setDynamicTheme(Globals.appSetting, context);
                        Globals.homeObject = state.obj;
                        setState(() {});
                      } else if (state is HomeErrorReceived) {
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Center(child: Text("Unable to load the data")),
                        );
                      }
                    },
                    child: EmptyContainer()),
              ),
            ]);
          },
          child: Container()),
      onRefresh: refreshPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
          marginLeft: 30,
          refresh: (v) {
            setState(() {});
          },
        ),
        body: Globals.homeObject["Student_Banner_Image__c"] != null &&
                Globals.homeObject["Student_Banner_Image__c"] != ''
            ? NestedScrollView(

                // controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    Globals.homeObject["Student_Banner_Image__c"] != null
                        ? BannerImageWidget(
                            imageUrl:
                                Globals.homeObject["Student_Banner_Image__c"],
                            bgColor:
                                Globals.homeObject["Student_Banner_Color__c"] !=
                                        null
                                    ? Utility.getColorFromHex(Globals
                                        .homeObject["Student_Banner_Color__c"])
                                    : null,
                          )
                        : SliverAppBar(),
                  ];
                },
                body: _body())
            : _body());
  }
}
