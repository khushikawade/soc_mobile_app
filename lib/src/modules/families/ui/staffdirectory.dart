import 'dart:ui';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/error_message_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

// ignore: must_be_immutable
class StaffDirectory extends StatefulWidget {
  final obj;
  bool isbuttomsheet;
  String appBarTitle;
  String? language;
  StaffDirectory(
      {Key? key,
      required this.obj,
      required this.isbuttomsheet,
      required this.appBarTitle,
      required this.language})
      : super(key: key);

  @override
  _StaffDirectoryState createState() => _StaffDirectoryState();
}

class _StaffDirectoryState extends State<StaffDirectory> {
  static const double _kLabelSpacing = 16.0;
  static const double _kIconSize = 45.0;
  final _controller = TextEditingController();
  String? language = Globals.selectedLanguage;
  FamilyBloc _bloc = FamilyBloc();
  UrlLauncherWidget objurl = new UrlLauncherWidget();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  bool? iserrorstate = false;

  @override
  void initState() {
    super.initState();
    _bloc.add(SDevent());
  }

  Widget _buildHeading(String tittle) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _kLabelSpacing * 1.2),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          width: 0,
        ),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message: tittle,
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                )
              : Text(
                  tittle,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
        ],
      ),
    );
  }

  Widget contactItem(obj, index) {
    return InkWell(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 1.5),
          padding: EdgeInsets.symmetric(
              horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 1.5),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    HorzitalSpacerWidget(_kLabelSpacing / 1.5),
                    obj.imageUrlC != null && obj.imageUrlC.length > 0
                        ? CachedNetworkImage(
                            imageUrl: obj.imageUrlC,
                            fit: BoxFit.fill,
                            width: 90,
                            height: 120,
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
                          )
                        : Container(
                            child: ClipRRect(
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                width: 90,
                                height: 120,
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
                    HorzitalSpacerWidget(_kLabelSpacing),
                    Expanded(
                      child: Globals.selectedLanguage != null &&
                              Globals.selectedLanguage != "English"
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SpacerWidget(_kLabelSpacing * 3),
                                TranslationWidget(
                                  message: obj.titleC ?? "-",
                                  toLanguage: Globals.selectedLanguage,
                                  fromLanguage: "en",
                                  builder: (translatedMessage) => Text(
                                      translatedMessage.toString(),
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontWeight: FontWeight.w400)),
                                ),
                              ],
                            )
                          : Text(obj.titleC ?? "-",
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.w400)),
                    ),
                  ]),
              SpacerWidget(_kLabelSpacing * 1.2),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 45,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        if (obj.phoneC != null) {
                          objurl.callurlLaucher(context, "tel:" + obj.phoneC);
                        }
                      },
                      child: Globals.selectedLanguage != null &&
                              Globals.selectedLanguage != "English"
                          ? Container(
                              child: TranslationWidget(
                                message: "Call",
                                fromLanguage: "en",
                                toLanguage: language,
                                builder: (translatedMessage) => Text(
                                  translatedMessage.toString(),
                                ),
                              ),
                            )
                          : Text("Call"),
                    ),
                  ),
                  SizedBox(
                    width: _kLabelSpacing / 1.5,
                  ),
                  SizedBox(
                    height: 45,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        if (obj.emailC != null) {
                          objurl.callurlLaucher(
                              context, 'mailto:"${obj.emailC}"');
                        }
                      },
                      child: Globals.selectedLanguage != null &&
                              Globals.selectedLanguage != "English"
                          ? Container(
                              child: TranslationWidget(
                                message: "Mail",
                                fromLanguage: "en",
                                toLanguage: language,
                                builder: (translatedMessage) => Text(
                                  translatedMessage.toString(),
                                ),
                              ),
                            )
                          : Text("Mail"),
                    ),
                  ),
                ],
              ),
              SpacerWidget(_kLabelSpacing / 1.2),
              Row(
                children: [
                  Expanded(
                    child: Globals.selectedLanguage != null &&
                            Globals.selectedLanguage != "English"
                        ? TranslationWidget(
                            message: obj.descriptionC ?? "-",
                            toLanguage: Globals.selectedLanguage,
                            fromLanguage: "en",
                            builder: (translatedMessage) => Text(
                                translatedMessage.toString(),
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w400)))
                        : Text(obj.descriptionC ?? "-",
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          appBarTitle: widget.appBarTitle,
          isSearch: true,
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
          isShare: false,
          isCenterIcon: true,
          language: Globals.selectedLanguage,
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

                if (connected) {
                  if (iserrorstate == true) {
                    iserrorstate = false;
                    _bloc.add(SDevent());
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return new Stack(fit: StackFit.expand, children: [
                  connected
                      ? Column(
                          children: [
                            Expanded(
                              child: BlocBuilder<FamilyBloc, FamilyState>(
                                  bloc: _bloc,
                                  builder:
                                      (BuildContext contxt, FamilyState state) {
                                    if (state is FamilyInitial ||
                                        state is FamilyLoading) {
                                      return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8,
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator());
                                    } else if (state is SDDataSucess) {
                                      return state.obj != null &&
                                              state.obj!.length > 0
                                          ? Column(
                                              children: [
                                                _buildHeading(
                                                    "STAFF DIRECTORY"),
                                                Expanded(
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        state.obj!.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return contactItem(
                                                          state.obj![index],
                                                          index);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Expanded(
                                              child: ListView(children: [
                                              ErrorMessageWidget(
                                                msg: "No Data Found",
                                                isnetworkerror: false,
                                                icondata: 0xe81d,
                                              )
                                            ]));
                                    } else if (state is ErrorLoading) {
                                      return ListView(children: [
                                        ErrorMessageWidget(
                                          msg: "Error",
                                          isnetworkerror: false,
                                          icondata: 0xe81c,
                                        ),
                                      ]);
                                    }
                                    return Container();
                                  }),
                            ),
                            BlocListener<HomeBloc, HomeState>(
                              bloc: _homeBloc,
                              listener: (context, state) async {
                                if (state is BottomNavigationBarSuccess) {
                                  AppTheme.setDynamicTheme(
                                      Globals.appSetting, context);
                                  Globals.homeObjet = state.obj;
                                  setState(() {});
                                } else if (state is HomeErrorReceived) {
                                  Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: Center(
                                        child: Text("Unable to load the data")),
                                  );
                                }
                              },
                              child: Container(
                                height: 0,
                                width: 0,
                              ),
                            ),
                          ],
                        )
                      : NoInternetErrorWidget(
                          connected: connected, issplashscreen: false),
                ]);
              },
              child: Container()),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(SDevent());
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
