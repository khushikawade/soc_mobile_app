import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/about/bloc/about_bloc.dart';
import 'package:Soc/src/modules/custom/bloc/custom_bloc.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/resources/bloc/resources_bloc.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class SubListPage extends StatefulWidget {
  final obj;
  final recordId;
  final String? module;
  final bool isbuttomsheet;
  final String appBarTitle;
  final String? language;

  SubListPage(
      {Key? key,
      required this.obj,
      this.recordId,
      required this.module,
      required this.isbuttomsheet,
      required this.appBarTitle,
      required this.language})
      : super(key: key);
  @override
  _SubListPageState createState() => _SubListPageState();
}

class _SubListPageState extends State<SubListPage> {
  FocusNode myFocusNode = new FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ResourcesBloc _resourceBloc = ResourcesBloc();
  FamilyBloc _bloc = FamilyBloc();
  StaffBloc _staffBloc = StaffBloc();
  AboutBloc _aboutBloc = AboutBloc();
  CustomBloc _customBloc = CustomBloc();
  bool? iserrorstate = false;

  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    if (widget.module == "family") {
      _bloc.add(FamiliesSublistEvent(id: widget.obj.id));
    } else if (widget.module == "staff") {
      _staffBloc.add(StaffSubListEvent(id: widget.obj.id));
    } else if (widget.module == "resources") {
      _resourceBloc.add(ResourcesSublistEvent(id: widget.obj.id));
    } else if (widget.module == "about") {
      _aboutBloc.add(AboutSublistEvent(id: widget.obj.id));
    } else if (widget.module == "Custom") {
      _customBloc.add(CustomSublistEvent(id: widget.obj.id));
    }
  }

  _body(bool connected) => RefreshIndicator(
        key: refreshKey,
        onRefresh: refreshPage,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            widget.module == "family"
                ? Expanded(
                    child: BlocBuilder<FamilyBloc, FamilyState>(
                        bloc: _bloc,
                        builder: (BuildContext contxt, FamilyState state) {
                          if (state is FamilyInitial ||
                              state is FamilyLoading) {
                            return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant,
                                ));
                          } else if (state is FamiliesSublistSucess) {
                            return CommonListWidget(
                                scaffoldKey: _scaffoldKey,
                                connected: connected,
                                data: state.obj!,
                                sectionName: 'family');
                          } else {
                            return Container();
                          }
                        }),
                  )
                : widget.module == 'staff'
                    ? Expanded(
                        child: BlocBuilder<StaffBloc, StaffState>(
                            bloc: _staffBloc,
                            builder: (BuildContext contxt, StaffState state) {
                              if (state is StaffInitial ||
                                  state is StaffLoading) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.75,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                    ));
                              } else if (state is StaffSubListSucess) {
                                return CommonListWidget(
                                    scaffoldKey: _scaffoldKey,
                                    connected: connected,
                                    data: state.obj!,
                                    sectionName: 'staff');
                              } else {
                                return Container();
                              }
                            }),
                      )
                    : widget.module == "resources"
                        ? Expanded(
                            child: BlocBuilder<ResourcesBloc, ResourcesState>(
                                bloc: _resourceBloc,
                                builder: (BuildContext contxt,
                                    ResourcesState state) {
                                  if (state is ResourcesInitial ||
                                      state is ResourcesLoading) {
                                    return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.75,
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryVariant,
                                        ));
                                  } else if (state is ResourcesSubListSucess) {
                                    return CommonListWidget(
                                        scaffoldKey: _scaffoldKey,
                                        connected: connected,
                                        data: state.obj!,
                                        sectionName: 'resources');
                                  } else {
                                    return Container();
                                  }
                                }),
                          )
                        : widget.module == "about"
                            ? Expanded(
                                child: BlocBuilder<AboutBloc, AboutState>(
                                    bloc: _aboutBloc,
                                    builder: (BuildContext contxt,
                                        AboutState state) {
                                      if (state is AboutInitial ||
                                          state is AboutLoading) {
                                        return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.75,
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryVariant,
                                            ));
                                      } else if (state is AboutSublistSucess) {
                                        return CommonListWidget(
                                            scaffoldKey: _scaffoldKey,
                                            connected: connected,
                                            data: state.obj!,
                                            sectionName: 'about');
                                      } else {
                                        return Container();
                                      }
                                    }),
                              )
                            : widget.module == "Custom"
                                ? Expanded(
                                    child: BlocBuilder<CustomBloc, CustomState>(
                                        bloc: _customBloc,
                                        builder: (BuildContext contxt,
                                            CustomState state) {
                                          if (state is CustomInitial ||
                                              state is CustomLoading) {
                                            return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.75,
                                                alignment: Alignment.center,
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (state
                                              is CustomSublistSuccess) {
                                            return CommonListWidget(
                                              scaffoldKey: _scaffoldKey,
                                              connected: connected,
                                              data: state.obj!,
                                              sectionName: 'Custom',
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  )
                                : Expanded(
                                    child: NoDataFoundErrorWidget(
                                      isResultNotFoundMsg: false,
                                      isNews: false,
                                      isEvents: false,
                                    ),
                                  ),
          ],
        ),
      );

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBarWidget(
          isSearch: true,
          isShare: false,
          appBarTitle: widget.appBarTitle,
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
          language: Globals.selectedLanguage,
        ),
        body: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;
              if (connected) {
                if (iserrorstate == true) {
                  refreshPage();
                  iserrorstate = false;
                }
              } else if (!connected) {
                iserrorstate = true;
              }

              return _body(connected);
            },
            child: Container()));
  }

  Future refreshPage() async {
    if (widget.module == "family") {
      _bloc.add(FamiliesSublistEvent(id: widget.obj.id));
    } else if (widget.module == "staff") {
      _staffBloc.add(StaffSubListEvent(id: widget.obj.id));
    } else if (widget.module == "resources") {
      _resourceBloc.add(ResourcesSublistEvent(id: widget.obj.id));
    } else if (widget.module == "about") {
      _aboutBloc.add(AboutSublistEvent(id: widget.obj.id));
    }
    await Future.delayed(Duration(seconds: 2));
    refreshKey.currentState?.show(atTop: false);
  }
}
