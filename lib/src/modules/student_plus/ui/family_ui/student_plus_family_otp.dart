import 'package:Soc/src/modules/graded_plus/widgets/common_fab.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/family_login_common_widget.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/family_login_success.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/shake_widget.dart';
import 'package:Soc/src/modules/student_plus/widgets/timer_animated_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentPlusFamilyOtp extends StatefulWidget {
  final String emailId;
  const StudentPlusFamilyOtp({Key? key, required this.emailId})
      : super(key: key);

  @override
  State<StudentPlusFamilyOtp> createState() => _StudentPlusFamilyOtpState();
}

class _StudentPlusFamilyOtpState extends State<StudentPlusFamilyOtp>
    with TickerProviderStateMixin {
  TextEditingController emailEditingController = TextEditingController();

  int _counter = 0;
  final otpFieldKeys =
      List.generate(6, (index) => GlobalKey<FormFieldState<String>>());

  AnimationController? _controller;

  int levelClock = 60;
  StudentPlusBloc studentPlusBloc = StudentPlusBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the application

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
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: FamilyLoginCommonWidget.familyLoginAppBar(
              context: context, isBackButton: true),
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
                ShakeWidget(child: otpWidget()),
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
        familyLoginBlocListener()
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
          onTap: () {
            if (_controller!.duration == Duration(seconds: 0)) {
              studentPlusBloc.add(SendOtpFamilyLogin(emailId: widget.emailId));
            }
          },
          child: Utility.textWidget(
              textAlign: TextAlign.center,
              text: " Resend Code",
              context: context,
              textTheme: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: _controller!.duration != Duration(seconds: 0)
                        ? Colors.grey
                        : Theme.of(context).colorScheme.secondary,
                  )),
        ),
      ],
    );
  }

  Widget otpWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildOtpField(0),
        SizedBox(width: 16.0),
        _buildOtpField(1),
        SizedBox(width: 16.0),
        _buildOtpField(2),
        SizedBox(width: 16.0),
        _buildOtpField(3),
        SizedBox(width: 16.0),
        _buildOtpField(4),
        SizedBox(width: 16.0),
        _buildOtpField(5),
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
        _verifyOtp();
      },
    );
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 40.0,
      child: Center(
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          key: otpFieldKeys[index],
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
          validator: (value) {
            if (value!.isEmpty) {
              return '';
            }
            return null;
          },
        ),
      ),
    );
  }

  /* ------------------------- bloc listener widget to manage family login ------------------------- */

  Widget familyLoginBlocListener() {
    return BlocListener(
      bloc: studentPlusBloc,
      child: Container(),
      listener: (context, state) {
        if (state is FamilyLoginOtpVerifySuccess) {
          Utility.showSnackBar(
              _scaffoldKey, "Otp Verify Successfully", context, null);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StudentPlusFamilyLogInSuccess(
                      token: state.authToken ?? '',
                      email: widget.emailId,
                    )),
          );
        } else if (state is FamilyLoginOtpVerifyFailure) {
          Utility.showSnackBar(
              _scaffoldKey, "Please Enter Valid Otp", context, null);
          Navigator.pop(context);
        } else if (state is FamilyLoginErrorReceived) {
          Utility.showSnackBar(
              _scaffoldKey, "Something Went Wrong", context, null);
          Navigator.pop(context);
        } else if (state is FamilyLoginLoading) {
          Utility.showLoadingDialog(
              context: context, msg: 'Please wait', isOCR: false);
        } else if (state is FamilyLoginOtpSendSuccess) {
          Utility.showSnackBar(
              _scaffoldKey, "Otp Resend Send Successfully", context, null);
          Navigator.pop(context);
        }
      },
    );
  }

  void _verifyOtp() {
    String enteredOtp = otp.join();
    if (_isOtpValid()) {
      studentPlusBloc
          .add(VerifyOtpFamilyLogin(emailId: widget.emailId, otp: enteredOtp));
    }
    print('Entered OTP: $enteredOtp');
  }

  List<String> otp = List.filled(6, '');

  void _onOtpChanged(int index, String value) {
    if (value == '') {
      FocusScope.of(context).previousFocus();
    } else if (value.length == 1) {
      otp[index] = value;
      if (index < otp.length - 1) {
        FocusScope.of(context).nextFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  bool _isOtpValid() {
    bool isValid = true;
    for (int i = 0; i < otp.length; i++) {
      final field = otpFieldKeys[i].currentState;
      if (field != null && !field.validate()) {
        isValid = false;
      }
    }
    return isValid;
  }
}
