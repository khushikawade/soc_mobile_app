import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_fab.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/family_login_common_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class StudentPlusFamilyLogIn extends StatefulWidget {
  const StudentPlusFamilyLogIn({Key? key}) : super(key: key);

  @override
  State<StudentPlusFamilyLogIn> createState() => _StudentPlusFamilyLogInState();
}

class _StudentPlusFamilyLogInState extends State<StudentPlusFamilyLogIn> {
  TextEditingController emailEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                IconData(0xe80d,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: AppTheme.kButtonColor,
              ),
              onPressed: () {},
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SpacerWidget(MediaQuery.of(context).size.height * 0.1),
                FamilyLoginCommonWidget.titleAndDesWidget(
                    context: context,
                    title: 'Email',
                    description:
                        'Enter your email below to receive a one-time password.'),
                SpacerWidget(MediaQuery.of(context).size.height * 0.1),
                FamilyLoginCommonWidget.familyCircularIcon(
                    context: context,
                    assetImageUrl: 'assets/images/login_lock.png'),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Utility.textWidget(
                      context: context,
                      text: 'Enter your email',
                      textTheme: Theme.of(context).textTheme.headline3),
                ),
                SpacerWidget(20),
                textFormFieldWidget(),
                SpacerWidget(10),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: fabButton())
              ],
            ),
          ),
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
      title: 'Generate OTP',
      onPressed: () async {},
    );
  }

  static bool isValidEmail(String value) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(value);
  }
}
