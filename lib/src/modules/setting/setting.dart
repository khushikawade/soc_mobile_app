import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/setting/licenceinfo.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/error_icon_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/error_message_widget.dart';
import 'package:Soc/src/widgets/no_internet_icon.dart';
import 'package:Soc/src/widgets/share_button.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  bool isbuttomsheet;
  String appbarTitle;
  SettingPage(
      {Key? key, required this.isbuttomsheet, required this.appbarTitle})
      : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const double _kLabelSpacing = 18.0;
  bool _lights = true;
  bool? push;
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();

  @override
  void initState() {
    super.initState();
    OneSignal.shared
        .getDeviceState()
        .then((value) => {pushState(value!.pushDisabled)});
  }

  pushState(data) async {
    SharedPreferences pushStatus = await SharedPreferences.getInstance();
    pushStatus.setBool("push", data);
    setState(() {
      push = pushStatus.getBool("push")!;
    });

    if (push == null) {
      push = false;
    }
  }

  Widget _buildHeading(String tittle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: _kLabelSpacing / 1.5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: _kLabelSpacing),
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message: tittle,
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) => Text(
                        translatedMessage.toString(),
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Theme.of(context).colorScheme.primary)),
                  )
                : Text(tittle,
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitch() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Transform.scale(
            scale: 1.0,
            child: Padding(
              padding: const EdgeInsets.only(left: _kLabelSpacing * 1.5),
              child: Switch(
                value: push != null ? _lights = !push! : _lights,
                onChanged: (bool value) async {
                  setState(() {
                    _lights = value;

                    push = !push!;
                    OneSignal.shared.disablePush(push!);
                  });
                  //
                },
                activeColor: AppTheme.kactivebackColor,
                activeTrackColor: AppTheme.kactiveTrackColor,
                inactiveThumbColor: AppTheme.kIndicatorColor,
                inactiveTrackColor: AppTheme.kinactiveTrackColor,
              ),
            ),
          ),
        ]);
  }

  Widget _buildNotification() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English"
            ? Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 0, vertical: _kLabelSpacing / 2),
                child: TranslationWidget(
                  message: "Enable Notification",
                  fromLanguage: "en",
                  toLanguage: Globals.selectedLanguage,
                  builder: (translatedMessage) => Padding(
                    padding: const EdgeInsets.only(left: _kLabelSpacing),
                    child: Text(translatedMessage.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.primary)),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: _kLabelSpacing),
                child: Text("Enable Notification",
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.primary)),
              ),
        _buildSwitch(),
      ],
    );
  }

  Widget _buildLicence() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Licenceinfo()));

        // urlobj.callurlLaucher(context, "https://www.google.com/");
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English"
            ? TranslationWidget(
                message: "Open Source licences",
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.primary)),
              )
            : Text("Open Source licences",
                style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primary)),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          appBarTitle: 'Setting',
          isSearch: false,
          isShare: false,
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
          language: Globals.selectedLanguage,
        ),
        body: RefreshIndicator(
          key: refreshKey,
          child: Container(
              child: ListView(
            children: [
              _buildHeading("Push Notifcation"),
              _buildNotification(),
              _buildHeading("Acknowledgements"),
              _buildLicence(),
              HorzitalSpacerWidget(_kLabelSpacing * 20),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 100.0,
                  child: ShareButtonWidget(
                    language: Globals.selectedLanguage,
                  )),
              BlocListener<HomeBloc, HomeState>(
                bloc: _homeBloc,
                listener: (context, state) async {
                  if (state is BottomNavigationBarSuccess) {
                    AppTheme.setDynamicTheme(Globals.appSetting, context);
                    Globals.homeObjet = state.obj;
                    setState(() {});
                  } else if (state is HomeErrorReceived) {
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(child: Text("Unable to load the data")),
                    );
                  }
                },
                child: Container(
                  height: 0,
                  width: 0,
                ),
              ),
              BlocBuilder<HomeBloc, HomeState>(
                  bloc: _homeBloc,
                  builder: (BuildContext contxt, HomeState state) {
                    if (state is HomeErrorReceived) {
                      if (state.err == "NO_CONNECTION") {
                        return ListView(children: [
                          SizedBox(
                            child: NoInternetIconWidget(),
                          ),
                          SpacerWidget(12),
                          Globals.selectedLanguage != null &&
                                  Globals.selectedLanguage != "English"
                              ? TranslationWidget(
                                  message: "No internet connection",
                                  toLanguage: Globals.selectedLanguage,
                                  fromLanguage: "en",
                                  builder: (translatedMessage) => Text(
                                    translatedMessage.toString(),
                                  ),
                                )
                              : Text("No internet connection"),
                        ]);
                      } else if (state.err == "Something went wrong") {
                        return ListView(shrinkWrap: true, children: [
                          ErrorMessageWidget(
                            imgURL: 'assets/images/no_data_icon.png',
                            msg: "No data found",
                          ),
                          // SpacerWidget(12),
                          // Globals.selectedLanguage != null &&
                          //         Globals.selectedLanguage != "English"
                          //     ? TranslationWidget(
                          //         message: "No  data found",
                          //         toLanguage: Globals.selectedLanguage,
                          //         fromLanguage: "en",
                          //         builder: (translatedMessage) => Text(
                          //           translatedMessage.toString(),
                          //         ),
                          //       )
                          //     : Text("No data found"),
                        ]);
                      } else {
                        return ListView(shrinkWrap: true, children: [
                          SizedBox(child: ErrorIconWidget()),
                          Globals.selectedLanguage != null &&
                                  Globals.selectedLanguage != "English"
                              ? TranslationWidget(
                                  message: "Error",
                                  toLanguage: Globals.selectedLanguage,
                                  fromLanguage: "en",
                                  builder: (translatedMessage) => Text(
                                    translatedMessage.toString(),
                                  ),
                                )
                              : Text("Error"),
                        ]);
                      }
                    } else {
                      return Container();
                    }
                  }),
            ],
          )),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    setState(() {});

    _homeBloc.add(FetchBottomNavigationBar());
  }
}
