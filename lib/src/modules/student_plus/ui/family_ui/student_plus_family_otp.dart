import 'package:Soc/src/globals.dart';

import 'package:Soc/src/modules/graded_plus/widgets/common_fab.dart';

import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';

import 'package:Soc/src/modules/student_plus/ui/family_ui/family_login_common_widget.dart';

import 'package:Soc/src/modules/student_plus/ui/family_ui/family_login_success.dart';

import 'package:Soc/src/modules/student_plus/widgets/timer_animated_widget.dart';

import 'package:Soc/src/overrides.dart';

import 'package:Soc/src/services/utility.dart';

import 'package:Soc/src/styles/theme.dart';

import 'package:Soc/src/widgets/spacer_widget.dart';

import 'package:flutter/material.dart';

class StudentPlusFamilyOtp extends StatefulWidget {
  const StudentPlusFamilyOtp({Key? key}) : super(key: key);

  @override
  State<StudentPlusFamilyOtp> createState() => _StudentPlusFamilyOtpState();
}

class _StudentPlusFamilyOtpState extends State<StudentPlusFamilyOtp>
    with TickerProviderStateMixin {
  TextEditingController emailEditingController = TextEditingController();

  int _counter = 0;

  AnimationController? _controller;

  int levelClock = 60;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation

        );

    _controller!.forward();

    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: FamilyLoginCommonWidget.familyLoginAppBar(context: context),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SpacerWidget(MediaQuery.of(context).size.height * 0.06),

                FamilyLoginCommonWidget.titleAndDesWidget(
                    context: context,
                    title: 'Enter Your Passcode',
                    description:
                        'Enter the one-time password we just sent to your email address.'),

                SpacerWidget(MediaQuery.of(context).size.height * 0.07),

                FamilyLoginCommonWidget.familyCircularIcon(
                    context: context,
                    assetImageUrl: 'assets/images/otp_lock.png'),

                SpacerWidget(20),

                otpWidget(),

                SpacerWidget(30),

                timerWidget(),

                SpacerWidget(10),

                reSendButtonTextWidget(),

                SpacerWidget(30),

                // Container(

                //     margin: EdgeInsets.symmetric(horizontal: 20),

                //     child: fabButton())
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

  Widget reSendButtonTextWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Utility.textWidget(
            textAlign: TextAlign.center,
            text: "Didn’t receive code?",
            context: context,
            textTheme: Theme.of(context).textTheme.subtitle1),
        InkWell(
          onTap: () {},
          child: Utility.textWidget(
              textAlign: TextAlign.center,
              text: " Resend Code",
              context: context,
              textTheme: Theme.of(context).textTheme.subtitle1),
        ),
      ],
    );
  }

  Widget otpWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildOtpField(otpFieldKey1, 0),
        SizedBox(width: 16.0),
        _buildOtpField(otpFieldKey2, 1),
        SizedBox(width: 16.0),
        _buildOtpField(otpFieldKey3, 2),
        SizedBox(width: 16.0),
        _buildOtpField(otpFieldKey4, 3),
      ],
    );
  }

  Widget timerWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Utility.textWidget(
            textAlign: TextAlign.center,
            text: "Code expires in :  ",
            context: context,
            textTheme: Theme.of(context).textTheme.subtitle1),
        Countdown(
          animation: StepTween(
            begin: levelClock, // THIS IS A USER ENTERED NUMBER

            end: 0,
          ).animate(_controller!),
        ),
      ],
    );
  }

  /* ----------------------------- widget to show generate otp button ----------------------------- */

  Widget fabButton() {
    return GradedPlusCustomFloatingActionButton(
      isExtended: true,
      fabWidth: MediaQuery.of(context).size.width * 0.7,
      title: 'Verify Passcode',
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentPlusFamilyLogInSuccess()),
        );
      },
    );
  }

  Widget _buildOtpField(GlobalKey<FormFieldState<String>> fieldKey, int index) {
    return Container(
      width: 60.0,
      child: Center(
        child: TextFormField(
          key: fieldKey,
          maxLength: 1,
          onChanged: (value) => _onOtpChanged(index, value),
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
          showCursor: true,
          cursorColor: Theme.of(context).colorScheme.primaryVariant,
          decoration: InputDecoration(
              fillColor: Colors.transparent,
              labelStyle: Theme.of(context).textTheme.headline3,
              hintText: '-',
              counterText: "",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.kButtonColor, width: 1),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
              border: new UnderlineInputBorder(
                  borderSide: new BorderSide(color: Colors.red))),
        ),
      ),
    );
  }

  void _verifyOtp() {
    String enteredOtp = otp.join();

    print('Entered OTP: $enteredOtp');
  }

  List<String> otp = List.filled(4, '');

  final otpFieldKey1 = GlobalKey<FormFieldState<String>>();

  final otpFieldKey2 = GlobalKey<FormFieldState<String>>();

  final otpFieldKey3 = GlobalKey<FormFieldState<String>>();

  final otpFieldKey4 = GlobalKey<FormFieldState<String>>();

  void _onOtpChanged(int index, String value) {
    if (value == '') {
      FocusScope.of(context).previousFocus();
    } else if (value.length == 1) {
      if (index < otp.length - 1) {
        FocusScope.of(context).nextFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }
}
