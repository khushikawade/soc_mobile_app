// ignore_for_file: deprecated_member_use

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pibs_plus_history_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_filtter_bottom_sheet.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PBISPlusHistory extends StatefulWidget {
  final IconData titleIconData;

  PBISPlusHistory({
    Key? key,
    required this.titleIconData,
  }) : super(key: key);

  @override
  State<PBISPlusHistory> createState() => _PBISPlusHistoryState();
}

class _PBISPlusHistoryState extends State<PBISPlusHistory> {
  static const double _KVertcalSpace = 60.0;
  PBISPlusBloc PBISPlusBlocInstance = PBISPlusBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<String> filterNotifier =
      ValueNotifier<String>(PBISPlusOverrides.pbisPlusFilterValue);

  @override
  void initState() {
    super.initState();
    PBISPlusBlocInstance.add(GetPBISPlusHistory());

    /*-------------------------User Activity Track START----------------------------*/
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "pbis_plus_history_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'pbis_plus_history_screen',
        screenClass: 'PBISPlusHistory');
    /*-------------------------User Activity Track END----------------------------*/
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
              appBar: PBISPlusUtility.pbisAppBar(
                context: context,
                titleIconData: widget.titleIconData,
                title: 'Class',
                scaffoldKey: _scaffoldKey,
              ),
              extendBody: true,
              body: body(context)))
    ]);
  }

  Widget body(BuildContext context) {
    return ListView(
        padding: EdgeInsets.symmetric(
            horizontal: StudentPlusOverrides.kSymmetricPadding),
        physics: NeverScrollableScrollPhysics(),
        children: [
          // SpacerWidget(StudentPlusOverrides.KVerticalSpace / 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            PlusScreenTitleWidget(
                kLabelSpacing: StudentPlusOverrides.kLabelSpacing,
                text: 'History'),
            Stack(alignment: Alignment.topRight, children: [
              IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    /*-------------------------User Activity Track START----------------------------*/
                    FirebaseAnalyticsService.addCustomAnalyticsEvent(
                        'Filter History PBIS+'
                            .toLowerCase()
                            .replaceAll(" ", "_"));

                    PlusUtility.updateLogs(
                        activityType: 'PBIS+',
                        userType: 'Teacher',
                        activityId: '39',
                        description: 'Filter History PBIS+',
                        operationResult: 'Success');
                    /*-------------------------User Activity Track END----------------------------*/

                    filterBottomSheet(context);
                  },
                  icon: Icon(
                      IconData(0xe87d,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      color: AppTheme.kButtonColor)),
              ValueListenableBuilder(
                  valueListenable: filterNotifier,
                  child: Container(),
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    return filterNotifier.value == "All"
                        ? Container()
                        : Wrap(children: [
                            Container(
                                margin: EdgeInsets.only(top: 6, right: 6),
                                height: 7,
                                width: 7,
                                decoration: BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle))
                          ]);
                  })
            ])
          ]),
          // SpacerWidget(_KVertcalSpace / 3),
          SpacerWidget(_KVertcalSpace / 5),

          ValueListenableBuilder(
              valueListenable: filterNotifier,
              builder: (BuildContext context, String value, Widget? child) {
                return BlocConsumer(
                    bloc: PBISPlusBlocInstance,
                    builder: (context, state) {
                      if (state is PBISPlusHistorySuccess) {
                        //---------------------return the filter list to UI-----------//
                        if (filterNotifier.value ==
                            PBISPlusOverrides.pbisGoogleClassroom) {
                          return _listBuilder(state.pbisClassroomHistoryList,
                              isShimmerLoading: false);
                        } else if (filterNotifier.value ==
                            PBISPlusOverrides.pbisGoogleSheet) {
                          return _listBuilder(state.pbisSheetHistoryList,
                              isShimmerLoading: false);
                        } else {
                          return _listBuilder(state.pbisHistoryList,
                              isShimmerLoading: false);
                        }
                      }

                      //Managing shimmer loading in case of initial loading
                      return _listBuilder(
                          List.generate(10, (index) => PBISPlusHistoryModal()),
                          isShimmerLoading: true);
                    },
                    listener: (context, state) {});
              })
        ]);
  }

  Widget _listBuilder(List<PBISPlusHistoryModal> historyList,
      {required final bool isShimmerLoading}) {
    return historyList.length > 0
        ? Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.8,
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
                          padding: EdgeInsets.only(bottom: 70),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return listTile(
                                historyList[index], index, isShimmerLoading);
                          },
                          itemCount: historyList.length));
                }),
          )
        : RefreshIndicator(
            color: AppTheme.kButtonColor,
            key: refreshKey,
            onRefresh: refreshPage,
            child: NoDataFoundErrorWidget(
                isResultNotFoundMsg: true, isNews: false, isEvents: false));
  }

  Widget listTile(
      PBISPlusHistoryModal obj, index, final bool isShimmerLoading) {
    return Container(
        decoration: BoxDecoration(
          // border: Border.all(
          //     color: Theme.of(context).colorScheme.background, width: 0.65),
          borderRadius: BorderRadius.circular(0.0),
          color: (index % 2 == 0)
              ? Theme.of(context).colorScheme.background == Color(0xff000000)
                  ? Color(0xff162429)
                  : Color(0xffF7F8F9) //Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.background == Color(0xff000000)
                  ? Color(0xff111C20)
                  : Color(0xffE9ECEE),
          // ? Theme.of(context).colorScheme.background
          // : Theme.of(context).colorScheme.secondary,
        ),
        child: ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: 0),
            horizontalTitleGap: 20,
            leading: Container(
                height: 30,
                width: 30,
                child: ShimmerLoading(
                    isLoading: isShimmerLoading,
                    child: isShimmerLoading == true
                        ? localSimmerWidget(height: 30, width: 30)
                        : SvgPicture.asset(
                            "assets/ocr_result_section_bottom_button_icons/${obj.type == "Classroom" ? 'Classroom' : 'Spreadsheet'}.svg"))),
            title: isShimmerLoading == true
                ? localSimmerWidget(height: 20, width: 30)
                : Utility.textWidget(
                    text: obj.title ?? '',
                    context: context,
                    textTheme: Theme.of(context).textTheme.headline2!,
                    // Theme.of(context)
                    //     .textTheme
                    //     .headline3!
                    //     .copyWith(fontWeight: FontWeight.bold)
                  ),
            subtitle: Row(children: [
              isShimmerLoading == true
                  ? localSimmerWidget(height: 10, width: 30)
                  : Utility.textWidget(
                      context: context,
                      textTheme: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: Colors.grey.shade500),
                      text: obj.createdAt!),
              SizedBox(width: 10),
              Container(width: 1, height: 16, color: Colors.grey.shade500),
              SizedBox(width: 10),
              Expanded(
                  child: isShimmerLoading == true
                      ? localSimmerWidget(height: 10, width: 30)
                      : Utility.textWidget(
                          context: context,
                          textTheme: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(color: Colors.grey.shade500),
                          text: obj.classroomCourse!))
            ]),
            trailing: ShimmerLoading(
                isLoading: isShimmerLoading,
                child: Icon(
                    IconData(0xe88c,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: AppTheme.kButtonColor)),
            onTap: (() {
              if (isShimmerLoading) {
                return;
              }

              /*-------------------------User Activity Track START----------------------------*/
              FirebaseAnalyticsService.addCustomAnalyticsEvent(
                  'History record view PBIS+'
                      .toLowerCase()
                      .replaceAll(" ", "_"));
              /*-------------------------User Activity Track END----------------------------*/

              obj.uRL == null || obj.uRL == '' || !obj.uRL!.contains('http')
                  ? Utility.showSnackBar(
                      _scaffoldKey, 'Launch URL not found', context, null)
                  : Utility.launchUrlOnExternalBrowser(obj.uRL!);
            })));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    PBISPlusBlocInstance.add(GetPBISPlusHistory());

    /*-------------------------User Activity Track START----------------------------*/
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        'Sync history records PBIS+'.toLowerCase().replaceAll(" ", "_"));
    /*-------------------------User Activity Track END----------------------------*/
  }

//------------------------------for filter call bottom sheet"-------------------//
  filterBottomSheet(context) {
    showModalBottomSheet(
        useRootNavigator: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        elevation: 10,
        context: context,
        builder: (context) => LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return PBISPlusHistoryFilterBottomSheet(
                  height: Globals.deviceType == "phone"
                      ? MediaQuery.of(context).size.width - 60
                      : MediaQuery.of(context).size.width / 2 - 40,
                  // constraints.maxHeight < 750
                  //     // ? MediaQuery.of(context).size.height * 0.5
                  //     // : MediaQuery.of(context).size.height * 0.43,
                  //     ? Globals.deviceType == "phone"
                  //         ? MediaQuery.of(context).size.height * 0.5 //0.45
                  //         : MediaQuery.of(context).size.height * 0.26
                  //     : Globals.deviceType == "phone"
                  //         ? MediaQuery.of(context).size.height * 0.40 //0.45
                  //         : MediaQuery.of(context).size.height * 0.26,
                  title: 'Filter Assignment',
                  selectedValue: filterNotifier.value,
                  update: ({String? filterValue}) async {
                    // update the filter value
                    filterNotifier.value = filterValue!;
                    PBISPlusOverrides.pbisPlusFilterValue =
                        filterNotifier.value;
                  },
                  scaffoldKey: _scaffoldKey);
            }));
  }

  Widget localSimmerWidget({required double height, required double width}) {
    return ShimmerLoading(
        isLoading: true,
        child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                color: AppTheme.kShimmerBaseColor!,
                borderRadius: BorderRadius.circular(20))));
  }
}
