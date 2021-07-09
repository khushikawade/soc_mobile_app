import 'dart:async';
import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/modules/home/ui/home.dart';
import 'package:app/src/modules/user/bloc/user_bloc.dart';
import 'package:app/src/overrides.dart';
import 'package:app/src/services/custom_flutter_icons.dart';
import 'package:app/src/services/utility.dart';
import 'package:app/src/widgets/app_bar.dart';
import 'package:app/src/widgets/common_button_widget.dart';
import 'package:app/src/widgets/cutombutton.dart';
import 'package:app/src/widgets/divider.dart';
import 'package:app/src/widgets/inapp_url_launcher.dart';
import 'package:app/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../styles/theme.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const double _kLabelverticalSpacing = 12.0;
  static const double _kLabelhoriztonalSpacing = 16.0;
  static const double _kIconSize = 100;
  static const double _kButtonSize = 50;

  bool? value = false;
  FocusNode myFocusNode = new FocusNode();
  final TextStyle heading1 = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Bold",
    fontSize: 16,
    color: Color(0xff0059D6),
  );

  final TextStyle heading2 = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Medium",
    fontSize: 22,
    color: Color(0xffFF690B),
  );

  final TextStyle KlabelStyle = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Medium",
    fontSize: 13,
    color: Color(0xff474D55),
  );

  final TextStyle lable2 = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Regular",
    fontSize: 12,
    color: Color(0xffBCC5D4),
  );

  final TextStyle lable3 = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Regular",
    fontSize: 12,
    color: Color(0xff0059D6),
  );
  final TextStyle lable4 = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Regular",
    fontSize: 13,
    color: Color(0xff0059D6),
  );

  Widget _buildlogo() {
    return Container(
        child: Image.asset(
      'assets/images/Nyc_logo.png',
      fit: BoxFit.fill,
      height: _kIconSize / 3,
      width: _kIconSize * 1.75,
    ));
  }

  Widget _buildDivider() {
    return DividerWidget(0);
  }

  Widget _buildHeading1() {
    return Row(
      children: [
        Text(
          "NYC Schools Account",
          style: heading1,
        ),
      ],
    );
  }

  Widget _buildHeading2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcom Nyc Parent",
          style: heading2,
        ),
        Text(
          "or Guardian!",
          style: heading2,
        ),
      ],
    );
  }

  Widget _buildlabel(String label) {
    return Row(
      children: [
        Text(
          label,
          style: KlabelStyle,
        ),
      ],
    );
  }

  Widget _buildEmailfield() {
    return TextFormField(
      focusNode: myFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordfield() {
    return TextFormField(
      focusNode: myFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildcheckbox() {
    return SizedBox(
      height: 24,
      width: 24,
      child: Checkbox(
        value: this.value,
        onChanged: (bool? value) {
          setState(() {
            this.value = value;
          });
        },
      ),
    ); //
  }

  Widget _buildPrivacywidget() {
    return Row(
      children: <Widget>[
        _buildcheckbox(),
        Text(
          "I have read and agree to the ",
          style: lable2,
        ),
        Text(
          "privacy policy",
          style: lable3,
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
        height: _kButtonSize,
        child: Custombuttom(
          'SIGN IN',
          Color(0xff548952),
          _kButtonSize,
        ));
  }

  Widget _buildCreateAccountbutton() {
    return SizedBox(
        height: _kButtonSize,
        child: Custombuttom(
          'CREATE ACCOUNT',
          Color(0xff882737),
          _kButtonSize,
        ));
  }

  Widget _buildForgetPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Forgot your password?",
          style: lable4,
        ),
      ],
    );
  }

  Widget _buildLearnMore() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Learn More",
          style: lable4,
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: _kLabelhoriztonalSpacing,
              vertical: _kLabelverticalSpacing / 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildlogo(),
              SpacerWidget(_kLabelverticalSpacing),
              _buildDivider(),
              SpacerWidget(_kLabelverticalSpacing),
              _buildHeading1(),
              SpacerWidget(_kLabelverticalSpacing * 2),
              _buildHeading2(),
              SpacerWidget(_kLabelverticalSpacing * 1.5),
              _buildlabel("Email"),
              SpacerWidget(_kLabelverticalSpacing / 2),
              _buildEmailfield(),
              SpacerWidget(_kLabelverticalSpacing),
              _buildlabel("Password"),
              SpacerWidget(_kLabelverticalSpacing / 2),
              _buildPasswordfield(),
              SpacerWidget(_kLabelverticalSpacing),
              _buildPrivacywidget(),
              SpacerWidget(_kLabelverticalSpacing * 3),
              _buildSignInButton(),
              SpacerWidget(_kLabelverticalSpacing),
              _buildForgetPassword(),
              SpacerWidget(_kLabelverticalSpacing * 1.5),
              _buildCreateAccountbutton(),
              SpacerWidget(_kLabelverticalSpacing / 2),
              _buildLearnMore(),
            ],
          ),
        ),
      ),
    );
  }
}
