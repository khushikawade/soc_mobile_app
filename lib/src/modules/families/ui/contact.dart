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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';

class ContactPage extends StatefulWidget {
  final obj;
  final bool isBottomSheet;
  final String appBarTitle;
  final String? language;
  final bool? isAppBar;

  ContactPage({
    Key? key,
    required this.obj,
    required this.isBottomSheet,
    required this.appBarTitle,
    required this.language,
    this.isAppBar,
  }) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  static const double _kLabelSpacing = 16.0;
  static const double _kboxheight = 60.0;
  bool issuccesstate = false;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  final HomeBloc homebloc = new HomeBloc();
  bool? isErrorState = false;
  static const double _kboxborderwidth = 0.75;
  bool? isLoadingstate = false;
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    homebloc.add(FetchStandardNavigationBar());
    Globals.callSnackbar = true;
    _markers.add(Marker(
        markerId: MarkerId("Your location"),
        draggable: false,
        position: LatLng(Globals.appSetting.contactOfficeLocationLatitudeS!,
            Globals.appSetting.contactOfficeLocationLongitudeS!)));
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
              iconUrl: Globals.appSetting.contactImageC ??
                  Globals.splashImageUrl ??
                  Globals.appSetting.appLogoC,
            )));
  }

  Widget _buildTitleWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing,
        ),
        child: TranslationWidget(
          message: Globals.appSetting.contactImageC ?? "",
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
        child: Globals.appSetting.contactOfficeLocationLatitudeS != null &&
                Globals.appSetting.contactOfficeLocationLongitudeS != null
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
                            Globals.appSetting.contactOfficeLocationLatitudeS!,
                            Globals
                                .appSetting.contactOfficeLocationLongitudeS!),
                        zoom: 18,
                        tilt: 59.440717697143555),
                    markers: Set.from(_markers)),
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
          HorizontalSpacerWidget(_kLabelSpacing / 2),
          Expanded(
            child: GestureDetector(
              onTap: _launchMapsUrl,
              child: Text(
                Globals.appSetting.contactAddressC ?? '-',
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
          HorizontalSpacerWidget(_kLabelSpacing / 2),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: InkWell(
              onTap: () {
                if (Globals.appSetting.contactPhoneC != null) {
                  Utility.launchUrlOnExternalBrowser("tel:" +
                      (Globals.appSetting.contactPhoneC ?? '')
                          .replaceAll(new RegExp(r'[^\w\s]+'), ''));
                }
              },
              child: Text(
                Globals.appSetting.contactPhoneC ?? '-',
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
          HorizontalSpacerWidget(_kLabelSpacing / 2),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: InkWell(
              onTap: () {
                Globals.appSetting.contactEmailC != null
                    ? Utility.launchUrlOnExternalBrowser(
                        "mailto:" + Globals.appSetting.contactEmailC!)
                    : print("null value");
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
      Globals.appSetting.contactPhoneC != null
          ? _buildPhoneWidget()
          : Container(),
      SpacerWidget(_kLabelSpacing / 1.25),
      Globals.appSetting.contactEmailC != null
          ? _buildEmailWidget()
          : Container(),
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.isAppBar == false
            ? null
            : CustomAppBarWidget(
                isSearch: true,
                isShare: false,
                appBarTitle: widget.appBarTitle,
                sharedPopBodyText: '',
                sharedPopUpHeaderText: '',
                language: Globals.selectedLanguage,
                marginLeft: 30,
              ),
        body: RefreshIndicator(
          key: refreshKey,
          child: Stack(fit: StackFit.expand, children: [
            //         connected
            //             ?
            Column(
              children: [
                Expanded(
                    child: isLoadingstate!
                        ? ShimmerLoading(isLoading: true, child: _buildItem())
                        : _buildItem()),
                Container(
                  height: 0,
                  width: 0,
                  child: BlocListener<HomeBloc, HomeState>(
                      bloc: homebloc,
                      listener: (context, state) async {
                        if (state is HomeLoading) {
                          isLoadingstate = true;
                        }
                        if (state is BottomNavigationBarSuccess) {
                          AppTheme.setDynamicTheme(Globals.appSetting, context);
                          Globals.appSetting = AppSetting.fromJson(state.obj);
                          isLoadingstate = false;
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

                    Globals.appSetting = AppSetting.fromJson(state.obj);
                    setState(() {});
                  }
                },
                child: EmptyContainer(),
              ),
            ),
          ]),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    homebloc.add(FetchStandardNavigationBar());
  }
}
