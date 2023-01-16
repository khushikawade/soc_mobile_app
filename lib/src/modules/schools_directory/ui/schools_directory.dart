import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/schools_directory/bloc/school_bloc.dart';
import 'package:Soc/src/modules/shared/ui/common_school_directory_widget.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class SchoolDirectoryPage extends StatefulWidget {
  final obj;
  final bool? isStandardPage;
  final bool? isSubmenu;
  final String? title;
  final bool? isCustomSection;

  const SchoolDirectoryPage(
      {Key? key,
      this.obj,
      required this.isStandardPage,
      this.isSubmenu,
      this.title,
      required,
      required this.isCustomSection})
      : super(key: key);

  @override
  _SchoolDirectoryPageState createState() => _SchoolDirectoryPageState();
}

class _SchoolDirectoryPageState extends State<SchoolDirectoryPage> {
  // static const double _kIconSize = 48.0;
  // static const double _kLabelSpacing = 16.0;
  SchoolDirectoryBloc bloc = new SchoolDirectoryBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isErrorState = false;
  final HomeBloc _homeBloc = new HomeBloc();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    //lock screen orientation
    //Utility.setLocked();
    super.initState();
    bloc.add(SchoolDirectoryListEvent(
        customRecordId: widget.isStandardPage != false ? null : widget.obj.id,
        isSubMenu: widget.isSubmenu));

    FirebaseAnalyticsService.addCustomAnalyticsEvent("school_directory_page");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'school_directory_page',
        screenClass: 'SchoolDirectoryPage');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _body(String key) => Container(
        child: RefreshIndicator(
          key: refreshKey,
          child: OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                final bool connected = connectivity != ConnectivityResult.none;
                if (connected) {
                  if (isErrorState == true) {
                    bloc.add(SchoolDirectoryListEvent(
                        customRecordId: widget.isStandardPage != false
                            ? null
                            : widget.obj.id,
                        isSubMenu: widget.isSubmenu));
                    isErrorState = false;
                  }
                } else if (!connected) {
                  isErrorState = true;
                }
                return Stack(
                  children: [
                    BlocBuilder<SchoolDirectoryBloc, SchoolDirectoryState>(
                        bloc: bloc,
                        builder:
                            (BuildContext contxt, SchoolDirectoryState state) {
                          if (state is SchoolDirectoryInitial ||
                              state is SchoolDirectoryLoading) {
                            return Container(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant,
                                ));
                          } else if (state is SchoolDirectoryDataSucess) {
                            return CommonSchoolDirectoryWidget(
                              scrollController: _scrollController,
                              data: state.obj!,
                            );
                          } else if (state is SchoolDirectoryErrorLoading) {
                            return ListView(children: [ErrorMsgWidget()]);
                          } else {
                            return Container();
                          }
                        }),
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
                  ],
                );
              },
              child: Container()),
          onRefresh: refreshPage,
        ),
      );

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.isStandardPage == true
            ? AppBarWidget(
                onTap: () {
                  Utility.scrollToTop(scrollController: _scrollController);
                },
                marginLeft: 30,
                refresh: (v) {
                  setState(() {});
                },
              )
            : (widget.isSubmenu == true
                ? CustomAppBarWidget(
                    isSearch: true,
                    isShare: false,
                    sharedpopBodytext: '',
                    sharedpopUpheaderText: '',
                    appBarTitle: widget.title ?? '',
                    language: Globals.selectedLanguage,
                  )
                : null),
        body: widget.isCustomSection == false &&
                widget.isSubmenu == true &&
                Globals.appSetting.schoolBannerImageC != null &&
                Globals.appSetting.schoolBannerImageC != "" &&
                widget.isSubmenu != true
            ? NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    BannerImageWidget(
                      imageUrl: Globals.appSetting.schoolBannerImageC!,
                      bgColor: Globals.appSetting.schoolBannerColorC != null
                          ? Utility.getColorFromHex(
                              Globals.appSetting.schoolBannerColorC!)
                          : null,
                    )
                  ];
                },
                body: _body('body1'))
            : _body('body2'));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    bloc.add(SchoolDirectoryListEvent(
        customRecordId: widget.isStandardPage != false ? null : widget.obj.id,
        isSubMenu: widget.isSubmenu));
    _homeBloc.add(FetchStandardNavigationBar());
  }
}
