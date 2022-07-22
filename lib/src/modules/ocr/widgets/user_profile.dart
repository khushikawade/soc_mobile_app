import 'dart:ui';

import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/ocr/widgets/warning_popup_model.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../globals.dart';
import '../../../styles/theme.dart';
import '../../../translator/translation_widget.dart';
import '../../google_drive/model/user_profile.dart';
import '../../home/ui/home.dart';

class CustomDialogBox extends StatefulWidget {
  final UserInformation? profileData;

  const CustomDialogBox({Key? key, this.profileData}) : super(key: key);

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
            elevation: 5,
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
          height: Globals.deviceType == 'phone'
              ? MediaQuery.of(context).size.height * 0.24
              : MediaQuery.of(context).size.height * 0.22,
          width: Globals.deviceType == 'phone'
              ? MediaQuery.of(context).size.width * 0.8
              : MediaQuery.of(context).size.width * 0.5,
          padding:
              EdgeInsets.only(left: 20, top: 45 + 20, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color(0xff000000) != Theme.of(context).backgroundColor
                  ? Color(0xffF7F8F9)
                  : Color(0xff111C20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.kSelectedColor,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: Globals.deviceType == 'phone' ? 2 : 10,
              ),
              FittedBox(
                child: Utility.textWidget(
                  context: context,
                  text: widget.profileData!.userName!.replaceAll("%20", " "),
                  textTheme: Theme.of(context).textTheme.headline1!.copyWith(
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
                    textTheme: Theme.of(context).textTheme.subtitle1!.copyWith(
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
                  child: TranslationWidget(
                      message: "Sign Out",
                      fromLanguage: "en",
                      toLanguage: Globals.selectedLanguage,
                      builder: (translatedMessage) {
                        return Text(translatedMessage.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                  fontSize:
                                      Globals.deviceType == 'phone' ? 18 : 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000) ==
                                          Theme.of(context).backgroundColor
                                      ? Color(0xffFFFFFF)
                                      : Color(0xff000000),
                                ));
                      }),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      primary: AppTheme.kSelectedColor),
                  onPressed: () {
                    WarningPopupModel();
                    UserGoogleProfile.clearUserProfile();
                    Utility.updateLoges(
                        // accountType: 'Free',
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
            ],
          ),
        ),
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
}
