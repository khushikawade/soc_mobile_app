import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/button_widget.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_offline/flutter_offline.dart';

// ignore: must_be_immutable
class AboutSDDetailPage extends StatefulWidget {
  final obj;
  AboutSDDetailPage({
    Key? key,
    required this.obj,
  }) : super(key: key);

  @override
  _AboutSDDetailPageState createState() => _AboutSDDetailPageState();
}

class _AboutSDDetailPageState extends State<AboutSDDetailPage> {
  static const double _kLabelSpacing = 16.0;
  // static const double _kboxheight = 60.0;
  static const double _kIconSize = 48.0;
  bool issuccesstate = false;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  final HomeBloc homebloc = new HomeBloc();
  bool? iserrorstate = false;
  static const double _kboxborderwidth = 0.75;
  bool? isloadingstate = false;

  Widget _sdImage() {
    return Container(
        child: CustomIconWidget(
      iconUrl: widget.obj!.imageUrlC ??
          Globals.splashImageUrl ??
          Globals.homeObject["App_Logo__c"],
      height: Utility.displayHeight(context) *
          (AppTheme.kDetailPageImageHeightFactor / 100),
      fitMethod: BoxFit.fitHeight,
      isOnTap: true,
    ));
  }

  Widget _buildTitleWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing,
        ),
        child: Text(
          widget.obj!.titleC ?? "",
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headline2!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ));
  }

  Widget _buildNameWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing,
        ),
        child: Text(
          widget.obj!.name ?? "",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ));
  }

  Widget _buildDescriptionWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing,
        ),
        // TODO: Replace text with HTML // text: widget.obj!.descriptionC ?? "",
        child: Linkify(
          onOpen: (link) => Utility.launchUrlOnExternalBrowser(link.url),
          options: LinkifyOptions(humanize: false),
          linkStyle: TextStyle(color: Colors.blue),
          text: widget.obj!.descriptionC ?? "",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(),
        ));
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
        child: Padding(
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
                    urlobj.callurlLaucher(context, "tel:" + widget.obj!.phoneC);
                  },
                  child: Text(
                    widget.obj!.phoneC ?? "",
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
              )
            ],
          ),
        ),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Globals.selectedLanguage != null &&
                        Globals.selectedLanguage != "English" &&
                        Globals.selectedLanguage != ""
                    ? TranslationWidget(
                        message: "Email :",
                        toLanguage: Globals.selectedLanguage,
                        fromLanguage: "en",
                        builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: InkWell(
                    onTap: () {
                      urlobj.callurlLaucher(
                          context, 'mailto:"${widget.obj!.emailC}"');
                    },
                    child: Text(
                      widget.obj!.emailC ?? '-',
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
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _buildItem() {
    return ListView(padding: const EdgeInsets.only(bottom: 35.0), children: [
      SpacerWidget(_kLabelSpacing / 1.5),
      _buildNameWidget(),
      SpacerWidget(_kLabelSpacing),
      _sdImage(),
      SpacerWidget(_kLabelSpacing),
      _buildTitleWidget(),
      SpacerWidget(_kLabelSpacing),
      _buildDescriptionWidget(),
      // SpacerWidget(_kLabelSpacing / 1.25),
      widget.obj!.phoneC != null
          ? Padding(
              padding: const EdgeInsets.only(top: _kLabelSpacing / 1.25),
              child: _buildPhoneWidget(),
            )
          : Container(),
      // SpacerWidget(_kLabelSpacing / 1.25),
      widget.obj!.emailC != null
          ? Padding(
              padding: const EdgeInsets.only(top: _kLabelSpacing / 1.25),
              child: _buildEmailWidget(),
            )
          : Container(),
      SpacerWidget(_kLabelSpacing),
      ButtonWidget(
        title: widget.obj!.titleC ?? "",
        buttonTitle: "Share",
        obj: widget.obj,
        body:
            "${widget.obj!.descriptionC != null ? widget.obj!.descriptionC.toString() : ""}" +
                "\n" +
                "${widget.obj!.imageUrlC ?? ""}" +
                "\n" +
                "${"Phone : " + widget.obj!.phoneC.toString()}" +
                // "\n" +
                "${"Email : " + widget.obj!.emailC.toString()}",
      ),
      SpacerWidget(_kLabelSpacing / 2),
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
                                  Globals.homeObject = state.obj;
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
                      Globals.homeObject = state.obj;
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
