import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/common_image_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class StaffDirectory extends StatefulWidget {
  final bool isCustom;
  final bool? isSubmenu;
  final obj;
  final bool isbuttomsheet;
  final String appBarTitle;
  final String? language;
  final String?
      staffDirectoryCategoryId; // To support categories staff list which is used in the District template.
  final bool isAbout;

  StaffDirectory(
      {Key? key,
      required this.obj,
      required this.isbuttomsheet,
      required this.appBarTitle,
      required this.language,
      required this.isAbout,
      this.staffDirectoryCategoryId,
      required this.isCustom,
      this.isSubmenu})
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
    //Utility.setLocked();
    super.initState();
    if (widget.staffDirectoryCategoryId != null) {
      _bloc.add(SDevent(categoryId: widget.staffDirectoryCategoryId));
    } else {
      _bloc.add(SDevent(
          customRecordId: widget.isCustom && widget.isSubmenu == true
              ? widget.obj.id
              : null));
    }
    Globals.callsnackbar = true;
  }

  Widget listItem(list, obj, index) {
    return GestureDetector(
      onTap: () async {
        // if (widget.isAbout == true) {
        //lock screen orientation
        // Utility.setLocked();
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SliderWidget(
                      obj: list,
                      currentIndex: index,
                      issocialpage: false,
                      isAboutSDPage: widget.isAbout, // true,
                      isNewsPage: false,
                      // iseventpage: false,
                      date: "",
                      isbuttomsheet: true,
                      language: Globals.selectedLanguage,
                    )));
        //lock screen orientation
        // Utility.setLocked();
        // }
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
                  CommonImageWidget(
                      darkModeIconUrl: obj.darkModeIconC,
                      height: Globals.deviceType == "phone"
                          ? _kIconSize * 1.4
                          : _kIconSize * 2,
                      width: Globals.deviceType == "phone"
                          ? _kIconSize * 1.4
                          : _kIconSize * 2,
                      fitMethod: BoxFit.cover,
                      iconUrl: obj.imageUrlC ??
                          Globals.splashImageUrl ??
                          Globals.appSetting.appLogoC),
                  HorzitalSpacerWidget(_kLabelSpacing),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TranslationWidget(
                          message: obj.name ?? "-",
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                              translatedMessage.toString(),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.headline2!),
                        ),
                        obj.designation != null && obj.designation != ""
                            ? TranslationWidget(
                                message: obj.designation,
                                toLanguage: Globals.selectedLanguage,
                                fromLanguage: "en",
                                builder: (translatedMessage) => Text(
                                    translatedMessage.toString(),
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.headline2!),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  obj.phoneC != null && obj.phoneC != ""
                      ? Container(
                          height: _KButtonMinSize,
                          width: _KButtonMinSize,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(8),
                            ),
                            onPressed: () {
                              Utility.launchUrlOnExternalBrowser(
                                  "tel:" + obj.phoneC);
                            },
                            child: Icon(
                              Icons.local_phone_outlined,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        )
                      : EmptyContainer(),
                  HorzitalSpacerWidget(_kLabelSpacing / 2),
                  obj.emailC != null && obj.emailC != ""
                      ? Container(
                          height: _KButtonMinSize,
                          width: _KButtonMinSize,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(6),
                              ),
                              onPressed: () {
                                Utility.launchUrlOnExternalBrowser(
                                    "mailto:" + obj.emailC);
                              },
                              child: Icon(
                                Icons.email_outlined,
                                color: Theme.of(context).colorScheme.background,
                              )),
                        )
                      : EmptyContainer()
                ]),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.isSubmenu == true
            ? CustomAppBarWidget(
                marginLeft: 30,
                appBarTitle: widget.appBarTitle,
                isSearch: true,
                sharedpopBodytext: '',
                sharedpopUpheaderText: '',
                isShare: false,
                isCenterIcon: true,
                language: Globals.selectedLanguage,
              )
            : widget.isSubmenu == false
                ? AppBarWidget(
                    marginLeft: 30,
                    refresh: (v) {
                      setState(() {});
                    },
                  )
                : null,
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
                      _bloc.add(SDevent(
                          customRecordId:
                              widget.isCustom ? widget.obj.id : null));
                    }
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return
                    // connected  ?
                    Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<FamilyBloc, FamilyState>(
                          bloc: _bloc,
                          builder: (BuildContext contxt, FamilyState state) {
                            if (state is FamilyInitial ||
                                state is FamilyLoading) {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant,
                                  ));
                            } else if (state is SDDataSucess) {
                              return state.obj != null && state.obj!.length > 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: state.obj!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return listItem(state.obj,
                                            state.obj![index], index);
                                      },
                                    )
                                  : NoDataFoundErrorWidget(
                                      isResultNotFoundMsg: false,
                                      isNews: false,
                                      isEvents: false,
                                      connected: connected,
                                    );
                            } else if (state is ErrorLoading) {
                              return ListView(children: [ErrorMsgWidget()]);
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

                              Globals.appSetting =
                                  AppSetting.fromJson(state.obj);
                              setState(() {});
                            } else if (state is HomeErrorReceived) {
                              ErrorMsgWidget();
                            }
                          },
                          child: EmptyContainer()),
                    ),
                    SpacerWidget(_kLabelSpacing * 2),
                  ],
                );
                // : NoInternetErrorWidget(
                //     connected: connected, issplashscreen: false);
              },
              child: Container()),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if (widget.staffDirectoryCategoryId != null) {
      _bloc.add(SDevent(categoryId: widget.staffDirectoryCategoryId));
    } else {
      _bloc
          .add(SDevent(customRecordId: widget.isCustom ? widget.obj.id : null));
    }
    _homeBloc.add(FetchStandardNavigationBar());
  }
}
