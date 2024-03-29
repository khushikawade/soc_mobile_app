import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/contact.dart';
import 'package:Soc/src/modules/families/ui/event.dart';
import 'package:Soc/src/modules/families/ui/event_with_banners.dart';
import 'package:Soc/src/modules/shared/ui/common_grid_folder_widget.dart';
import 'package:Soc/src/modules/staff_directory/staffdirectory.dart';
import 'package:Soc/src/modules/shared/models/shared_list.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/styles/marquee.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/custom_image_widget_small.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../../../widgets/no_data_found_error_widget.dart';
import '../../schools_directory/ui/schools_directory.dart';

class CommonGridWidget extends StatefulWidget {
  final List<SharedList> data;
  final String sectionName;
  final bool? connected;
  final scaffoldKey;
  final double? bottomPadding;
  final ScrollController? scrollController;

  CommonGridWidget(
      {Key? key,
      required this.data,
      required this.sectionName,
      required this.scaffoldKey,
      required this.scrollController,
      this.bottomPadding,
      this.connected})
      : super(key: key);
  @override
  _CommonGridWidgetState createState() => _CommonGridWidgetState();
}

class _CommonGridWidgetState extends State<CommonGridWidget> {
  static const double _kLableSpacing = 12.0;
  // bool? isLoading = false;
  List<SharedList> subList = [];

  _launchURL(SharedList obj) async {
    if (obj.appUrlC.toString().split(":")[0] == 'http' ||
        obj.deepLinkC == 'YES') {
      await Utility.launchUrlOnExternalBrowser(obj.appUrlC!);
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: obj.titleC!,
                    url: obj.appUrlC!,
                    isBottomSheet: true,
                    language: Globals.selectedLanguage,
                  )));
    }
  }

  _navigate(List<SharedList> list, SharedList obj, index) async {
    await FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "${widget.sectionName}_${obj.titleC!}");

    if (obj.typeC == "Contact") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ContactPage(
                    obj: Globals.appSetting,
                    isBottomSheet: true,
                    appBarTitle: obj.titleC!,
                    language: Globals.selectedLanguage ?? "English",
                  )));
    } else if (obj.typeC == "URL") {
      obj.appUrlC != null && obj.appUrlC != ""
          ? _launchURL(obj)
          : Utility.showSnackBar(
              widget.scaffoldKey, "No link available", context, null);
    } else if (obj.typeC == "Form") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffDirectory(
                    isCustom: widget.sectionName == 'Custom' ? true : false,
                    isSubmenu:
                        obj.typeC == 'Org Directory' || obj.typeC == "Form"
                            ? true
                            : false,
                    staffDirectoryCategoryId: null,
                    isAbout: true,
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    isBottomSheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (obj.typeC == "Calendar/Events") {
      obj.calendarId != null && obj.calendarId != ""
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => EventPage(
                        isBottomSheet: true,
                        appBarTitle: obj.titleC,
                        language: Globals.selectedLanguage,
                        calendarId: obj.calendarId.toString(),
                      )))
          : Utility.showSnackBar(widget.scaffoldKey,
              "No calendar/events available", context, null);
    } else if (obj.typeC == "RTF_HTML" ||
        obj.typeC == "RFT_HTML" ||
        obj.typeC == "HTML/RTF" ||
        obj.typeC == "RTF/HTML") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
                        isBottomSheet: true,
                        ishtml: true,
                        appbarTitle: obj.titleC!,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(
              widget.scaffoldKey, "No data available", context, null);
    } else if (obj.typeC == "Embed iFrame") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InAppUrlLauncer(
                        isiFrame: true,
                        title: obj.titleC!,
                        url: obj.rtfHTMLC.toString(),
                        isBottomSheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(
              widget.scaffoldKey, "No data available", context, null);
    } else if (obj.typeC == "PDF URL" || obj.typeC == "PDF") {
      obj.pdfURL != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => CommonPdfViewerPage(
                        isOCRFeature: false,
                        isHomePage: false,
                        url: obj.pdfURL,
                        title: obj.titleC,
                        isBottomSheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(
              widget.scaffoldKey, "No pdf available", context, null);
    } else if (obj.typeC == "Sub-Menu") {
      return subListDialog(obj);
    } else if (obj.typeC == "Staff_Directory") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffDirectory(
                    isCustom: false,
                    staffDirectoryCategoryId: obj.id,
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    isSubmenu: true,
                    isBottomSheet: true,
                    isAbout: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (obj.typeC == "School Directory" ||
        obj.typeC == 'Org Directory') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SchoolDirectoryPage(
                    title: obj.titleC,
                    isSubmenu: obj.typeC == 'Org Directory' ||
                            obj.typeC == "School Directory"
                        ? true
                        : false,
                    obj: obj,
                    isStandardPage: false,
                    isCustomSection: false, //Since its a record here
                  )));
    } else {
      Utility.showSnackBar(
          widget.scaffoldKey, "No data available", context, null);
    }
  }

  Widget _buildLeading(SharedList obj) {
    if (obj.appIconUrlC != null) {
      return CustomIconMode(
        darkModeIconUrl: obj.darkModeIconC,
        iconUrl: obj.appIconUrlC ?? Overrides.defaultIconUrl,
      );
    } else if (obj.appIconC != null) {
      return Icon(
        IconData(
          int.parse('0x${obj.appIconC!}'),
          fontFamily: 'FontAwesomeSolid',
          fontPackage: 'font_awesome_flutter',
        ),
        color: Theme.of(context).colorScheme.primary,
        size: Globals.deviceType == "phone" ? 24 : 32,
      );
    } else {
      return CustomIconMode(
        iconUrl: Overrides.defaultIconUrl,
      );
    }
  }

  Widget _buildGrid(
      List<SharedList> list, List<SharedList> subList, String key) {
    //print(
    // "inside heeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeellllll custom sectionnnnnnnnnn");
    return list.length > 0
        ? GridView.count(
            controller: widget.scrollController,
            shrinkWrap: true,
            key: ValueKey(key),
            padding: const EdgeInsets.only(
                bottom: AppTheme.klistPadding, top: AppTheme.kBodyPadding),
            childAspectRatio:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 1
                    : 3 / 2,
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait &&
                        Globals.deviceType == "phone"
                    ? 3
                    : (MediaQuery.of(context).orientation ==
                                Orientation.landscape &&
                            Globals.deviceType == "phone")
                        ? 4
                        : MediaQuery.of(context).orientation ==
                                    Orientation.portrait &&
                                Globals.deviceType != "phone"
                            ? 4
                            : MediaQuery.of(context).orientation ==
                                        Orientation.landscape &&
                                    Globals.deviceType != "phone"
                                ? 5
                                : 3,
            crossAxisSpacing: _kLableSpacing * 1.2,
            mainAxisSpacing: _kLableSpacing * 1.2,
            children: List.generate(
              list.length,
              (index) {
                return Container(
                  padding: EdgeInsets.only(
                    top: Globals.deviceType == "phone"
                        ? MediaQuery.of(context).size.height * 0.001
                        : MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: GestureDetector(
                      onTap: () => _navigate(
                          list, list[index], index), //_launchURL(list[index]),
                      child: Column(
                        // mainAxisAlignment:MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                              height: 80,
                              width: 80,
                              child: _buildLeading(list[index])),
                          Container(
                            child: TranslationWidget(
                              message: "${list[index].titleC}",
                              fromLanguage: "en",
                              toLanguage: Globals.selectedLanguage,
                              builder: (translatedMessage) => Container(
                                child: MediaQuery.of(context).orientation ==
                                            Orientation.portrait &&
                                        translatedMessage.toString().length > 11
                                    ? Expanded(
                                        child: MarqueeWidget(
                                        pauseDuration: Duration(seconds: 1),
                                        child: Text(
                                          translatedMessage.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  fontSize:
                                                      Globals.deviceType ==
                                                              "phone"
                                                          ? 16
                                                          : 24),
                                        ),
                                      )

                                        //  Marquee(
                                        //   text: translatedMessage.toString(),
                                        //   style: Theme.of(context)
                                        //       .textTheme
                                        //       .bodyText1!
                                        //       .copyWith(
                                        //           fontSize:
                                        //               Globals.deviceType ==
                                        //                       "phone"
                                        //                   ? 16
                                        //                   : 24),
                                        //   scrollAxis: Axis.horizontal,
                                        //   velocity: 30.0,
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   blankSpace: 50,
                                        //   //MediaQuery.of(context).size.width
                                        //   // velocity: 100.0,
                                        //   pauseAfterRound: Duration(seconds: 5),
                                        //   showFadingOnlyWhenScrolling: true,
                                        //   startPadding: 10.0,
                                        //   accelerationDuration:
                                        //       Duration(seconds: 1),
                                        //   accelerationCurve: Curves.linear,
                                        //   decelerationDuration:
                                        //       Duration(milliseconds: 500),
                                        //   decelerationCurve: Curves.easeOut,
                                        //   numberOfRounds: 1,
                                        // ),
                                        )
                                    : MediaQuery.of(context).orientation ==
                                                Orientation.landscape &&
                                            translatedMessage
                                                    .toString()
                                                    .length >
                                                18
                                        ? Expanded(
                                            child: MarqueeWidget(
                                            pauseDuration: Duration(seconds: 1),
                                            child: Text(
                                              translatedMessage.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      fontSize:
                                                          Globals.deviceType ==
                                                                  "phone"
                                                              ? 16
                                                              : 24),
                                            ),
                                          )

                                            //    Marquee(
                                            //   text: translatedMessage.toString(),
                                            //   style: Theme.of(context)
                                            //       .textTheme
                                            //       .bodyText1!
                                            //       .copyWith(
                                            //           fontSize:
                                            //               Globals.deviceType ==
                                            //                       "phone"
                                            //                   ? 16
                                            //                   : 24),
                                            //   scrollAxis: Axis.horizontal,
                                            //   velocity: 30.0,
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.start,

                                            //   blankSpace:
                                            //       50, //MediaQuery.of(context).size.width
                                            //   // velocity: 100.0,
                                            //   pauseAfterRound:
                                            //       Duration(seconds: 5),
                                            //   showFadingOnlyWhenScrolling: true,
                                            //   startPadding: 10.0,
                                            //   accelerationDuration:
                                            //       Duration(seconds: 1),
                                            //   accelerationCurve: Curves.linear,
                                            //   decelerationDuration:
                                            //       Duration(milliseconds: 500),
                                            //   decelerationCurve: Curves.easeOut,
                                            //   numberOfRounds: 1,
                                            // )
                                            )
                                        : SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              translatedMessage.toString(),
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      fontSize:
                                                          Globals.deviceType ==
                                                                  "phone"
                                                              ? 16
                                                              : 24),
                                            ),
                                          ),
                              ),
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          )
        : NoDataFoundErrorWidget(
            isResultNotFoundMsg: false,
            isNews: false,
            isEvents: false,
            // connected: connected,
          );
  }

  @override
  Widget build(BuildContext context) {
    return widget.data.length > 0
        ? Container(
            // padding: EdgeInsets.symmetric(horizontal: 5),
            padding: EdgeInsets.only(
                left: 5, right: 5, bottom: widget.bottomPadding ?? 0.0),
            child: _buildGrid(widget.data, widget.data, "key"))
        : Container(
            child: NoDataFoundErrorWidget(
                isResultNotFoundMsg: false,
                isNews: false,
                isEvents: false,
                connected: true));
  }

  subListDialog(obj) {
    showDialog(
        useRootNavigator: false,
        // barrierColor: Color.fromARGB(96, 73, 73, 75),
        context: context,
        builder: (_) => CommonGridFolder(
              obj: obj,
              sectionName: widget.sectionName,
              scaffoldKey: widget.scaffoldKey,
              // folderName: title,
            ));
  }
}
