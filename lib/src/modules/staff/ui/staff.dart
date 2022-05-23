import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../../services/local_database/local_db.dart';
import '../../../widgets/google_auth_webview.dart';
import '../../custom/model/custom_setting.dart';
import '../../google_drive/bloc/google_drive_bloc.dart';
import '../../ocr/modal/user_info.dart';
import '../../ocr/ui/ocr_home.dart';
import '../../shared/ui/common_grid_widget.dart';
//import 'package:file_picker/file_picker.dart';

class StaffPage extends StatefulWidget {
  StaffPage(
      {Key? key,
      this.title,
      this.language,
      this.customObj,
      required this.isFromOcr})
      : super(key: key);
  final CustomSetting? customObj;
  final String? title;
  final String? language;
  final bool isFromOcr;

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
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  // OcrBloc _ocrBloc = new OcrBloc();
  ScrollController _scrollController = new ScrollController();
  final ValueNotifier<bool> isScrolling = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _bloc.add(StaffPageEvent());
    if (widget.isFromOcr) {
      _homeBloc.add(FetchStandardNavigationBar());
    }
    localdb();
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() async {
    if (isScrolling.value == true) return;
    isScrolling.value = true;
    if (isScrolling.value == false) return;
    await Future.delayed(Duration(milliseconds: 2000));
    isScrolling.value = false;
  }

  localdb() async {
    _localData = await _localUserInfo.getData();
  }

//To authenticate the user via google
  _launchURL(String? title) async {
    var themeColor = Theme.of(context).backgroundColor == Color(0xff000000)
        ? Color(0xff000000)
        : Color(0xffFFFFFF);

    print(Theme.of(context)
        .backgroundColor
        .toString()
        .split('0xff')[1]
        .split(')')[0]);

    pushNewScreen(
      context,
      screen: GoogleAuthWebview(
          title: title!,
          url: Overrides.secureLoginURL +
              '?' +
              Globals.appSetting.appLogoC +
              '?' +
              themeColor.toString().split('0xff')[1].split(')')[0],

          // .split('0x')[
          //     1].split(')')[0], //queryParameter=='' ? obj.appUrlC! : obj.appUrlC!+'?'+queryParameter,
          isbuttomsheet: true,
          language: Globals.selectedLanguage,
          hideAppbar: false,
          hideShare: true,
          zoomEnabled: false,
          callBackFunction: (value) async {
            // print(value);
            if (value.toString().contains('displayName')) {
              value = value.split('?')[1];
              //Save user profile
              saveUserProfile(value);
              // Push to the grading system
              pushNewScreen(
                context,
                screen: OpticalCharacterRecognition(),
                withNavBar: false,
              );
            } else if (value.toString().contains('authenticationfailure')) {
              Navigator.pop(context, false);
              Utility.showSnackBar(
                  _scaffoldKey,
                  'You are not authorized to access the feature. Please use the authorized account.',
                  context,
                  50.0);
            }
          }),
      withNavBar: false,
    );
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) => GoogleAuthWebview(
    //             title: title!,
    //             url: Overrides.secureLoginURL +
    //                 '?' +
    //                 Globals.appSetting.appLogoC +
    //                 '?' + themeColor.toString().split('0xff')[
    //                     1].split(')')[0],

    //                 // .split('0x')[
    //                 //     1].split(')')[0], //queryParameter=='' ? obj.appUrlC! : obj.appUrlC!+'?'+queryParameter,
    //             isbuttomsheet: true,
    //             language: Globals.selectedLanguage,
    //             hideAppbar: false,
    //             hideShare: true,
    //             zoomEnabled: false,
    //             callBackFunction: (value) async {
    //               // print(value);
    //               if (value.toString().contains('displayName')) {
    //                 value = value.split('?')[1];
    //                 //Save user profile
    //                 saveUserProfile(value);
    //                 // Push to the grading system
    //                 pushNewScreen(
    //                   context,
    //                   screen: OpticalCharacterRecognition(),
    //                   withNavBar: false,
    //                 );
    //               } else if (value
    //                   .toString()
    //                   .contains('authenticationfailure')) {
    //                 Navigator.pop(context, false);
    //                 Utility.showSnackBar(
    //                     _scaffoldKey,
    //                     'You are not authorized to access the feature. Please use the authorized account.',
    //                     context,
    //                     50.0);
    //               }
    //             })
    //             ));
  }

  saveUserProfile(profileData) {
    var profile = profileData.split('+');
    _localUserInfo.addData(UserInfo(
        userName: profile[0].toString().split('=')[1],
        userEmail: profile[1].toString().split('=')[1],
        profilePicture: profile[2].toString().split('=')[1],
        authorizationToken:
            profile[3].toString().split('=')[1].replaceAll('#', '')));

    localdb();

    //Creating a assessment folder in users google drive to maintain all the assessments together at one place
    _googleDriveBloc.add(CreateFolderOnGoogleDriveEvent(
        //  filePath: file,
        token: profile[3].toString().split('=')[1].replaceAll('#', ''),
        folderName: "Assessments"));
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
                                  bottomPadding: 60,
                                  connected: connected,
                                  data: state.obj!,
                                  sectionName: "staff")
                              : CommonListWidget(
                                  scrollController: _scrollController,
                                  bottomPadding: 80,
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
                          setState(() {});
                        }
                      },
                      child: EmptyContainer()),
                ),
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
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.03,
          ),
          child: cameraButton(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    _bloc.add(StaffPageEvent());
    _homeBloc.add(FetchStandardNavigationBar());
  }

//   Future<File> _getpath() async {
//  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
//   //  return File(result!.files.first.path!);
//   }

  Widget cameraButton() {
    return ValueListenableBuilder<bool>(
        valueListenable: isScrolling,
        child: Container(),
        builder: (BuildContext context, bool value, Widget? child) {
          return AnimatedOpacity(
            opacity: isScrolling.value ? 0 : 1,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 800),
            child: FloatingActionButton.extended(
                backgroundColor: AppTheme.kButtonColor,
                onPressed: () async {
                  // _localData.clear();
                  if (_localData.isEmpty) {
                    await _launchURL('Google Authentication');
                  } else {
                    pushNewScreen(
                      context,
                      screen: OpticalCharacterRecognition(),
                      withNavBar: false,
                    );
                  }
                },
                icon: Icon(Icons.add, color: Theme.of(context).backgroundColor),
                label: textwidget(
                    text: 'Add Assessment',
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Theme.of(context).backgroundColor))),
          );
        });
  }

  Widget textwidget({required String text, required dynamic textTheme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        style: textTheme,
      ),
    );
  }
}
