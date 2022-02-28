import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class StaffPage extends StatefulWidget {
  StaffPage({Key? key, this.title, this.language}) : super(key: key);
  final String? title;
  final String? language;

  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  // static const double _kLabelSpacing = 16.0;
  FocusNode myFocusNode = new FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  StaffBloc _bloc = StaffBloc();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;

  @override
  void initState() {
    super.initState();
    _bloc.add(StaffPageEvent());
  }

  Widget _body(String key) => RefreshIndicator(
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
                _bloc.add(StaffPageEvent());
              }
            } else if (!connected) {
              iserrorstate = true;
            }

            return
                // connected?
                Container(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                Expanded(
                  child: BlocBuilder<StaffBloc, StaffState>(
                      bloc: _bloc,
                      builder: (BuildContext contxt, StaffState state) {
                        if (state is StaffInitial || state is StaffLoading) {
                          return Center(child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primaryVariant,
                          ));
                        } else if (state is StaffDataSucess) {
                          return CommonListWidget(
                              key: ValueKey(key),
                              scaffoldKey: _scaffoldKey,
                              connected: connected,
                              data: state.obj!,
                              sectionName: "staff");
                        } else if (state is ErrorInStaffLoading) {
                          return ListView(children: [ErrorMsgWidget()]);
                        } else {
                          return ErrorMsgWidget();
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
                          AppTheme.setDynamicTheme(Globals.appSetting, context);
                     //     Globals.homeObject = state.obj;
                          Globals.appSetting = AppSetting.fromJson(state.obj);

                          setState(() {});
                        }
                      },
                      child: EmptyContainer()),
                ),
                // BlocListener<StaffBloc, StaffState>(
                //     bloc: _bloc,
                //     listener: (context, state) async {
                //       if (state is StaffDataSucess) {
                //         newList.clear();
                //         for (int i = 0; i < state.obj!.length; i++) {
                //           if (state.obj![i].status != "Hide") {
                //             newList.add(state.obj![i]);
                //           }
                //         }
                //       }
                //     },
                //     child: EmptyContainer()),
              ]),
            );
            // : NoInternetErrorWidget(
            //     connected: connected, issplashscreen: false);
          },
          child: Container()),
      onRefresh: refreshPage);

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(
        marginLeft: 30,
        refresh: (v) {
          setState(() {});
        },
      ),
      body: Globals.appSetting.staffBannerImageC != null &&
              Globals.appSetting.staffBannerImageC  != ''
      //  Globals.homeObject["Staff_Banner_Image__c"] != null &&
      //         Globals.homeObject["Staff_Banner_Image__c"] != ''
          ? NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  BannerImageWidget(
                    imageUrl: Globals.appSetting.staffBannerImageC!, 
                    //Globals.homeObject["Staff_Banner_Image__c"],
                    bgColor: Globals.appSetting.studentBannerColorC != null
                    // Globals.homeObject["Staff_Banner_Color__c"] != null
                        ? Utility.getColorFromHex(
                          Globals.appSetting.studentBannerColorC!
                            // Globals.homeObject["Staff_Banner_Color__c"]
                            )
                        : null,
                  )
                ];
              },
              body: _body('body1'),
            )
          : _body('body2'),
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(StaffPageEvent());
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
