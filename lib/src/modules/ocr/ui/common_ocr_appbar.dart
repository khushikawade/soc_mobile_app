import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/ocr/ui/camera_screen.dart';
import 'package:Soc/src/modules/staff/ui/staff.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomOcrAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  CustomOcrAppBarWidget(
      {Key? key,
      required this.isBackButton,
      this.isTitle,
      this.isFailureState,
      this.isResultScreen,
      this.isHomeButtonPopup,
      this.actionIcon})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);
  bool? isFailureState;
  bool? isBackButton;
  bool? isTitle;
  bool? isResultScreen;
  bool? isHomeButtonPopup;
  Widget? actionIcon;

  @override
  final Size preferredSize;

  @override
  _CustomOcrAppBarWidgetState createState() => _CustomOcrAppBarWidgetState();
}

class _CustomOcrAppBarWidgetState extends State<CustomOcrAppBarWidget> {
  double lineProgress = 0.0;
  SharePopUp shareobj = new SharePopUp();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: widget.isFailureState == true ? 200 : null,
      automaticallyImplyLeading: false,
      leading: widget.isFailureState == true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                highlightText(
                    text: 'Scane Failure',
                    theme: Theme.of(context)
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
        Container(
            padding: widget.isFailureState != true
                ? EdgeInsets.only(right: 10)
                : EdgeInsets.zero,
            child: IconButton(
              onPressed: () {
                if (widget.isHomeButtonPopup == true) {
                  _onHomePressed();
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomePage()),
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
            )),
        widget.isFailureState == true || widget.isResultScreen == true
            ? Container(
                padding: widget.isFailureState != true
                    ? EdgeInsets.only(right: 10)
                    : EdgeInsets.zero,
                child: widget.actionIcon!, 
                // IconButton(
                //   onPressed: () {
                //     if (widget.isFailureState == true) {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (_) => CameraScreen()));
                //     } else if (widget.isResultScreen == true) {
                //       onFinishedPopup();
                //     }
                //   },
                //   icon: Icon(
                //     IconData(0xe877,
                //         fontFamily: Overrides.kFontFam,
                //         fontPackage: Overrides.kFontPkg),
                //     size: 30,
                //     color: AppTheme.kButtonColor,
                //   ),
                // ),
              )
            : Container()
      ],
    );
  }

  Widget highlightText({required String text, required theme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Center(
        child: Text(
          translatedMessage.toString(),
          // maxLines: 2,
          //overflow: TextOverflow.ellipsis,
          // textAlign: TextAlign.center,
          style: theme,
        ),
      ),
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
                        message:
                            "you are about to lose scanned assessment sheet",
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) {
                          return Text(translatedMessage.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(color: Colors.black));
                        }),
                  ),
                ),
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
                                        color: AppTheme.kButtonColor,
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

 
}
