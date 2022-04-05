import 'package:Soc/src/modules/custom/bloc/custom_bloc.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/custom_setting.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';

class CustomAppSection extends StatefulWidget {
  final id;
  final CustomSetting obj;
  final searchObj;
  CustomAppSection({
    Key? key,
    required this.obj,
    this.id,
    this.searchObj,
  }) : super(key: key);

  @override
  _CustomAppSectionState createState() => _CustomAppSectionState();
}

class _CustomAppSectionState extends State<CustomAppSection> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CustomBloc _bloc = CustomBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  bool? iserrorstate = false;

  @override
  void initState() {
    super.initState();
      Utility.setLocked();
    _bloc.add(CustomEvents(id: widget.obj.id));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(CustomEvents(id: widget.obj.id));
    _homeBloc.add(FetchStandardNavigationBar());
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
                  if (iserrorstate == true) {
                    _bloc.add(CustomEvents(id: widget.obj.id));
                    iserrorstate = false;
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return
                    // connected?
                    Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: BlocBuilder<CustomBloc, CustomState>(
                          bloc: _bloc,
                          builder: (BuildContext contxt, CustomState state) {
                            if (state is CustomInitial ||
                                state is CustomLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is CustomDataSucess) {
                              return CommonListWidget(
                                  scaffoldKey: _scaffoldKey,
                                  connected: connected,
                                  data: state.obj!,
                                  sectionName: "Custom");
                            } else if (state is ErrorLoading) {
                              return ListView(children: [ErrorMsgWidget()]);
                            } else {
                              return Container();
                            }
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
      key: _scaffoldKey,
      appBar: AppBarWidget(
        marginLeft: 30,
        refresh: (v) {
          setState(() {});
        },
      ),
      body: widget.obj.customBannerImageC != null &&
              widget.obj.customBannerImageC != ''
          ? NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  BannerImageWidget(
                    imageUrl: widget.obj.customBannerImageC!,
                    bgColor: widget.obj.customBannerImageC != null
                        ? Utility.getColorFromHex(
                            widget.obj.customBannerImageC!)
                        : null,
                  )
                ];
              },
              body: _body('body2'),
            )
          : _body('body1'),
    );
  }
}
