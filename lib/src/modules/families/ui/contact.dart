import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/common_image_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';

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
            Globals.appSetting.contactOfficeLocationLatitudeS!,Globals.appSetting.contactOfficeLocationLongitudeS!
            // Globals.homeObject["Contact_Office_Location__Latitude__s"],
            // Globals.homeObject["Contact_Office_Location__Longitude__s"]
            )
            ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildIcon() {
    return Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing / 2),
            child: CommonImageWidget(
              fitMethod: BoxFit.fitHeight,
              isOnTap: true,
              height: Utility.displayHeight(context) *
                  (AppTheme.kDetailPageImageHeightFactor / 100),
              iconUrl: Globals.appSetting.contactImageC
              // Globals.homeObject["Contact_Image__c"]
               ??
                  Globals.splashImageUrl ??
                  Globals.appSetting.appLogoC,
                  // Globals.homeObject["App_Logo__c"],
            )));
  }

  Widget _buildTitleWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing,
        ),
        child: TranslationWidget(
          message: Globals.appSetting.contactImageC
          // Globals.homeObject["Contact_Name__c"]
           ?? "-",
          toLanguage: Globals.selectedLanguage,
          fromLanguage: "en",
          builder: (translatedMessage) => Text(
            translatedMessage.toString(),
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ));
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
        child: Globals.appSetting.contactOfficeLocationLatitudeS !=
                    null &&
                Globals.appSetting.contactOfficeLocationLongitudeS !=
                    null
        // Globals.homeObject["Contact_Office_Location__Latitude__s"] !=
        //             null &&
        //         Globals.homeObject["Contact_Office_Location__Longitude__s"] !=
        //             null
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
                           Globals.appSetting.contactOfficeLocationLatitudeS!,Globals.appSetting.contactOfficeLocationLongitudeS!
                            // Globals.homeObject[
                            //     "Contact_Office_Location__Latitude__s"],
                            // Globals.homeObject[
                            //     "Contact_Office_Location__Longitude__s"]
                                ),
                        zoom: 18,
                        tilt: 59.440717697143555),
                    markers: Set.from(
                        _markers) //_markers.toSet(), //   values.toSet(),
                    ),
              )
            : EmptyContainer());
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
       'https://www.google.com/maps/search/?api=1&query=${Globals.appSetting.contactOfficeLocationLatitudeS},${Globals.appSetting.contactOfficeLocationLongitudeS}';
        // 'https://www.google.com/maps/search/?api=1&query=${Globals.homeObject["Contact_Office_Location__Latitude__s"]},${Globals.homeObject["Contact_Office_Location__Longitude__s"]}';
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
          TranslationWidget(
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
          ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          Expanded(
            child: GestureDetector(
              onTap: _launchMapsUrl,
              child: Text(
                Globals.appSetting.contactAddressC
                // Globals.homeObject["Contact_Address__c"]
                 ?? '-',
                style: AppTheme
                    .linkStyle, //Theme.of(context).textTheme.bodyText1!,
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
          TranslationWidget(
            message: "Phone :",
            toLanguage: Globals.selectedLanguage,
            fromLanguage: "en",
            builder: (translatedMessage) => Text(
              translatedMessage.toString(),
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: InkWell(
              onTap: () {
                if (
                  Globals.appSetting.contactPhoneC != null
                  // Globals.homeObject["Contact_Phone__c"] != null
                  ) {
                  // urlobj.callurlLaucher(
                  //     context, "tel:" + Globals.homeObject["Contact_Phone__c"]);
                  Utility.launchUrlOnExternalBrowser(
                      "tel:" + Globals.appSetting.contactPhoneC!
                      //  Globals.homeObject["Contact_Phone__c"]
                      );
                }
              },
              child: Text(
                Globals.appSetting.contactPhoneC
                // Globals.homeObject["Contact_Phone__c"] 
                ?? '-',
                style: AppTheme.linkStyle,
                textAlign: TextAlign.center,
              ),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TranslationWidget(
            message: "Email :",
            toLanguage: Globals.selectedLanguage,
            fromLanguage: "en",
            builder: (translatedMessage) => Text(
              translatedMessage.toString(),
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: InkWell(
              onTap: () {
                // Globals.homeObject["Contact_Email__c"]
                Globals.appSetting.contactEmailC
                 != null
                    ?
                    // urlobj.callurlLaucher(context,
                    //     'mailto:"${Globals.homeObject["Contact_Email__c"]}"')
                    Utility.launchUrlOnExternalBrowser(
                        "mailto:" + Globals.appSetting.contactEmailC!)
                    : print("null value");
                    // Globals.homeObject["Contact_Email__c"]
              },
              child: Text(
                Globals.appSetting.contactEmailC ?? '-',
                style: Theme.of(context).textTheme.bodyText1!,
              ),
            ),
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
      // Globals.homeObject["Contact_Phone__c"]
      Globals.appSetting.contactPhoneC != null
          ? _buildPhoneWidget()
          : Container(),
      SpacerWidget(_kLabelSpacing / 1.25),
      // Globals.homeObject["Contact_Email__c"] 
      Globals.appSetting.contactEmailC
      != null
          ? _buildEmailWidget()
          : Container(),
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
          marginLeft: 30,
        ),
        body: RefreshIndicator(
          key: refreshKey,
          child:
              // OfflineBuilder(
              //     connectivityBuilder: (
              //       BuildContext context,
              //       ConnectivityResult connectivity,
              //       Widget child,
              //     ) {
              //       final bool connected = connectivity != ConnectivityResult.none;
              //       Globals.isNetworkError = !connected;

              //       if (connected) {
              //         if (iserrorstate == true) {
              //           homebloc.add(FetchBottomNavigationBar());
              //           iserrorstate = false;
              //         }
              //       } else if (!connected) {
              //         iserrorstate = true;
              //       }

              //       return new
              Stack(fit: StackFit.expand, children: [
            //         connected
            //             ?
            Column(
              children: [
                Expanded(
                    child: isloadingstate!
                        ? ShimmerLoading(isLoading: true, child: _buildItem())
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
                          AppTheme.setDynamicTheme(Globals.appSetting, context);
                          Globals.appSetting = AppSetting.fromJson(state.obj);
                          isloadingstate = false;
                          setState(() {});
                        }
                      },
                      child: EmptyContainer()),
                ),
              ],
            ),
            // : NoInternetErrorWidget(
            //     connected: connected, issplashscreen: false),
            Container(
              height: 0,
              width: 0,
              child: BlocListener<HomeBloc, HomeState>(
                bloc: homebloc,
                listener: (context, state) async {
                  if (state is BottomNavigationBarSuccess) {
                    AppTheme.setDynamicTheme(Globals.appSetting, context);
                    // Globals.homeObject = state.obj;
                    Globals.appSetting = AppSetting.fromJson(state.obj);
                    setState(() {});
                  }
                },
                child: EmptyContainer(),
              ),
            ),
          ]),
          // },
          // child: EmptyContainer()),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    homebloc.add(FetchBottomNavigationBar());
  }
}
