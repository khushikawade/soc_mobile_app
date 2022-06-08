import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';

import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../services/local_database/local_db.dart';
import '../../google_drive/bloc/google_drive_bloc.dart';
import '../../google_drive/model/user_profile.dart';

// ignore: must_be_immutable
class CustomOcrAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  CustomOcrAppBarWidget(
      {required Key? key,
      required this.isBackButton,
      this.isTitle,
      this.isSuccessState,
      this.isResultScreen,
      this.isHomeButtonPopup,
      this.assessmentDetailPage,
      this.assessmentPage,
      this.actionIcon,
      this.scaffoldKey,
      this.customBackButton,
      this.isbackOnSuccess})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);
  bool? isSuccessState;
  bool? isBackButton;
  bool? isTitle;
  bool? isResultScreen;
  bool? isHomeButtonPopup;
  bool? assessmentDetailPage;
  bool? assessmentPage;
  Widget? actionIcon;
  Widget? customBackButton;
  bool? isbackOnSuccess;

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
        leadingWidth: widget.isSuccessState == false ? 200 : null,
        automaticallyImplyLeading: false,
        leading: widget.customBackButton != null
            ? widget.customBackButton
            : widget.isSuccessState == false
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Utility.textWidget(
                          text: 'Scan Failure',
                          context: context,
                          textTheme: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 5.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffCF6679),
                        ),
                        child: Icon(
                            IconData(0xe838,
                                fontFamily: Overrides.kFontFam,
                                fontPackage: Overrides.kFontPkg),
                            size: 19,
                            color: Colors.white),
                      ),
                    ],
                  )
                : widget.isBackButton == true
                    ? IconButton(
                        onPressed: () {
                          //To dispose the snackbar message before navigating back if exist
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          IconData(0xe80d,
                              fontFamily: Overrides.kFontFam,
                              fontPackage: Overrides.kFontPkg),
                          color: AppTheme.kButtonColor,
                        ),
                      )
                    : null,
        actions: [
          widget.assessmentPage == true
              ? GestureDetector(
                  onTap: () {
                    print(
                        'Google drive folder path : ${Globals.googleDriveFolderPath}');
                    Globals.googleDriveFolderPath != null
                        ? Utility.launchUrlOnExternalBrowser(
                            Globals.googleDriveFolderPath!)
                        : getGoogleFolderPath();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image(
                      alignment: Alignment.center,
                      width: Globals.deviceType == "phone" ? 34 : 32,
                      height: Globals.deviceType == "phone" ? 34 : 32,
                      image: AssetImage(
                        "assets/images/drive_ico.png",
                      ),
                    ),
                  ),
                )
              : widget.assessmentDetailPage == null
                  ? Container(
                      padding: widget.isSuccessState != false
                          ? EdgeInsets.only(right: 10)
                          : EdgeInsets.zero,
                      child:
                          //widget.actionIcon,
                          IconButton(
                        onPressed: () {
                          if (widget.isHomeButtonPopup == true) {
                            _onHomePressed();
                          } else {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (_) => false);
                          }

                          // Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (context) => HomePage()),
                          // );
                        },
                        icon: Icon(
                          IconData(0xe874,
                              fontFamily: Overrides.kFontFam,
                              fontPackage: Overrides.kFontPkg),
                          color: AppTheme.kButtonColor,
                          size: 30,
                        ),
                      ))
                  : Container(),
          widget.assessmentDetailPage == true
              ? Container()
              : widget.isSuccessState == false || widget.isResultScreen == true ||  widget.isbackOnSuccess ==true
                  ? widget.actionIcon!
                  // Container(
                  //     padding: widget.isSuccessState != false
                  //         ? EdgeInsets.only(right: 10)
                  //         : EdgeInsets.zero,
                  //     child: IconButton(
                  //       onPressed: () {
                  //         if (widget.isSuccessState == false) {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (_) => CameraScreen()));
                  //         } else if (widget.isResultScreen == true) {
                  //           onFinishedPopup();
                  //         }
                  //       },
                  //       icon: Icon(
                  //         IconData(0xe877,
                  //             fontFamily: Overrides.kFontFam,
                  //             fontPackage: Overrides.kFontPkg),
                  //         size: 30,
                  //         color: AppTheme.kButtonColor,
                  //       ),
                  //     ),
                  //   )
                  : Container(),
          Container(
            margin: EdgeInsets.all(10),
            padding: widget.isSuccessState != false
                ? EdgeInsets.only(right: 10, top: 5)
                : EdgeInsets.zero,
            child: FutureBuilder(
                future: getUserProfile(),
                builder: (context, AsyncSnapshot<UserInformation> snapshot) {
                  if (snapshot.hasData) {
                    return InkWell(
                      onTap: () {
                        _showPopUp(snapshot.data!);
                        print("profile url");
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CachedNetworkImage(
                          // height: 30,
                          fit: BoxFit.cover,
                          imageUrl: snapshot.data!.profilePicture!,
                          placeholder: (context, url) =>
                              CupertinoActivityIndicator(
                                  animating: true, radius: 10),
                        ),
                      ),
                    );
                  }
                  return Container(
                    margin: EdgeInsets.all(10),
                    padding: widget.isSuccessState != false
                        ? EdgeInsets.only(right: 10, top: 5)
                        : EdgeInsets.zero,
                  );
                  //  CupertinoActivityIndicator(
                  //     animating: true, radius: 10);
                }),
          ),
        ]);
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
        //  filePath: file,
        token: _profileData[0].authorizationToken,
        folderName: "SOLVED GRADED+",
        refreshtoken: _profileData[0].refreshToken));
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
                    height: Globals.deviceType == 'phone'
                        ? null
                        : orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.height / 15
                            : MediaQuery.of(context).size.width / 15,
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
                        onPressed: () {
                          //Globals.iscameraPopup = false;
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
                          //Globals.iscameraPopup = false;
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (_) => false);
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

  // Future<String?> _getProfileUrl() async {
  //   List<UserInformation> _userprofilelocalData = await getUserProfile();
  //   return _userprofilelocalData[0].profilePicture!;
  // }

  Future<UserInformation> getUserProfile() async {
    LocalDatabase<UserInformation> _localDb = LocalDatabase('user_profile');
    List<UserInformation> _userInformation = await _localDb.getData();
    print("printing _userInformation length : ${_userInformation[0]}");
    return _userInformation[0];
  }

  void _showPopUp(UserInformation userInformation) {
    showCupertinoModalPopup(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          // RenderBox renderBox = (widget.key as GlobalKey)
          //     .currentContext
          //     .findAncestorRenderObjectOfType() as RenderBox;
          // Offset position = renderBox.localToGlobal(Offset.zero);
          return Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Positioned(
                  right: 10,
                  left: 0,
                  top: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? MediaQuery.of(context).size.width / 10
                      : MediaQuery.of(context).size.height / 10,
                  child: Container(
                      height: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? MediaQuery.of(context).size.height / 2
                          : MediaQuery.of(context).size.height / 4.5,
                      // height: 500,
                      //  width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.height / 60,
                          vertical: MediaQuery.of(context).size.height / 60),
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 1.9),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 8)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                AppTheme.kButtonColor.withOpacity(0.4),
                            radius: 28.0,
                            child: ClipOval(
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 50,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    imageUrl: userInformation.profilePicture!,
                                    placeholder: (context, url) => Center(
                                          child: CupertinoActivityIndicator(),
                                        ))),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            userInformation.userName!.replaceAll("%20", " "),
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                          ),
                          SpacerWidget(
                            3.0,
                          ),
                          Text(userInformation.userEmail!,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(color: Colors.grey.shade500)),
                          SpacerWidget(3.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Sign Out",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.bold)),
                              IconButton(
                                onPressed: () {
                                  UserGoogleProfile.clearUserProfile();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                      (_) => false);
                                },
                                icon: Icon(
                                  Icons.logout,
                                  size: 26,
                                  color: AppTheme.kButtonColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ],
            ),
          );
        });
  }
}
