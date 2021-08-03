import 'package:Soc/src/modules/families/ui/contact.dart';
import 'package:Soc/src/modules/families/ui/event.dart';
import 'package:Soc/src/modules/families/ui/staffdirectory.dart';
import 'package:Soc/src/modules/home/ui/app_Bar_widget.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/common_sublist.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/families/modal/family_list.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Soc/src/globals.dart';

class FamilyPage extends StatefulWidget {
  var obj;
  var searchObj;
  FamilyPage({Key? key, this.obj, this.searchObj}) : super(key: key);

  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  static const double _kLabelSpacing = 16.0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FamilyBloc _bloc = FamilyBloc();
  var object;
  @override
  void initState() {
    super.initState();
    _bloc.add(FamiliesEvent());
  }

  @override
  void dispose() {
    super.dispose();
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

  Widget _buildList(FamiliesList obj, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.kDividerColor2,
          width: 0.65,
        ),
        borderRadius: BorderRadius.circular(0.0),
        color: (index % 2 == 0)
            ? Theme.of(context).backgroundColor
            : Theme.of(context).colorScheme.secondary,
      ),
      child: ListTile(
        onTap: () {
          _route(obj, index);
        },
        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
        contentPadding:
            EdgeInsets.only(left: _kLabelSpacing, right: _kLabelSpacing / 2),
        leading: Icon(
          IconData(
            int.parse(obj.appIconC!),
            fontFamily: 'FontAwesomeSolid',
            fontPackage: 'font_awesome_flutter',
          ),
          color: AppTheme.kListIconColor3,
          size: Globals.deviceType == "phone" ? 18 : 26,
        ),
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
          color: AppTheme.kButtonbackColor,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(),
        body: BlocBuilder<FamilyBloc, FamilyState>(
            bloc: _bloc,
            builder: (BuildContext contxt, FamilyState state) {
              if (state is FamilyInitial || state is FamilyLoading) {
                return Center(
                    child: CircularProgressIndicator(
                  
                ));
              } else if (state is FamiliesDataSucess) {
                return state.obj != null && state.obj!.length > 0
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: state.obj!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildList(state.obj![index], index);
                        },
                      )
                    : Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Globals.selectedLanguage != null &&
                                Globals.selectedLanguage != "English"
                            ? TranslationWidget(
                                message: "No data found",
                                toLanguage: Globals.selectedLanguage,
                                fromLanguage: "en",
                                builder: (translatedMessage) => Text(
                                  translatedMessage.toString(),
                                ),
                              )
                            : Text("No data found"),
                      );
              } else if (state is ErrorLoading) {
                return Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Globals.selectedLanguage != null &&
                          Globals.selectedLanguage != "English"
                      ? TranslationWidget(
                          message: "Unable to load the data",
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                          ),
                        )
                      : Text("Unable to load the data"),
                );
              } else {
                return Container();
              }
            }));
  }
}
