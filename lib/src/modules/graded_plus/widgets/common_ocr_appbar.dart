import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/ui/graded_landing_page.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/plus_common_widgets/profile_page.dart';
import 'package:Soc/src/modules/graded_plus/widgets/Common_popup.dart';
import 'package:Soc/src/modules/graded_plus/widgets/custom_intro_layout.dart'
    as customIntroLayout;
import 'package:Soc/src/modules/graded_plus/widgets/user_profile.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../services/local_database/local_db.dart';
import '../../google_drive/bloc/google_drive_bloc.dart';
import '../../google_drive/model/user_profile.dart';

// ignore: must_be_immutable
class CustomOcrAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
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
      required this.fromGradedPlus})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);
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

  final scaffoldKey;

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
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 300, //widget.isSuccessState == false ? 200 : null,
        automaticallyImplyLeading: false,
        leading: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.customBackButton != null
                ? widget.customBackButton!
                : widget.isBackButton == true
                    ? IconButton(
                        onPressed: () {
                          //To dispose the snackbar message before navigating back if exist
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          Navigator.pop(context, widget.navigateBack);
                        },
                        icon: Icon(
                          IconData(0xe80d,
                              fontFamily: Overrides.kFontFam,
                              fontPackage: Overrides.kFontPkg),
                          color: AppTheme.kButtonColor,
                        ),
                      )
                    : Container(
                        height: 0,
                        width: 8.0,
                      ),
            widget.fromGradedPlus == true ? commonGradedLogo() : Container()
          ],
        ),
        title: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: 70,
              height: 40,
              color: Colors.transparent,
            )),
        actions: [
          widget.isProfilePage == true
              ? IconButton(
                  onPressed: () {
                    //  WarningPopupModel();

                    popupModal(
                        message:
                            "Are you sure you want to log out of all PLUS(+) apps?",
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
                              // If app is running as the regular school app, it should navigate to the Home page(Staff section).
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(
                                            isFromOcrSection: true,
                                          )),
                                  (_) => false);
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
                            Utility.updateLogs(
                                activityType: 'GRADED+',
                                activityId: '16',
                                // sessionId: widget.assessmentDetailPage == true
                                //     ? widget.obj!.sessionId
                                //     : '',
                                description: widget.assessmentDetailPage == true
                                    ? 'Drive Button pressed from Assessment History Detail Page'
                                    : 'Drive Button pressed from Result Summary',
                                operationResult: 'Success');
                            Globals.googleDriveFolderPath != null
                                ? Utility.launchUrlOnExternalBrowser(
                                    Globals.googleDriveFolderPath!)
                                : getGoogleFolderPath();
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
                      : widget.assessmentDetailPage == null
                          ? IconButton(
                              iconSize: 32,
                              onPressed: () {
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
                                    // If app is running as the regular school app, it should navigate to the Home page(Staff section).
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                  isFromOcrSection: true,
                                                )),
                                        (_) => false);
                                  }
                                }
                              },
                              icon: Icon(
                                IconData(0xe874,
                                    fontFamily: Overrides.kFontFam,
                                    fontPackage: Overrides.kFontPkg),
                                color: AppTheme.kButtonColor,
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
          widget.isOcrHome == true && Overrides.STANDALONE_GRADED_APP != true
              ? IconButton(
                  iconSize: 32,
                  onPressed: () async {
                    await FirebaseAnalyticsService.addCustomAnalyticsEvent(
                        "walkthrough");
                    var result = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              customIntroLayout.CustomIntroWidget()),
                    );
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.help,
                    //  size: 32,
                    color: AppTheme.kButtonColor,
                  ))
              : Container(),
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
                            child: CachedNetworkImage(
                              height: Globals.deviceType == "phone" ? 28 : 32,
                              width: Globals.deviceType == "phone" ? 28 : 32,
                              imageUrl: snapshot.data!.profilePicture!,
                              placeholder: (context, url) =>
                                  CupertinoActivityIndicator(
                                      animating: true, radius: 10),
                            ),
                          ),
                          onPressed: () async {
                            await FirebaseAnalyticsService
                                .addCustomAnalyticsEvent("profile");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                        fromGradedPlus: widget.fromGradedPlus,
                                        hideStateSelection:
                                            widget.hideStateSelection ?? false,
                                        profile: snapshot.data!,
                                      )),
                            );

                            // _showPopUp(snapshot.data!);
                            //print("profile url");
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
                  title: title!);
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

  Widget commonGradedLogo() {
    return Image.asset(
      Color(0xff000000) == Theme.of(context).backgroundColor
          ? "assets/images/graded+_light.png"
          : "assets/images/graded+_dark.png",
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
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                          isFromOcrSection: true,
                                        )),
                                (_) => false);
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
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    List<UserInformation> _userInformation = await _localDb.getData();
    Globals.teacherEmailId = _userInformation[0].userEmail!;
    //print("//printing _userInformation length : ${_userInformation[0]}");
    return _userInformation[0];
  }

  void _showPopUp(UserInformation userInformation) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CustomDialogBox(
            activityType: 'GRADED+',
            profileData: userInformation,
            isUserInfoPop: true,
          );
        });
  }
}
