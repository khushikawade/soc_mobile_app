import 'dart:ui';
import 'package:Soc/src/modules/google_classroom/ui/graded_standalone_landing_page.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/graded_plus/widgets/Common_popup.dart';
import 'package:Soc/src/modules/graded_plus/widgets/warning_popup_model.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../globals.dart';
import '../../../styles/theme.dart';
import '../../google_classroom/modal/google_classroom_list.dart';
import '../../../services/user_profile.dart';
import '../../home/ui/home.dart';
import '../modal/student_assessment_info_modal.dart';

class CustomDialogBox extends StatefulWidget {
  final UserInformation? profileData;
  final bool? isUserInfoPop;
  final VoidCallback? onSignOut;
  final StudentAssessmentInfo? studentAssessmentInfo;
  final String? title;
  final double? height;
  final double? width;
  final bool? isMcqSheet;
  final String? activityType;
  const CustomDialogBox(
      {Key? key,
      this.isMcqSheet,
      this.profileData,
      this.onSignOut,
      required this.isUserInfoPop,
      this.studentAssessmentInfo,
      this.title,
      this.height,
      this.width,
      required this.activityType})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;
  // DateTime currentDateTime = DateTime.now(); //DateTime
  //   final OcrBloc _ocrBlocLogs = new OcrBloc();

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    scaleAnimation = CurvedAnimation(
      parent: controller!,
      curve: Curves.bounceInOut,
    );

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Dialog(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: ScaleTransition(
              scale: scaleAnimation!,
              child: contentBox(context),
            )));
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
            height: widget.height != null
                ? widget.height
                : Globals.deviceType == 'phone'
                    ? MediaQuery.of(context).size.height * 0.28
                    : MediaQuery.of(context).size.height * 0.22,
            width: widget.width != null
                ? widget.width
                : Globals.deviceType == 'phone'
                    ? MediaQuery.of(context).size.width * 0.8
                    : MediaQuery.of(context).size.width * 0.5,
            padding: EdgeInsets.only(
                left: 20,
                top: widget.isUserInfoPop == true ? 45 + 20 : 30,
                right: 20,
                bottom: 20),
            margin: EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xff000000) != Theme.of(context).backgroundColor
                    ? Color(0xffF7F8F9)
                    : Color(0xff111C20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.fromRGBO(0, 149, 205, 1),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: widget.isUserInfoPop == true
                ? Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SizedBox(
                      height: Globals.deviceType == 'phone' ? 2 : 10,
                    ),
                    FittedBox(
                      child: Utility.textWidget(
                        context: context,
                        text: widget.profileData!.userName!
                            .replaceAll("%20", " "),
                        textTheme:
                            Theme.of(context).textTheme.headline1!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000) ==
                                          Theme.of(context).backgroundColor
                                      ? Color(0xffFFFFFF)
                                      : Color(0xff000000),
                                ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: Utility.textWidget(
                          context: context,
                          text: widget.profileData!.userEmail!,
                          textTheme:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.grey.shade500,
                                  )),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: Globals.deviceType == 'phone'
                          ? MediaQuery.of(context).size.width * 0.35
                          : MediaQuery.of(context).size.width * 0.25,
                      child: ElevatedButton(
                        child: FittedBox(
                            child: Utility.textWidget(
                                context: context,
                                text: 'Sign Out',
                                textTheme: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontSize: Globals.deviceType == 'phone'
                                          ? 18
                                          : 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000) ==
                                              Theme.of(context).backgroundColor
                                          ? Color(0xffFFFFFF)
                                          : Color(0xff000000),
                                    ))),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            primary: AppTheme.kSelectedColor),
                        onPressed: () {
                          // if (widget.onSignOut != null) {
                          //   widget.onSignOut!();
                          //   return;
                          // }
                          // WarningPopupModel();
                          // UserGoogleProfile.clearUserProfile();
                          // GoogleClassroom.clearClassroomCourses();
                          // Utility.updateLogs(
                          //     activityType: widget.activityType,
                          //     activityId: '3',
                          //     description: 'User profile logout',
                          //     operationResult: 'Success');
                          // // If app is running as the standalone Graded+ app, it should navigate to the Graded+ landing page.
                          // if (Overrides.STANDALONE_GRADED_APP) {
                          //   Navigator.of(context).pushAndRemoveUntil(
                          //       MaterialPageRoute(
                          //           builder: (context) => GradedLandingPage(
                          //                 isFromLogoutPage: true,
                          //               )),
                          //       (_) => false);
                          // } else {
                          //   // If app is running as the regular school app, it should navigate to the Home page(Staff section).
                          //   Navigator.of(context)
                          //       .popUntil((route) => route.isFirst);
                          // }
                        },
                      ),
                    ),
                  ])
                : studentInfoWidget(
                    studentAssessmentInfo: widget.studentAssessmentInfo!)),
        // if (widget.isUserInfoPop == true)
        widget.isUserInfoPop == true
            ? Positioned(
                left: 20,
                right: 20,
                child: CircleAvatar(
                  backgroundColor: AppTheme.kSelectedColor,
                  radius: 52,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(80),
                      ),
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageUrl: widget.profileData!.profilePicture!,
                          placeholder: (context, url) => Center(
                                child: CupertinoActivityIndicator(),
                              )),
                    ),
                  ),
                ),
              )
            : Positioned(
                right: 10,
                top: 60,
                // left: 20,
                // right: 20,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Icon(
                    Icons.clear,
                    color: AppTheme.kButtonColor,
                    size: Globals.deviceType == "phone" ? 28 : 36,
                  ),
                ),
              ),
      ],
    );
  }

  Widget studentInfoWidget(
      {required StudentAssessmentInfo studentAssessmentInfo}) {
    return Container(
      child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        FittedBox(
          child: Utility.textWidget(
              text: widget.title!,
              context: context,
              maxLines: 2,
              textAlign: TextAlign.center,
              textTheme: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        FittedBox(
          child: Utility.textWidget(
              text: widget.isMcqSheet == true
                  ? 'Multiple Choice'
                  : 'Constructed Response',
              context: context,
              maxLines: 2,
              textAlign: TextAlign.center,
              textTheme: Theme.of(context).textTheme.headline3!),
        ),
        Expanded(
          child: ListView(physics: BouncingScrollPhysics(), children: <Widget>[
            // _headingWidget(
            //     title: 'Assessment Type',
            //     value: widget.isMcqSheet == true
            //         ? 'Multiple Choice'
            //         : 'Constructed Response'),
            _headingWidget(
                title: 'Subject',
                value: studentAssessmentInfo.subject ?? 'Subject'),
            _headingWidget(
                title: 'Grade', value: studentAssessmentInfo.grade ?? 'Grade'),
            _headingWidget(
                title: 'Class',
                value: studentAssessmentInfo.className ?? 'Class'),
            _headingWidget(
                title: 'Domain',
                value: studentAssessmentInfo.learningStandard ?? 'Domain'),
            _headingWidget(
                title: 'Sub-Domain',
                value:
                    studentAssessmentInfo.subLearningStandard ?? 'Sub-Domain'),
          ]),
        )
      ]),
    );
    // ]);
  }

  Widget _headingWidget({required String title, required String value}) {
    return Container(
      child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utility.textWidget(
                  text: title,
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontWeight: FontWeight.bold)),
              Utility.textWidget(
                  text: value,
                  context: context,
                  textAlign: TextAlign.left,
                  textTheme: Theme.of(context).textTheme.headline2!),
            ],
          )),
    );
  }
}
