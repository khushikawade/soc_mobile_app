// ignore_for_file: deprecated_member_use

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_student_list_modal.dart';
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PBISPlusNotesDetailPage extends StatefulWidget {
  final PBISPlusStudentList item;

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
    PBISPlusBlocInstance.add(GetPBISPlusStudentNotes(oldItemList: null));

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
            backgroundColor:
                Colors.transparent, // appBar: PBISPlusUtility.pbisAppBar(
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

  Widget _buildbackIcon() {
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
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        SpacerWidget(24),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          // SpacerWidget(StudentPlusOverrides.KVerticalSpace / 10),
          _buildbackIcon(),
          // SpacerWidget(StudentPlusOverrides.KVerticalSpace / 20),
          Padding(
            padding: EdgeInsets.only(left: 4),
            child: FittedBox(
              child: Text("${widget.item.names!.fullName!}'s" + " Notes ",
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 28, fontWeight: FontWeight.w600)),
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
                    if (state is PBISPlusStudentNotesSucess) {
                      //---------------------return the filter list to UI-----------//
                      return _listBuilder(state.studentNotes,
                          isShimmerLoading: false);
                    } else if (state is PBISPlusStudentNotesShimmer ||
                        state is PBISPlusInitial) {
                      return _listBuilder(
                          List.generate(10, (index) => PBISPlusStudentList()),
                          isShimmerLoading: true);
                    } else if (state is PBISPlusStudentNotesError) {
                      return _noDataFoundWidget();
                    }

                    //Managing shimmer loading in case of initial loading
                    return _noDataFoundWidget();
                  },
                  listener: (context, state) {});
            }),
      ],
    );
  }

  Widget _listBuilder(List<PBISPlusStudentList> studentNotesList,
      {required final bool isShimmerLoading}) {
    return studentNotesList.length > 0
        ? Container(
            height: MediaQuery.of(context).size.height * 0.8,
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
      PBISPlusStudentList obj, index, final bool isShimmerLoading) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 4),
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            SpacerWidget(24),
            Text(
              "${obj.notes!.notes ?? ""}  Sed euismod eros non ante lacinia condimentum. Pellentesque est lacus, rutrum ac arcu et, accumsan pharetra neque. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nunc vel lectus rutrum, mollis dui ac, molestie neque. Quisque sit amet lacus vulputate, varius leo eu, elementum dui. Curabitur condimentum facilisis nisi, a pretium risus malesuada et. Mauris non leo",
              // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at nisilorem. Donec augue eros, molestie a risus quis, consectetur eleifend leo. Cras sit amet nibh tincidunt, pellentesque massa vel, finibus",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color:
                        Color(0xff000000) == Theme.of(context).backgroundColor
                            ? Color(0xffFFFFFF)
                            : Color(0xff162429),
                    fontSize: 12,
                  ),
            ),
            SpacerWidget(24),
            _buildDateList(obj),
            SpacerWidget(24),
          ],
        ),
      ),
    );
  }

  Widget _buildDateList(PBISPlusStudentList item) {
    return Row(
      children: [
        _buildCardDateTime(item.notes!.date ?? "", true),
        _buildCardDateTime("Monday", true),
        _buildCardDateTime("10:30 PM", false)
      ],
    );
  }

  Widget _buildCardDateTime(item, bool isShowDivider) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "$item",
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Color(0xff000000) == Theme.of(context).backgroundColor
                    ? Color(0xffA6A6A6)
                    : Color(0xff162429),
                fontSize: 10,
                fontWeight: FontWeight.w500),
          ),
          isShowDivider ? _buildVerticalDivider() : SizedBox.shrink()
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
    PBISPlusBlocInstance.add(GetPBISPlusStudentNotes(oldItemList: null));
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
