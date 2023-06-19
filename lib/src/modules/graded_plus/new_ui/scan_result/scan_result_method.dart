import 'package:Soc/src/globals.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScanResultMethods {
/*------------------------------------------------------------------------------------------------*/
/*------------------------------------------getIdFromEmail----------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static String getIdFromEmail(
      {required studentEmailDetails, required standardStudentDetails}) {
    try {
      for (int i = 0; i < standardStudentDetails.length; i++) {
        if (standardStudentDetails[i].email == studentEmailDetails) {
          return standardStudentDetails[i].studentId ?? studentEmailDetails;
        }
      }
      return studentEmailDetails;
    } catch (e) {
      return studentEmailDetails;
    }
  }

/*------------------------------------------------------------------------------------------------*/
/*------------------------------------------getEmailFromId----------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static String getEmailFromId(
      {required String studentIdDetails, required standardStudentDetails}) {
    try {
      for (int i = 0; i < standardStudentDetails.length; i++) {
        if (standardStudentDetails[i].studentId == studentIdDetails) {
          return standardStudentDetails[i].email ?? studentIdDetails;
        }
      }
      return studentIdDetails;
    } catch (e) {
      return studentIdDetails;
    }
  }

/*------------------------------------------------------------------------------------------------*/
/*-----------------------------------------validateStudentId--------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  // Function to validate student id field to show retry and next button
  static bool validateStudentId({required String value, required regex}) {
    return (value.isNotEmpty && Overrides.STANDALONE_GRADED_APP == true
        ? (regex.hasMatch(value))
        : (Utility.checkForInt(value)
            ? (value.length == 9 && ((value[0] == '2' || value[0] == '1')))
            : (regex.hasMatch(value))));
  }

/*------------------------------------------------------------------------------------------------*/
/*----------------------------------------animatedArrowWidget-------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static Widget animatedArrowWidget({required context, required animation}) {
    // print(_animation);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          transform: Matrix4.translationValues(0, animation.value * 5, 0),
          child: SvgPicture.asset(
            Strings.keyArrowSvgIconPath,
            fit: BoxFit.contain,
            width: Globals.deviceType == "phone" ? 28 : 50,
            height: Globals.deviceType == "phone" ? 28 : 50,
          ),
        ),
        Utility.textWidget(
            textAlign: TextAlign.center,
            text: "Key",
            context: context,
            textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primaryVariant)),
      ],
    );
  }
}
