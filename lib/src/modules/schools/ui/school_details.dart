import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/schools/modal/school_directory_list.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/button_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/list_border_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SchoolDetailPage extends StatefulWidget {
  final SchoolDirectoryList obj;
  SchoolDetailPage({
    Key? key,
    required this.obj,
  }) : super(key: key);

  @override
  _SchoolDetailPageState createState() => _SchoolDetailPageState();
}

class _SchoolDetailPageState extends State<SchoolDetailPage> {
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
    if (widget.obj.geoLocation != null) {
      _markers.add(Marker(
          markerId: MarkerId("Location"),
          draggable: true,
          position: LatLng(widget.obj.geoLocation["latitude"],
              widget.obj.geoLocation["longitude"])));
    }
  }

  Widget _buildIcon() {
    return Hero(
        tag: widget.obj.imageUrlC ??
            Globals.splashImageUrl ??
            Globals.homeObjet["App_Logo__c"],
        child: Container(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing / 2),
          child: CachedNetworkImage(
            imageUrl: widget.obj.imageUrlC ??
                Globals.splashImageUrl ??
                Globals.homeObjet["App_Logo__c"],
            // "https://the-noun-project-icons.s3.us-east-2.amazonaws.com/noun_School_3390481+(2).png",
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
              imageUrl:
                  Globals.splashImageUrl ?? Globals.homeObjet["App_Logo__c"],
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
        )));
  }

  Widget _buildTitleWidget() {
    return Center(
      child: widget.obj.titleC != null &&
              Globals.selectedLanguage != null &&
              Globals.selectedLanguage != "English" &&
              Globals.selectedLanguage != ""
          ? TranslationWidget(
              message: widget.obj.titleC ?? "-",
              toLanguage: Globals.selectedLanguage,
              fromLanguage: "en",
              builder: (translatedMessage) => Text(
                translatedMessage.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            )
          : Text(
              widget.obj.titleC ?? "-",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
    );
  }

  Widget _buildDescriptionWidget() {
    return widget.obj.rtfHTMLC != null
        ? Container(
            margin: const EdgeInsets.symmetric(
              horizontal: _kLabelSpacing,
            ),
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English" &&
                    Globals.selectedLanguage != ""
                ? TranslationWidget(
                    message: widget.obj.rtfHTMLC,
                    toLanguage: Globals.selectedLanguage,
                    fromLanguage: "en",
                    builder: (translatedMessage) => Html(
                      data: translatedMessage.toString(),
                    ),
                  )
                : Html(data: widget.obj.rtfHTMLC),
          )
        : Container();
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
            child: widget.obj.geoLocation["latitude"] != null &&
                    widget.obj.geoLocation["longitude"] != null
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
                            target: LatLng(widget.obj.geoLocation["latitude"],
                                widget.obj.geoLocation["longitude"]),
                            zoom: 18,
                            tilt: 59.440717697143555),
                        markers: Set.from(_markers)),
                  )
                : EmptyContainer()),
      ),
    );
  }

  Widget _buildPhoneWidget() {
    return ListBorderWidget(
      title: "Phone",
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: InkWell(
          onTap: () {
            urlobj.callurlLaucher(context, "tel:" + widget.obj.phoneC!);
          },
          child: Text(
            widget.obj.phoneC ?? '-',
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue,
              fontSize: Globals.deviceType == "phone"
                  ? AppTheme.kBodyText1FontSize
                  : AppTheme.kBodyText1FontSize + AppTheme.kSize,
              color: Colors.blue,
              fontWeight: FontWeight.normal,
              fontFamily: 'Roboto Regular',
              height: 1.5,
            ), //Theme.of(context).textTheme.bodyText1!,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildWebsiteWidget() {
    return ListBorderWidget(
      title: "Website",
      child: Expanded(
          child: Linkify(
        onOpen: (link) => _launchURL(link.url),
        text: widget.obj.urlC!,
        style: TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue,
          fontSize: Globals.deviceType == "phone"
              ? AppTheme.kBodyText1FontSize
              : AppTheme.kBodyText1FontSize + AppTheme.kSize,
          color: Colors.blue,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto Regular',
          height: 1.5,
        ),
      )),
    );
  }

  _launchURL(obj) async {
    if (obj.toString().split(":")[0] == 'http') {
      await Utility.launchUrlOnExternalBrowser(obj);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: widget.obj.titleC ?? "",
                    url: widget.obj.urlC!,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    }
  }

  Widget _buildEmailWidget() {
    return ListBorderWidget(
      title: "Email",
      child: Expanded(
        child: GestureDetector(
          onTap: () {
            urlobj.callurlLaucher(context, 'mailto:"${widget.obj.emailC}"');
          },
          child: Text(
            widget.obj.emailC!,
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue,
              fontSize: Globals.deviceType == "phone"
                  ? AppTheme.kBodyText1FontSize
                  : AppTheme.kBodyText1FontSize + AppTheme.kSize,
              color: Colors.blue,
              fontWeight: FontWeight.normal,
              fontFamily: 'Roboto Regular',
              height: 1.5,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }

  Widget _buildAddressWidget() {
    return ListBorderWidget(
      title: "Address",
      child: Expanded(
        child: GestureDetector(
          onTap: _launchMapsUrl,
          child: Text(
            widget.obj.address!,
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue,
              fontSize: Globals.deviceType == "phone"
                  ? AppTheme.kBodyText1FontSize
                  : AppTheme.kBodyText1FontSize + AppTheme.kSize,
              color: Colors.blue,
              fontWeight: FontWeight.normal,
              fontFamily: 'Roboto Regular',
              height: 1.5,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }

  void _launchMapsUrl() async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${widget.obj.geoLocation["latitude"]},${widget.obj.geoLocation["longitude"]}';
    await Utility.launchUrlOnExternalBrowser(url);
  }

  Widget _buildItem() {
    return ListView(padding: const EdgeInsets.only(bottom: 35.0), children: [
      _buildTitleWidget(),
      SpacerWidget(_kLabelSpacing / 1.5),
      _buildIcon(),
      SpacerWidget(_kLabelSpacing),
      _buildDescriptionWidget(),
      SpacerWidget(_kLabelSpacing * 2),
      widget.obj.geoLocation != null ? _buildMapWidget() : Container(),
      SpacerWidget(_kLabelSpacing / 1.25),
      widget.obj.urlC != null ? _buildWebsiteWidget() : Container(),
      SpacerWidget(_kLabelSpacing / 1.25),
      widget.obj.emailC != null ? _buildEmailWidget() : Container(),
      SpacerWidget(_kLabelSpacing / 1.25),
      widget.obj.address != null ? _buildAddressWidget() : Container(),
      SpacerWidget(_kLabelSpacing / 1.25),
      widget.obj.phoneC != null ? _buildPhoneWidget() : Container(),
      SpacerWidget(_kLabelSpacing / 1.25),
      ButtonWidget(
        title: widget.obj!.titleC ?? "",
        obj: widget.obj,
        body: Utility.parseHtml(widget.obj.rtfHTMLC ?? "") +
            "\n" +
            "${widget.obj.urlC ?? ""}" +
            "\n"
                "${widget.obj.emailC ?? ""}" +
            "\n" +
            "${widget.obj.address ?? ""}" +
            "\n" +
            "${widget.obj.phoneC ?? ""}",
        buttonTitle: "Share",
      ),
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          isSearch: true,
          isShare: false,
          appBarTitle: "",
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
