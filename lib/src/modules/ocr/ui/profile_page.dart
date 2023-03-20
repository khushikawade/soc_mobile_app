import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/ocr/ui/state_selection_page.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/modules/setting/information.dart';
import 'package:Soc/src/modules/setting/setting.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final bool? hideStateSelection;
  final UserInformation profile;

  const ProfilePage({Key? key, required this.profile, this.hideStateSelection})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int counter = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAnalyticsService.addCustomAnalyticsEvent("Profile_page");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'Profile_page', screenClass: 'ProfilePage');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackGroundImgWidget(),
        Scaffold(
          // key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: CustomOcrAppBarWidget(
            isSuccessState: ValueNotifier<bool>(true),
            isBackOnSuccess: isBackFromCamera,
            key: GlobalKey(),
            isBackButton: true,
            isProfilePage: true,
          ),
          body: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.30,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.64,

                  //  height: double.infinity,
                  decoration: BoxDecoration(
                      //boxShadow: [BoxShadow(color: Colors.white54)],
                      color: Color(0xff000000) !=
                              Theme.of(context).backgroundColor
                          ? Color.fromARGB(236, 178, 179, 183).withOpacity(0.1)
                          : Color(0xff1f2f34).withOpacity(0.5),

                      // border: Border.all(
                      //   color: Colors.black,
                      // ),

                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SpacerWidget(20),
                        Utility.textWidget(
                            text: "Details",
                            context: context,
                            textTheme: Theme.of(context).textTheme.headline1),
                        Divider(
                          height: 5,
                          color: Color(0xff000000) ==
                                  Theme.of(context).backgroundColor
                              ? Color.fromARGB(255, 203, 204, 206)
                                  .withOpacity(0.5)
                              : Color(0xff1f2f34).withOpacity(0.5),
                        ),
                        listTile(
                            icon: Icons.info_outline,
                            onTap: () async {
                              Globals.appSetting.appInformationC != null
                                  ? await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InformationPage(
                                                appbarTitle: 'Information',
                                                isBottomSheet: true,
                                                ishtml: true,
                                              )))
                                  : Utility.currentScreenSnackBar(
                                      'No Information Available', null);
                            },
                            title: 'Information'),
                        Divider(
                          height: 5,
                          color: Color(0xff000000) ==
                                  Theme.of(context).backgroundColor
                              ? Color.fromARGB(255, 203, 204, 206)
                                  .withOpacity(0.5)
                              : Color(0xff1f2f34).withOpacity(0.5),
                        ),
                        listTile(
                            icon: Icons.settings,
                            onTap: () async {
                              String settingsSectionLogMsg =
                                  "Navigate From Graded+ Profile to Settings";
                              FirebaseAnalyticsService.addCustomAnalyticsEvent(
                                  settingsSectionLogMsg
                                          .toLowerCase()
                                          .replaceAll(" ", "_") ??
                                      '');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingPage(
                                            appbarTitle: 'Settings',
                                            isBottomSheet: true,
                                          )));
                            },
                            title: 'Settings'),
                        Divider(
                          height: 5,
                          color: Color(0xff000000) ==
                                  Theme.of(context).backgroundColor
                              ? Color.fromARGB(255, 203, 204, 206)
                                  .withOpacity(0.5)
                              : Color(0xff1f2f34).withOpacity(0.5),

                          // Colors.grey[300],
                        ),
                        widget.hideStateSelection == true ||
                                !Overrides.STANDALONE_GRADED_APP
                            ? Container()
                            : listTile(
                                icon: Icons.location_pin,
                                onTap: () async {
                                  String stateSelectionLogMsg =
                                      "Navigate From Graded+ Profile to State selection";
                                  FirebaseAnalyticsService
                                      .addCustomAnalyticsEvent(
                                          stateSelectionLogMsg
                                                  .toLowerCase()
                                                  .replaceAll(" ", "_") ??
                                              '');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StateSelectionPage(
                                                isFromCreateAssessmentScreen:
                                                    false,
                                                questionImageUrl: '',
                                                selectedClass: '',
                                              )));
                                },
                                title: 'States'),
                        widget.hideStateSelection == true ||
                                !Overrides.STANDALONE_GRADED_APP
                            ? Container()
                            : Divider(
                                height: 5,
                                color: Color(0xff000000) ==
                                        Theme.of(context).backgroundColor
                                    ? Color.fromARGB(255, 203, 204, 206)
                                        .withOpacity(0.5)
                                    : Color(0xff1f2f34).withOpacity(0.5),

                                // Colors.grey[300],
                              ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.045,
            left: 20.0,
            right: 20.0,
            child: Container(
              width: double.infinity,
              child: Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(widget.profile.profilePicture!),
                  backgroundColor: Colors.white,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(widget.profile.userName!.replaceAll("%20", " "),
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontWeight: FontWeight.bold)),
                SpacerWidget(12),
                Text(widget.profile.userEmail!,
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.grey)),
              ]),
            ))
      ],
    );
  }

  Widget listTile(
      {required Function() onTap,
      required String title,
      required IconData icon}) {
    return ListTile(
        leading: Icon(
          icon,
          color: AppTheme.kButtonColor,
          size: 30,
        ),
        title: Utility.textWidget(
            text: title,
            context: context,
            textTheme: Theme.of(context).textTheme.headline2),
        onTap: onTap);
  }
}
