import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/families/ui/family.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/news/ui/news.dart';
import 'package:Soc/src/modules/social/ui/Soical.dart';
import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/modules/staff/ui/staff.dart';
import 'package:Soc/src/modules/students/ui/student.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/common_pdf_viewer_page.dart';
import 'package:Soc/src/widgets/customList.dart';
import 'package:Soc/src/widgets/html_description.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/internalbuttomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubListPage extends StatefulWidget {
  var obj;
  String? module;
  bool isbuttomsheet;

  SubListPage(
      {Key? key,
      required this.obj,
      required this.module,
      required this.isbuttomsheet})
      : super(key: key);
  @override
  _SubListPageState createState() => _SubListPageState();
}

class _SubListPageState extends State<SubListPage> {
  FocusNode myFocusNode = new FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FamilyBloc _bloc = FamilyBloc();
  StaffBloc _staffBloc = StaffBloc();

  @override
  void initState() {
    super.initState();
    if (widget.module == "family") {
      _bloc.add(FamiliesSublistEvent(id: widget.obj.id));
    } else if (widget.module == "staff") {
      _staffBloc.add(StaffSubListEvent(id: widget.obj.id));
    }

    // _selectedIndex = Globals.internalBottombarIndex;
  }

  _route(obj, index) {
    if (obj.typeC == "URL") {
      obj.appUrlC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InAppUrlLauncer(
                        title: obj.titleC!,
                        url: obj.appUrlC!,
                        isbuttomsheet: true,
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No link available", context);
    } else if (obj.typeC == "RFT_HTML" || obj.typeC == "RTF/HTML") {
      obj.rtfHTMLC != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AboutusPage(
                        htmlText: obj.rtfHTMLC.toString(),
                        url: obj.appUrlC!,
                        isbuttomsheet: true,
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
                      )))
          : Utility.showSnackBar(_scaffoldKey, "No pdf available", context);
    } else {
      print("");
    }
  }

  Widget _buildList(int index, Widget listItem, obj) {
    return GestureDetector(
        onTap: () {
          _route(obj, index);
        },
        child: ListWidget(index, _buildFormName(index, obj)));
  }

  // selectedpage(context, _selectedIndex) {
  //   if (_selectedIndex == 0) {
  //     return Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => HomePage()));
  //   } else if (_selectedIndex == 1) {
  //     return Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => HomePage()));
  //   } else if (_selectedIndex == 2) {
  //     return Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => HomePage()));
  //   } else if (_selectedIndex == 3) {
  //     return Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => HomePage()));

  //   } else if (_selectedIndex == 4) {
  //     return Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => HomePage()));
  //   }
  // }

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
        appBar: CustomAppBarWidget(
          isSearch: true,
          isShare: false,
          sharedpopBodytext: '',
          sharedpopUpheaderText: '',
        ),
        key: _scaffoldKey,
        body: widget.module == "family"
            ? BlocBuilder<FamilyBloc, FamilyState>(
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
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                })
            : widget.module == 'staff'
                ? BlocBuilder<StaffBloc, StaffState>(
                    bloc: _staffBloc,
                    builder: (BuildContext contxt, StaffState state) {
                      if (state is StaffInitial || state is StaffLoading) {
                        return Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).accentColor,
                        ));
                      } else if (state is StaffSubListSucess) {
                        return SingleChildScrollView(
                          child: SafeArea(
                            child: Column(
                              children: [
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: state.obj!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _buildList(
                                        index,
                                        _buildFormName(
                                            index, state.obj![index]),
                                        state.obj![index]);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    })
                : Container(),
        bottomNavigationBar: widget.isbuttomsheet && Globals.homeObjet != null
            ? InternalButtomNavigationBar()
            : null);
  }
}
