import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/button_widget.dart';
import 'package:Soc/src/widgets/common_image_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/list_border_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/dom.dart' as dom;

class SchoolDetailPage extends StatefulWidget {
  final obj;
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
    homebloc.add(FetchStandardNavigationBar());
    Globals.callsnackbar = true;
    if (widget.obj.latitude != null && widget.obj.longitude != null) {
      _markers.add(Marker(
          markerId: MarkerId("Location"),
          draggable: true,
          position: LatLng(double.parse(widget.obj.latitude ?? "0.0"),
              double.parse(widget.obj.longitude ?? "0.0"))));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _buildIcon() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing / 2),
        child: CommonImageWidget(
          darkModeIconUrl: widget.obj.darkModeIconC,
          iconUrl: widget.obj.imageUrlC ??
              Globals.splashImageUrl ??
              Globals.appSetting.appLogoC,
          height: Utility.displayHeight(context) *
              (AppTheme.kDetailPageImageHeightFactor / 100),
          fitMethod: BoxFit.fitHeight,
          isOnTap: true,
        ));
  }

  Widget _buildTitleWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: TranslationWidget(
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
      ),
    );
  }

  Widget _buildDescriptionWidget() {
    return widget.obj.rtfHTMLC != null
        ? Container(
            margin: const EdgeInsets.symmetric(
              horizontal: _kLabelSpacing,
            ),
            child: TranslationWidget(
              message: widget.obj.rtfHTMLC,
              toLanguage: Globals.selectedLanguage,
              fromLanguage: "en",
              builder: (translatedMessage) => Html(
                data: translatedMessage.toString(),
                onLinkTap: (String? url, RenderContext context,
                    Map<String, String> attributes, dom.Element? element) {
                  Utility.launchUrlOnExternalBrowser(url!);
                },
              ),
            ),
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
            child: widget.obj.latitude != null && widget.obj.longitude != null
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
                                double.parse(widget.obj.latitude ?? "0.0"),
                                double.parse(widget.obj.longitude ?? "0.0")),
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
            Utility.launchUrlOnExternalBrowser("tel:" + widget.obj.phoneC!);
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
            ),
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
        onOpen: (link) => Utility.launchUrlOnExternalBrowser(link.url),
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
        ),
      )),
    );
  }

  Widget _buildEmailWidget() {
    return ListBorderWidget(
      title: "Email",
      child: Expanded(
        child: GestureDetector(
          onTap: () {
            Utility.launchUrlOnExternalBrowser("mailto:" + widget.obj.emailC!);
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
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }

  void _launchMapsUrl() async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${widget.obj.latitude},${widget.obj.longitude}';
    await Utility.launchUrlOnExternalBrowser(url);
  }

  Widget _buildItem() {
    return ListView(children: [
      _buildTitleWidget(),
      SpacerWidget(_kLabelSpacing / 1.5),
      _buildIcon(),
      _buildDescriptionWidget(),
      SpacerWidget(_kLabelSpacing * 2),
      widget.obj.latitude != null && widget.obj.longitude != null
          ? _buildMapWidget()
          : Container(),
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
        title: widget.obj.titleC ?? "",
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
      SpacerWidget(_kLabelSpacing * 3),
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          isSearch: true,
          isShare: false,
          isCenterIcon: true,
          appBarTitle: "",
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
          language: Globals.selectedLanguage,
          marginLeft: 30,
        ),
        body: RefreshIndicator(
          key: refreshKey,
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.85,
                child: isloadingstate!
                    ? ShimmerLoading(isLoading: true, child: _buildItem())
                    : _buildItem(),
              ),
              Container(
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
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    homebloc.add(FetchStandardNavigationBar());
  }
}
