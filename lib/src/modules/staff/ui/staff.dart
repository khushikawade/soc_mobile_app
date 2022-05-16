import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../../../services/local_database/local_db.dart';
import '../../../widgets/google_auth_webview.dart';
import '../../custom/model/custom_setting.dart';
import '../../ocr/modal/user_info.dart';
import '../../ocr/ui/ocr_home.dart';
import '../../shared/ui/common_grid_widget.dart';

class StaffPage extends StatefulWidget {
  StaffPage({Key? key, this.title, this.language, this.customObj})
      : super(key: key);
  final CustomSetting? customObj;
  final String? title;
  final String? language;

  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  LocalDatabase<UserInfo> _localUserInfo = LocalDatabase('user_profile');
  List<UserInfo> _localData = [];
  FocusNode myFocusNode = new FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  StaffBloc _bloc = StaffBloc();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;
  OcrBloc ocrBloc = new OcrBloc();
  bool? authSuccess = false;
  dynamic userData;

  @override
  void initState() {
    super.initState();
    _bloc.add(StaffPageEvent());
    localdb();
  }

  localdb() async {
    _localData = await _localUserInfo.getData();
  }

//To authenticate the user via google
  _launchURL(String? title) async {
    Globals.isbottomNavbar = false;
    setState(() {
      
    });
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const OpticalCharacterRecognition()),
  );
  //  Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (BuildContext context) => GoogleAuthWebview(
  //                 title: title!,
  //                 url: Overrides.secureLoginURL +
  //                     '?' +
  //                     Globals.appSetting
  //                         .appLogoC, //queryParameter=='' ? obj.appUrlC! : obj.appUrlC!+'?'+queryParameter,
  //                 isbuttomsheet: true,
  //                 language: Globals.selectedLanguage,
  //                 hideAppbar: false,
  //                 hideShare: true,
  //                 zoomEnabled: false,
  //                 callBackFunction: (value) async {
  //                   if (value.toString().contains('displayName')) {
  //                     value = value.split('?')[1];

  //                     //Comparing and saving the user profile locally
  //                     if (value
  //                             .split('+')[1]
  //                             .toString()
  //                             .split('=')[1]
  //                             .contains('@schools.nyc.gov') ||
  //                         value
  //                             .split('+')[1]
  //                             .toString()
  //                             .split('=')[1]
  //                             .contains('@solvedconsulting')) {
  //                       _localUserInfo.addData(UserInfo(
  //                           userName: value
  //                               .split('+')[0]
  //                               .toString()
  //                               .toString()
  //                               .split('=')[1],
  //                           userEmail: value
  //                               .split('+')[1]
  //                               .toString()
  //                               .toString()
  //                               .split('=')[1],
  //                           profilePicture: value
  //                               .split('+')[2]
  //                               .toString()
  //                               .toString()
  //                               .split('=')[1]));

  //                       localdb();

  //                       Navigator.pushReplacement(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (BuildContext context) =>
  //                                   OpticalCharacterRecognition()));
  //                     } else {
  //                       Navigator.pop(context, false);
  //                       Utility.showSnackBar(
  //                           _scaffoldKey,
  //                           'You are not authorized to access the feature. Please use the authorized account.',
  //                           context,
  //                           50.0);
  //                     }
  //                     // ocrBloc.add(AuthenticateEmail(
  //                     //     email: value.split('+')[1].toString().split('=')[1]));
  //                     // setState(() {
  //                     //   userData = value;
  //                     // });
  //                   }
  //                 },
  //               )));
  }

  Widget _body(String key) => RefreshIndicator(
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

            return
                // connected?
                Container(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                Expanded(
                  child: BlocBuilder<StaffBloc, StaffState>(
                      bloc: _bloc,
                      builder: (BuildContext contxt, StaffState state) {
                        if (state is StaffInitial || state is StaffLoading) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primaryVariant,
                          ));
                        } else if (state is StaffDataSucess) {
                          return widget.customObj != null &&
                                  widget.customObj!.sectionTemplate ==
                                      "Grid Menu"
                              ? CommonGridWidget(
                                  scaffoldKey: _scaffoldKey,
                                  connected: connected,
                                  data: state.obj!,
                                  sectionName: "staff")
                              : CommonListWidget(
                                  key: ValueKey(key),
                                  scaffoldKey: _scaffoldKey,
                                  connected: connected,
                                  data: state.obj!,
                                  sectionName: "staff");
                        } else if (state is ErrorInStaffLoading) {
                          return ListView(children: [ErrorMsgWidget()]);
                        } else {
                          return ErrorMsgWidget();
                        }
                      }),
                ),
                Container(
                  height: 0,
                  width: 0,
                  child: BlocListener<HomeBloc, HomeState>(
                      bloc: _homeBloc,
                      listener: (context, state) async {
                        if (state is BottomNavigationBarSuccess) {
                          AppTheme.setDynamicTheme(Globals.appSetting, context);
                          Globals.appSetting = AppSetting.fromJson(state.obj);
                        }
                      },
                      child: EmptyContainer()),
                ),
                // BlocListener<OcrBloc, OcrState>(
                //     bloc: ocrBloc,
                //     listener: (context, state) async {
                //       if (state is EmailAuthenticationSuccess) {
                //         if (state.obj == "true") {
                //           _localUserInfo.addData(UserInfo(
                //               userName: userData
                //                   .split('+')[0]
                //                   .toString()
                //                   .toString()
                //                   .split('=')[1],
                //               userEmail: userData
                //                   .split('+')[1]
                //                   .toString()
                //                   .toString()
                //                   .split('=')[1],
                //               profilePicture: userData
                //                   .split('+')[2]
                //                   .toString()
                //                   .toString()
                //                   .split('=')[1]));

                //           localdb();
                //           Navigator.pushReplacement(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (BuildContext context) =>
                //                       OpticalCharacterRecognition()));
                //         } else {
                //           Navigator.pop(context);
                //         }
                //       }
                //     },
                //     child: EmptyContainer()),
              ]),
            );
          },
          child: Container()),
      onRefresh: refreshPage);

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(
        marginLeft: 30,
        refresh: (v) {
          setState(() {});
        },
      ),
      body: Globals.appSetting.staffBannerImageC != null &&
              Globals.appSetting.staffBannerImageC != ''
          ? NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  BannerImageWidget(
                    imageUrl: Globals.appSetting.staffBannerImageC!,
                    bgColor: Globals.appSetting.studentBannerColorC != null
                        ? Utility.getColorFromHex(
                            Globals.appSetting.studentBannerColorC!)
                        : null,
                  )
                ];
              },
              body: _body('body1'),
            )
          : _body('body2'),
      floatingActionButton: Container(
        height: Globals.deviceType == 'phone' ? 80 : 100.0,
        width: Globals.deviceType == 'phone' ? 80 : 100.0,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.03,
        ),
        child: FloatingActionButton(
          onPressed: () async {
            if (_localData.isEmpty) {
              await _launchURL('Google Authentication');
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          OpticalCharacterRecognition()));
            }
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _bloc.add(StaffPageEvent());
    _homeBloc.add(FetchStandardNavigationBar());
  }
}