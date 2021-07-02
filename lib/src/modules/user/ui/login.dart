import 'dart:async';
import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/modules/home/ui/home.dart';
import 'package:app/src/modules/user/bloc/user_bloc.dart';
import 'package:app/src/overrides.dart';
import 'package:app/src/services/custom_flutter_icons.dart';
import 'package:app/src/services/utility.dart';
import 'package:app/src/widgets/common_button_widget.dart';
import 'package:app/src/widgets/inapp_url_launcher.dart';
import 'package:app/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../styles/theme.dart';

class LoginPage extends StatefulWidget {
  // final String? msg;
  // final bool? isInitial;
  // LoginPage({Key? key, this.msg, this.isInitial}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserBloc _bloc = UserBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();

  final ValueNotifier<int?> _currentFocusedFieldNumber =
      ValueNotifier<int?>(null);

  String? username;
  String? password;
  final focus = FocusNode();
  bool showPassword = false;

  static const double _kLabelSpacing = 8.0;
  FocusNode _usernameFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();

  void initState() {
    super.initState();
    _usernameFocus.addListener(() => _onFocusChange(0, _usernameFocus));
    _passwordFocus.addListener(() => _onFocusChange(1, _passwordFocus));
    _bloc.add(InitLogin());
  }

  void _onFocusChange(i, focusNode) {
    _currentFocusedFieldNumber.value = focusNode.hasFocus ? i : null;
  }

  login() async {
    _bloc.add(PerfomLogin(
      email: username,
      password: password,
    ));
  }

  void _handleSubmitted(String value) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      login();
    }
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _inputLabel(AppTranslations.of(context)!.text('username'), 0),
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(AppTheme.kBorderRadius),
          shadowColor: Colors.white,
          child: TextFormField(
            focusNode: _usernameFocus,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value!.isEmpty
                ? (AppTranslations.of(context)!
                    .text('username_validation_error'))
                : null,
            onSaved: (value) => username = value,
            // style: Theme.of(context).textTheme.caption,
            style: Theme.of(context).textTheme.caption,
            decoration: InputDecoration(
              hintText: AppTranslations.of(context)!.text('username_hint'),
            ),
          ),
        )
      ],
    );
  }

  Widget _inputLabel(label, i) => Column(
        children: [
          ValueListenableBuilder(
            builder: (BuildContext context, int? value, Widget? child) {
              return Row(
                children: <Widget>[
                  Text("$label",
                      style: i == _currentFocusedFieldNumber.value
                          ? Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Theme.of(context).colorScheme.primary)
                          : Theme.of(context).textTheme.subtitle1),
                ],
              );
            },
            valueListenable: _currentFocusedFieldNumber,
            child: Container(),
          ),
          SpacerWidget(_kLabelSpacing),
        ],
      );

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _inputLabel(AppTranslations.of(context)!.text('password'), 1),
        Material(
          borderRadius: BorderRadius.circular(AppTheme.kBorderRadius),
          elevation: 2,
          shadowColor: Colors.white,
          child: TextFormField(
            obscureText: !showPassword,
            focusNode: _passwordFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: _handleSubmitted,
            validator: (value) => value!.isEmpty
                ? (AppTranslations.of(context)!
                    .text('password_validation_error'))
                : null,
            onSaved: (value) => password = value,
            style: Theme.of(context).textTheme.caption,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: showPassword
                      ? Icon(
                          CustomFlutterIcons.eye_show_ico,
                          color: Theme.of(context).primaryColor,
                        )
                      : Icon(
                          CustomFlutterIcons.eye_hide_ico,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  onPressed: () {
                    showPassword = !showPassword;
                    setState(() {});
                  }),
              hintText: AppTranslations.of(context)!.text('password_hint'),
            ),
            obscuringCharacter: "*",
          ),
        )
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(AppTranslations.of(context)!.text('forgot_password'),
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                decoration: TextDecoration.underline,
              )),
    );
  }

  Widget _buildLoginBtn(state) {
    return CommonButtonWidget(
      buttonText: AppTranslations.of(context)!.text('login'),
      isLoading: state is Loading ? true : false,
      onTap: (val) {
        _currentFocusedFieldNumber.value = null;
        Utility.closeKeyboard(context);
        if (state is Loading) {
          print("Already in process...");
        } else {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            login();
          }
        }
      },
    );
  }

  Widget _loginSection(state) => Container(
        child: Column(
          children: <Widget>[
            Container(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 97.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppTranslations.of(context)!.text('login'),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(color: AppTheme.kFontColor1),
                              ),
                            ]),
                      ),
                      SpacerWidget(6),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppTranslations.of(context)!
                                    .text('login_subtitle'),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ]),
                      ),
                      SpacerWidget(28),
                      Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20),
                        child: Form(
                            autovalidateMode: AutovalidateMode.disabled,
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _buildUsernameField(),
                                SpacerWidget(20),
                                _buildPasswordField(),
                                SpacerWidget(20),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InAppUrlLauncer(
                                                    url: Overrides
                                                        .forgotPasswordUrl,
                                                    title: AppTranslations.of(
                                                            context)!
                                                        .text(
                                                            'forgot_password'),
                                                  )));
                                    },
                                    child: _buildForgotPasswordBtn()),
                                SpacerWidget(45),
                                _buildLoginBtn(state)
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    Utility.upliftPage(context, _scrollController);
    print(DefaultTextStyle.of(context).style.fontFamily);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          key: _scaffoldKey,
          body: ListView(
            padding: EdgeInsets.zero,
            controller: _scrollController,
            children: [
              BlocBuilder(
                  bloc: _bloc,
                  builder: (BuildContext context, UserState state) {
                    if (state is UserInitial) {
                      return Container(
                          margin: EdgeInsets.only(
                              top: Utility.displayHeight(context) * 0.30),
                          color: Theme.of(context).backgroundColor,
                          child: Center(
                              child: Image.asset('assets/images/splash.png',
                                  fit: BoxFit.cover)));
                    } else {
                      return _loginSection(state);
                    }
                  }),
              BlocListener<UserBloc, UserState>(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is InvalidCredentials) {
                    Utility.showSnackBar(
                        _scaffoldKey,
                        AppTranslations.of(context)!
                            .text('invalid_credentials'),
                        context);
                  }
                  if (state is LoginSuccess) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                  if (state is OpenChangePassword) {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => ChangePasswordPage()));
                  }
                  if (state is ErrorReceived) {
                    if (state.err != null && state.err != "") {
                      Utility.showSnackBar(
                          _scaffoldKey, "${state.err}", context);
                    }
                  }
                },
                child: Container(),
              )
            ],
          )),
    );
  }
}
