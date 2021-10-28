import 'dart:ui';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/about/modal/aboutstafflist.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

// ignore: must_be_immutable
class StaffDirectory extends StatefulWidget {
  final List<AboutStaffDirectoryList> obj;
  bool isbuttomsheet;
  String appBarTitle;
  String? language;
  StaffDirectory(
      {Key? key,
      required this.obj,
      required this.isbuttomsheet,
      required this.appBarTitle,
      required this.language})
      : super(key: key);

  @override
  _StaffDirectoryState createState() => _StaffDirectoryState();
}

class _StaffDirectoryState extends State<StaffDirectory> {
  static const double _kLabelSpacing = 16.0;
  static const double _kIconSize = 45.0;
  static const double _KButtonMinSize = 45.0;
  UrlLauncherWidget objurl = new UrlLauncherWidget();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;
  List<AboutStaffDirectoryList> sdList = [];
  List<AboutStaffDirectoryList> sliderList = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.obj.length; i++) {
      if (widget.obj[i].department == widget.appBarTitle) {
        sdList.add(widget.obj[i]);
        //To remove url contains record from slider page
        if (widget.obj[i].urlC == null || widget.obj[i].urlC == "") {
          sliderList.add(widget.obj[i]);
        }
      }
    }
  }

  _launchURL(obj) async {
    if (obj.urlC.toString().split(":")[0] == 'http') {
      await Utility.launchUrlOnExternalBrowser(obj.urlC);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: obj.titleC ?? "",
                    url: obj.urlC,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    }
  }

  Widget staffDirectoryDetails(obj, index) {
    return GestureDetector(
      onTap: () {
        obj.urlC != null && obj.urlC != ""
            ? _launchURL(obj)
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SliderWidget(
                          obj: sliderList,
                          currentIndex: index,
                          issocialpage: false,
                          isAboutSDPage: true,
                          date: "",
                          isbuttomsheet: true,
                          language: Globals.selectedLanguage,
                        )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
        padding: EdgeInsets.symmetric(
            horizontal: _kLabelSpacing / 2, vertical: _kLabelSpacing / 1.5),
        decoration: BoxDecoration(
          border: (index % 2 == 0)
              ? Border.all(
                  color: Theme.of(context).colorScheme.background,
                )
              : Border.all(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(0.0),
          color: (index % 2 == 0)
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.secondary,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              spreadRadius: 0,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  HorzitalSpacerWidget(_kLabelSpacing / 1.5),
                  obj.imageUrlC != null
                      ? CachedNetworkImage(
                          imageUrl: obj.imageUrlC,
                          fit: BoxFit.fill,
                          width: 60,
                          height: 60,
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
                        )
                      : CustomIconWidget(
                          iconUrl:
                              "https://solved-consulting-images.s3.us-east-2.amazonaws.com/Miscellaneous/default_icon.png",
                        ),
                  HorzitalSpacerWidget(_kLabelSpacing),
                  Expanded(
                    child: Globals.selectedLanguage != null &&
                            Globals.selectedLanguage != "English" &&
                            Globals.selectedLanguage != ""
                        ? TranslationWidget(
                            message: obj.titleC ?? "-",
                            toLanguage: Globals.selectedLanguage,
                            fromLanguage: "en",
                            builder: (translatedMessage) => Text(
                                translatedMessage.toString(),
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.headline2!),
                          )
                        : Text(obj.titleC ?? "-",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.headline2!),
                  ),
                  obj.phoneC != null
                      ? Container(
                          height: _KButtonMinSize,
                          width: _KButtonMinSize,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(8),
                            ),
                            onPressed: () {
                              if (obj.phoneC != null) {
                                objurl.callurlLaucher(
                                    context, "tel:" + obj.phoneC);
                              }
                            },
                            child: Icon(
                              Icons.local_phone_outlined,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        )
                      : EmptyContainer(),
                  HorzitalSpacerWidget(_kLabelSpacing / 2),
                  obj.emailC != null
                      ? Container(
                          height: _KButtonMinSize,
                          width: _KButtonMinSize,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(6),
                              ),
                              onPressed: () {
                                if (obj.emailC != null) {
                                  objurl.callurlLaucher(
                                      context, 'mailto:"${obj.emailC}"');
                                }
                              },
                              child: Icon(
                                Icons.email_outlined,
                                color: Theme.of(context).colorScheme.background,
                              )),
                        )
                      : EmptyContainer()
                ]),
            obj.descriptionC != null
                ? SpacerWidget(_kLabelSpacing / 1.2)
                : Container(),
            Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English" &&
                    Globals.selectedLanguage != ""
                ? TranslationWidget(
                    message: obj.descriptionC ?? "-",
                    toLanguage: Globals.selectedLanguage,
                    fromLanguage: "en",
                    builder: (translatedMessage) => Text(
                        translatedMessage.toString(),
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyText1!))
                : Text(obj.descriptionC ?? "",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyText1!),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          appBarTitle: widget.appBarTitle,
          isSearch: true,
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
          isShare: false,
          isCenterIcon: true,
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
                    iserrorstate = false;
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return connected
                    ? Column(
                        children: [
                          Expanded(
                              child: sdList.length > 0
                                  ? Column(
                                      children: [
                                        SpacerWidget(_kLabelSpacing / 4),
                                        Expanded(
                                          child: ListView.builder(
                                            padding:
                                                EdgeInsets.only(bottom: 25.0),
                                            scrollDirection: Axis.vertical,
                                            itemCount: sdList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return staffDirectoryDetails(
                                                  sdList[index], index);
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : NoDataFoundErrorWidget(
                                      isResultNotFoundMsg: false,
                                      isNews: false,
                                      isEvents: false,
                                    )),
                          Container(
                            height: 0,
                            width: 0,
                            child: BlocListener<HomeBloc, HomeState>(
                                bloc: _homeBloc,
                                listener: (context, state) async {
                                  if (state is BottomNavigationBarSuccess) {
                                    AppTheme.setDynamicTheme(
                                        Globals.appSetting, context);
                                    Globals.homeObjet = state.obj;
                                    setState(() {});
                                  } else if (state is HomeErrorReceived) {
                                    ErrorMsgWidget();
                                  }
                                },
                                child: EmptyContainer()),
                          ),
                          SpacerWidget(_kLabelSpacing * 2),
                        ],
                      )
                    : NoInternetErrorWidget(
                        connected: connected, issplashscreen: false);
              },
              child: Container()),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
