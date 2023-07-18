import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class StudentPlusCommonBottomSheet {
  /* --------------------------------------------------------------------*/
  /*                    Function to show bottom Sheet                    */
  /* --------------------------------------------------------------------*/

  static showBottomSheet(
      {required double kLabelSpacing,
      required BuildContext context,
      required String text,
      required String title}) {
    showModalBottomSheet(
        //  transitionAnimationController:AnimationController(animationBehavior: AnimationBehavior.preserve) ,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        elevation: 20,
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              //  padding: EdgeInsets.only(bottom: 100),
              decoration: BoxDecoration(
                  color: Color(0xff000000) != Theme.of(context).backgroundColor
                      ? Color(0xffF7F8F9)
                      : Color(0xff111C20),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              height: Globals.deviceType == 'phone'
                  ? MediaQuery.of(context).size.width / 2 + 50
                  : MediaQuery.of(context).size.width / 3,
              // ? MediaQuery.of(context).size.height * 0.35
              // : MediaQuery.of(context).size.height * 0.25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    padding: EdgeInsets.only(top: 16, right: 16),
                    onPressed: () {
                      Navigator.pop(context);
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    icon: Icon(
                      Icons.clear,
                      color: AppTheme.kButtonColor,
                      size: Globals.deviceType == "phone" ? 28 : 36,
                    ),
                  ),
                  SizedBox(
                    height: kLabelSpacing * 0.5,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Utility.textWidget(
                          text: title,
                          context: context,
                          textTheme: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                    ),
                  ),
                  SizedBox(
                    height: kLabelSpacing,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Utility.textWidget(
                          text: text,
                          context: context,
                          textTheme: Theme.of(context).textTheme.headline2,
                          textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
