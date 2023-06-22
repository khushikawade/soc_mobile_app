// ignore_for_file: deprecated_member_use

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_student_notes_modal.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_search_bar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pibs_plus_history_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_filtter_bottom_sheet.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_search_bar.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PBISPlusNotesDetailPage extends StatefulWidget {
  final PBISPlusStudentNotes item;

  PBISPlusNotesDetailPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<PBISPlusNotesDetailPage> createState() => _PBISPlusHistoryState();
}

class _PBISPlusHistoryState extends State<PBISPlusNotesDetailPage> {
  static const double _KVertcalSpace = 60.0;
  // used for space between the widgets
  static const double _kLabelSpacing = 20.0;
  PBISPlusBloc PBISPlusBlocInstance = PBISPlusBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  FocusNode searchFocusNode = new FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<String> filterNotifier =
      ValueNotifier<String>(PBISPlusOverrides.pbisPlusFilterValue);
  // search text editing controller
  final _searchController = TextEditingController();
  // hide animated container
  final ValueNotifier<bool> moveToTopNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    PBISPlusBlocInstance.add(GetPBISPlusStudentNotes(index: 0, item: "TTT"));

    // /*-------------------------User Activity Track START----------------------------*/
    // FirebaseAnalyticsService.addCustomAnalyticsEvent(
    //     "pbis_plus_history_screen");
    // FirebaseAnalyticsService.setCurrentScreen(
    //     screenTitle: 'pbis_plus_history_screen', screenClass: 'PBISPlusNotesDetailPage');
    // /*-------------------------User Activity Track END----------------------------*/
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonBackgroundImgWidget(),
      WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            // appBar: PBISPlusUtility.pbisAppBar(
            //   context: context,
            //   titleIconData: widget.titleIconData,
            //   title: 'Class',
            //   scaffoldKey: _scaffoldKey,
            // ),
            extendBody: true,
            body: body(context)),
      )
    ]);
  }

  Widget body(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        SpacerWidget(48),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: EdgeInsets.only(left: 24),
            child: FittedBox(
              child: Text("${widget.item.studentName}" + " Notes",
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 30, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
        SpacerWidget(_KVertcalSpace / 5),
        ValueListenableBuilder(
            valueListenable: filterNotifier,
            builder: (BuildContext context, String value, Widget? child) {
              return BlocConsumer(
                  bloc: PBISPlusBlocInstance,
                  builder: (context, state) {
                    print(state);
                    if (state is PBISPlusStudentNotesSucess) {
                      //---------------------return the filter list to UI-----------//
                      return _listBuilder(state.studentNotes,
                          isShimmerLoading: false);
                    } else if (state is PBISPlusStudentNotesShimmer) {
                      return _listBuilder(
                          List.generate(10, (index) => PBISPlusStudentNotes()),
                          isShimmerLoading: true);
                    } else if (state is PBISPlusStudentNotesError) {
                      return _noDataFoundWidget();
                    }

                    //Managing shimmer loading in case of initial loading
                    return _listBuilder(
                        List.generate(10, (index) => PBISPlusStudentNotes()),
                        isShimmerLoading: true);
                  },
                  listener: (context, state) {});
            }),
      ],
    );
  }

  Widget _listBuilder(List<PBISPlusStudentNotes> studentNotesList,
      {required final bool isShimmerLoading}) {
    return studentNotesList.length > 0
        ? Container(
            height: MediaQuery.of(context).size.height * 0.7,
            // color: Colors.red,
            child: ValueListenableBuilder(
                valueListenable: filterNotifier,
                builder: (BuildContext context, String value, Widget? child) {
                  return RefreshIndicator(
                      color: AppTheme.kButtonColor,
                      key: refreshKey,
                      onRefresh: refreshPage,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: isShimmerLoading
                            ? NeverScrollableScrollPhysics()
                            : null,
                        padding: EdgeInsets.only(
                          bottom: 20,
                        ),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildCard(
                              studentNotesList[index], index, isShimmerLoading);
                        },
                        itemCount: studentNotesList.length,
                      ));
                }),
          )
        : RefreshIndicator(
            color: AppTheme.kButtonColor,
            key: refreshKey,
            onRefresh: refreshPage,
            child: NoDataFoundErrorWidget(
                isResultNotFoundMsg: true, isNews: false, isEvents: false));
  }

  Widget _noDataFoundWidget() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Text(
          "No Data Found",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildCard(
      PBISPlusStudentNotes obj, index, final bool isShimmerLoading) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 12),
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            SpacerWidget(24),
            Text(
              "${obj.notesComments}",
              // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at nisilorem. Donec augue eros, molestie a risus quis, consectetur eleifend leo. Cras sit amet nibh tincidunt, pellentesque massa vel, finibus",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color:
                        Color(0xff000000) == Theme.of(context).backgroundColor
                            ? Color(0xffFFFFFF)
                            : Color(0xff000000),
                    fontSize: 12,
                  ),
            ),
            SpacerWidget(24),
            _buildDateList(obj),
            SpacerWidget(12),
          ],
        ),
      ),
    );
  }

  Widget _buildDateList(PBISPlusStudentNotes item) {
    return Row(
      children: [
        _buildCardDateTime(item.date),
        _buildCardDateTime(item.date),
        _buildCardDateTime(item.date)
      ],
    );
  }

  Widget _buildCardDateTime(item) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "$item",
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Color(0xff000000) == Theme.of(context).backgroundColor
                    ? Color(0xffA6A6A6)
                    : Color(0xff000000),
                fontSize: 10,
                fontWeight: FontWeight.w500),
          ),
          _buildVerticalDivider()
        ]);
  }

  Widget _buildVerticalDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 12,
      width: 1, // Adjust the width as needed
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Color(0xFFAAAAAA), // Replace with your desired color
            width: 1, // Adjust the width as needed
          ),
        ),
      ),
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    PBISPlusBlocInstance.add(GetPBISPlusStudentNotes(index: 0, item: "TTT"));

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
          color: AppTheme.kShimmerBaseColor!,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
