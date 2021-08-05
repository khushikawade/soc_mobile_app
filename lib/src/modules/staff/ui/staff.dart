import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/modules/staff/models/staffmodal.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/common_sublist.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffPage extends StatefulWidget {
  StaffPage({Key? key, this.title, this.language}) : super(key: key);
  final String? title;
  String? language;

  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  static const double _kLabelSpacing = 16.0;
  FocusNode myFocusNode = new FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StaffBloc _bloc = StaffBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(StaffPageEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  _route(StaffList obj, index) {
    if (obj.typeC == "URL") {
      obj.urlC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InAppUrlLauncer(
                        title: obj.titleC!,
                        url: obj.urlC!,
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (obj.typeC == "HTML/RTF") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
                        // url: obj.urlC.toString(),
                        isbuttomsheet: true,
                        ishtml: true,
                        appbarTitle: obj.titleC!,
                        language: Globals.selectedLanguage,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No data available", context);
    } else if (obj.typeC == "PDF") {
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
                    obj: obj,
                    module: "staff",
                    isbuttomsheet: true,
                    appBarTitle: obj.titleC!,
                    language: Globals.selectedLanguage,
                  )));
    } else {
      Utility.showSnackBar(_scaffoldKey, "No data available", context);
    }
  }

  Widget _buildLeading(StaffList obj) {
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
                  child: ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
                  )),
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
        // color: AppTheme.kListIconColor3,
        size: Globals.deviceType == "phone" ? 18 : 26,
      );
    }
  }

  Widget _buildList(StaffList obj, int index) {
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
        child: obj.titleC != null && obj.titleC!.length > 0
            ? ListTile(
                onTap: () {
                  _route(obj, index);
                },
                visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                contentPadding: EdgeInsets.only(
                    left: _kLabelSpacing, right: _kLabelSpacing / 2),
                leading: _buildLeading(obj),
                // leading: Icon(
                //   IconData(
                //     int.parse('0x${obj.appIconC!}'),
                //     fontFamily: 'FontAwesomeSolid',
                //     fontPackage: 'font_awesome_flutter',
                //   ),
                //   // color: AppTheme.kListIconColor3,
                //   size: Globals.deviceType == "phone" ? 18 : 26,
                // ),
                title: Globals.selectedLanguage != null &&
                        Globals.selectedLanguage != "English"
                    ? TranslationWidget(
                        message: obj.titleC.toString(),
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
              )
            : Container(
                child: Globals.selectedLanguage != null &&
                        Globals.selectedLanguage != "English"
                    ? TranslationWidget(
                        message: "No data found",
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                        ),
                      )
                    : Text("No data found")));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
          refresh: (v) {
            setState(() {});
          },
        ),
        body: BlocBuilder<StaffBloc, StaffState>(
            bloc: _bloc,
            builder: (BuildContext contxt, StaffState state) {
              if (state is StaffInitial || state is StaffLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is StaffDataSucess) {
                return Column(
                  children: [
                    state.obj != null && state.obj!.length > 0
                        ? Container(
                            child: Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: state.obj!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildList(state.obj![index], index);
                                },
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Globals.selectedLanguage != null &&
                                    Globals.selectedLanguage != "English"
                                ? TranslationWidget(
                                    message: "No data found",
                                    fromLanguage: "en",
                                    toLanguage: Globals.selectedLanguage,
                                    builder: (translatedMessage) => Text(
                                      // obj.titleC.toString(),
                                      translatedMessage.toString(),
                                    ),
                                  )
                                : Text("No data found"),
                          ),
                  ],
                );
              } else if (state is ErrorInStaffLoading) {
                return Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Globals.selectedLanguage != null &&
                          Globals.selectedLanguage != "English"
                      ? TranslationWidget(
                          message: "Unable to load the data",
                          fromLanguage: "en",
                          toLanguage: Globals.selectedLanguage,
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
