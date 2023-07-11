import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_fab.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/family_login_common_widget.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/student_plus_family_otp.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_home.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class StudentPlusFamilyLogInFailure extends StatefulWidget {
  const StudentPlusFamilyLogInFailure({Key? key}) : super(key: key);

  @override
  State<StudentPlusFamilyLogInFailure> createState() =>
      _StudentPlusFamilyLogInFailureState();
}

class _StudentPlusFamilyLogInFailureState
    extends State<StudentPlusFamilyLogInFailure> {
  TextEditingController emailEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.red.withOpacity(0.2),
          appBar: FamilyLoginCommonWidget.familyLoginAppBar(context: context),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SpacerWidget(MediaQuery.of(context).size.height * 0.1),
                FamilyLoginCommonWidget.titleAndDesWidget(
                  context: context,
                  title: 'Not Verified',
                ),
                SpacerWidget(MediaQuery.of(context).size.height * 0.05),
                FamilyLoginCommonWidget.familyCircularIcon(
                    context: context,
                    assetImageUrl: 'assets/images/failure_lock.png'),
                SpacerWidget(MediaQuery.of(context).size.height * 0.05),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: Utility.textWidget(
                        context: context,
                        textAlign: TextAlign.center,
                        text:
                            'Uh oh! We couldn\'t verify the provided email address. You can try again with another email address.',
                        textTheme: Theme.of(context).textTheme.headline3),
                  ),
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

  /* ------------------------ Widget to get student email (Text form field) ----------------------- */
  Widget textFormFieldWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        autofocus: false,
        style: Theme.of(context).textTheme.headline3,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: emailEditingController,
        cursorColor: Theme.of(context).colorScheme.primaryVariant,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: AppTheme.kButtonColor, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            hintStyle: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontWeight: FontWeight.w300, color: Colors.grey),
            hintText: 'Email',
            fillColor: Color(0xff000000) != Theme.of(context).backgroundColor
                ? Theme.of(context).colorScheme.secondary
                : Color.fromARGB(255, 12, 20, 23),
            //Theme.of(context).colorScheme.secondary,

            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.email,
                size: 26,
                color: AppTheme.kButtonColor,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                emailEditingController.clear();
              },
              icon: Icon(
                Icons.clear,
                color: Theme.of(context).colorScheme.primaryVariant,
                size: Globals.deviceType == "phone" ? 20 : 28,
              ),
            ),
            prefix: SizedBox(
              width: 20,
            )),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!isValidEmail(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
        onChanged: (value) {},
      ),
    );
  }

  /* ----------------------------- widget to show generate otp button ----------------------------- */
  Widget fabButton() {
    return GradedPlusCustomFloatingActionButton(
      isExtended: true,
      fabWidth: MediaQuery.of(context).size.width * 0.7,
      title: 'Try Again',
      onPressed: () async {
        pushNewScreen(
          context,
          screen: StudentPlusHome(
            sectionType: "Family",
            studentPlusStudentInfo: StudentPlusDetailsModel(),
            index: 0,
          ),
          withNavBar: false,
        );
      },
    );
  }

  static bool isValidEmail(String value) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(value);
  }
}
