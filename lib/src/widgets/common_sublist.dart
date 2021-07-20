import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/families/modal/family_sublist.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/customList.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/searchfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubListPage extends StatefulWidget {
  var title;

  SubListPage({
    Key? key,
    required this.title,
  }) : super(key: key);
  @override
  _SubListPageState createState() => _SubListPageState();
}

class _SubListPageState extends State<SubListPage> {
  static const double _kLabelSpacing = 17.0;
  FocusNode myFocusNode = new FocusNode();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FamilyBloc _bloc = FamilyBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(FamiliesSublistEvent());
  }

  _route(FamiliesSubList obj, index) {
    if (obj.typeC == "URL") {
      obj.appUrlC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InAppUrlLauncer(
                        title: obj.titleC!,
                        url: obj.appUrlC!,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (obj.typeC == "RFT_HTML") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No data available", context);
    } else if (obj.typeC == "PDF") {
      print(obj.pdfURL);
      obj.pdfURL != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => CommonPdfViewerPage(
                        url: obj.pdfURL,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No pdf available", context);
    } else if (obj.typeC == "Sub-Menu") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SubListPage(
                    title: obj.titleC,
                  )));
    } else {
      print("");
    }
  }

  Widget _buildSearchfield() {
    return SearchFieldWidget();
  }

  Widget _buildList(int index, Widget listItem, obj) {
    return GestureDetector(
        onTap: () {
          _route(obj, index);
        },
        child: ListWidget(index, _buildFormName(index, obj)));
  }

  Widget _buildFormName(int index, obj) {
    return InkWell(
      child: Text(
        obj.titleC.toString(),
        style: Theme.of(context).textTheme.bodyText1,
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
              } else if (state is FamiliesSublistSucess) {
                return SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        _buildSearchfield(),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.obj!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildList(
                                index,
                                _buildFormName(index, state.obj![index]),
                                state.obj![index]);
                          },
                        ),
                        // ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }));
  }
}
