import 'dart:ui';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
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
  final obj;
  bool isbuttomsheet;
  String appBarTitle;
  String? language;
  String?
      staffDirectoryCategoryId; // To support categories staff list which is used in the District template.
  bool isAbout;
  StaffDirectory(
      {Key? key,
      required this.obj,
      required this.isbuttomsheet,
      required this.appBarTitle,
      required this.language,
      required this.isAbout,
      this.staffDirectoryCategoryId})
      : super(key: key);

  @override
  _StaffDirectoryState createState() => _StaffDirectoryState();
}

class _StaffDirectoryState extends State<StaffDirectory> {
  static const double _kLabelSpacing = 16.0;
  static const double _kIconSize = 45.0;
  static const double _KButtonMinSize = 45.0;
  String? language = Globals.selectedLanguage;
  FamilyBloc _bloc = FamilyBloc();
  UrlLauncherWidget objurl = new UrlLauncherWidget();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;

  @override
  void initState() {
    super.initState();
    if (widget.staffDirectoryCategoryId != null) {
      _bloc.add(SDevent(categoryId: widget.staffDirectoryCategoryId));
    } else {
      _bloc.add(SDevent());
    }

    Globals.callsnackbar = true;
  }

  Widget _buildHeading(String tittle) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _kLabelSpacing * 1.2),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          width: 0,
        ),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English" &&
                  Globals.selectedLanguage != ""
              ? TranslationWidget(
                  message: tittle,
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.headline6!,
                  ),
                )
              : Text(tittle, style: Theme.of(context).textTheme.headline6!),
        ],
      ),
    );
  }

  Widget listItem(list, obj, index) {
    return Container(
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
      child: GestureDetector(
        onTap: () {
          if (widget.isAbout == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SliderWidget(
                          obj: list,
                          currentIndex: index,
                          issocialpage: false,
                          isAboutSDPage: widget.isAbout,
                          isEvent: false,
                          date: "",
                          isbuttomsheet: true,
                          language: Globals.selectedLanguage,
                        )));
          }
        },
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
                      : Container(
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              width: 60,
                              height: 60,
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
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                  HorzitalSpacerWidget(_kLabelSpacing),
                  Expanded(
                    child: Globals.selectedLanguage != null &&
                            Globals.selectedLanguage != "English" &&
                            Globals.selectedLanguage != ""
                        ? TranslationWidget(
                            message: obj.name ?? "-",
                            toLanguage: Globals.selectedLanguage,
                            fromLanguage: "en",
                            builder: (translatedMessage) => Text(
                                translatedMessage.toString(),
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.headline2!),
                          )
                        : Text(obj.name ?? "-",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.headline2!),
                  ),
                  obj.phoneC.toString().isNotEmpty
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
                  obj.emailC.toString().isNotEmpty
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
            widget.isAbout
                ? Container()
                : Column(
                    children: [
                      SpacerWidget(_kLabelSpacing / 1.2),
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
                                  style:
                                      Theme.of(context).textTheme.bodyText1!))
                          : Text(obj.descriptionC ?? "",
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyText1!),
                    ],
                  ),
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
                    if (widget.staffDirectoryCategoryId != null) {
                      _bloc.add(
                          SDevent(categoryId: widget.staffDirectoryCategoryId));
                    } else {
                      _bloc.add(SDevent());
                    }
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return connected
                    ? Column(
                        children: [
                          Expanded(
                            child: BlocBuilder<FamilyBloc, FamilyState>(
                                bloc: _bloc,
                                builder:
                                    (BuildContext contxt, FamilyState state) {
                                  if (state is FamilyInitial ||
                                      state is FamilyLoading) {
                                    return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator());
                                  } else if (state is SDDataSucess) {
                                    return state.obj != null &&
                                            state.obj!.length > 0
                                        ? Column(
                                            children: [
                                              widget.isAbout == true
                                                  ? Container()
                                                  : _buildHeading(
                                                      "STAFF DIRECTORY"),
                                              SpacerWidget(_kLabelSpacing / 4),
                                              Expanded(
                                                child: ListView.builder(
                                                  padding: EdgeInsets.only(
                                                      bottom: 25.0),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: state.obj!.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return listItem(
                                                        state.obj,
                                                        state.obj![index],
                                                        index);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : NoDataFoundErrorWidget(
                                            isResultNotFoundMsg: false,
                                            isNews: false,
                                            isEvents: false,
                                          );
                                  } else if (state is ErrorLoading) {
                                    return ListView(
                                        children: [ErrorMsgWidget()]);
                                  }
                                  return Container();
                                }),
                          ),
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
    if (widget.staffDirectoryCategoryId != null) {
      _bloc.add(SDevent(categoryId: widget.staffDirectoryCategoryId));
    } else {
      _bloc.add(SDevent());
    }
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
