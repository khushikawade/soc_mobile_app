import 'package:Soc/src/modules/families/ui/contact.dart';
import 'package:Soc/src/modules/families/ui/event.dart';
import 'package:Soc/src/modules/families/ui/staffdirectory.dart';
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
import 'package:html/dom_parsing.dart';

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

  @override
  void initState() {
    super.initState();
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
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (obj.titleC == "Staff Directory") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StaffDirectory(
                    obj: obj,
                    isbuttomsheet: true,
                  )));
    } else if (obj.titleC == "Calendar/Events") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => EventPage(
                    isbuttomsheet: true,
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
            : AppTheme.kListBackgroundColor2,
      ),
      child: ListTile(
        onTap: () {
          _route(obj, index);
        },
        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
        contentPadding:
            EdgeInsets.only(left: _kLabelSpacing, right: _kLabelSpacing / 2),
        leading: Icon(
          Icons.list,
          color: AppTheme.kListIconColor3,
        ),
        title: Text(
          obj.titleC.toString(),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: AppTheme.kButtonbackColor,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: BlocBuilder<FamilyBloc, FamilyState>(
            bloc: _bloc,
            builder: (BuildContext contxt, FamilyState state) {
              if (state is FamilyInitial || state is FamilyLoading) {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor,
                ));
              } else if (state is FamiliesDataSucess) {
                return SingleChildScrollView(
                  child: state.obj != null && state.obj!.length > 0
                      ? Container(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.obj!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildList(state.obj![index], index);
                            },
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Text("No data found"),
                        ),
                );
              } else if (state is ErrorLoading) {
                return Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Text("Unable to load the data"),
                );
              } else {
                return Container();
              }
            }));
  }
}
