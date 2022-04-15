import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/schools_directory/bloc/school_bloc.dart';
import 'package:Soc/src/modules/shared/ui/common_school_directory_widget.dart';
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
  final bool? isStanderdPage;
  final bool? isSubmenu;
  final String? title;

  const SchoolDirectoryPage(
      {Key? key, this.obj, this.isStanderdPage, this.isSubmenu, this.title})
      : super(key: key);

  @override
  _SchoolDirectoryPageState createState() => _SchoolDirectoryPageState();
}

class _SchoolDirectoryPageState extends State<SchoolDirectoryPage> {
  // static const double _kIconSize = 48.0;
  // static const double _kLabelSpacing = 16.0;
  SchoolDirectoryBloc bloc = new SchoolDirectoryBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool iserrorstate = false;
  final HomeBloc _homeBloc = new HomeBloc();

  @override
  void initState() {
    //lock screen orientation
    //Utility.setLocked();
    super.initState();
    bloc.add(SchoolDirectoryListEvent(
        customRecordId: widget.isStanderdPage != false ? null : widget.obj.id,
        isSubMenu: widget.isSubmenu));
  }

  // Widget _buildnewsHeading(SchoolDirectoryList obj) {
  //   return Container(
  //       alignment: Alignment.centerLeft,
  //       child: Globals.selectedLanguage != null &&
  //               Globals.selectedLanguage != "English" &&
  //               Globals.selectedLanguage != ""
  //           ? TranslationWidget(
  //               message: obj.titleC ?? "",
  //               fromLanguage: "en",
  //               toLanguage: Globals.selectedLanguage,
  //               builder: (translatedMessage) => Text(
  //                 translatedMessage.toString(),
  //                 style: Theme.of(context).textTheme.bodyText2!,
  //               ),
  //             )
  //           : Text(
  //               obj.titleC ?? "",
  //               overflow: TextOverflow.ellipsis,
  //               maxLines: 2,
  //               style: Theme.of(context).textTheme.headline4!,
  //             ));
  // }

  // Widget _buildList(SchoolDirectoryList obj, int index) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(
  //       horizontal: _kLabelSpacing,
  //       vertical: _kLabelSpacing / 2,
  //     ),
  //     color: (index % 2 == 0)
  //         ? Theme.of(context).colorScheme.background
  //         : Theme.of(context).colorScheme.secondary,
  //     child: InkWell(
  //       onTap: () async {
  //         //free screen orientation
  //         //  Utility.setFree();
  //         await Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => SchoolDetailPage(obj: obj)));
  //         //Utility.setLocked();
  //       },
  //       child: Row(
  //         children: <Widget>[
  //           Container(
  //               alignment: Alignment.center,
  //               width: Globals.deviceType == "phone"
  //                   ? _kIconSize * 1.4
  //                   : _kIconSize * 2,
  //               height: Globals.deviceType == "phone"
  //                   ? _kIconSize * 1.5
  //                   : _kIconSize * 2,
  //               child: ClipRRect(
  //                   child: CommonImageWidget(
  //                 darkModeIconUrl: obj.darkModeIconC,
  //                 height: Globals.deviceType == "phone"
  //                     ? _kIconSize * 1.4
  //                     : _kIconSize * 2,
  //                 width: Globals.deviceType == "phone"
  //                     ? _kIconSize * 1.4
  //                     : _kIconSize * 2,
  //                 iconUrl: obj.imageUrlC ??
  //                     Globals.splashImageUrl ??
  //                     Globals.appSetting.appLogoC,
  //                 fitMethod: BoxFit.cover,
  //               ))),
  //           SizedBox(
  //             width: _kLabelSpacing / 2,
  //           ),
  //           Expanded(
  //             child: Container(
  //               child: _buildnewsHeading(obj),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                  if (iserrorstate == true) {
                    bloc.add(SchoolDirectoryListEvent(
                        customRecordId: widget.isStanderdPage != false
                            ? null
                            : widget.obj.id,
                        isSubMenu: widget.isSubmenu));
                    iserrorstate = false;
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }
                return
                    // connected ?
                    Stack(
                  // mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
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
                              data: state.obj!,
                            );
                            // state.obj!.length > 0
                            //     ? ListView.builder(
                            //         key: ValueKey(key),
                            //         padding: EdgeInsets.only(
                            //             bottom: AppTheme.klistPadding),
                            //         scrollDirection: Axis.vertical,
                            //         itemCount: state.obj!.length,
                            //         itemBuilder:
                            //             (BuildContext context, int index) {
                            //           return _buildList(
                            //               state.obj![index], index);
                            //         },
                            //       )
                            //     : NoDataFoundErrorWidget(
                            //         isCalendarPageOrientationLandscape: false,
                            //         isResultNotFoundMsg: false,
                            //         isNews: false,
                            //         isEvents: false,
                            //         connected: connected,
                            //       );
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
                // : NoInternetErrorWidget(
                //     connected: connected, issplashscreen: false);
              },
              child: Container()),
          onRefresh: refreshPage,
        ),
      );

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.isStanderdPage == true
            ? AppBarWidget(
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
        body: widget.isSubmenu == true &&
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
        customRecordId: widget.isStanderdPage != false ? null : widget.obj.id,
        isSubMenu: widget.isSubmenu));
    _homeBloc.add(FetchStandardNavigationBar());
  }
}
