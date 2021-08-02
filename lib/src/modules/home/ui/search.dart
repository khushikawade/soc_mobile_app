import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/contact.dart';
import 'package:Soc/src/modules/families/ui/staffdirectory.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/model/recent.dart';
import 'package:Soc/src/modules/home/model/search_list.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/db_service.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/Strings.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/backbuttonwidget.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/common_sublist.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/internalbuttomnavigation.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  bool isbuttomsheet;
  String? language;
  SearchPage({Key? key, required this.isbuttomsheet, required this.language})
      : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool issuggestionList = false;
  static const double _kLabelSpacing = 20.0;
  var _controller = TextEditingController();
  final backColor = AppTheme.kactivebackColor;
  final sebarcolor = AppTheme.kFieldbackgroundColor;
  FocusNode myFocusNode = new FocusNode();
  final _debouncer = Debouncer(milliseconds: 500);
  HomeBloc _searchBloc = new HomeBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const double _kIconSize = 38.0;

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
    deleteItem();
  }

  deleteItem() async {
    int itemcount = await DbServices().getListLength(Strings.hiveLogName);
    if (itemcount > 5) {
      await DbServices().deleteData(Strings.hiveLogName, 0);
    }
  }

  Future<void> _route(obj) async {
    if (obj.titleC == "Contact") {
      obj.titleC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ContactPage(
                        obj: Globals.homeObjet,
                        isbuttomsheet: true,
                        appBarTitle: obj.titleC!,
                        language: widget.language!,
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
                    language: widget.language,
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
                      language: widget.language,
                    )));
      } else {
        if (await canLaunch(obj.appURLC!)) {
          await launch(obj.appURLC!);
        } else {
          throw 'Could not launch ${obj.appURLC}';
        }
      }
    } else if (obj.typeC == "URL") {
      obj.urlC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InAppUrlLauncer(
                        title: obj.titleC!,
                        url: obj.urlC!,
                        isbuttomsheet: true,
                        language: widget.language,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (obj.typeC == "RFT_HTML") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
                        language: widget.language,
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
                        language: widget.language,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No pdf available", context);
    } else if (obj.typeC == "Sub-Menu") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SubListPage(
                    obj: obj,
                    module: "family",
                    isbuttomsheet: true,
                    appBarTitle: obj.titleC!,
                    language: widget.language,
                  )));
    } else {
      Utility.showSnackBar(
          _scaffoldKey, "No data available for this record", context);
    }
  }

  Widget _buildSearchbar() {
    return SizedBox(
      height: 50,
      child: Container(
          padding: EdgeInsets.symmetric(
              vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing / 2),
          color: AppTheme.kFieldbackgroundColor,
          child: TextFormField(
            focusNode: myFocusNode,
            controller: _controller,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search',
              contentPadding: EdgeInsets.symmetric(
                  vertical: _kLabelSpacing / 2, horizontal: _kLabelSpacing / 2),
              filled: true,
              fillColor: AppTheme.kBackgroundColor,
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                const IconData(0xe805,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: AppTheme.kprefixIconColor,
                size: Globals.deviceType == "phone" ? 20 : 28,
              ),
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    _controller.clear();
                    issuggestionList = false;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                icon: Icon(
                  Icons.clear,
                  color: AppTheme.kIconColor,
                  size: Globals.deviceType == "phone" ? 18 : 24,
                ),
              ),
            ),
            onChanged: onItemChanged,
          )),
    );
  }

  Widget _buildRecentItemList() {
    return FutureBuilder(
        future: DbServices().getListData(Strings.hiveLogName),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data != null && snapshot.data.length > 0
                ? Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      // shrinkWrap: true,
                      // reverse: true,
                      itemCount:
                          snapshot.data.length < 5 ? snapshot.data.length : 5,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildIListtem(index, snapshot.data);
                      },
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: widget.language != null &&
                              widget.language != "English"
                          ? TranslationWidget(
                              message: 'No Recent Item Found',
                              toLanguage: widget.language,
                              fromLanguage: "en",
                              builder: (translatedMessage) => Text(
                                translatedMessage.toString(),
                                textAlign: TextAlign.end,
                              ),
                            )
                          : Text(
                              'No Recent Item Found',
                              textAlign: TextAlign.end,
                            ),
                    ),
                  );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor,
                )),
              ),
            );
          } else
            return Scaffold();
        });
  }

  Widget _buildIListtem(int index, items) {
    return InkWell(
      onTap: () async {
        // await _recentListRoute(items[index]);
        await _route(items[index]);
      },
      child: Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
          padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
          decoration: BoxDecoration(
            color: (index % 2 == 0)
                ? AppTheme.kListBackgroundColor3
                : Theme.of(context).backgroundColor,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        widget.language != null && widget.language != "English"
                            ? TranslationWidget(
                                message: items[index].titleC != null &&
                                        items[index].titleC.isNotEmpty
                                    ? '${items[index].titleC} '
                                    : '',
                                toLanguage: widget.language,
                                fromLanguage: "en",
                                builder: (translatedMessage) => Text(
                                  translatedMessage.toString(),
                                ),
                              )
                            : Text(
                                items[index].titleC != null &&
                                        items[index].titleC.isNotEmpty
                                    ? '${items[index].titleC} '
                                    : '',
                              ),
                      ]),
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
                        margin: EdgeInsets.only(
                            left: _kLabelSpacing / 2,
                            right: _kLabelSpacing / 2,
                            bottom: _kLabelSpacing * 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0)),
                        ),
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.all(_kLabelSpacing / 2),
                          children: state.obj.map<Widget>((data) {
                            return Container(
                              decoration: BoxDecoration(
                                border: (state.obj.indexOf(data) % 2 == 0)
                                    ? Border.all(
                                        color: AppTheme.kListBackgroundColor3)
                                    : Border.all(
                                        color:
                                            Theme.of(context).backgroundColor),
                                borderRadius: BorderRadius.circular(0.0),
                                color: (state.obj.indexOf(data) % 2 == 0)
                                    ? AppTheme.kListBackgroundColor3
                                    : Theme.of(context).backgroundColor,
                              ),
                              child: ListTile(
                                  title: widget.language != null &&
                                          widget.language != "English"
                                      ? TranslationWidget(
                                          message: data.titleC,
                                          toLanguage: widget.language,
                                          fromLanguage: "en",
                                          builder: (translatedMessage) => Text(
                                            translatedMessage.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        )
                                      : Text(
                                          data.titleC ?? '-',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
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
                                          data.name,
                                          data.pdfURL,
                                          data.rtfHTMLC,
                                          data.typeC,
                                          data.deepLink);

                                      addtoDataBase(recentitem);
                                    }
                                  }),
                            );
                          }).toList(),
                        ))
                    : Container(
                        height: 0,
                      ));
          } else if (state is SearchLoading) {
            return Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor,
                )),
              ),
            );
          } else {
            return Container(height: 0);
          }
        });
  }

  Widget _buildHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        HorzitalSpacerWidget(_kLabelSpacing / 2),
        widget.language != null && widget.language != "English"
            ? TranslationWidget(
                message: "Search",
                toLanguage: widget.language,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                  textAlign: TextAlign.left,
                ),
              )
            : Text(
                "Search",
                style: Theme.of(context).appBarTheme.titleTextStyle,
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
        widget.language != null && widget.language != "English"
            ? TranslationWidget(
                message: "Recent Search",
                toLanguage: widget.language,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                        fontSize: 18,
                      ),
                  textAlign: TextAlign.left,
                ),
              )
            : Text(
                "Recent Search",
                style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                      fontSize: 18,
                    ),
                textAlign: TextAlign.left,
              ),
      ],
    );
  }

  void addtoDataBase(Recent log) async {
    bool isSuccess = await DbServices().addData(log, Strings.hiveLogName);
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
                SizedBox(width: 100.0, height: 60.0, child: AppLogoWidget())),
        body: Container(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            _buildHeading(),
            SpacerWidget(_kLabelSpacing / 2),
            _buildSearchbar(),
            issuggestionList ? _buildissuggestionList() : SizedBox(height: 0),
            SpacerWidget(_kLabelSpacing),
            issuggestionList == false ? _buildHeading2() : SizedBox(height: 0),
            issuggestionList == false
                ? _buildRecentItemList()
                : SizedBox(height: 0),
          ]),
        ),
        bottomNavigationBar: widget.isbuttomsheet && Globals.homeObjet != null
            ? InternalButtomNavigationBar()
            : null);
  }
}
