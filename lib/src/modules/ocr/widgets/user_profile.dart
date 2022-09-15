import 'dart:ui';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/ocr/widgets/warning_popup_model.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../globals.dart';
import '../../../styles/theme.dart';
import '../../google_drive/model/user_profile.dart';
import '../../home/ui/home.dart';
import '../modal/student_assessment_info_modal.dart';

class CustomDialogBox extends StatefulWidget {
  final UserInformation? profileData;
  final bool? isUserInfoPop;
  final StudentAssessmentInfo? studentAssessmentInfo;
  final String? title;
  final double? height;
  final double? width;
  const CustomDialogBox(
      {Key? key,
      this.profileData,
      required this.isUserInfoPop,
      this.studentAssessmentInfo,
      this.title,
      this.height,
      this.width})
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
                          WarningPopupModel();
                          UserGoogleProfile.clearUserProfile();
                          Utility.updateLoges(
                              // ,
                              activityId: '3',
                              description: 'User profile logout',
                              operationResult: 'Success');

                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        isFromOcrSection: true,
                                      )),
                              (_) => false);
                          //Globals.iscameraPopup = false;
                        },
                      ),
                    ),
                  ])
                : studentInfoWidget(
                    studentAssessmentInfo: widget.studentAssessmentInfo!)),
        if (widget.isUserInfoPop == true)
          Positioned(
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
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl: widget.profileData!.profilePicture!,
                      placeholder: (context, url) => Center(
                            child: CupertinoActivityIndicator(),
                          )),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget studentInfoWidget(
      {required StudentAssessmentInfo studentAssessmentInfo}) {
    return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Utility.textWidget(
          text: widget.title!,
          context: context,
          maxLines: 2,
          textAlign: TextAlign.center,
          textTheme: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
      Expanded(
        child: ListView(children: <Widget>[
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
              value: studentAssessmentInfo.subLearningStandard ?? 'Sub-Domain'),
        ]),
      )
    ]);
    // ]);
  }

  Widget _headingWidget({required String title, required String value}) {
    return ListTile(
      title: Utility.textWidget(
          text: title,
          context: context,
          textTheme: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(fontWeight: FontWeight.bold)),
      subtitle: Utility.textWidget(
          text: value,
          context: context,
          textAlign: TextAlign.left,
          textTheme: Theme.of(context).textTheme.headline2!),
    );
  }
}
