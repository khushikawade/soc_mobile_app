import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/button_widget.dart';
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
      child: widget.obj!.imageUrlC != null
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: _kLabelSpacing / 2),
              child: CachedNetworkImage(
                imageUrl: widget.obj!.imageUrlC,
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
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing,
        ),
        child: Text(
          widget.obj!.titleC ?? "",
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
        child: Text(
          widget.obj!.descriptionC ?? "",
          style: Theme.of(context).textTheme.headline2!.copyWith(
                fontWeight: FontWeight.w500,
              ),
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
                    
                      urlobj.callurlLaucher(context,
                          "tel:" + widget.obj!.phoneC);
                    
                  },
                  child: Text(
                    widget.obj!.phoneC ?? "" ,
                    style: Theme.of(context).textTheme.bodyText1!,
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
                      urlobj.callurlLaucher(context,
                              'mailto:"${widget.obj!.emailC}"')
                         ;
                    },
                    child: Text(
                      widget.obj!.emailC ?? '-',
                      style: Theme.of(context).textTheme.bodyText1!,
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
      _buildTitleWidget(),
      SpacerWidget(_kLabelSpacing),
      _sdImage(),
      SpacerWidget(_kLabelSpacing ),
      _buildDescriptionWidget(),
      SpacerWidget(_kLabelSpacing / 1.25),
      widget.obj!.phoneC != null
          ? _buildPhoneWidget()
          : Container(),
      SpacerWidget(_kLabelSpacing / 1.25),
      widget.obj!.emailC != null
          ? _buildEmailWidget()
          : Container(),
          SpacerWidget(_kLabelSpacing / 1.25),
          ButtonWidget(title: "Share",)
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: CustomAppBarWidget(
        //   isSearch: true,
        //   isShare: false,
        //   appBarTitle: "widget.obj.titleC",
        //   sharedpopBodytext: '',
        //   sharedpopUpheaderText: '',
        //   language: Globals.selectedLanguage,
        //   marginLeft: 30,
        // ),
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
