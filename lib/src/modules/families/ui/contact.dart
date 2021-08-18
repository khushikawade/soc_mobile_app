import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/mapwidget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
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
                ),
              ),
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
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              )
            : Text(
                Globals.homeObjet["Contact_Name__c"] ?? "-",
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
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
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Text(
                  "Address : ",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
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
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                      textAlign: TextAlign.start,
                    ),
                  )
                : Text(
                    Globals.homeObjet["Contact_Address__c"] ?? '-',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(),
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
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                )
              : Text(
                  "Phone : ",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
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
                        style: Theme.of(context).textTheme.bodyText1!),
                  )
                : Text(Globals.homeObjet["Contact_Phone__c"] ?? '-',
                    style: Theme.of(context).textTheme.bodyText1!),
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
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                )
              : Text(
                  "Email : ",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          InkWell(
            onTap: () {
              Globals.homeObjet["Contact_Email__c"] != null
                  ? urlobj.callurlLaucher(context,
                      'mailto:"${Globals.homeObjet["Contact_Email__c"]}"')
                  : print("null value");
            },
            child: Text(Globals.homeObjet["Contact_Email__c"] ?? '-',
                style: Theme.of(context).textTheme.bodyText1!),
          )
        ],
      ),
    );
  }

  Widget _buildItem() {
    return ListView(padding: const EdgeInsets.only(bottom: 35.0), children: [
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
        body: RefreshIndicator(
          key: refreshKey,
          child: OfflineBuilder(
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
                }

                return new Stack(fit: StackFit.expand, children: [
                  connected
                      ? BlocBuilder<HomeBloc, HomeState>(
                          bloc: _bloc,
                          builder: (BuildContext contxt, HomeState state) {
                            if (state is HomeLoading) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            } else if (state is BottomNavigationBarSuccess) {
                              return state.obj != null && state.obj.length > 0
                                  ? _buildItem()
                                  : ListView(children: [
                                      NoDataFoundErrorWidget(),
                                    ]);
                            } else if (state is HomeErrorReceived) {
                              return ListView(children: [ErrorMsgWidget()]);
                            }
                            return Container();
                          })
                      : NoInternetErrorWidget(
                          connected: connected, issplashscreen: false),
                  Container(
                    height: 0,
                    width: 0,
                    child: BlocListener<HomeBloc, HomeState>(
                      bloc: _bloc,
                      listener: (context, state) async {
                        if (state is BottomNavigationBarSuccess) {
                          AppTheme.setDynamicTheme(Globals.appSetting, context);
                          Globals.homeObjet = state.obj;
                          setState(() {});
                        }
                      },
                      child: Container(),
                    ),
                  ),
                ]);
              },
              child: Container()),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(FetchBottomNavigationBar());
  }
}
