import 'package:Soc/src/modules/families/ui/contact.dart';
import 'package:Soc/src/modules/families/ui/event.dart';
import 'package:Soc/src/modules/families/ui/staffdirectory.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/common_sublist.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/error_icon_widget.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/families/modal/family_list.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/error_message_widget.dart';
import 'package:Soc/src/widgets/no_internet_icon.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';

class FamilyPage extends StatefulWidget {
  var obj;
  final searchObj;
  FamilyPage({Key? key, this.obj, this.searchObj}) : super(key: key);

  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  static const double _kLabelSpacing = 16.0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FamilyBloc _bloc = FamilyBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(FamiliesEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _bloc.add(FamiliesEvent());
  }

  _route(FamiliesList obj, index) {
    if (obj.titleC == "Contact") {
      obj.titleC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ContactPage(
                        obj: widget.obj,
                        isbuttomsheet: true,
                        appBarTitle: obj.titleC!,
                        language: Globals.selectedLanguage ?? "English",
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (obj.titleC == "Staff Directory") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffDirectory(
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (obj.titleC == "Calendar/Events") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => EventPage(
                    isbuttomsheet: true,
                    appBarTitle: obj.titleC,
                    language: Globals.selectedLanguage,
                  )));
    } else if (obj.typeC == "URL") {
      obj.appUrlC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InAppUrlLauncer(
                        title: obj.titleC!,
                        url: obj.appUrlC ?? '',
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (obj.typeC == "RFT_HTML") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
                        // url: obj.appUrlC ?? '',
                        isbuttomsheet: true,
                        ishtml: true,
                        appbarTitle: obj.titleC!,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No data available", context);
    } else if (obj.typeC == "PDF URL") {
      obj.pdfURL != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => CommonPdfViewerPage(
                        url: obj.pdfURL,
                        tittle: obj.titleC,
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No pdf available", context);
    } else if (obj.typeC == "Sub-Menu") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SubListPage(
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    module: "family",
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else {
      Utility.showSnackBar(_scaffoldKey, "No data available", context);
    }
  }

  Widget _buildLeading(FamiliesList obj) {
    if (obj.appIconUrlC != null) {
      return Container(
        child: ClipRRect(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CachedNetworkImage(
              imageUrl: obj.appIconUrlC!,
              fit: BoxFit.cover,
              height: 20,
              width: 20,
              placeholder: (context, url) => Container(
                alignment: Alignment.center,
                // width: _kIconSize * 1.4,
                // height: _kIconSize * 1.5,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      );
    } else {
      return Icon(
        IconData(
          int.parse('0x${obj.appIconC!}'),
          fontFamily: 'FontAwesomeSolid',
          fontPackage: 'font_awesome_flutter',
        ),
        color: Theme.of(context).colorScheme.primary,
        size: Globals.deviceType == "phone" ? 18 : 26,
      );
    }
  }

  Widget _buildList(FamiliesList obj, int index) {
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
          _route(obj, index);
        },
        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
        contentPadding:
            EdgeInsets.only(left: _kLabelSpacing, right: _kLabelSpacing / 2),
        leading: _buildLeading(obj),
        title: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English"
            ? TranslationWidget(
                message: obj.titleC,
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              )
            : Text(
                obj.titleC.toString(),
                style: Theme.of(context).textTheme.bodyText2,
              ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: Globals.deviceType == "phone" ? 12 : 20,
          color: Theme.of(context).colorScheme.primary,
          // color: AppTheme.kButtonbackColor,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBarWidget(
            refresh: (v) {
              setState(() {});
            },
          ),
          body: RefreshIndicator(
            key: refreshKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: BlocBuilder<FamilyBloc, FamilyState>(
                      bloc: _bloc,
                      builder: (BuildContext contxt, FamilyState state) {
                        if (state is FamilyInitial || state is FamilyLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is FamiliesDataSucess) {
                          return state.obj != null && state.obj!.length > 0
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: state.obj!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _buildList(state.obj![index], index);
                                  },
                                )
                              : ListView(children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: Globals.selectedLanguage != null &&
                                            Globals.selectedLanguage !=
                                                "English"
                                        ? TranslationWidget(
                                            message: "No data found",
                                            toLanguage:
                                                Globals.selectedLanguage,
                                            fromLanguage: "en",
                                            builder: (translatedMessage) =>
                                                Text(
                                              translatedMessage.toString(),
                                            ),
                                          )
                                        : Text("No data found"),
                                  ),
                                ]);
                        } else if (state is ErrorLoading) {
                          if (state.err == "NO_CONNECTION") {
                            return ListView(shrinkWrap: true, children: [
                              SizedBox(
                                child: NoInternetIconWidget(),
                              ),
                              SpacerWidget(12),
                              Globals.selectedLanguage != null &&
                                      Globals.selectedLanguage != "English"
                                  ? TranslationWidget(
                                      message: "No internet connection",
                                      toLanguage: Globals.selectedLanguage,
                                      fromLanguage: "en",
                                      builder: (translatedMessage) => Text(
                                        translatedMessage.toString(),
                                      ),
                                    )
                                  : Text("No internet connection"),
                            ]);
                          } else if (state.err == "Something went wrong") {
                            return ListView(shrinkWrap: true, children: [
                              ErrorMessageWidget(
                                imgURL: 'assets/images/no_data_icon.png',
                                msg: "No data found",
                              ),
                              // SpacerWidget(12),
                              // SpacerWidget(12),
                              // Globals.selectedLanguage != null &&
                              //         Globals.selectedLanguage != "English"
                              //     ? TranslationWidget(
                              //         message: "No  data found",
                              //         toLanguage: Globals.selectedLanguage,
                              //         fromLanguage: "en",
                              //         builder: (translatedMessage) => Text(
                              //           translatedMessage.toString(),
                              //         ),
                              //       )
                              //     : Text("No data found"),
                            ]);
                          } else {
                            return ListView(shrinkWrap: true, children: [
                              SizedBox(child: ErrorIconWidget()),
                              Globals.selectedLanguage != null &&
                                      Globals.selectedLanguage != "English"
                                  ? TranslationWidget(
                                      message: "Error",
                                      toLanguage: Globals.selectedLanguage,
                                      fromLanguage: "en",
                                      builder: (translatedMessage) => Text(
                                        translatedMessage.toString(),
                                      ),
                                    )
                                  : Text("Error"),
                            ]);
                          }
                        } else {
                          return Container();
                        }
                      }),
                ),
                BlocListener<HomeBloc, HomeState>(
                  bloc: _homeBloc,
                  listener: (context, state) async {
                    if (state is BottomNavigationBarSuccess) {
                      AppTheme.setDynamicTheme(Globals.appSetting, context);
                      Globals.homeObjet = state.obj;
                      setState(() {});
                    } else if (state is HomeErrorReceived) {
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(child: Text("Unable to load the data")),
                      );
                    }
                  },
                  child: Container(
                    height: 0,
                    width: 0,
                  ),
                ),
              ],
            ),
            onRefresh: refreshPage,
          ),
        ));
  }
}
