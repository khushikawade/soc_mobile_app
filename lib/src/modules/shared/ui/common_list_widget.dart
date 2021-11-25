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
import 'package:Soc/src/widgets/custom_icon_widget.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:flutter/material.dart';

import '../../../widgets/no_data_found_error_widget.dart';

class CommonListWidget extends StatefulWidget {
  final List<SharedList> data;
  final String sectionName;
  CommonListWidget({required this.data, required this.sectionName});
  @override
  _CommonListWidgetState createState() => _CommonListWidgetState();
}

class _CommonListWidgetState extends State<CommonListWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
 

  _launchURL(obj) async {
    if (obj.appUrlC.toString().split(":")[0] == 'http') {
      await Utility.launchUrlOnExternalBrowser(obj.appUrlC);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: obj.titleC,
                    url: obj.appUrlC,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    }
  }

  _navigate(SharedList obj, index) {
    if (obj.typeC == "Contact") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ContactPage(
                    obj: Globals.homeObject,
                    isbuttomsheet: true,
                    appBarTitle: obj.titleC!,
                    language: Globals.selectedLanguage ?? "English",
                  )));
    } else if (obj.typeC == "URL") {
      obj.appUrlC != null
          ? _launchURL(obj)
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
    } else if (obj.typeC == "Calendar/Events") {
      obj.calendarId != null && obj.calendarId != ""
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => EventPage(
                        isbuttomsheet: true,
                        appBarTitle: obj.titleC,
                        language: Globals.selectedLanguage,
                        // calendarId: obj.calendarId.toString(),
                      )))
          : Utility.showSnackBar(
              _scaffoldKey, "No calendar/events available", context);
    } else if (obj.typeC == "RFT_HTML" ||
        obj.typeC == "HTML/RTF" ||
        obj.typeC == "RTF/HTML") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
                        isbuttomsheet: true,
                        ishtml: true,
                        appbarTitle: obj.titleC!,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No data available", context);
    } else if (obj.typeC == "Embed iFrame") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InAppUrlLauncer(
                        isiFrame: true,
                        title: obj.titleC!,
                        url: obj.rtfHTMLC.toString(),
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No data available", context);
    } else if (obj.typeC == "PDF URL" || obj.typeC == "PDF") {
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
                    module: widget.sectionName,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    } else {
      Utility.showSnackBar(_scaffoldKey, "No data available", context);
    }
  }

  Widget _buildLeading(SharedList obj) {
    if (obj.appIconUrlC != null) {
      return CustomIconWidget(
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
      return CustomIconWidget(
        iconUrl: Overrides.defaultIconUrl,
      );
    }
  }

  Widget _buildList(SharedList obj, int index) {
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
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: widget.data.length > 0
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
                scrollDirection: Axis.vertical,
                itemCount: widget.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildList(widget.data[index], index);
                },
              )
            : Container(
                child: NoDataFoundErrorWidget(
                isResultNotFoundMsg: false,
                isNews: false,
                isEvents: false,
              )));
  }
}
