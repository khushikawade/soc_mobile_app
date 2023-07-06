import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_fab.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/family_login_common_widget.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/student_plus_family_login_failure.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/student_plus_family_otp.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class StudentPlusFamilyLogInSuccess extends StatefulWidget {
  const StudentPlusFamilyLogInSuccess({Key? key}) : super(key: key);

  @override
  State<StudentPlusFamilyLogInSuccess> createState() =>
      _StudentPlusFamilyLogInSuccessState();
}

class _StudentPlusFamilyLogInSuccessState
    extends State<StudentPlusFamilyLogInSuccess> {
  TextEditingController emailEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
         appBar: FamilyLoginCommonWidget.familyLoginAppBar(context:context),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SpacerWidget(MediaQuery.of(context).size.height * 0.2),
                FamilyLoginCommonWidget.familyCircularIcon(
                    context: context,
                    assetImageUrl: 'assets/images/success_lock.png'),
                SpacerWidget(MediaQuery.of(context).size.height * 0.05),
                Center(
                  child: Utility.textWidget(
                      context: context,
                      textAlign: TextAlign.center,
                      text: 'Your account has been verified successfully.',
                      textTheme: Theme.of(context).textTheme.headline6),
                ),
                SpacerWidget(MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
          floatingActionButton: fabButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ],
    );
  }

  /* ----------------------------- widget to show generate otp button ----------------------------- */
  Widget fabButton() {
    return GradedPlusCustomFloatingActionButton(
      isExtended: true,
      fabWidth: MediaQuery.of(context).size.width * 0.7,
      title: 'Get Started',
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentPlusFamilyLogInFailure()),
        );
      },
    );
  }
}
