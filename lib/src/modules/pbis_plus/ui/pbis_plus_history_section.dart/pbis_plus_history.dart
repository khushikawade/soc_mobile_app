// ignore_for_file: deprecated_member_use

import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pibs_plus_history_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_filtter_bottom_sheet.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PBISPlusHistory extends StatefulWidget {
  final IconData titleIconData;
  PBISPlusHistory({Key? key, required this.titleIconData}) : super(key: key);

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
      Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: PBISPlusUtility.pbisAppBar(
              context, widget.titleIconData, 'Class', _scaffoldKey),
          extendBody: true,
          body: body(context))
    ]);
  }

  Widget body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SpacerWidget(_KVertcalSpace / 4),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 30),
            child: Utility.textWidget(
              text: 'History',
              context: context,
              textTheme: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                  onPressed: () {
                    /*-------------------------User Activity Track START----------------------------*/
                    FirebaseAnalyticsService.addCustomAnalyticsEvent(
                        'Filter History PBIS+'
                            .toLowerCase()
                            .replaceAll(" ", "_"));

                    Utility.updateLogs(
                        activityType: 'PBIS+',
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
                    color: AppTheme.kButtonColor,
                    size: 28,
                  )),
              ValueListenableBuilder(
                  valueListenable: filterNotifier,
                  child: Container(),
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    return filterNotifier.value == "All"
                        ? Container()
                        : Wrap(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 6, right: 6),
                                height: 7,
                                width: 7,
                                decoration: BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                              ),
                            ],
                          );
                  })
            ],
          )
        ]),
        // SpacerWidget(_KVertcalSpace / 3),
        SpacerWidget(_KVertcalSpace / 5),
        Container(
          // color: Colors.red,
          height: MediaQuery.of(context).size.height * 0.65,
          child: ValueListenableBuilder(
              valueListenable: filterNotifier,
              builder: (BuildContext context, String value, Widget? child) {
                return ListView(children: [
                  BlocConsumer(
                      bloc: PBISPlusBlocInstance,
                      builder: (context, state) {
                        if (state is PBISPlusLoading) {
                          return Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator.adaptive(
                                backgroundColor: AppTheme.kButtonColor,
                              ));
                        }
                        if (state is PBISPlusHistorySuccess
                            // &&
                            // (state.pbisHistoryList.isNotEmpty ?? false) &&
                            // (state.pbisClassroomHistoryList.isNotEmpty ??
                            //     false) &&
                            // (state.pbisSheetHistoryList.isNotEmpty ??
                            //     false)
                            ) {
                          //---------------------return the filter list to UI-----------//
                          if (filterNotifier.value ==
                              PBISPlusOverrides.pbisGoogleClassroom) {
                            return RefreshIndicator(
                                key: refreshKey,
                                onRefresh: refreshPage,
                                child: _listBuilder(
                                    state.pbisClassroomHistoryList));
                          } else if (filterNotifier.value ==
                              PBISPlusOverrides.pbisGoogleSheet) {
                            return RefreshIndicator(
                                key: refreshKey,
                                onRefresh: refreshPage,
                                child:
                                    _listBuilder(state.pbisSheetHistoryList));
                          } else {
                            return RefreshIndicator(
                                key: refreshKey,
                                onRefresh: refreshPage,
                                child: _listBuilder(state.pbisHistoryList));
                          }
                        }
                        return Container();
                      },
                      listener: (context, state) {})
                ]);
              }),
        ),
      ],
    );
  }

  Widget _listBuilder(List<PBISPlusHistoryModal> historyList) {
    return historyList.length > 0
        ? ValueListenableBuilder(
            valueListenable: filterNotifier,
            builder: (BuildContext context, String value, Widget? child) {
              return Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return listTile(historyList[index], index);
                    },
                    itemCount: historyList.length,
                  ));
            })
        : NoDataFoundErrorWidget(
            isResultNotFoundMsg: true, isNews: false, isEvents: false);
  }

  Widget listTile(PBISPlusHistoryModal obj, index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.background,
          width: 0.65,
        ),
        borderRadius: BorderRadius.circular(0.0),
        color: (index % 2 == 0)
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.secondary,
      ),
      child: ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
        horizontalTitleGap: 20,
        leading: Container(
          height: 30,
          width: 30,
          child: SvgPicture.asset(
            "assets/ocr_result_section_bottom_button_icons/${obj.type == "Classroom" ? 'Classroom' : 'Spreadsheet'}.svg",
          ),
        ),
        title: Utility.textWidget(
            text: obj.title ?? '',
            context: context,
            textTheme: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Utility.textWidget(
                context: context,
                textTheme: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Colors.grey.shade500),
                text: obj.createdAt!),
            SizedBox(width: 10),
            Container(
              width: 1,
              height: 16,
              color: Colors.grey.shade500,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Utility.textWidget(
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Colors.grey.shade500),
                  text: obj.classroomCourse!),
            ),
          ],
        ),
        trailing: Icon(
          IconData(0xe88c,
              fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
          color: AppTheme.kButtonColor,
        ),
        onTap: (() {
          /*-------------------------User Activity Track START----------------------------*/
          FirebaseAnalyticsService.addCustomAnalyticsEvent(
              'History record view PBIS+'.toLowerCase().replaceAll(" ", "_"));
          /*-------------------------User Activity Track END----------------------------*/

          obj.uRL == null || obj.uRL == '' || !obj.uRL!.contains('http')
              ? Utility.showSnackBar(
                  _scaffoldKey, 'Launch URL not found', context, null)
              : Utility.launchUrlOnExternalBrowser(obj.uRL!);
        }),
      ),
    );
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
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        elevation: 10,
        context: context,
        builder: (context) => PBISPlusHistoryFilterBottomSheet(
              title: 'Filter Assignment',
              selectedValue: filterNotifier.value,
              update: ({String? filterValue}) async {
                // update the filter value
                filterNotifier.value = filterValue!;
                PBISPlusOverrides.pbisPlusFilterValue = filterNotifier.value;
              },
              scaffoldKey: _scaffoldKey,
            ));
  }
}
