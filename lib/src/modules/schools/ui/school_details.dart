import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/button_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';

import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class SchoolDetailPage extends StatefulWidget {
  // final obj;
  // bool isbuttomsheet;
  // // String appBarTitle;
  // String? language;
  // SchoolDetailPage(
  //     {Key? key,
  //     required this.obj,
  //     required this.isbuttomsheet,
  //     // required this.appBarTitle,
  //     required this.language})
  //     : super(key: key);

  @override
  _SchoolDetailPageState createState() => _SchoolDetailPageState();
}

class _SchoolDetailPageState extends State<SchoolDetailPage> {
      static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;
  static const double _kLabelSpacing = 16.0;
  static const double _kboxheight = 60.0;
  static const double _kIconSize = 48.0;
  bool issuccesstate = false;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  final HomeBloc homebloc = new HomeBloc();
  bool? iserrorstate = false;
  static const double _kboxborderwidth = 0.75;
  bool? isloadingstate = false;
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    homebloc.add(FetchBottomNavigationBar());
    Globals.callsnackbar = true;
    _markers.add(Marker(
        markerId: MarkerId("Your location"),
        draggable: false,
        position: LatLng(
            Globals.homeObjet["Contact_Office_Location__Latitude__s"],
            Globals.homeObjet["Contact_Office_Location__Longitude__s"])));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildIcon() {
     // TO DO : HTML Widget ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    return Container(
      child: Globals.homeObjet != null &&
              Globals.homeObjet["Contact_Image__c"] != null
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: _kLabelSpacing / 2),
              child: CachedNetworkImage(
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
                errorWidget: (context, url, error) => CachedNetworkImage(
                  imageUrl: Globals.splashImageUrl != null &&
                          Globals.splashImageUrl != ""
                      ? Globals.splashImageUrl
                      : Globals.homeObjet["App_Logo__c"],
                  placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      child: ShimmerLoading(
                        isLoading: true,
                        child: Container(
                          width: _kIconSize * 1.4,
                          height: _kIconSize * 1.5,
                          color: Colors.white,
                        ),
                      )),
                ),
              ),
            )
          : Container(
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: Globals.splashImageUrl != null &&
                          Globals.splashImageUrl != ""
                      ? Globals.splashImageUrl
                      : Globals.homeObjet["App_Logo__c"],
                  placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      child: ShimmerLoading(
                        isLoading: true,
                        child: Container(
                          height: 200,
                          color: Colors.white,
                        ),
                      )),
                  errorWidget: (context, url, error) => CachedNetworkImage(
                    imageUrl: Globals.splashImageUrl != null &&
                            Globals.splashImageUrl != ""
                        ? Globals.splashImageUrl
                        : Globals.homeObjet["App_Logo__c"],
                    placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: ShimmerLoading(
                          isLoading: true,
                          child: Container(
                            width: _kIconSize * 1.4,
                            height: _kIconSize * 1.5,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTitleWidget() {
    return Center(
      child: Globals.homeObjet["Contact_Name__c"] != null &&
              Globals.selectedLanguage != null &&
              Globals.selectedLanguage != "English" &&
              Globals.selectedLanguage != ""
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
            ),
    );
  }

Widget _buildDescriptionWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing,
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Globals.homeObjet["Contact_Name__c"] != null &&
                  Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English" &&
                  Globals.selectedLanguage != ""
              ? TranslationWidget(
                  message: "Principal : Elmer Myers",
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.headline2!
                  ),
                )
              : Text(
                 "Principal : Elmer Myers",
                  style: Theme.of(context).textTheme.headline2!
                ),
                      Globals.homeObjet["Contact_Name__c"] != null &&
                              Globals.selectedLanguage != null &&
                              Globals.selectedLanguage != "English" &&
                              Globals.selectedLanguage != ""
                          ? TranslationWidget(
                              message: "Parent Coordinator : Janine Guerieri",
                              toLanguage: Globals.selectedLanguage,
                              fromLanguage: "en",
                              builder: (translatedMessage) => Text(
                                translatedMessage.toString(),
                                style: Theme.of(context).textTheme.headline2!
                              ),
                            )
                          : Text(
                              "Parent Coordinator : Janine Guerieri",
                              style: Theme.of(context).textTheme.headline2!
                            ),
                      Globals.homeObjet["Contact_Name__c"] != null &&
                              Globals.selectedLanguage != null &&
                              Globals.selectedLanguage != "English" &&
                              Globals.selectedLanguage != ""
                          ? TranslationWidget(
                              message:  "Parent Coordinator Email:\nJGuerieri@school.nyc.gov",
                              toLanguage: Globals.selectedLanguage,
                              fromLanguage: "en",
                              builder: (translatedMessage) => Text(
                                translatedMessage.toString(),
                                style: Theme.of(context).textTheme.headline2!
                                  
                              ),
                            )
                          : Text(
                            "Parent Coordinator Email: \nJGuerieri@school.nyc.gov",
                              style: Theme.of(context).textTheme.headline2!
                            ),
        ],
      ),
    );
  }
  Widget _buildMapWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.20,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
            border: Border.all(
              width: _kboxborderwidth,
              color: AppTheme.kTxtfieldBorderColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Container(
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
                Globals.homeObjet["Contact_Office_Location__Longitude__s"] !=
                    null
            ? SizedBox(
                height: _kboxheight * 2,
                child: GoogleMap(
                    compassEnabled: true,
                    buildingsEnabled: true,
                    scrollGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    tiltGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                        // bearing: 192.8334901395799,
                        target: LatLng(
                            Globals.homeObjet[
                                "Contact_Office_Location__Latitude__s"],
                            Globals.homeObjet[
                                "Contact_Office_Location__Longitude__s"]),
                        zoom: 18,
                        tilt: 59.440717697143555),
                    markers: Set.from(
                        _markers) //_markers.toSet(), //   values.toSet(),
                    ),
              )
            : EmptyContainer()),
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

  void _launchMapsUrl() async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${Globals.homeObjet["Contact_Office_Location__Latitude__s"]},${Globals.homeObjet["Contact_Office_Location__Longitude__s"]}';
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    await Utility.launchUrlOnExternalBrowser(url);
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
                  Globals.selectedLanguage != "English" &&
                  Globals.selectedLanguage != ""
              ? TranslationWidget(
                  message: "Website :",
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
                  "Website : ",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          Expanded(
            child: GestureDetector(
              onTap: _launchMapsUrl,
              child: Text(
                 "https://psis48.echalksites.com",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                  fontSize: Globals.deviceType == "phone"
                      ? AppTheme.kBodyText1FontSize
                      : AppTheme.kBodyText1FontSize + AppTheme.kSize,
                  color: Colors.blue,//AppTheme.kAccentColor,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Roboto Regular',
                  height: 1.5,
                  
                ), //Theme.of(context).textTheme.bodyText1!,
                textAlign: TextAlign.start,
              ),
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
                  Globals.selectedLanguage != "English" &&
                  Globals.selectedLanguage != ""
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
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: InkWell(
              onTap: () {
                if (Globals.homeObjet["Contact_Phone__c"] != null) {
                  urlobj.callurlLaucher(
                      context, "tel:" + Globals.homeObjet["Contact_Phone__c"]);
                }
              },
              child: Text(
                Globals.homeObjet["Contact_Phone__c"] ?? '-',
                style: Theme.of(context).textTheme.bodyText1!,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

 

  Widget _buildItem() {
    return ListView(padding: const EdgeInsets.only(bottom: 35.0), children: [
      _buildTitleWidget(),
      SpacerWidget(_kLabelSpacing / 1.5),
      _buildIcon(),
      SpacerWidget(_kLabelSpacing),
      _buildDescriptionWidget(),
      SpacerWidget(_kLabelSpacing*2),
      _buildMapWidget(),
      _buildAddressWidget(),
      SpacerWidget(_kLabelSpacing / 1.25),
      Globals.homeObjet["Contact_Phone__c"] != null
          ? _buildPhoneWidget()
          : Container(),
          SpacerWidget(_kLabelSpacing / 1.25),
     ButtonWidget(title: "Share",)
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          isSearch: true,
          isShare: false,
          appBarTitle: "Appbar",
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
          language: Globals.selectedLanguage,
          marginLeft: 30,
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
                Globals.isNetworkError = !connected;

                if (connected) {
                  if (iserrorstate == true) {
                    homebloc.add(FetchBottomNavigationBar());
                    iserrorstate = false;
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return new Stack(fit: StackFit.expand, children: [
                  connected
                      ? Column(
                          children: [
                            Expanded(
                                child: isloadingstate!
                                    ? ShimmerLoading(
                                        isLoading: true, child: _buildItem())
                                    : _buildItem()),
                            Container(
                              height: 0,
                              width: 0,
                              child: BlocListener<HomeBloc, HomeState>(
                                  bloc: homebloc,
                                  listener: (context, state) async {
                                    if (state is HomeLoading) {
                                      isloadingstate = true;
                                    }
                                    if (state is BottomNavigationBarSuccess) {
                                      AppTheme.setDynamicTheme(
                                          Globals.appSetting, context);
                                      Globals.homeObjet = state.obj;
                                      isloadingstate = false;
                                      setState(() {});
                                    }
                                  },
                                  child: EmptyContainer()),
                            ),
                          ],
                        )
                      : NoInternetErrorWidget(
                          connected: connected, issplashscreen: false),
                  Container(
                    height: 0,
                    width: 0,
                    child: BlocListener<HomeBloc, HomeState>(
                      bloc: homebloc,
                      listener: (context, state) async {
                        if (state is BottomNavigationBarSuccess) {
                          AppTheme.setDynamicTheme(Globals.appSetting, context);
                          Globals.homeObjet = state.obj;
                          setState(() {});
                        }
                      },
                      child: EmptyContainer(),
                    ),
                  ),
                ]);
              },
              child: EmptyContainer()),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    homebloc.add(FetchBottomNavigationBar());
  }
}
