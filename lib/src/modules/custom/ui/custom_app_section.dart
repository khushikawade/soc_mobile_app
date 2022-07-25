import 'package:Soc/src/modules/custom/bloc/custom_bloc.dart';
import 'package:Soc/src/modules/custom/ui/custom_page.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
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
import '../../home/ui/app_bar_widget.dart';
import '../model/custom_setting.dart';

class CustomAppSection extends StatefulWidget {
  final id;
  final CustomSetting customObj;
  final searchObj;

  CustomAppSection({
    Key? key,
    required this.customObj,
    this.id,
    this.searchObj,
  }) : super(key: key);
  @override
  _CustomAppSectionState createState() => _CustomAppSectionState();
}

class _CustomAppSectionState extends State<CustomAppSection> {
  bool? iserrorstate = false;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  CustomBloc _bloc = CustomBloc();
  HomeBloc _homeBloc = HomeBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _bloc.add(CustomEvents(id: widget.customObj.id));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _bloc.add(CustomEvents(id: widget.customObj.id));
    _homeBloc.add(FetchStandardNavigationBar());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(
        marginLeft: 30,
        refresh: (v) {
          setState(() {});
        },
      ),
      body: widget.customObj.customBannerImageC != null &&
              widget.customObj.customBannerImageC != ''
          ? NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  BannerImageWidget(
                      imageUrl: widget.customObj.customBannerImageC!,
                      bgColor: widget.customObj.customBannerColorC != null
                          ? Utility.getColorFromHex(
                              widget.customObj.customBannerColorC!)
                          : Colors.transparent)
                ];
              },
              body: _body('body2'),
            )
          : _body('body1'),
    );
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
                    _bloc.add(CustomEvents(id: widget.customObj.id));
                    iserrorstate = false;
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return
                    // connected?
                    Stack(
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    BlocBuilder<CustomBloc, CustomState>(
                        bloc: _bloc,
                        builder: (BuildContext contxt, CustomState state) {
                          if (state is CustomInitial ||
                              state is CustomLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is CustomDataSucess) {
                            return CustomPages(
                              customList: state.obj,
                              customObj: widget.customObj,
                            );
                          } else if (state is ErrorLoading) {
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
}
