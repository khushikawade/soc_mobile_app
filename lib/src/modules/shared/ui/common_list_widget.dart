import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/ui/contact.dart';
import 'package:Soc/src/modules/families/ui/event.dart';
import 'package:Soc/src/modules/staff_directory/staffdirectory.dart';
import 'package:Soc/src/modules/shared/models/shared_list.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/modules/shared/ui/common_sublist.dart';
import 'package:Soc/src/widgets/custom_image_widget_small.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:flutter/material.dart';
import '../../../widgets/no_data_found_error_widget.dart';
import '../../schools_directory/ui/schools_directory.dart';

class CommonListWidget extends StatefulWidget {
  CommonListWidget(
      {Key? key,
      required this.data,
      required this.sectionName,
      required this.scaffoldKey,
      this.connected})
      : super(key: key);

  final bool? connected;
  final List<SharedList> data;
  final scaffoldKey;
  final String sectionName;

  @override
  _CommonListWidgetState createState() => _CommonListWidgetState();
}

class _CommonListWidgetState extends State<CommonListWidget> {
  _launchURL(SharedList obj, String queryParameter) async {
    if (obj.appUrlC.toString().split(":")[0] == 'http' ||
        obj.deepLinkC == 'YES') {
      await Utility.launchUrlOnExternalBrowser(obj.appUrlC!);
    } else {
      // print(queryParameter=='' ? obj.appUrlC! : obj.appUrlC!+'?'+queryParameter);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: obj.titleC!,
                    url: obj
                        .appUrlC!, //queryParameter=='' ? obj.appUrlC! : obj.appUrlC!+'?'+queryParameter,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                    //  hideAppbar: false,
                    // hideShare: true,
                    // zoomEnabled: false,
                    // callBackFunction: (value) {
                    //   // print(value);
                    //   if (value.toString().contains('displayName')) {
                    //     // Navigator.pop(context);
                    //   Future.delayed(const Duration(milliseconds: 2000), () {

                    //     Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (BuildContext context) =>
                    //                 OpticalCharacterRecognition()));
                    //                 });
                    //   }
                    // },
                  )));
    }
  }

  _navigate(SharedList obj, index) async {
    if (obj.typeC == "Contact") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ContactPage(
                    obj: Globals.appSetting,
                    isbuttomsheet: true,
                    appBarTitle: obj.titleC!,
                    language: Globals.selectedLanguage ?? "English",
                  )));
    } else if (obj.typeC == "URL") {
      obj.appUrlC != null && obj.appUrlC != ""
          ? await _launchURL(obj, '')
          : Utility.showSnackBar(
              widget.scaffoldKey, "No link available", context);
    } else if (obj.typeC == "Form") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffDirectory(
                    isCustom: widget.sectionName == 'Custom' ? true : false,
                    staffDirectoryCategoryId: null,
                    isAbout: true,
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    isSubmenu: true,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (obj.typeC == "Calendar/Events") {
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
              widget.scaffoldKey, "No calendar/events available", context);
    } else if (obj.typeC == "RTF_HTML" ||
        obj.typeC == "RFT_HTML" ||
        obj.typeC == "HTML/RTF" ||
        obj.typeC == "RTF/HTML") {
      obj.rtfHTMLC != null
          ? await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
                        isbuttomsheet: true,
                        ishtml: true,
                        appbarTitle: obj.titleC!,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(
              widget.scaffoldKey, "No data available", context);
    } else if (obj.typeC == "Embed iFrame") {
      obj.rtfHTMLC != null
          ? await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InAppUrlLauncer(
                        isiFrame: true,
                        title: obj.titleC!,
                        url: obj.rtfHTMLC.toString(),
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(
              widget.scaffoldKey, "No data available", context);
    } else if (obj.typeC == "PDF URL" || obj.typeC == "PDF") {
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
          : Utility.showSnackBar(
              widget.scaffoldKey, "No pdf available", context);
    } else if (obj.typeC == "Sub-Menu") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SubListPage(
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    module: widget.sectionName,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (obj.typeC == "Staff_Directory") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffDirectory(
                    isCustom: false,
                    staffDirectoryCategoryId: obj.id,
                    appBarTitle: obj.titleC!,
                    obj: obj,
                    isSubmenu: true,
                    isbuttomsheet: true,
                    isAbout: true,
                    language: Globals.selectedLanguage,
                  )));
    } else if (obj.typeC == "School Directory" ||
        obj.typeC == 'Org Directory') {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SchoolDirectoryPage(
                    title: obj.titleC,
                    isSubmenu: obj.typeC == 'Org Directory' ? true : false,
                    obj: obj,
                    isStanderdPage: false,
                  )));
      // } else if (obj.typeC == "OCR") {
      //   if (obj.isSecure == 'true') {
      //     obj.appUrlC != null && obj.appUrlC != ""
      //         ? await _launchURL(obj,Globals.appSetting.appLogoC)
      //         : Utility.showSnackBar(
      //             widget.scaffoldKey, "No authentication URL available", context);
      //   } else {
      //      await Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                             builder: (BuildContext context) =>
      //                                 OpticalCharacterRecognition()));}
    } else {
      Utility.showSnackBar(widget.scaffoldKey, "No data available", context);
    }
    // Utility.setLocked();
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
        darkModeIconUrl: obj.darkModeIconC,
        iconUrl: Overrides.defaultIconUrl,
      );
    }
  }

  Widget _buildList(SharedList obj, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.background,
          width: 0.65,
        ),
        borderRadius: BorderRadius.circular(0.0),
        color: (index % 2 == 0)
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.secondary,
      ),
      child: ListTile(
        onTap: () {
          _navigate(obj, index);
        },
        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
        // contentPadding:
        //     EdgeInsets.only(left: _kLabelSpacing, right: _kLabelSpacing / 2),
        leading: _buildLeading(obj),
        title: TranslationWidget(
            message: obj.titleC ?? "No title",
            fromLanguage: "en",
            toLanguage: Globals.selectedLanguage,
            builder: (translatedMessage) {
              return Text(translatedMessage.toString(),
                  style: Theme.of(context).textTheme.bodyText1!);
            }),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: Globals.deviceType == "phone" ? 12 : 20,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.data.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
            scrollDirection: Axis.vertical,
            itemCount: widget.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildList(widget.data[index], index);
            },
          )
        : NoDataFoundErrorWidget(
            isCalendarPageOrientationLandscape: false,
            isResultNotFoundMsg: false,
            isNews: false,
            isEvents: false,
            connected: true);
  }
}
