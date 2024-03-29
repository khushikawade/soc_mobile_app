import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_list.dart';
import 'package:Soc/src/modules/google_classroom/ui/graded_standalone_landing_page.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_student_list_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/modules/plus_common_widgets/profile_page.dart';
import 'package:Soc/src/modules/graded_plus/widgets/Common_popup.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/help/intro_tutorial.dart'
    as customIntroLayout;
import 'package:Soc/src/modules/setting/ios_accessibility_guide_page.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/services/parent_profile_details.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/lanuage_selector.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_apps_settings/open_apps_settings.dart';
import 'package:open_apps_settings/settings_enum.dart';
import '../../google_drive/bloc/google_drive_bloc.dart';
import '../../../services/user_profile.dart';
import './Common_popup.dart';

// ignore: must_be_immutable
class CustomOcrAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  ValueListenable<bool>? isSuccessState;
  bool? isBackButton;
  bool? isProfilePage;
  bool? isTitle;
  bool? isOcrHome;
  bool? isResultScreen;
  bool? isHomeButtonPopup;
  bool? assessmentDetailPage;
  bool? assessmentPage;
  Widget? actionIcon;
  Widget? customBackButton;
  bool? hideStateSelection;
  ValueListenable<bool>? isBackOnSuccess;
  String? sessionId;
  bool? isFromResultSection;
  bool? navigateBack;
  final VoidCallback? onTap;
  bool? fromGradedPlus;
  String? plusAppName;
  IconData? iconData;
  final String? sectionType;
  final scaffoldKey;
  final ValueChanged? refresh;
  String? commonLogoPath;

  CustomOcrAppBarWidget(
      {required Key? key,
      this.hideStateSelection,
      required this.isBackButton,
      this.isTitle,
      required this.isSuccessState,
      this.isResultScreen,
      this.isHomeButtonPopup,
      this.assessmentDetailPage,
      this.assessmentPage,
      this.actionIcon,
      this.sessionId,
      this.isOcrHome,
      this.scaffoldKey,
      this.customBackButton,
      this.onTap,
      required this.isBackOnSuccess,
      this.isFromResultSection,
      this.navigateBack,
      this.isProfilePage,
      required this.fromGradedPlus,
      required this.plusAppName,
      required this.iconData,
      this.sectionType,
      required this.refresh,
      this.commonLogoPath})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomOcrAppBarWidgetState createState() => _CustomOcrAppBarWidgetState();
}

class _CustomOcrAppBarWidgetState extends State<CustomOcrAppBarWidget> {
  double lineProgress = 0.0;
  SharePopUp shareobj = new SharePopUp();
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();

  @override
  Widget build(BuildContext context) {
    Widget leading = Container(
      child: Row(
        children: [
          _translateButton(setState, context),
          _openAccessibility(context),
        ],
      ),
    );

    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 110, //widget.isSuccessState == false ? 200 : null,
        automaticallyImplyLeading: false,
        leading: leading,
        // title: GestureDetector(
        //     onTap: widget.onTap,
        //     child: Container(
        //       width: 70,
        //       height: 40,
        //       color: Colors.transparent,
        //     )),
        title: widget.iconData == null
            ? commonGradedLogo(commonLogoPath: widget.commonLogoPath)
            : allScreenIconWidget(),
        actions: [
          widget.isProfilePage == true
              ? IconButton(
                  onPressed: () {
                    //  WarningPopupModel();

                    popupModal(
                        message:
                            "Are you sure you want to log out of all Staff+ apps?",
                        //  'You are about to Signout from the google account. This may restricts you to use the app without google SignIn. \n\nContinue Signout?',
                        title: "Log Out"
                        //'Signout'
                        );
                  },
                  icon: Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.logout_outlined,
                        size: 28,
                        color: AppTheme.kButtonColor,
                      )))
              : widget.isFromResultSection == true
                  ? Container(
                      padding: widget.isSuccessState!.value != false
                          ? EdgeInsets.only(right: 10)
                          : EdgeInsets.zero,
                      child:
                          //widget.actionIcon,
                          IconButton(
                        onPressed: () async {
                          await FirebaseAnalyticsService
                              .addCustomAnalyticsEvent("home");
                          if (widget.isHomeButtonPopup == true) {
                            _onHomePressed();
                          } else {
                            Utility.setFree();
                            // If app is running as the standalone Graded+ app, it should navigate to the Graded+ landing page.
                            if (Overrides.STANDALONE_GRADED_APP) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GradedLandingPage()),
                                  (_) => false);
                            } else {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            }
                          }
                        },
                        icon: Icon(
                          IconData(0xe874,
                              fontFamily: Overrides.kFontFam,
                              fontPackage: Overrides.kFontPkg),
                          color: AppTheme.kButtonColor,
                          size: 30,
                        ),
                      ),
                    )
                  : widget.assessmentPage == true
                      ? GestureDetector(
                          onTap: () async {
                            await FirebaseAnalyticsService
                                .addCustomAnalyticsEvent(
                                    "go_to_drive_assessment_detail");
                            //print(
                            // 'Google drive folder path : ${Globals.googleDriveFolderPath}');
                            PlusUtility.updateLogs(
                                activityType: 'GRADED+',
                                userType: 'Teacher',
                                activityId: '16',
                                // sessionId: widget.assessmentDetailPage == true
                                //     ? widget.obj!.sessionId
                                //     : '',
                                description: widget.assessmentDetailPage == true
                                    ? 'Drive Button pressed from Assessment History Detail Page'
                                    : 'Drive Button pressed from Result Summary',
                                operationResult: 'Success');

                            // Globals.googleDriveFolderPath != null
                            //     ? Utility.launchUrlOnExternalBrowser(
                            //         Globals.googleDriveFolderPath!)
                            //     : getGoogleFolderPath();

                            List<UserInformation> userProfileInfoData =
                                await UserGoogleProfile.getUserProfile();
                            if (userProfileInfoData[0]
                                        .gradedPlusGoogleDriveFolderPathUrl !=
                                    null &&
                                userProfileInfoData[0]
                                        .gradedPlusGoogleDriveFolderPathUrl !=
                                    '') {
                              Utility.launchUrlOnExternalBrowser(
                                  userProfileInfoData[0]
                                          .gradedPlusGoogleDriveFolderPathUrl ??
                                      '');
                            } else {
                              getGoogleFolderPath();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                              alignment: Alignment.center,
                              width: Globals.deviceType == "phone" ? 32 : 34,
                              height: Globals.deviceType == "phone" ? 32 : 34,
                              image: AssetImage(
                                "assets/images/drive_ico.png",
                              ),
                            ),
                          ),
                        )
                      : Container(),
          widget.assessmentDetailPage == true
              ? Container()
              : ValueListenableBuilder(
                  valueListenable: widget.isSuccessState!,
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    return widget.isSuccessState!.value == false ||
                            widget.isResultScreen == true
                        ? widget.actionIcon!
                        : ValueListenableBuilder(
                            valueListenable: widget.isBackOnSuccess!,
                            builder: (BuildContext context, dynamic value,
                                Widget? child) {
                              return value == true
                                  ? widget.actionIcon!
                                  : Container();
                            });
                  }),
          widget.isProfilePage == true
              ? Container()
              : FutureBuilder(
                  future: getUserProfile(),
                  builder: (context, AsyncSnapshot<UserInformation> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        child: IconButton(
                          icon: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            child: snapshot.data!.profilePicture != null
                                ? CachedNetworkImage(
                                    height:
                                        Globals.deviceType == "phone" ? 28 : 32,
                                    width:
                                        Globals.deviceType == "phone" ? 28 : 32,
                                    imageUrl:
                                        snapshot.data!.profilePicture ?? '',
                                    placeholder: (context, url) =>
                                        CupertinoActivityIndicator(
                                            animating: true, radius: 10))
                                : CircleAvatar(
                                    // alignment: Alignment.center,
                                    // height:
                                    //     Globals.deviceType == "phone" ? 28 : 32,
                                    // width:
                                    //     Globals.deviceType == "phone" ? 28 : 32,
                                    // color: Color.fromARGB(255, 29, 146, 242),
                                    child: Text(
                                      snapshot.data!.userName!.substring(0, 1),
                                      style: TextStyle(
                                          color: Color(0xff000000) ==
                                                  Theme.of(context)
                                                      .backgroundColor
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                  ),
                          ),
                          onPressed: () async {
                            await FirebaseAnalyticsService
                                .addCustomAnalyticsEvent("profile");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                        commonLogoPath: widget.commonLogoPath,
                                        sectionType: widget.sectionType ?? '',
                                        plusAppName: 'Graded+',
                                        fromGradedPlus: widget.fromGradedPlus,
                                        hideStateSelection:
                                            widget.hideStateSelection ?? false,
                                        profile: snapshot.data!,
                                      )),
                            );
                          },
                        ),
                      );
                    }
                    return IconButton(icon: Container(), onPressed: (() {}));
                  }),
        ]);
  }

  popupModal({required String message, required String? title}) {
    return showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return CommonPopupWidget(
                isLogout: true,
                orientation: orientation,
                context: context,
                message: message,
                title: title!,
                confirmationOnPress: () async {
                  if (widget.sectionType == 'Family') {
                    await FamilyUserDetails.clearFamilyUserProfile();

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  index: 3,
                                  isFromOcrSection: true,
                                )),
                        (_) => false);
                    return;
                  }

                  await FirebaseAnalyticsService.addCustomAnalyticsEvent(
                      "logout");
                      
                  await UserGoogleProfile.clearUserProfile();
                  await GoogleClassroom.clearClassroomCourses();
                  await Authentication.signOut(context: context);
                  await Utility.clearStudentInfo(tableName: 'student_info');
                  await Utility.clearStudentInfo(
                      tableName: 'history_student_info');

                  //  LocalDatabase<PBISPlusNotesUniqueStudentList>
                  //             _pbisPlusStudentListDB =
                  //             LocalDatabase(PBISPlusOverrides.pbisPlusStudentListDB);
                  //         await _pbisPlusStudentListDB.clear();
                  // Globals.googleDriveFolderId = null;
                  PlusUtility.updateLogs(
                      activityType: 'GRADED+',
                      userType: 'Teacher',
                      activityId: '3',
                      description: 'User profile logout',
                      operationResult: 'Success');

                  // If app is running as the standalone Graded+ app, it should navigate to the Graded+ landing page.
                  if (Overrides.STANDALONE_GRADED_APP) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => GradedLandingPage(
                                  isFromLogoutPage: true,
                                )),
                        (_) => false);
                  } else {
                    //PBIS +
                    await PBISPlusUtility.cleanPbisPlusDataOnLogOut();

                    // If app is running as the regular school app, it should navigate to the Home page(Staff section).
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
              );
            }));
  }

  getGoogleFolderPath() async {
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();
    Utility.showSnackBar(
        widget.scaffoldKey,
        "Unable to navigate at the moment. Please try again later",
        context,
        null);

    _googleDriveBloc.add(GetDriveFolderIdEvent(
        isReturnState: false,
        //  filePath: file,
        token: _profileData[0].authorizationToken,
        folderName: "SOLVED GRADED+",
        refreshToken: _profileData[0].refreshToken));
  }

  Widget commonGradedLogo(
      {String? commonLogoPath = "assets/images/pbis_plus_light.png"}) {
    return Image.asset(
      commonLogoPath!,
      // Color(0xff000000) == Theme.of(context).backgroundColor
      //     ? "assets/images/graded+_light.png"
      //     : "assets/images/graded+_dark.png",
      height: Globals.deviceType == "phone"
          ? AppTheme.kIconSize * 2
          : AppTheme.kTabIconSize * 2,
      width: Globals.deviceType == "phone"
          ? AppTheme.kIconSize * 2
          : AppTheme.kTabIconSize * 2,
    );
  }

  _onHomePressed() {
    return showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Center(
                  child: Container(
                    padding: Globals.deviceType == 'phone'
                        ? null
                        : const EdgeInsets.only(top: 10.0),
                    height: Globals.deviceType == 'phone' ? null : 50,
                    width: Globals.deviceType == 'phone'
                        ? null
                        : orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.height / 2,
                    child: TranslationWidget(
                        message: "Confirm exit",
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) {
                          return Text(translatedMessage.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(color: AppTheme.kButtonColor));
                        }),
                  ),
                ),
                content: TranslationWidget(
                    message:
                        "Do you want to exit? You will lose all the scanned assesment sheets.",
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) {
                      return Text(translatedMessage.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.black));
                    }),
                actions: <Widget>[
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.height,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        child: TranslationWidget(
                            message: "No",
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) {
                              return Text(translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: AppTheme.kButtonColor,
                                      ));
                            }),
                        onPressed: () async {
                          //Globals.isCameraPopup = false;
                          Navigator.pop(context, false);
                        },
                      ),
                      TextButton(
                        child: TranslationWidget(
                            message: "Yes ",
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) {
                              return Text(translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: Colors.red,
                                      ));
                            }),
                        onPressed: () {
                          Utility.setFree();
                          // If app is running as the standalone Graded+ app, it should navigate to the Graded+ landing page.
                          if (Overrides.STANDALONE_GRADED_APP) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => GradedLandingPage()),
                                (_) => false);
                          } else {
                            // If app is running as the regular school app, it should navigate to the Home page(Staff section).
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //         builder: (context) => HomePage(
                            //               isFromOcrSection: true,
                            //             )),
                            //     (_) => false);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          }
                        },
                      ),
                    ],
                  )
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              );
            }));
  }

  Future<UserInformation> getUserProfile() async {
    //GET CURRENT GOOGLE USER PROFILE
    List<UserInformation> _userInformation =
        await UserGoogleProfile.getUserProfile();
    Globals.userEmailId = _userInformation[0].userEmail!;
    return _userInformation[0];
  }

  Widget _translateButton(StateSetter setState, BuildContext context) {
    return IconButton(
        // key: _bshowcase,
        onPressed: () async {
          setState(() {});
          LanguageSelector(context, (language) {
            if (language != null) {
              setState(() {
                Globals.selectedLanguage = language;
                Globals.languageChanged.value = language;
              });
              widget.refresh!(true);
            }
          });
          /*-------------------------User Activity Track START----------------------------*/
          FirebaseAnalyticsService.addCustomAnalyticsEvent(
              'Google Translation ${widget.plusAppName ?? ''}'
                  .toLowerCase()
                  .replaceAll(" ", "_"));

          PlusUtility.updateLogs(
              activityType: widget.plusAppName ?? '',
              userType: 'Teacher',
              activityId: '43',
              description: 'Google Translation',
              operationResult: 'Success');
          /*-------------------------User Activity Track END----------------------------*/
        },
        icon: Container(
          child: Image(
            width: !Overrides.STANDALONE_GRADED_APP
                ? Globals.deviceType == "phone"
                    ? 26
                    : 32
                : 28,
            height: !Overrides.STANDALONE_GRADED_APP
                ? Globals.deviceType == "phone"
                    ? 26
                    : 32
                : 28,
            image: AssetImage("assets/images/gtranslate.png"),
          ),
        ));
  }

  Widget _openAccessibility(BuildContext context) {
    return IconButton(
      iconSize: 28,
      onPressed: () async {
        //----------------------------------------------------------------------
        await FirebaseAnalyticsService.addCustomAnalyticsEvent(
            'Accessibility ${widget.plusAppName ?? ''}'
                .toLowerCase()
                .replaceAll(" ", "_"));

        PlusUtility.updateLogs(
            activityType: widget.plusAppName ?? '',
            userType: 'Teacher',
            activityId: '61',
            description: 'Accessibility',
            operationResult: 'Success');
        //----------------------------------------------------------------------

        if (Platform.isAndroid) {
          OpenAppsSettings.openAppsSettings(
              settingsCode: SettingsCode.ACCESSIBILITY);
        } else {
          // AppSettings.openAccessibilitySettings(asAnotherTask: true);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      IosAccessibilityGuidePage()));
        }
      },
      icon: Icon(
        FontAwesomeIcons.universalAccess,
        color: Colors.blue,
        // key: _openSettingShowCaseKey,
        size: !Overrides.STANDALONE_GRADED_APP
            ? Globals.deviceType == "phone"
                ? 25
                : 32
            : null,
      ),
    );
  }

  Widget allScreenIconWidget() {
    return Container(
      padding: EdgeInsets.only(right: 7),
      child: Icon(
        widget.iconData,
        color: AppTheme.kButtonColor,
      ),
    );
  }
}
