import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/error_icon_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/mapwidget.dart';
import 'package:Soc/src/widgets/no_data_icon_widget.dart';
import 'package:Soc/src/widgets/no_internet_icon.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

// ignore: must_be_immutable
class ContactPage extends StatefulWidget {
  final obj;
  bool isbuttomsheet;
  String appBarTitle;
  String? language;
  ContactPage(
      {Key? key,
      required this.obj,
      required this.isbuttomsheet,
      required this.appBarTitle,
      required this.language})
      : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  static const double _kLabelSpacing = 16.0;
  static const double _kboxheight = 60.0;
  bool issuccesstate = false;

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  final HomeBloc _bloc = new HomeBloc();
  bool? iserrorstate = false;
  static const double _kboxborderwidth = 0.75;
  var longitude;
  var latitude;

  @override
  void initState() {
    super.initState();
    _bloc.add(FetchBottomNavigationBar());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildIcon() {
    return Container(
      child: Globals.homeObjet != null &&
              Globals.homeObjet["Contact_Image__c"] != null
          ? CachedNetworkImage(
              imageUrl: Globals.homeObjet["Contact_Image__c"],
              fit: BoxFit.fill,
              placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  child: ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      height: 200,
                      color: Colors.white,
                    ),
                  )),
              errorWidget: (context, url, error) => Icon(
                Icons.error,
              ),
            )
          : Container(
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: Globals.homeObjet["App_Logo__c"],
                  placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      child: ShimmerLoading(
                        isLoading: true,
                        child: Container(
                          height: 200,
                          // width: MediaQuery.of(context).size.width,
                          // height: _kIconSize * 1.5,
                          color: Colors.white,
                        ),
                      )),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
    );
  }

  Widget _buildTitleWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing,
        ),
        child: Globals.homeObjet["Contact_Name__c"] != null &&
                Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English"
            ? TranslationWidget(
                message: Globals.homeObjet["Contact_Name__c"] ?? "-",
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.headline2,
                ),
              )
            : Text(
                Globals.homeObjet["Contact_Name__c"] ?? "-",
                style: Theme.of(context).textTheme.headline2,
              ));
  }

  Widget _buildMapWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
      child: Container(
        height: _kboxheight * 2.5,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
            border: Border.all(
              width: _kboxborderwidth,
              color: AppTheme.kTxtfieldBorderColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: _buildmap(),
      ),
    );
  }

  Widget _buildmap() {
    return Container(
      margin: EdgeInsets.only(
          top: _kLabelSpacing / 3,
          bottom: _kLabelSpacing / 1.5,
          right: _kLabelSpacing / 3,
          left: _kLabelSpacing / 3),
      decoration: BoxDecoration(
          color: AppTheme.kmapBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Globals.homeObjet["Contact_Office_Location__Latitude__s"] !=
                  null &&
              Globals.homeObjet["Contact_Office_Location__Longitude__s"] != null
          ? SizedBox(
              height: _kboxheight * 2,
              child: GoogleMaps(
                latitude:
                    Globals.homeObjet["Contact_Office_Location__Latitude__s"],
                longitude:
                    Globals.homeObjet["Contact_Office_Location__Longitude__s"],
                // locationName: 'soc client',
              ),
            )
          : Container(
              height: 0,
            ),
    );
  }

  Widget _buildPhoneWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
            border: Border.all(
              width: _kboxborderwidth,
              color: AppTheme.kTxtfieldBorderColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: _buildphone(),
      ),
    );
  }

  Widget _buildAddressWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
            border: Border.all(
              width: _kboxborderwidth,
              color: AppTheme.kTxtfieldBorderColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: _buildaddress(),
      ),
    );
  }

  Widget _buildaddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message: "Address:",
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                    // .copyWith(color: Color(0xff171717)),
                    textAlign: TextAlign.center,
                  ),
                )
              : Text(
                  "Address : ",
                  style: Theme.of(context).textTheme.bodyText1!,
                  // .copyWith(color: Color(0xff171717)
                  // ),
                  textAlign: TextAlign.center,
                ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          Expanded(
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message: Globals.homeObjet["Contact_Address__c"] ?? '-',
                    toLanguage: Globals.selectedLanguage,
                    fromLanguage: "en",
                    builder: (translatedMessage) => Text(
                      translatedMessage.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.start,
                    ),
                  )
                : Text(
                    Globals.homeObjet["Contact_Address__c"] ?? '-',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.start,
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildphone() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
      child: Row(
        children: [
          Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message: "Phone :",
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.bodyText1!,
                    // .copyWith(color: Color(0xff171717)),
                  ),
                )
              : Text(
                  "Phone : ",
                  style: Theme.of(context).textTheme.bodyText1!,
                  // .copyWith(color: Color(0xff171717)),
                ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          InkWell(
            onTap: () {
              if (Globals.homeObjet["Contact_Phone__c"] != null) {
                urlobj.callurlLaucher(
                    context, "tel:" + Globals.homeObjet["Contact_Phone__c"]);
              }
            },
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message: Globals.homeObjet["Contact_Phone__c"] ?? '-',
                    toLanguage: Globals.selectedLanguage,
                    fromLanguage: "en",
                    builder: (translatedMessage) => Text(
                      translatedMessage.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  )
                : Text(
                    Globals.homeObjet["Contact_Phone__c"] ?? '-',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildEmailWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
              border: Border.all(
                width: _kboxborderwidth,
                color: AppTheme.kTxtfieldBorderColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: _builEmail()),
    );
  }

  Widget _builEmail() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
      child: Row(
        children: [
          Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message: "Email :",
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.bodyText1!,
                    // .copyWith(color: Color(0xff171717)),
                  ),
                )
              : Text(
                  "Email : ",
                  style: Theme.of(context).textTheme.bodyText1!,
                  // .copyWith(color: Color(0xff171717)),
                ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          InkWell(
            onTap: () {
              Globals.homeObjet["Contact_Email__c"] != null
                  ? urlobj.callurlLaucher(context,
                      'mailto:"${Globals.homeObjet["Contact_Email__c"]}"')
                  : print("null value");
            },
            child: Text(
              Globals.homeObjet["Contact_Email__c"] ?? '-',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          isSearch: true,
          isShare: false,
          appBarTitle: widget.appBarTitle,
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
          language: Globals.selectedLanguage,
        ),
        body: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;

              if (connected) {
                if (iserrorstate == true) {
                  _bloc.add(FetchBottomNavigationBar());
                  iserrorstate = false;
                }
              } else if (!connected) {
                iserrorstate = true;
                _bloc.add(FetchBottomNavigationBar());
              }

              return new Stack(fit: StackFit.expand, children: [
                BlocBuilder<HomeBloc, HomeState>(
                    bloc: _bloc,
                    builder: (BuildContext contxt, HomeState state) {
                      if (state is HomeLoading) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is BottomNavigationBarSuccess) {
                        return ListView(children: [
                          _buildIcon(),
                          SpacerWidget(_kLabelSpacing),
                          _buildTitleWidget(),
                          SpacerWidget(_kLabelSpacing / 1.5),
                          _buildMapWidget(),
                          _buildAddressWidget(),
                          SpacerWidget(_kLabelSpacing / 1.25),
                          _buildPhoneWidget(),
                          SpacerWidget(_kLabelSpacing / 1.25),
                          _buildEmailWidget(),
                        ]);
                      } else if (state is HomeErrorReceived) {
                        if (state.err == "NO_CONNECTION") {
                          return Stack(children: [
                            Positioned(
                              height: 20.0,
                              left: 0.0,
                              right: 0.0,
                              top: 25,
                              child: Container(
                                color: connected
                                    ? Color(0xFF00EE44)
                                    : Color(0xFFEE4400),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${connected ? 'ONLINE' : 'OFFLINE'}",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          HorzitalSpacerWidget(16),
                                          connected
                                              ? Container(
                                                  height: 0,
                                                )
                                              : SizedBox(
                                                  height: 10,
                                                  width: 10,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ))
                                        ],
                                      ),
                                      // SizedBox(
                                      //   child: NoInternetIconWidget(),
                                      // ),
                                      // SpacerWidget(12),
                                      // Globals.selectedLanguage != null &&
                                      //         Globals.selectedLanguage !=
                                      //             "English"
                                      //     ? TranslationWidget(
                                      //         message: "No internet connection",
                                      //         toLanguage:
                                      //             Globals.selectedLanguage,
                                      //         fromLanguage: "en",
                                      //         builder: (translatedMessage) =>
                                      //             Text(
                                      //           translatedMessage.toString(),
                                      //         ),
                                      //       )
                                      //     : Text("No internet connection"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: NoInternetIconWidget(),
                                  ),
                                  SpacerWidget(12),
                                  Text("No internet connection")
                                ]),
                          ]);
                        } else if (state.err == "Something went wrong") {
                          return ListView(children: [
                            SizedBox(
                              child: NoDataIconWidget(),
                            ),
                            SpacerWidget(12),
                            Globals.selectedLanguage != null &&
                                    Globals.selectedLanguage != "English"
                                ? TranslationWidget(
                                    message: "No  data found",
                                    toLanguage: Globals.selectedLanguage,
                                    fromLanguage: "en",
                                    builder: (translatedMessage) => Text(
                                      translatedMessage.toString(),
                                    ),
                                  )
                                : Text("No data found"),
                          ]);
                        } else {
                          return ListView(children: [
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
                // ),
                BlocListener<HomeBloc, HomeState>(
                  bloc: _bloc,
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
                  child: Container(),
                ),
              ]);
              // onRefresh: refreshPage,
            },
            child: Container()));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(FetchBottomNavigationBar());
  }
}
