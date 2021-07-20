import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/modules/staff/bloc/staff_bloc.dart';
import 'package:Soc/src/modules/staff/models/models/staffmodal.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

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
  StaffBloc _bloc = StaffBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(StaffPageEvent());
  }

  //STYLE
  // static const _kheadingStyle = TextStyle(
  //     fontFamily: "Roboto Bold",
  //     fontWeight: FontWeight.bold,
  //     fontSize: 16,
  //     color: Color(0xff2D3F98));

  // static const _ktextStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto Regular",
  //   fontSize: 14,
  //   color: Color(0xff2D3F98),
  // );

  _route(StaffList obj, index) {
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
    } else if (obj.typeC == "PDF URL") {
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

  // // UI Widget
  // Widget _buildIcon() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Container(
  //           child: Image.asset(
  //         'assets/images/splash_bear_icon.png',
  //         fit: BoxFit.fill,
  //         height: _kIconSize,
  //         width: _kIconSize,
  //       )),
  //     ],
  //   );
  // }

  // Widget _buildHeading() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Text(
  //         "This content has beeen locked.",
  //         style: Theme.of(context).textTheme.headline2,
  //       )
  //     ],
  //   );
  // }

  // Widget _buildcontent() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(
  //             "Please unlock this content to continue.",
  //             style: Theme.of(context).textTheme.bodyText1,
  //             textAlign: TextAlign.center,
  //           )
  //         ],
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(
  //             "If you need support accessing this page, please reach ",
  //             style: Theme.of(context).textTheme.bodyText1,
  //             textAlign: TextAlign.center,
  //           ),
  //         ],
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(
  //             "out to Mr. Edwards.",
  //             style: Theme.of(context).textTheme.bodyText1,
  //             textAlign: TextAlign.center,
  //           )
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildPasswordField() {
  //   return Padding(
  //     padding: const EdgeInsets.all(_kLabelSpacing),
  //     child: TextFormField(
  //       focusNode: myFocusNode,
  //       decoration: InputDecoration(
  //         labelText: 'Please enter the password',
  //         border: OutlineInputBorder(),
  //       ),
  //     ),
  //   );
  // }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: ListView(children: [
  //       Center(
  //           child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           SpacerWidget(_kLabelSpacing * 2.0),
  //           _buildIcon(),
  //           SpacerWidget(_kLabelSpacing),
  //           _buildHeading(),
  //           SpacerWidget(_kLabelSpacing / 2),
  //           _buildcontent(),
  //           SpacerWidget(_kLabelSpacing),
  //           _buildPasswordField(),
  //         ],
  //       )),
  //     ]),
  //   );
  // }
}
