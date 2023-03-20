import 'package:Soc/src/modules/custom/model/custom_setting.dart';
import 'package:Soc/src/modules/custom/ui/open_external_browser_button.dart';
import 'package:Soc/src/modules/families/ui/contact.dart';
import 'package:Soc/src/modules/families/ui/event_with_banners.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/schools_directory/ui/schools_directory.dart';
import 'package:Soc/src/modules/shared/models/shared_list.dart';
import 'package:Soc/src/modules/shared/ui/common_list_widget.dart';
import 'package:Soc/src/modules/social/ui/social_new.dart';
import 'package:Soc/src/modules/staff_directory/staffdirectory.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import '../../../widgets/inapp_url_launcher.dart';
import '../../shared/ui/common_grid_widget.dart';

class CustomPages extends StatefulWidget {
  final List<SharedList>? customList;
  final CustomSetting? customObj;
  final ScrollController? scrollController;

  CustomPages({
    Key? key,
    this.customList,
    this.customObj,
    required this.scrollController,
  }) : super(key: key);

  @override
  _CustomPagesState createState() => _CustomPagesState();
}

class _CustomPagesState extends State<CustomPages> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  HomeBloc _homeBloc = HomeBloc();
  var pdfViewerKey = UniqueKey();
  bool? isErrorState = false;

  @override
  void initState() {
    super.initState();
    // Utility.setLocked();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _homeBloc.add(FetchStandardNavigationBar());
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        key: _scaffoldKey,
        body: //_body('body1')
            widget.customObj!.sectionTemplate == "Calendar/Events"
                ? bodyView()
                : RefreshIndicator(
                    key: refreshKey,
                    child: bodyView(),
                    onRefresh: refreshPage,
                  ));
  }

  Widget bodyView() {
    return OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;

          if (connected) {
            if (isErrorState == true) {
              isErrorState = false;
            }
          } else if (!connected) {
            isErrorState = true;
          }

          return Stack(
            fit: StackFit.expand,
            //   mainAxisSize: MainAxisSize.max,
            children: [
              buildPage(widget.customList!, widget.customObj!, connected),
              Container(
                height: 0,
                width: 0,
                child: BlocListener<HomeBloc, HomeState>(
                    bloc: _homeBloc,
                    listener: (context, state) async {
                      if (state is BottomNavigationBarSuccess) {
                        AppTheme.setDynamicTheme(Globals.appSetting, context);
                        Globals.appSetting = AppSetting.fromJson(state.obj);
                        // setState(() {});
                      }
                    },
                    child: EmptyContainer()),
              ),
            ],
          );
          // connected?
        },
        child: Container());
  }

  Widget buildPage(List<SharedList> list, CustomSetting obj, connected) {
    if (obj.sectionTemplate == 'List Menu') {
      return CommonListWidget(
          scrollController: widget.scrollController,
          scaffoldKey: _scaffoldKey,
          connected: connected,
          data: list,
          sectionName: "Custom");
    } else if (obj.sectionTemplate == 'Grid Menu') {
      return CommonGridWidget(
          scrollController: widget.scrollController,
          scaffoldKey: _scaffoldKey,
          connected: connected,
          data: list,
          sectionName: "Custom");
    } else if (obj.sectionTemplate == "URL") {
      return obj.appUrlC != null && obj.appUrlC != ""
          ? (obj.appUrlC.toString().split(":")[0] == 'http'
                  // || obj.deepLinkC == 'YES'
                  ? OpenExternalBrowser(
                      url: obj.appUrlC,
                      connected: true,
                    ) // TODO: Add a proper message when links are unable to open
                  : InAppUrlLauncer(
                      title: obj.sectionTitleC!, // "no scaffold",
                      url: obj.appUrlC,
                      isBottomSheet: true,
                      language: Globals.selectedLanguage,
                      isCustomMainPageWebView: true,
                    )

              //  HomeInAppUrlLauncher(
              //     url: obj.appUrlC,
              //     language: Globals.selectedLanguage,
              //   )
              )
          : NoDataFoundErrorWidget(
              isResultNotFoundMsg: false,
              isNews: false,
              isEvents: false,
              connected: true);
    } else if (obj.sectionTemplate == "RTF_HTML" ||
        obj.sectionTemplate == "RFT_HTML" ||
        obj.sectionTemplate == "HTML/RTF" ||
        obj.sectionTemplate == "RTF/HTML") {
      return obj.rtfHTMLC != null && obj.rtfHTMLC != ""
          ? AboutusPage(
              htmlText: obj.rtfHTMLC.toString(),
              isBottomSheet: true,
              ishtml: true,
              isAppBar: false,
              language: Globals.selectedLanguage,
              appbarTitle: '',
            )
          : NoDataFoundErrorWidget(
              isResultNotFoundMsg: false,
              isNews: false,
              isEvents: false,
              connected: true);
    } else if (obj.sectionTemplate == "Embedded iFrame") {
      return obj.rtfHTMLC != null && obj.rtfHTMLC != ""
          ? InAppUrlLauncer(
              hideAppbar: true,
              isiFrame: true,
              title: obj.sectionTitleC!,
              url: obj.rtfHTMLC,
              // obj.appUrlC,
              isBottomSheet: false,
              language: Globals.selectedLanguage,
            )
          : NoDataFoundErrorWidget(
              isResultNotFoundMsg: false,
              isNews: false,
              isEvents: false,
              connected: true);
    } else if (obj.sectionTemplate == "PDF URL" ||
        obj.sectionTemplate == "PDF") {
      return obj.pdfURL != null && obj.pdfURL != ""
          ? Expanded(
              child: CommonPdfViewerPage(
                isOCRFeature: false,
                tittle: '',
                isHomePage: true,
                url: obj.pdfURL,
                isBottomSheet: true,
                language: Globals.selectedLanguage,
              ),
            )
          : NoDataFoundErrorWidget(
              isResultNotFoundMsg: false,
              isNews: false,
              isEvents: false,
              connected: true);
    } else if (obj.sectionTemplate == "Contact") {
      return ContactPage(
        obj: Globals.appSetting,
        isBottomSheet: true,
        isAppBar: false,
        language: Globals.selectedLanguage ?? "English",
        appBarTitle: '',
      );
    } else if (obj.sectionTemplate == "Calendar/Events") {
      return obj.calendarId != null && obj.calendarId != ""
          ? EventPage(
              customObj: widget.customObj,
              isMainPage: true,
              appBarTitle: '',
              isAppBar: false,
              isBottomSheet: true,
              language: Globals.selectedLanguage,
              calendarId: obj.calendarId.toString(),
            )
          : NoDataFoundErrorWidget(
              isResultNotFoundMsg: false,
              isNews: false,
              isEvents: false,
              connected: true);
    } else if (obj.sectionTemplate == "RSS Feed") {
      Globals.appSetting.socialapiurlc = obj.rssFeed;
      return Expanded(child: SocialNewPage());
    } else if (obj.sectionTemplate == "Org Directory") {
      return SchoolDirectoryPage(
        obj: widget.customObj,
        isStandardPage: null, //To omit the appbar
        isSubmenu: false,
        isCustomSection: true,
      );
    } else if (obj.sectionTemplate == "Personnel Directory") {
      return StaffDirectory(
        isCustom: true,
        // staffDirectoryCategoryId: obj.id,
        appBarTitle: obj.sectionTitleC!,
        obj: widget.customObj,
        isBottomSheet: true,
        isAbout: false,
        isSubmenu: null, //To omit the appbar
        language: Globals.selectedLanguage,
      );
    }
    return NoDataFoundErrorWidget(
        isResultNotFoundMsg: false,
        isNews: false,
        isEvents: false,
        connected: true);
  }
}
