import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/schools/bloc/school_bloc.dart';
import 'package:Soc/src/modules/schools/modal/school_directory_list.dart';
import 'package:Soc/src/modules/schools/ui/school_details.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/banner_image_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class SchoolPage extends StatefulWidget {
  @override
  _SchoolPageState createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  static const double _kIconSize = 48.0;
  static const double _kLabelSpacing = 16.0;
  SchoolDirectoryBloc bloc = new SchoolDirectoryBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool iserrorstate = false;
  final HomeBloc _homeBloc = new HomeBloc();
  List<SchoolDirectoryList> newList = [];

  @override
  void initState() {
    super.initState();
    bloc.add(SchoolDirectoryListEvent());
  }

  Widget _buildnewsHeading(SchoolDirectoryList obj) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English" &&
                Globals.selectedLanguage != ""
            ? TranslationWidget(
                message: obj.titleC ?? "",
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.bodyText2!,
                ),
              )
            : Text(
                obj.titleC ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.headline4!,
              ));
  }

  Widget _buildList(SchoolDirectoryList obj, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
        vertical: _kLabelSpacing / 2,
      ),
      color: (index % 2 == 0)
          ? Theme.of(context).colorScheme.background
          : Theme.of(context).colorScheme.secondary,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SchoolDetailPage(obj: obj)));
        },
        child: Row(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                width: Globals.deviceType == "phone"
                    ? _kIconSize * 1.4
                    : _kIconSize * 2,
                height: Globals.deviceType == "phone"
                    ? _kIconSize * 1.5
                    : _kIconSize * 2,
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: obj.imageUrlC ??
                        Globals.splashImageUrl ??
                        Globals.homeObject["App_Logo__c"],
                    fit: BoxFit.cover,
                    // "https://the-noun-project-icons.s3.us-east-2.amazonaws.com/noun-school.png",
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
                    errorWidget: (context, url, error) => CachedNetworkImage(
                      imageUrl: Globals.splashImageUrl ??
                          Globals.homeObject["App_Logo__c"],
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
                    ),
                  ),
                )),
            SizedBox(
              width: _kLabelSpacing / 2,
            ),
            Expanded(
              child: Container(
                child: _buildnewsHeading(obj),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() => RefreshIndicator(
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
                  bloc.add(SchoolDirectoryListEvent());
                  iserrorstate = false;
                }
              } else if (!connected) {
                iserrorstate = true;
              }
              return connected
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: BlocBuilder<SchoolDirectoryBloc,
                                  SchoolDirectoryState>(
                              bloc: bloc,
                              builder: (BuildContext contxt,
                                  SchoolDirectoryState state) {
                                if (state is SchoolDirectoryInitial ||
                                    state is SchoolDirectoryLoading) {
                                  return Container(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator());
                                } else if (state is SchoolDirectoryDataSucess) {
                                  return newList.length > 0
                                      ? ListView.builder(
                                          padding: EdgeInsets.only(
                                              bottom: AppTheme.klistPadding),
                                          scrollDirection: Axis.vertical,
                                          itemCount: newList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return _buildList(
                                                newList[index], index);
                                          },
                                        )
                                      : NoDataFoundErrorWidget(
                                          isResultNotFoundMsg: false,
                                          isNews: false,
                                          isEvents: false,
                                        );
                                } else if (state
                                    is SchoolDirectoryErrorLoading) {
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
                                  Globals.homeObject = state.obj;
                                  setState(() {});
                                } else if (state is HomeErrorReceived) {
                                  ErrorMsgWidget();
                                }
                              },
                              child: EmptyContainer()),
                        ),
                        BlocListener<SchoolDirectoryBloc, SchoolDirectoryState>(
                            bloc: bloc,
                            listener: (context, state) async {
                              if (state is SchoolDirectoryDataSucess) {
                                newList.clear();
                                for (int i = 0; i < state.obj!.length; i++) {
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
      );

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          marginLeft: 30,
          refresh: (v) {
            setState(() {});
          },
        ),
        body: Globals.homeObject["School_Banner_Image__c"] != null &&
                Globals.homeObject["School_Banner_Image__c"] != ""
            ? NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    BannerImageWidget(
                      imageUrl: Globals.homeObject["School_Banner_Image__c"],
                      bgColor:
                          Globals.homeObject["School_Banner_Color__c"] != null
                              ? Utility.getColorFromHex(
                                  Globals.homeObject["School_Banner_Color__c"])
                              : null,
                    )
                  ];
                },
                body: _body())
            : _body());
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    bloc.add(SchoolDirectoryListEvent());
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
