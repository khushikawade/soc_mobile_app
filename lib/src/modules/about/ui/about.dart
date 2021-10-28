import 'package:Soc/src/modules/about/bloc/about_bloc.dart';
import 'package:Soc/src/modules/about/modal/aboutstafflist.dart';
import 'package:Soc/src/modules/about/ui/about_staffdirectory.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';

class AboutPage extends StatefulWidget {
  final obj;
  final searchObj;
  AboutPage({
    Key? key,
    this.obj,
    this.searchObj,
  }) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AboutBloc _bloc = AboutBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  bool? iserrorstate = false;
  List<AboutStaffDirectoryList> newList = [];
  List<String?> department = [];

  @override
  void initState() {
    super.initState();
    _bloc.add(AboutStaffDirectoryEvent());
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(AboutStaffDirectoryEvent());
    _homeBloc.add(FetchBottomNavigationBar());
  }

  Widget _buildLeading(obj) {
    return CustomIconWidget(
      iconUrl:
          "https://solved-consulting-images.s3.us-east-2.amazonaws.com/Miscellaneous/default_icon.png",
    );
  }

  Widget _buildList(
      String? dept, List<AboutStaffDirectoryList> obj, int index) {
    print(dept);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.kDividerColor2,
          width: 0.65,
        ),
        borderRadius: BorderRadius.circular(0.0),
        color: (index % 2 == 0)
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.secondary,
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => 
                  StaffDirectory(
                        appBarTitle: dept!,
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                        obj: newList,
                      )));
        },
        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
        leading: _buildLeading(obj),
        title: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English" &&
                Globals.selectedLanguage != ""
            ? TranslationWidget(
                message: dept, //.titleC,
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) {
                  return Text(translatedMessage.toString(),
                      style: Theme.of(context).textTheme.bodyText2!);
                })
            : Text(dept!, //.titleC.toString(),
                style: Theme.of(context).textTheme.bodyText1!),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: Globals.deviceType == "phone" ? 12 : 20,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
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
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              Globals.homeObjet["About_Banner_Image__c"] != null
                  ? SliverAppBar(
                      expandedHeight: AppTheme.kBannerHeight,
                      floating: false,
                      // pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        background: Image.network(
                          Globals.homeObjet["About_Banner_Image__c"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : SliverAppBar(),
            ];
          },
          body: RefreshIndicator(
            key: refreshKey,
            child: OfflineBuilder(
                connectivityBuilder: (
                  BuildContext context,
                  ConnectivityResult connectivity,
                  Widget child,
                ) {
                  final bool connected =
                      connectivity != ConnectivityResult.none;

                  if (connected) {
                    if (iserrorstate == true) {
                      _bloc.add(AboutStaffDirectoryEvent());
                      iserrorstate = false;
                    }
                  } else if (!connected) {
                    iserrorstate = true;
                  }

                  return connected
                      ? Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: BlocBuilder<AboutBloc, AboutState>(
                                  bloc: _bloc,
                                  builder:
                                      (BuildContext contxt, AboutState state) {
                                    if (state is AboutInitial ||
                                        state is AboutLoading) {
                                      return Container(
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator());
                                    } else if (state is AboutDataSucess) {
                                      department.clear();
                                      for (int i = 0; i < newList.length; i++) {
                                        department.add(newList[i].department);
                                        department =
                                            department.toSet().toList();
                                      }
                                      return department.length > 0
                                          ? ListView.builder(
                                              padding:
                                                  EdgeInsets.only(bottom: 45),
                                              scrollDirection: Axis.vertical,
                                              itemCount: department.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return _buildList(
                                                    department[index],
                                                    state.obj!,
                                                    index);
                                              },
                                            )
                                          : NoDataFoundErrorWidget(
                                              isResultNotFoundMsg: false,
                                              isNews: false,
                                              isEvents: false,
                                            );
                                    } else if (state is ErrorLoading) {
                                      return ListView(
                                          children: [ErrorMsgWidget()]);
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
                                      Globals.homeObjet = state.obj;
                                      setState(() {});
                                    }
                                  },
                                  child: EmptyContainer()),
                            ),
                            BlocListener<AboutBloc, AboutState>(
                                bloc: _bloc,
                                listener: (context, state) async {
                                  if (state is AboutDataSucess) {
                                    newList.clear();
                                    for (int i = 0;
                                        i < state.obj!.length;
                                        i++) {
                                      if (state.obj![i].statusC != "Hide") {
                                        newList.add(state.obj![i]);
                                      }
                                    }
                                  }
                                },
                                child: EmptyContainer()),
                          ],
                        )
                      : NoInternetErrorWidget(
                          connected: connected, issplashscreen: false);
                },
                child: Container()),
            onRefresh: refreshPage,
          ),
        ));
  }
}
