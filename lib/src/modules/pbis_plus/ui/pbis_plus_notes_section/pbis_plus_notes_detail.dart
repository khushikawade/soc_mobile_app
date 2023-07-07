// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_student_list_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PBISPlusNotesDetailPage extends StatefulWidget {
  final PBISPlusNotesUniqueStudentList item;

  PBISPlusNotesDetailPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<PBISPlusNotesDetailPage> createState() => _PBISPlusHistoryState();
}

class _PBISPlusHistoryState extends State<PBISPlusNotesDetailPage> {
  static const double _KVertcalSpace = 60.0;

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  FocusNode searchFocusNode = new FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // hide animated container
  PBISPlusBloc PBISPlusBlocInstance = new PBISPlusBloc();
  @override
  void initState() {
    super.initState();
    initMethod();
  }

  initMethod() async {
    // /*-------------------------User Activity Track START----------------------------*/
    // FirebaseAnalyticsService.addCustomAnalyticsEvent(
    //     "pbis_plus_history_screen");
    // FirebaseAnalyticsService.setCurrentScreen(
    //     screenTitle: 'pbis_plus_history_screen', screenClass: 'PBISPlusNotesDetailPage');
    // /*-------------------------User Activity Track END----------------------------*/
    PBISPlusBlocInstance.add(
        GetPBISPlusNotes(studentId: widget.item.studentId!));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonBackgroundImgWidget(),
      WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            extendBody: true,
            body: body(context)),
      )
    ]);
  }

  Widget _buildBackIcon() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
              IconData(0xe80d,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
              size: Globals.deviceType == 'phone' ? 24 : 32,
              color: AppTheme.kButtonColor),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return ListView(physics: NeverScrollableScrollPhysics(), children: [
      SpacerWidget(24),
      _buildBackIcon(),
      Padding(
          padding: EdgeInsets.only(left: 22, right: 22),
          child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text("${widget.item.names!.fullName!}'s" + " Notes",
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w500)))),
      SpacerWidget(_KVertcalSpace / 5),
      BlocConsumer(
          bloc: PBISPlusBlocInstance,
          builder: (context, state) {
            if (state is PBISPlusNotesSucess) {
              //---------------------return the filter list to UI-----------//
              return _listBuilder(state.notesList, isShimmerLoading: false);
            } else if (state is PBISPlusLoading || state is PBISPlusInitial) {
              return _listBuilder(
                  List.generate(10, (index) => PBISStudentNotes()),
                  isShimmerLoading: true);
            } else if (state is PBISErrorState) {
              return _noDataFoundWidget(state.error);
            }
            //Managing shimmer loading in case of initial loading
            return Container();
          },
          listener: (context, state) {})
    ]);
  }

//-----------------Build the Notes List-----------------------------------
  Widget _listBuilder(List<PBISStudentNotes> studentNotesList,
      {required final bool isShimmerLoading}) {
    return studentNotesList.length > 0
        ? Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: RefreshIndicator(
                color: AppTheme.kButtonColor,
                key: refreshKey,
                onRefresh: refreshPage,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: isShimmerLoading
                        ? NeverScrollableScrollPhysics()
                        : null,
                    padding: EdgeInsets.only(bottom: Platform.isIOS ? 80 : 48),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCard(
                          studentNotesList[index], index, isShimmerLoading);
                    },
                    itemCount: studentNotesList.length)))
        : RefreshIndicator(
            color: AppTheme.kButtonColor,
            key: refreshKey,
            onRefresh: refreshPage,
            child: NoDataFoundErrorWidget(
                isResultNotFoundMsg: true, isNews: false, isEvents: false));
  }
//-----------------Build the Notes List Card-----------------------------------

  Widget _buildCard(PBISStudentNotes obj, index, final bool isShimmerLoading) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 4),
        color: Theme.of(context).backgroundColor,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SpacerWidget(24),
              isShimmerLoading
                  ? localSimmerWidget(
                      height: MediaQuery.of(context).size.width * 0.3,
                      width: MediaQuery.of(context).size.width * 0.9)
                  : Text("${obj.notes ?? ""}",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Color(0xff000000) ==
                                  Theme.of(context).backgroundColor
                              ? Color(0xffFFFFFF)
                              : Color(0xff162429),
                          fontSize: 12)),
              SpacerWidget(24),
              _buildDateList(obj, isShimmerLoading),
              SpacerWidget(24)
            ])));
  }

//-----------------Build the Date List-----------------------------------
  Widget _buildDateList(PBISStudentNotes item, bool isShimmerLoading) {
    return Row(children: [
      _buildCardDateTime(item.date ?? "", true, isShimmerLoading),
      _buildCardDateTime(item.weekday ?? "", true, isShimmerLoading),
      _buildCardDateTime(item.time ?? "", false, isShimmerLoading)
    ]);
  }

//-----------------Build the Date Card Item-----------------------------------
  Widget _buildCardDateTime(item, bool isShowDivider, bool isShimmerLoading) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          isShimmerLoading
              ? localSimmerWidget(height: 15, width: 48)
              : Text("$item",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color:
                          Color(0xff000000) == Theme.of(context).backgroundColor
                              ? Color(0xffA6A6A6)
                              : Color(0xff162429),
                      fontSize: 10,
                      fontWeight: FontWeight.w500)),
          isShowDivider ? _buildVerticalDivider() : SizedBox.shrink()
        ]);
  }

//-----------------NO Data Found-----------------------------------
  Widget _noDataFoundWidget(String? errorMessage) {
    return Center(
        child: RefreshIndicator(
            color: AppTheme.kButtonColor,
            key: refreshKey,
            onRefresh: refreshPage,
            child: NoDataFoundErrorWidget(
                marginTop: MediaQuery.of(context).size.height / 4,
                isResultNotFoundMsg: false,
                isNews: false,
                isEvents: false,
                errorMessage: errorMessage //'No Notes Found',
                )));
  }

//---------------Build--Vertcial Divider-----------------------------------
  Widget _buildVerticalDivider() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        height: 12,
        width: 1, // Adjust the width as needed
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(
                    color: Color(0xFFAAAAAA), // Replace with your desired color
                    width: 1 // Adjust the width as needed
                    ))));
  }
//---------------Build--Refresh-------Function-----------------------------------

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    PBISPlusBlocInstance.add(
        GetPBISPlusNotes(studentId: widget.item.studentId!));
    // /*-------------------------User Activity Track START----------------------------*/
    // FirebaseAnalyticsService.addCustomAnalyticsEvent(
    //     'Sync history records PBIS+'.toLowerCase().replaceAll(" ", "_"));
    // /*-------------------------User Activity Track END----------------------------*/
  }

//------------------------------for filter call bottom sheet"-------------------//
  Widget localSimmerWidget({required double height, required double width}) {
    return ShimmerLoading(
        isLoading: true,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: AppTheme.kShimmerHighlightColor!,
            borderRadius: BorderRadius.circular(6),
          ),
        ));
  }
}
