import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/contact.dart';
import 'package:Soc/src/modules/families/ui/staffdirectory.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/model/recent.dart';
import 'package:Soc/src/modules/schools/ui/school_details.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/hive_db_services.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/backbuttonwidget.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class SearchPage extends StatefulWidget {
  final bool isbuttomsheet;
  final String? language;
  SearchPage({Key? key, required this.isbuttomsheet, required this.language})
      : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool issuggestionList = false;
  static const double _kLabelSpacing = 20.0;
  static const double _kMargin = 16.0;
  final _controller = TextEditingController();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool iserrorstate = false;
  final HomeBloc _homeBloc = new HomeBloc();
  FocusNode myFocusNode = new FocusNode();
  final _debouncer = Debouncer(milliseconds: 500);
  HomeBloc _searchBloc = new HomeBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const double _kIconSize = 38.0;
  bool? isDBListEmpty = true;

  onItemChanged(String value) {
    issuggestionList = true;
    _debouncer.run(() {
      _searchBloc.add(GlobalSearchEvent(keyword: value));
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    Globals.callsnackbar = true;
    getListLength();
  }

  getListLength() async {
    int length = await HiveDbServices().getListLength(Strings.hiveLogName);
    length < 1 ? isDBListEmpty = true : isDBListEmpty = false;
    // print(" ************");
    // print(isDBListEmpty);
  }

  deleteItem() async {
    int itemcount = await HiveDbServices().getListLength(Strings.hiveLogName);
    if (itemcount > 5) {
      await HiveDbServices().deleteData(Strings.hiveLogName, 0);
    }
  }

  Future<void> _route(obj) async {
    if (obj.typeC == "Contact") {
      obj.titleC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ContactPage(
                        obj: Globals.homeObjet,
                        isbuttomsheet: true,
                        appBarTitle: obj.titleC!,
                        language: Globals.selectedLanguage!,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (obj.typeC == "Form") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffDirectory(
                staffDirectoryCategoryId: null,
                    isAbout: false,
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (obj.typeC == "SchoolDirectoryApp") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SchoolDetailPage(
                    obj: obj,
                  )));
    } else if (obj.typeC == "Staff_Directory") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffDirectory(
                staffDirectoryCategoryId: obj.id,
                    isAbout: true,
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (obj.deepLink != null) {
      if (obj.deepLink == 'NO') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => InAppUrlLauncer(
                      title: obj.titleC!,
                      url: obj.appURLC!,
                      isbuttomsheet: true,
                      language: Globals.selectedLanguage,
                    )));
      } else {
        // if (await canLaunch(obj.appURLC!)) {
        //   await launch(obj.appURLC!);
        // } else {
        //   throw 'Could not launch ${obj.appURLC}';
        // }
        await Utility.launchUrlOnExternalBrowser(obj.appURLC!);
      }
    } else if (obj.typeC == "URL") {
      obj.urlC != null
          ? _launchURL(obj) 
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => InAppUrlLauncer(
          //               title: obj.titleC!,
          //               url: obj.urlC!,
          //               isbuttomsheet: true,
          //               language: Globals.selectedLanguage,
          //             )))
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (obj.typeC == "RFT_HTML" ||
        obj.typeC == "HTML/RTF" ||
        obj.typeC == "RTF/HTML") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
                        language: Globals.selectedLanguage,
                        isbuttomsheet: true,
                        ishtml: true,
                        appbarTitle: obj.titleC!,
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
    }
    //  else if (obj.typeC == "Sub-Menu") {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (BuildContext context) => SubListPage(
    //                 obj: obj,
    //                 module: "family",
    //                 isbuttomsheet: true,
    //                 appBarTitle: obj.titleC!,
    //                 language: Globals.selectedLanguage,
    //               )));
    // }
    else {
      Utility.showSnackBar(
          _scaffoldKey, "No data available for this record", context);
    }
  }

  _launchURL(obj) async {
    if (obj.urlC.toString().split(":")[0] == 'http') {
      await Utility.launchUrlOnExternalBrowser(obj.urlC);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: obj.titleC ?? "",
                    url: obj.urlC,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    }
  }

  Widget _buildSearchbar() {
    return SizedBox(
      height: 55,
      child: Container(
          width: MediaQuery.of(context).size.width * 1,
          padding: EdgeInsets.symmetric(
              vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing / 2),
          child: TextFormField(
            style:
                TextStyle(color: Theme.of(context).colorScheme.primaryVariant),
            focusNode: myFocusNode,
            controller: _controller,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary, width: 2),
              ),
              hintText: 'Search',
              fillColor: Theme.of(context).colorScheme.secondary,
              prefixIcon: Icon(
                const IconData(0xe805,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                size: Globals.deviceType == "phone" ? 20 : 28,
              ),
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : InkWell(
                      onTap: () {
                        setState(() {
                          _controller.clear();
                          issuggestionList = false;
                          FocusScope.of(context).requestFocus(FocusNode());
                        });
                      },
                      child: Icon(
                        Icons.clear,
                        size: Globals.deviceType == "phone" ? 20 : 28,
                      ),
                    ),
            ),
            onChanged: onItemChanged,
          )),
    );
  }

  Widget _buildRecentItemList() {
    return FutureBuilder(
        future: HiveDbServices().getListData(Strings.hiveLogName),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data != null && snapshot.data.length > 0
                ? Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 20),
                      scrollDirection: Axis.vertical,
                      itemCount:
                          snapshot.data.length < 5 ? snapshot.data.length : 5,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildItem(index, snapshot.data);
                      },
                    ),
                  )
                : EmptyContainer();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          } else
            return Scaffold();
        });
  }

  Widget _buildItem(int index, items) {
    return InkWell(
      onTap: () async {
        await _route(items[index]);
      },
      child: Container(
          margin: EdgeInsets.only(
              left: _kMargin, right: _kMargin, top: 6, bottom: 6),
          padding: EdgeInsets.only(
              left: _kMargin, right: _kMargin, top: 12, bottom: 12),
          decoration: BoxDecoration(
            color: (index % 2 == 0)
                ? Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                spreadRadius: 0,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(
                  const IconData(0xe805,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  size: Globals.deviceType == "phone" ? 14 : 22,
                ),
                HorzitalSpacerWidget(_kLabelSpacing),
                Globals.selectedLanguage != null &&
                        Globals.selectedLanguage != "English" &&
                        Globals.selectedLanguage != ""
                    ? TranslationWidget(
                        message: items[index].titleC != null &&
                                items[index].titleC.isNotEmpty
                            ? '${items[index].titleC} '
                            : '',
                        toLanguage: Globals.selectedLanguage,
                        fromLanguage: "en",
                        builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                            style: Theme.of(context).textTheme.bodyText1),
                      )
                    : Text(
                        items[index].titleC != null &&
                                items[index].titleC.isNotEmpty
                            ? '${items[index].titleC} '
                            : '',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color:
                                Theme.of(context).colorScheme.primaryVariant),
                      )
              ])),
    );
  }

  Widget _buildissuggestionList() {
    return BlocBuilder<HomeBloc, HomeState>(
        bloc: _searchBloc,
        builder: (BuildContext contxt, HomeState state) {
          if (state is GlobalSearchSuccess) {
            return Expanded(
                child: state.obj.map != null && state.obj.length > 0
                    ? Container(
                        child: ListView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(_kLabelSpacing / 2),
                        children: state.obj.map<Widget>((data) {
                          return Container(
                            decoration: BoxDecoration(
                              border: (state.obj.indexOf(data) % 2 == 0)
                                  ? Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background)
                                  : Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                              borderRadius: BorderRadius.circular(0.0),
                              color: (state.obj.indexOf(data) % 2 == 0)
                                  ? Theme.of(context).colorScheme.background
                                  : Theme.of(context).colorScheme.secondary,
                            ),
                            child: ListTile(
                                title: Globals.selectedLanguage != null &&
                                        Globals.selectedLanguage != "English" &&
                                        Globals.selectedLanguage != ""
                                    ? TranslationWidget(
                                        message: data.titleC,
                                        toLanguage: Globals.selectedLanguage,
                                        fromLanguage: "en",
                                        builder: (translatedMessage) => Text(
                                          translatedMessage.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!,
                                        ),
                                      )
                                    : Text(
                                        data.titleC ?? '-',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryVariant),
                                      ),
                                onTap: () async {
                                  _route(data);
                                  if (data != null) {
                                    deleteItem();
                                    final recentitem = Recent(
                                      1,
                                      data.titleC,
                                      data.appURLC,
                                      data.urlC,
                                      data.id,
                                      data.rtfHTMLC,
                                      data.schoolId,
                                      data.dept,
                                      data.descriptionC,
                                      data.emailC,
                                    );

                                    addtoDataBase(recentitem);
                                  }
                                }),
                          );
                        }).toList(),
                      ))
                    : NoDataFoundErrorWidget(
                        isResultNotFoundMsg: false,
                        isNews: false,
                        isEvents: false,
                      ));
          } else if (state is SearchLoading) {
            return Expanded(
                child: Center(
              child: Container(
                alignment: Alignment.center,
                width: _kIconSize * 1.4,
                height: _kIconSize * 1.5,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ));
          } else {
            return Container(height: 0);
          }
        });
  }

  Widget _buildHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HorzitalSpacerWidget(_kLabelSpacing / 2),
        Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English" &&
                Globals.selectedLanguage != ""
            ? TranslationWidget(
                message: "Search",
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                      color: Theme.of(context).colorScheme.primaryVariant,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              )
            : Text(
                "Search",
                style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                    color: Theme.of(context).colorScheme.primaryVariant,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
      ],
    );
  }

  Widget _buildHeading2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        HorzitalSpacerWidget(_kLabelSpacing / 2),
        Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English" &&
                Globals.selectedLanguage != ""
            ? TranslationWidget(
                message: "Recent Search",
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primaryVariant,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              )
            : Text(
                "Recent Search",
                style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primaryVariant,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
      ],
    );
  }

  void addtoDataBase(Recent log) async {
    bool isSuccess = await HiveDbServices().addData(log, Strings.hiveLogName);
    isDBListEmpty = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(
          elevation: 0.0,
          leading: BackButtonWidget(),
          title:
              // SizedBox(width: 100.0, height: 60.0, child:
              AppLogoWidget(
            marginLeft: 0,
          ),
          // )
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
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return connected
                    ? Container(
                        child:
                            Column(mainAxisSize: MainAxisSize.max, children: [
                          SpacerWidget(_kLabelSpacing / 4),
                          _buildHeading(),
                          SpacerWidget(_kLabelSpacing / 2),
                          _buildSearchbar(),
                          issuggestionList
                              ? _buildissuggestionList()
                              : SizedBox(height: 0),
                          SpacerWidget(_kLabelSpacing / 2),
                          issuggestionList == false
                              ? _buildHeading2()
                              : SizedBox(height: 0),
                          issuggestionList == false
                              ? _buildRecentItemList()
                              : SizedBox(height: 0),
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
                                  } else if (state is HomeErrorReceived) {}
                                },
                                child: EmptyContainer()),
                          ),
                        ]),
                      )
                    : NoInternetErrorWidget(
                        connected: connected, issplashscreen: false);
              },
              child: Container()),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
