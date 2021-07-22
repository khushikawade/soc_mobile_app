import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/modules/staff/models/staffmodal.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/common_sublist.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffPage extends StatefulWidget {
  StaffPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  static const double _kIconSize = 188;
  static const double _kLabelSpacing = 20.0;
  FocusNode myFocusNode = new FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StaffBloc _bloc = StaffBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(StaffPageEvent());
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
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (obj.typeC == "HTML/RTF") {
      obj.rtfHTMLC != null
          ?
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context) =>
          //             SubListPage(title: obj.titleC, module: "staff")))

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
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
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No pdf available", context);
    } else if (obj.typeC == "Sub-Menu") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  SubListPage(obj: obj, module: "staff")));
    } else {
      Utility.showSnackBar(_scaffoldKey, "No data available", context);
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
        body: BlocBuilder<StaffBloc, StaffState>(
            bloc: _bloc,
            builder: (BuildContext contxt, StaffState state) {
              if (state is StaffInitial || state is StaffLoading) {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor,
                ));
              } else if (state is StaffDataSucess) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.obj!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildList(state.obj![index], index);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }));
  }
}
