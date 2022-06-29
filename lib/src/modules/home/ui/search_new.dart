import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/contact.dart';
import 'package:Soc/src/modules/families/ui/event.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/schools_directory/ui/school_details.dart';
import 'package:Soc/src/modules/staff_directory/staffdirectory.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/recent.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/local_database/hive_db_services.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/backbuttonwidget.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/modules/shared/ui/common_sublist.dart';
import 'package:Soc/src/widgets/custom_image_widget_small.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
//  HomeBloc _searchBloc = new HomeBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const double _kIconSize = 38.0;
  bool? isDBListEmpty = true;
  List<dynamic> searchList = [];
  String? searchId;
  dynamic recordObject;

  onItemChanged(String value) {
    issuggestionList = true;
    _debouncer.run(() {
      _homeBloc.add(GlobalSearchEvent(keyword: value));
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _setLocked();
    Globals.callsnackbar = true;
    getListLength();
  }

  @override
  dispose() {
    _setFree();
    super.dispose();
  }

  getListLength() async {
    int length = await HiveDbServices().getListLength(Strings.hiveLogName);
    length < 1 ? isDBListEmpty = true : isDBListEmpty = false;
  }

  getListData(String localDatalogName) async {
    List listItem = await HiveDbServices().getListData(localDatalogName);
    return listItem;
  }

  deleteItem(String localDatalogName) async {
    int itemcount = await HiveDbServices().getListLength(localDatalogName);
    if (itemcount > 5) {
      await HiveDbServices().deleteData(localDatalogName, 0);
    }
  }

  Future<void> _route(
      {required obj,
      required String objectType,
      required String objectName}) async {
    // obj.typeC != null && obj.typeC != '' ? _setFree() : _setLocked();

    if (objectType == "Contact") {
      objectType != null && objectType != ""
          ? await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ContactPage(
                        obj: Globals.appSetting,
                        //  Globals.homeObject,
                        isbuttomsheet: true,
                        appBarTitle: obj.titleC!,
                        language: Globals.selectedLanguage!,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No data available", context);
    } else if (objectType == "Form" && objectName == 'Staff_Directory_App__c') {
      List<dynamic> newObj = [];
      newObj.add(obj);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SliderWidget(
                    obj: newObj,
                    currentIndex: 0,
                    issocialpage: false,
                    isAboutSDPage: true,
                    isNewsPage: false,
                    // iseventpage: false,
                    date: "",
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (objectType == "Form") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffDirectory(
                  isCustom: false,
                  staffDirectoryCategoryId: null,
                  isAbout: true,
                  appBarTitle: obj.titleC!,
                  obj: obj,
                  isbuttomsheet: true,
                  language: Globals.selectedLanguage,
                  isSubmenu: false)));
    } else if (objectType == "SchoolDirectoryApp") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SchoolDetailPage(
                    obj: obj,
                  )));
    } else if (objectType == "Staff_Directory") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffDirectory(
                    isCustom: false,
                    staffDirectoryCategoryId: obj.id,
                    isAbout: true,
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (objectType == "URL") {
      obj.appUrlC != null
          ? await _launchURL(obj, objectName)
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (objectType == "RTF_HTML" ||
        objectType == "RFT_HTML" ||
        objectType == "HTML/RTF" ||
        objectType == "RTF/HTML") {
      objectType != null
          ? await Navigator.push(
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
      // _setLocked();
    } else if (objectType == "PDF URL" || objectType == "PDF") {
      obj.pdfURL != null
          ? await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => CommonPdfViewerPage(
                        isHomePage: false,
                        url: obj.pdfURL,
                        tittle: obj.titleC,
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No pdf available", context);
      // _setLocked();
    } else if (objectType == "Calendar/Events") {
      obj.calendarId != null && obj.calendarId != ""
          ? await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => EventPage(
                        isbuttomsheet: true,
                        appBarTitle: obj.titleC,
                        language: Globals.selectedLanguage,
                        calendarId: obj.calendarId.toString(),
                      )))
          : Utility.showSnackBar(
              _scaffoldKey, "No calendar/events available", context);
    } else if (objectType == "Sub-Menu") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SubListPage(
                    obj: obj,
                    module: obj.name.toString().contains("FAN")
                        ? "family"
                        : obj.name.toString().contains("SA")
                            ? "staff"
                            : obj.name.toString().contains("ABT")
                                ? "about"
                                : obj.name.toString().contains("RES")
                                    ? "resources"
                                    : obj.name.toString().contains("CAM")
                                        ? "Custom"
                                        : "",
                    isbuttomsheet: true,
                    appBarTitle: obj.titleC!,
                    language: Globals.selectedLanguage,
                  )));
    } else {
      Utility.showSnackBar(
          _scaffoldKey, "No data available for this record", context);
    }
    _setLocked();
  }

  _launchURL(obj, objectName) async {
    if (obj.appUrlC.toString().split(":")[0] == 'http' ||
        obj.deepLinkC == 'YES') {
      if (objectName == "Student_App__c" && obj.appUrlC != null) {
        await Utility.launchUrlOnExternalBrowser(obj.appUrlC);
      } else if (obj.appUrlC != null && obj.appUrlC != "URL__c") {
        await Utility.launchUrlOnExternalBrowser(obj.appUrlC);
      } else {
        Utility.showSnackBar(_scaffoldKey, "No URL available", context);
      }
    } else if (
        //obj.urlC != null ||
        obj.appUrlC != null) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: obj.titleC ?? "",
                    url: obj.appUrlC,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
      // _setLocked();
    } else {
      Utility.showSnackBar(_scaffoldKey, "No URL available", context);
    }
  }

  Widget _buildSearchbar() {
    return SizedBox(
      height: 55,
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        padding: EdgeInsets.symmetric(
            vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing / 2),
        child: TranslationWidget(
            message: 'Search',
            fromLanguage: "en",
            toLanguage: Globals.selectedLanguage,
            builder: (translatedMessage) {
              return TextFormField(
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryVariant),
                focusNode: myFocusNode,
                controller: _controller,
                cursorColor: Theme.of(context).colorScheme.primaryVariant,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2),
                  ),
                  hintText: translatedMessage.toString(),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  prefixIcon: Icon(
                    const IconData(0xe805,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: Theme.of(context).colorScheme.primaryVariant,
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
                            color: Theme.of(context).colorScheme.primaryVariant,
                            size: Globals.deviceType == "phone" ? 20 : 28,
                          ),
                        ),
                ),
                onChanged: onItemChanged,
              );
            }),
      ),
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
                      padding: EdgeInsets.only(bottom: _kLabelSpacing * 1.5),
                      scrollDirection: Axis.vertical,
                      itemCount:
                          snapshot.data.length < 10 ? snapshot.data.length : 10,
                      itemBuilder: (BuildContext context, int index) {
                        List reverseList = List.from(snapshot.data.reversed);
                        // return _buildRecentItem(index, snapshot.data);
                        return _buildRecentItem(index, reverseList);
                      },
                    ),
                  )
                : EmptyContainer();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                    child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primaryVariant,
                )),
              ),
            );
          } else
            return Scaffold();
        });
  }

  Widget _buildRecentItem(int index, items) {
    return InkWell(
      onTap: () async {
        List<dynamic> recentDetailDbList =
            await getListData(Strings.hiveReferenceLogName);
        List<dynamic> reversedRecentDetailDbList =
            new List.from(recentDetailDbList.reversed);

        //To call the latest data silently.
        _homeBloc.add(GetRecordByID(
            //  isRecentRecord: true,
            // title: data.titleC,
            recordType: items[index].typeC,
            recordId: items[index].id,
            objectName: items[index].objectName));

        if (items[index].id == reversedRecentDetailDbList[index].id) {
          _route(
              obj: reversedRecentDetailDbList[index],
              objectName: items[index].objectName,
              objectType: items[index].typeC);
        }
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
                _buildLeading(items[index]),
                HorzitalSpacerWidget(_kLabelSpacing),
                TranslationWidget(
                  message: items[index].objectName == 'Staff_Directory_App__c'
                      ? (items[index].name != null &&
                              items[index].name != 'null' &&
                              items[index].name.isNotEmpty
                          ? '${items[index].name} '
                          : '')
                      : (items[index].titleC != null &&
                              items[index].titleC != 'null' &&
                              items[index].titleC.isNotEmpty
                          ? '${items[index].titleC} '
                          : ''),
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Expanded(
                    child: Text(
                      translatedMessage.toString(),
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Theme.of(context).colorScheme.primaryVariant),
                    ),
                  ),
                )
              ])),
    );
  }

  Widget _buildissuggestionList() {
    return BlocBuilder<HomeBloc, HomeState>(
        bloc: _homeBloc,
        builder: (BuildContext contxt, HomeState state) {
          if (state is GlobalSearchSuccess) {
            searchList.clear();
            for (int i = 0; i < state.obj!.length; i++) {
              // if (state.obj![i].statusC != "Hide") {
              if (state.obj![i].typeC == null && state.obj![i].urlC != null) {
                state.obj![i].typeC = "URL";
              }
              if (state.obj[i].objectName == 'Staff_Directory_App__c'
                  ? (state.obj[i].name != null &&
                      state.obj[i].name != 'null' &&
                      state.obj[i].name != "")
                  : state.obj[i].titleC != null &&
                      state.obj[i].titleC != 'null' &&
                      state.obj[i].titleC != "") {
                searchList.add(state.obj![i]);
                // }
              }
            }
            return searchList.length > 0
                ? Expanded(
                    child: ListView(
                    shrinkWrap: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(
                        left: _kLabelSpacing / 2,
                        right: _kLabelSpacing / 2,
                        bottom: _kLabelSpacing * 1.5),
                    children: searchList.map<Widget>((data) {
                      return Container(
                        decoration: BoxDecoration(
                          border: (searchList.indexOf(data) % 2 == 0)
                              ? Border.all(
                                  color:
                                      Theme.of(context).colorScheme.background)
                              : Border.all(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                          borderRadius: BorderRadius.circular(0.0),
                          color: (searchList.indexOf(data) % 2 == 0)
                              ? Theme.of(context).colorScheme.background
                              : Theme.of(context).colorScheme.secondary,
                        ),
                        child: ListTile(
                            leading: _buildLeading(data),
                            title: TranslationWidget(
                              message:
                                  data.objectName == 'Staff_Directory_App__c'
                                      ? data.name
                                      : data.titleC ?? "-",
                              toLanguage: Globals.selectedLanguage,
                              fromLanguage: "en",
                              builder: (translatedMessage) => Text(
                                  translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryVariant)),
                            ),
                            onTap: () async {
                              //  _route(data);
                              _homeBloc.add(GetRecordByID(
                                  // isRecentRecord: false,
                                  // title: data.titleC,
                                  recordType: data.typeC,
                                  recordId: data.id,
                                  objectName: data.objectName));

                              List itemListData =
                                  await getListData(Strings.hiveLogName);

                              List idList = [];
                              for (int i = 0; i < itemListData.length; i++) {
                                idList.add(itemListData[i].id);
                              }

                              if (idList.contains(data.id)) {
                              } else {
                                //TODO : Improve the recent item, Add only required keys
                                if (data != null) {
                                  deleteItem(Strings.hiveLogName);
                                  final recentitem = Recent(
                                      1,
                                      data.titleC,
                                      data.appIconUrlC,
                                      data.id,
<<<<<<< HEAD
                                      data.objectName,
                                      data.typeC,
=======
                                      data.name,
                                      data.objectName,
                                      data.rtfHTMLC,
                                      data.typeC,
                                      // data.schoolId,
                                      // data.dept,
                                      data.statusC,
                                      data.urlC,
                                      data.pdfURL,
                                      data.sortOrder,
                                      data.deepLink,
                                      data.appURLC,
                                      data.calendarId,
                                      data.emailC,
                                      data.imageUrlC,
                                      data.phoneC,
                                      data.webURLC,
                                      data.address,
                                      data.geoLocation,
                                      data.descriptionC,
                                      data.latitude,
                                      data.longitude,
>>>>>>> 18df4ad4cdfae0a1e47e0a12a0811d330d58f22e
                                      data.darkModeIconC);
                                  addtoDataBase(recentitem);
                                }
                              }
                            }),
                      );
                    }).toList(),
                  ))
                : Expanded(
                    child: NoDataFoundErrorWidget(
                      isSearchpage: true,
                      isResultNotFoundMsg: false,
                      marginTop: MediaQuery.of(context).size.height * 0.15,
                      isNews: false,
                      isEvents: false,
                    ),
                  );
          } else if (state is SearchLoading) {
            return Expanded(
                child: Center(
              child: Container(
                alignment: Alignment.center,
                width: _kIconSize * 1.4,
                height: _kIconSize * 1.5,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primaryVariant,
                  strokeWidth: 2,
                ),
              ),
            ));
<<<<<<< HEAD
          } else {
=======
          }
      
          else {
>>>>>>> 18df4ad4cdfae0a1e47e0a12a0811d330d58f22e
            return Container(height: 0);
          }
        });
  }

  Widget _buildLeading(obj) {
    if (obj.appIconUrlC != null) {
      return CustomIconMode(
        darkModeIconUrl: obj.darkModeIconC,
        iconUrl: obj.appIconUrlC ?? Overrides.defaultIconUrl,
      );
    } else if (obj.appIconUrlC != null) {
      return Icon(
        IconData(
          int.parse('0x${obj.appIconUrlC!}'),
          fontFamily: 'FontAwesomeSolid',
          fontPackage: 'font_awesome_flutter',
        ),
        color: Theme.of(context).colorScheme.primary,
        size: Globals.deviceType == "phone" ? 24 : 32,
      );
    } else {
      return CustomIconMode(
        iconUrl: Overrides.defaultIconUrl,
        darkModeIconUrl: '',
      );
    }
  }

  Widget _buildHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HorzitalSpacerWidget(_kLabelSpacing / 2),
        TranslationWidget(
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
        ),
      ],
    );
  }

  Widget _buildHeading2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        HorzitalSpacerWidget(_kLabelSpacing / 2),
        TranslationWidget(
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
        ),
      ],
    );
  }

  void addtoDataBase(Recent log) async {
    bool isSuccess = await HiveDbServices().addData(log, Strings.hiveLogName);
    isDBListEmpty = false;
  }

  void addRecordDetailtoLocalDb(dynamic log) async {
    await HiveDbServices().addData(log, Strings.hiveReferenceLogName);
  }

  void updateRecordList(List<dynamic> log) async {
    LocalDatabase<dynamic>? _localDb =
        LocalDatabase(Strings.hiveReferenceLogName);
    log.forEach((dynamic e) {
      print("local database");
      _localDb.addData(e);
    });
    _localDb.close();

    // bool isSuccess =
    //     await HiveDbServices().addData(log, Strings.hiveReferenceLogName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(
          elevation: 0.0,
          leading: BackButtonWidget(),
          centerTitle: true,
          title: // SizedBox(width: 100.0, height: 60.0, child:
              Container(
            // color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: AppLogoWidget(
                marginLeft: 0,
              ),
            ),
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

                return
                    //  connected
                    //     ?
                    Container(
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
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
                              // Globals.homeObject = state.obj;
                              Globals.appSetting =
                                  AppSetting.fromJson(state.obj);
                              setState(() {});
                            } else if (state is RecordDetailSuccess) {
                              //Navigator.of(context, rootNavigator: true).pop();

                              if (state.recordObject != '' &&
                                      state.recordObject != null
                                  //  &&
                                  // state.isRecentRecod == false
                                  ) {
                                if (!state.isRecentRecod!) {
                                  Navigator.pop(context);
                                }

                                _route(
                                    obj: state.recordObject,
                                    objectType: state.objectType!,
                                    objectName: state.objectName!);
<<<<<<< HEAD
=======

>>>>>>> 18df4ad4cdfae0a1e47e0a12a0811d330d58f22e
                              } else {
                                Utility.showSnackBar(
                                    _scaffoldKey,
                                    "please make sure you have a proper internet connection",
                                    context);
                              }
                            } else if (state is RefrenceSearchLoading) {
                              return showLoadingDialog(context);
                            } else if (state is HomeErrorReceived) {}
                          },
                          child: EmptyContainer()),
                    ),
                  ]),
                );
              },
              child: Container()),
          onRefresh: refreshPage,
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchStandardNavigationBar());
  }

  Future _setFree() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future _setLocked() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
        useRootNavigator: false,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ]),
                    )
                  ]));
        });
  }
}
