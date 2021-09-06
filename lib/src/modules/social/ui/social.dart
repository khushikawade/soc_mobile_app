import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/social/bloc/social_bloc.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

class SocialPage extends StatefulWidget {
  SocialPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  static const double _kLabelSpacing = 16.0;
  static const double _kIconSize = 48.0;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;
  SocialBloc bloc = SocialBloc();

  void initState() {
    super.initState();
    bloc.add(SocialPageEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    bloc.add(SocialPageEvent());
    _homeBloc.add(FetchBottomNavigationBar());
  }

  Widget _buildlist(obj, int index, mainObj) {
    final document = parse(obj.description["__cdata"]);
    dom.Element? link = document.querySelector('img');
    String? imageLink = link != null ? link.attributes['src'] : '';
    print(index);
    print(imageLink);

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
          // print(index);
          // print(mainObj.length);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SliderWidget(
                        obj: mainObj,
                        currentIndex: index,
                        issocialpage: true,
                        iseventpage: false,
                        date: '1',
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )));
        },
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: _kIconSize * 1.4,
              height: _kIconSize * 1.5,
              child: imageLink != null 
                  ? ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: imageLink,
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
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )
                  : Container(
                      height: _kIconSize * 1.5,
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: Globals.homeObjet["App_Logo__c"],
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
            ),
            SizedBox(
              width: _kLabelSpacing / 2,
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      obj.title["__cdata"] != null &&
                              obj.title["__cdata"].length > 1
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.69,
                              child: Globals.selectedLanguage != null &&
                                      Globals.selectedLanguage != "English" &&
                                      Globals.selectedLanguage != ""
                                  ? TranslationWidget(
                                      message:
                                          "${obj.title["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", " ").replaceAll("\nn", "\n")}",
                                      fromLanguage: "en",
                                      toLanguage: Globals.selectedLanguage,
                                      builder: (translatedMessage) => Text(
                                          translatedMessage.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2!),
                                    )
                                  : Text(
                                      "${obj.title["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", " ").replaceAll("\nn", "\n")}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryVariant,
                                          ),
                                    ),
                            )
                          : Container()
                    ],
                  ),
                  SizedBox(height: _kLabelSpacing / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      obj.pubDate != null && obj.pubDate.length > 1
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.40,
                              child: Globals.selectedLanguage != null &&
                                      Globals.selectedLanguage != "English" &&
                                      Globals.selectedLanguage != ""
                                  ? TranslationWidget(
                                      message: Utility.convertDate(obj.pubDate)
                                          .toString(),
                                      fromLanguage: "en",
                                      toLanguage: Globals.selectedLanguage,
                                      builder: (translatedMessage) => Text(
                                          translatedMessage.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!),
                                    )
                                  : Text(
                                      Utility.convertDate(obj.pubDate)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryVariant,
                                          ),
                                    ))
                          : Container()
                    ],
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  Widget makeList(obj) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: obj.length,
      padding: EdgeInsets.only(bottom: 30),
      itemBuilder: (BuildContext context, int index) {
        return _buildlist(obj[index], index, obj!);
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          refresh: (v) {
            setState(() {});
          },
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

                if (connectivity != ConnectivityResult.none) {
                  if (iserrorstate == true) {
                    bloc.add(SocialPageEvent());
                    iserrorstate = false;
                  }
                } else if (connectivity == ConnectivityResult.none) {
                  iserrorstate = true;
                }

                return connected
                    ? Column(
                        children: <Widget>[
                          BlocBuilder(
                              bloc: bloc,
                              builder:
                                  (BuildContext context, SocialState state) {
                                if (state is SocialDataSucess) {
                                  return state.obj != null &&
                                          state.obj!.length > 0
                                      ? Expanded(child: makeList(state.obj))
                                      : Expanded(
                                          child: ListView(children: [
                                            NoDataFoundErrorWidget(
                                                isResultNotFoundMsg: false)
                                          ]),
                                        );
                                } else if (state is Loading) {
                                  return Expanded(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                  );
                                }
                                if (state is SocialError) {
                                  return ListView(
                                      shrinkWrap: true,
                                      children: [ErrorMsgWidget()]);
                                }

                                return Container();
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
                                  Globals.homeObjet = state.obj;
                                  setState(() {});
                                }
                              },
                              child: Container(
                                height: 0,
                                width: 0,
                              ),
                            ),
                          ),
                        ],
                      )
                    : NoInternetErrorWidget(
                        connected: connected, issplashscreen: false);
              },
              child: Container()),
          onRefresh: refreshPage,
        ));
  }
}
