import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_fab.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/family_login_common_widget.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/student_plus_family_otp.dart';

import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentPlusFamilyLogIn extends StatefulWidget {
  const StudentPlusFamilyLogIn({Key? key}) : super(key: key);

  @override
  State<StudentPlusFamilyLogIn> createState() => _StudentPlusFamilyLogInState();
}

class _StudentPlusFamilyLogInState extends State<StudentPlusFamilyLogIn> {
  StudentPlusBloc studentPlusBloc = StudentPlusBloc();
  TextEditingController emailEditingController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final otpFieldKeys =
      List.generate(6, (index) => GlobalKey<FormFieldState<String>>());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: FamilyVerificationCommonWidget.familyLoginAppBar(
              context: context, isBackButton: true),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SpacerWidget(MediaQuery.of(context).size.height * 0.06),
                FamilyVerificationCommonWidget.titleAndDesWidget(
                    context: context,
                    title: 'Email',
                    description:
                        'Enter your email below to receive a one-time password.'),
                SpacerWidget(MediaQuery.of(context).size.height * 0.1),
                FamilyVerificationCommonWidget.familyCircularIcon(
                    context: context,
                    assetImageUrl: 'assets/images/login_lock.png'),
                SpacerWidget(40),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Utility.textWidget(
                      context: context,
                      text: 'Enter your email',
                      textTheme: Theme.of(context).textTheme.headline3),
                ),
                SpacerWidget(20),
                textFormFieldWidget(),
                SpacerWidget(MediaQuery.of(context).viewInsets.bottom / 1.5),
                // SpacerWidget(20),
                // SpacerWidget(MediaQuery.of(context).size.height * 0.05),
                // SpacerWidget(60),
              ],
            ),
          ),
          floatingActionButton: fabButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
        familyLoginBlocListener()
      ],
    );
  }

  /* ------------------------- bloc listener widget to manage family login ------------------------- */

  Widget familyLoginBlocListener() {
    return BlocListener(
      bloc: studentPlusBloc,
      child: Container(),
      listener: (context, state) {
        if (state is FamilyLoginOtpSendSuccess) {
          Utility.showSnackBar(
              _scaffoldKey, "OTP Sent Successfully", context, null);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    StudentPlusFamilyOtp(emailId: emailEditingController.text)),
          );
        } else if (state is FamilyLoginOtpSendFailure) {
          Utility.showSnackBar(
              _scaffoldKey,
              "You are not authorized to access STUDENT+ in Families section",
              context,
              null);
          Navigator.pop(context);
        } else if (state is FamilyLoginErrorReceived) {
          Utility.showSnackBar(
              _scaffoldKey, "Something Went Wrong", context, null);
          Navigator.pop(context);
        } else if (state is FamilyLoginLoading) {
          Utility.showLoadingDialog(
              context: context, msg: 'Please wait', isOCR: false);
        }
      },
    );
  }

  /* ------------------------ Widget to get student email (Text form field) ----------------------- */
  Widget textFormFieldWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: TextFormField(
          scrollPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 240),
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
              suffixIcon: isValidEmail(emailEditingController.text)
                  ? Icon(
                      Icons.check_circle_sharp,
                      color: AppTheme.kButtonColor,
                      size: Globals.deviceType == "phone" ? 20 : 28,
                    )
                  : IconButton(
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
              return 'Please Enter Your Email Address';
            }
            if (!isValidEmail(value)) {
              return 'Please Enter a Valid Email Address';
            }
            return null;
          },
          // onChanged: (value) {
          //   emailEditingController.text = value;
          // },
        ),
      ),
    );
  }

  /* ----------------------------- widget to show generate otp button ----------------------------- */
  Widget fabButton() {
    return GradedPlusCustomFloatingActionButton(
      isExtended: true,
      fabWidth: MediaQuery.of(context).size.width * 0.75,
      title: 'Generate Code',
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          studentPlusBloc
              .add(SendOtpFamilyLogin(emailId: emailEditingController.text));
        }
      },
    );
  }

  static bool isValidEmail(String value) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(value);
  }
}
