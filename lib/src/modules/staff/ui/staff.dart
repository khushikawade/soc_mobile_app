import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/custom_rubic_modal.dart';
import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
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
import '../../../widgets/google_auth_webview.dart';
import '../../custom/model/custom_setting.dart';
import '../../google_drive/bloc/google_drive_bloc.dart';
import '../../google_drive/model/user_profile.dart';
import '../../ocr/modal/user_info.dart';
import '../../ocr/ui/ocr_home.dart';
import '../../shared/ui/common_grid_widget.dart';

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
//   LocalDatabase<UserInfo> Globals.localUserInfo = LocalDatabase('user_profile');
//   List<UserInfo> Globals.userprofilelocalData = [];
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
  OcrBloc _ocrBloc = new OcrBloc();
  ScrollController _scrollController = new ScrollController();
  final ValueNotifier<bool> isScrolling = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _bloc.add(StaffPageEvent());
    if (widget.isFromOcr) {
      _homeBloc.add(FetchStandardNavigationBar());
    }
    _scrollController.addListener(_scrollListener);

    _getLocalDb();
  }

  _scrollListener() async {
    bool isTop = _scrollController.position.pixels < 150;
    if (isTop) {
      if (isScrolling.value == false) return;
      isScrolling.value = false;
    } else {
      if (isScrolling.value == true) return;
      isScrolling.value = true;
    }
  }

  //To authenticate the user via google
  _launchURL(String? title) async {
    var themeColor = Theme.of(context).backgroundColor == Color(0xff000000)
        ? Color(0xff000000)
        : Color(0xffFFFFFF);

    var value = await pushNewScreen(
      context,
      screen: GoogleAuthWebview(
        title: title!,
        url: Globals.appSetting.authenticationURL ??
            '' + //Overrides.secureLoginURL +
                '?' +
                Globals.appSetting.appLogoC +
                '?' +
                themeColor.toString().split('0xff')[1].split(')')[0],
        isbuttomsheet: true,
        language: Globals.selectedLanguage,
        hideAppbar: false,
        hideShare: true,
        zoomEnabled: false,
      ),
      withNavBar: false,
    );

    if (value.toString().contains('authenticationfailure')) {
      Navigator.pop(context, false);
      Utility.showSnackBar(
          _scaffoldKey,
          'You are not authorized to access the feature. Please use the authorized account.',
          context,
          50.0);
    } else if (value.toString().contains('success')) {
      value = value.split('?')[1] ?? '';
      //Save user profile
      await saveUserProfile(value);
      List<UserInformation> _userprofilelocalData =
          await UserGoogleProfile.getUserProfile();
      verifyUserAndGetDriveFolder(_userprofilelocalData);
      // Push to the grading system
      pushNewScreen(
        context,
        screen: OpticalCharacterRecognition(),
        withNavBar: false,
      );
    }
  }

  Future<void> saveUserProfile(String profileData) async {
    List<String> profile = profileData.split('+');
    UserInformation _userInformation = UserInformation(
        userName: profile[0].toString().split('=')[1],
        userEmail: profile[1].toString().split('=')[1],
        profilePicture: profile[2].toString().split('=')[1],
        authorizationToken:
            profile[3].toString().split('=')[1].replaceAll('#', ''),
        refreshToken: profile[4].toString().split('=')[1].replaceAll('#', ''));

    //Save user profile to locally
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    await _localDb.addData(_userInformation);
    await _localDb.close();
  }

  // Future<List<UserInformation>> getUserProfile() async {
  //   LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
  //   List<UserInformation> _userInformation = await _localDb.getData();
  //   return _userInformation;
  // }

  // saveUserProfile(profileData) async {
  //   var profile = profileData.split('+');
  //   Globals.localUserInfo.clear();

  //   await Globals.localUserInfo.addData(UserInformation(
  //       userName: profile[0].toString().split('=')[1],
  //       userEmail: profile[1].toString().split('=')[1],
  //       profilePicture: profile[2].toString().split('=')[1],
  //       authorizationToken:
  //           profile[3].toString().split('=')[1].replaceAll('#', '')));

  //   final temp = await Globals.localUserInfo.getData();
  //   Globals.userprofilelocalData = temp;

  //   setState(() {});
  //   _ocrBloc.add(
  //       VerifyUserWithDatabase(email: profile[1].toString().split('=')[1]));
  //   //Creating a assessment folder in users google drive to maintain all the assessments together at one place
  //   _googleDriveBloc.add(GetDriveFolderIdEvent(
  //       //  filePath: file,
  //       token: profile[3].toString().split('=')[1].replaceAll('#', ''),
  //       folderName: "Assessments"));
  // }

  verifyUserAndGetDriveFolder(
      List<UserInformation> _userprofilelocalData) async {
    // List<UserInformation> _userprofilelocalData =
    //     await UserGoogleProfile.getUserProfile();
    _ocrBloc
        .add(VerifyUserWithDatabase(email: _userprofilelocalData[0].userEmail));
    //Creating a assessment folder in users google drive to maintain all the assessments together at one place
    _googleDriveBloc.add(GetDriveFolderIdEvent(
        //  filePath: file,
        token: _userprofilelocalData[0].authorizationToken,
        folderName: "Solved Assessment",
        refreshtoken: _userprofilelocalData[0].refreshToken));
  }

  Widget _body(String key) => RefreshIndicator(
      key: refreshKey,
      child: Stack(children: [
        OfflineBuilder(
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
                              color:
                                  Theme.of(context).colorScheme.primaryVariant,
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
                            AppTheme.setDynamicTheme(
                                Globals.appSetting, context);
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
            cameraButton()
        // Globals.appSetting.enableGraded == 'true' ? cameraButton() : Container()
      ]),
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
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    _bloc.add(StaffPageEvent());
    _homeBloc.add(FetchStandardNavigationBar());
  }

  Widget cameraButton() {
    return ValueListenableBuilder<bool>(
        valueListenable: isScrolling,
        child: Container(),
        builder: (BuildContext context, bool value, Widget? child) {
          return AnimatedPositioned(
            bottom: 40.0,
            right: isScrolling.value
                ? 8
                : (Utility.displayWidth(context) / 2) - 100,
            duration: const Duration(milliseconds: 650),
            curve: Curves.decelerate,
            child: Container(
              width: isScrolling.value ? null : 200,
              child: FloatingActionButton.extended(
                  isExtended: !isScrolling.value,
                  backgroundColor: AppTheme.kButtonColor,
                  onPressed: () async {
                    // Globals.localUserInfo.clear(); // COMMENT
                    List<UserInformation> _profileData =
                        await UserGoogleProfile.getUserProfile();
                    if (_profileData.isEmpty) {
                      await _launchURL('Google Authentication');
                    } else {
                      // List<UserInformation> _userprofilelocalData =
                      //     await UserGoogleProfile.getUserProfile();
                      verifyUserAndGetDriveFolder(_profileData);
                      pushNewScreen(
                        context,
                        screen: OpticalCharacterRecognition(),
                        withNavBar: false,
                      );
                    }
                  },
                  icon:
                      Icon(Icons.add, color: Theme.of(context).backgroundColor),
                  label: textwidget(
                      text: 'Assessment',
                      textTheme: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: Theme.of(context).backgroundColor))),
            ),
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

  _getLocalDb() async {
    LocalDatabase<CustomRubicModal> _localDb = LocalDatabase('custom_rubic');
    List<CustomRubicModal> _localData = await _localDb.getData();

    if (_localData.isEmpty) {
      print("local db is empty");
      RubricScoreList.scoringList.forEach((CustomRubicModal e) {
        _localDb.addData(e);
      });
    } else {
      print("local db is not empty");
      RubricScoreList.scoringList = [];
      RubricScoreList.scoringList.addAll(_localData);
      // _localDb.close()
    }
  }
}
