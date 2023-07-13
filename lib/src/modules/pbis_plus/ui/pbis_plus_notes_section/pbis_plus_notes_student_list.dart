// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_student_list_modal.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_notes_section/pbis_plus_notes_detail.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_app_search_bar.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PBISPlusNotesStudentList extends StatefulWidget {
  final IconData titleIconData;

  PBISPlusNotesStudentList({Key? key, required this.titleIconData})
      : super(key: key);

  @override
  State<PBISPlusNotesStudentList> createState() => _PBISPlusHistoryState();
}

class _PBISPlusHistoryState extends State<PBISPlusNotesStudentList> {
  static const double _KVertcalSpace = 60.0;
  // used for space between the widgets
  static const double _kLabelSpacing = 20.0;
  static const double _kHorizontalLabelSpacing = 20.0;
  PBISPlusBloc PBISPlusBlocInstance = PBISPlusBloc();
  PBISPlusBloc PBISPlusBlocSearchInstance = PBISPlusBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  FocusNode searchFocusNode = new FocusNode();
  final ValueNotifier<bool> showErrorInSearch = ValueNotifier<bool>(false);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> showSearchList = ValueNotifier<bool>(false);

  ValueNotifier<String> filterNotifier =
      ValueNotifier<String>(PBISPlusOverrides.pbisPlusFilterValue);
  // search text editing controller
  final _searchController = TextEditingController();
  final _deBouncer = Debouncer(milliseconds: 100);
  List<PBISPlusNotesUniqueStudentList>? studentLocalList;

  @override
  void initState() {
    super.initState();
    searchFocusNode.unfocus();
    PBISPlusBlocInstance.add(GetPBISPlusStudentList(studentNotesList: null));

    // /*-------------------------User Activity Track START----------------------------*/
    // FirebaseAnalyticsService.addCustomAnalyticsEvent(
    //     "pbis_plus_history_screen");
    // FirebaseAnalyticsService.setCurrentScreen(
    //     screenTitle: 'pbis_plus_PBISPlusNotes', screenClass: 'PBISPlusNotesStudentList');
    // /*-------------------------User Activity Track END----------------------------*/
  }

  @override
  void dispose() {
    searchFocusNode.unfocus();
    super.dispose();
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
                title: 'Notes',
                scaffoldKey: _scaffoldKey,
              ),
              extendBody: true,
              body: body(context)))
    ]);
  }

  Widget body(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: StudentPlusOverrides.kSymmetricPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 5),
          PlusScreenTitleWidget(
              kLabelSpacing: StudentPlusOverrides.kLabelSpacing,
              text: 'Student Notes'),
          SpacerWidget(_KVertcalSpace / 2),
          searchBarWidget(),
          validationMessageWidget(),
          SpacerWidget(_KVertcalSpace / 5),
          _buildStudentList()
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    return ValueListenableBuilder(
        valueListenable: showSearchList,
        builder: (BuildContext context, bool value, Widget? child) {
          return showSearchList.value
              ? BlocConsumer(
                  bloc: PBISPlusBlocSearchInstance,
                  builder: (context, state) {
                    if (state is PBISPlusStudentSearchSucess) {
                      //---------------------return the filter list to UI-----------//
                      if (state.sortedList.isNotEmpty) {
                        //Storing the data in another list to use in search student functionality
                        // studentLocalList = state.studentList;
                        return _listBuilder(state.sortedList,
                            isShimmerLoading: false);
                      } else {
                        return _noDataFoundWidget();
                      }
                    } else if (state is PBISPlusLoading ||
                        state is PBISPlusInitial) {
                      return _listBuilder(
                          List.generate(
                              10, (index) => PBISPlusNotesUniqueStudentList()),
                          isShimmerLoading: true);
                    } else if (state is PBISErrorState) {
                      return _noDataFoundWidget();
                    }
                    //Managing shimmer loading in case of initial loading
                    return SizedBox.shrink();
                  },
                  listener: (context, state) {
                    if (state is PBISPlusImportRosterSuccess) {
                      PBISPlusBlocInstance.add(
                          GetPBISPlusStudentList(studentNotesList: null));
                    }
                  })
              : BlocConsumer(
                  bloc: PBISPlusBlocInstance,
                  builder: (context, state) {
                    if (state is PBISPlusStudentListSucess) {
                      //---------------------return the filter list to UI-----------//
                      if (state.studentList.isNotEmpty) {
                        //Storing the data in another list to use in search student functionality
                        studentLocalList = state.studentList;
                        return _listBuilder(state.studentList,
                            isShimmerLoading: false);
                      } else {
                        return _noDataFoundWidget();
                      }
                    } else if (state is PBISPlusLoading ||
                        state is PBISPlusInitial) {
                      return _listBuilder(
                          List.generate(
                              10, (index) => PBISPlusNotesUniqueStudentList()),
                          isShimmerLoading: true);
                    } else if (state is PBISPlusStudentSearchSucess) {
                      return _listBuilder(state.sortedList,
                          isShimmerLoading: false);
                    } else if (state is PBISErrorState) {
                      return _noDataFoundWidget();
                    }
                    //Managing shimmer loading in case of initial loading
                    return Container();
                  },
                  listener: (context, state) {
                    if (state is PBISPlusImportRosterSuccess) {
                      PBISPlusBlocInstance.add(
                          GetPBISPlusStudentList(studentNotesList: null));
                    }
                  });
        });
  }

  /* ----------- Search Widget ---------- */
  Widget searchBarWidget() {
    return ValueListenableBuilder(
        valueListenable: _searchController,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return PlusAppSearchBar(
              iconOnTap: () {
                _searchController.clear();
                onItemChanged("");
              },
              sectionName: 'PBIS+',
              hintText: StudentPlusOverrides.searchHintText,
              isMainPage: false,
              autoFocus: !_searchController.text.isEmpty,
              controller: _searchController,
              kLabelSpacing: 1,
              focusNode: searchFocusNode,
              onTap: () {},
              onItemChanged: onItemChanged);
        });
  }

  /* ----------- Widget to show error related to maximum three digit ---------- */
  Widget validationMessageWidget() {
    return ValueListenableBuilder(
        valueListenable: showErrorInSearch,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return showErrorInSearch.value == true
              ? Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 24),
                  child: Utility.textWidget(
                      text: StudentPlusOverrides.errorMessageOnSearchPage,
                      context: context,
                      textTheme: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: Colors.red)))
              : SizedBox.shrink();
        });
  }

  /* -----------------------------Widget to list of the student---------------- */
  Widget _listBuilder(List<PBISPlusNotesUniqueStudentList> studentNotesList,
      {required final bool isShimmerLoading}) {
    return Expanded(
      child: ValueListenableBuilder(
          valueListenable: filterNotifier,
          builder: (BuildContext context, String value, Widget? child) {
            return _searchController.value.text.isEmpty
                ? RefreshIndicator(
                    color: AppTheme.kButtonColor,
                    key: refreshKey,
                    onRefresh: refreshPage,
                    child: studentNotesList.length > 0
                        ? _buildListItem(studentNotesList, isShimmerLoading)
                        : NoDataFoundErrorWidget(
                            isResultNotFoundMsg: true,
                            isNews: false,
                            isEvents: false))
                : _buildListItem(studentNotesList, isShimmerLoading);
          }),
    );
  }

  /* -----------------------------Widget to list item of the student---------------- */
  Widget _buildListItem(List<PBISPlusNotesUniqueStudentList> studentNotesList,
      bool isShimmerLoading) {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(
          bottom: Platform.isIOS ? 50 : 30,
        ),
        itemCount: studentNotesList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.65,
                  ),
                  borderRadius: BorderRadius.circular(0.0),
                  color: (index % 2 == 0)
                      ? Theme.of(context).colorScheme.background ==
                              Color(0xff000000)
                          ? Color(0xff162429)
                          : Color(
                              0xffF7F8F9) //Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.background ==
                              Color(0xff000000)
                          ? Color(0xff111C20)
                          : Color(0xffE9ECEE)),
              child: ListTile(
                  visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                  horizontalTitleGap: 24,
                  minVerticalPadding: 20,
                  contentPadding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, left: 12, right: 16),
                  leading: isShimmerLoading
                      ? Container(
                          margin: EdgeInsets.only(left: 12),
                          width: 40,
                          height: 40,
                          child: localSimmerWidget(height: 40, width: 40))
                      : PBISCommonProfileWidget(
                          isFromStudentNotes: true,
                          studentname: studentNotesList[index].names!,
                          profilePictureSize: 30,
                          imageUrl: studentNotesList[index].iconUrlC!),
                  // Container(
                  //     width: 50,
                  //     height: 50,
                  //     child: CachedNetworkImage(
                  //         fit: BoxFit.contain,
                  //         placeholder: (context, url) => SizedBox(
                  //             height: 8,
                  //             width: 8,
                  //             child: Center(
                  //                 child: CircularProgressIndicator.adaptive(
                  //                     backgroundColor:
                  //                         AppTheme.kButtonColor))),
                  //         imageUrl: studentNotesList[index].iconUrlC ?? '',
                  //         errorWidget: (context, url, error) =>
                  //             Icon(Icons.error),
                  //         imageBuilder: (context, imageProvider) => CircleAvatar(
                  //             radius: 56, backgroundImage: imageProvider))),
                  title: isShimmerLoading == true
                      ? localSimmerWidget(height: 20, width: 30)
                      : Utility.textWidget(
                          text: studentNotesList[index].names!.fullName ?? '',
                          context: context,
                          textTheme: Theme.of(context).textTheme.headline2!),
                  trailing: ShimmerLoading(
                      isLoading: isShimmerLoading,
                      child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(Icons.arrow_forward_ios_rounded,
                              size: Globals.deviceType == "phone" ? 12 : 20,
                              color: AppTheme.kPrimaryColor))),
                  onTap: (() {
                    if (isShimmerLoading == false) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PBISPlusNotesDetailPage(
                              titleIconData: widget.titleIconData,
                              item: studentNotesList[index])));
                    }
                  })));
        });
  }

//------------------------NO DATA FOUND ---------------------------------//
  Widget _noDataFoundWidget() {
    return Expanded(
        child: Container(
            alignment: Alignment.center,
            child: RefreshIndicator(
                color: AppTheme.kButtonColor,
                key: refreshKey,
                onRefresh: refreshPage,
                child: NoDataFoundErrorWidget(
                    marginTop: MediaQuery.of(context).size.height / 4,
                    isResultNotFoundMsg: false,
                    isNews: false,
                    isEvents: false,
                    errorMessage: 'No Student Found'))));
  }

//----------------------------Pull to Refresh--------------------------
  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    PBISPlusBlocInstance.add(GetPBISPlusStudentList());
  }

  /* --------------- Things Perform on On changes in search bar --------------- */
  onItemChanged(String value) {
    _deBouncer.run(() {
      if (_searchController.text.isEmpty) {
        //Fetching all student list again to restore the student list from local db only
        PBISPlusBlocInstance.add(
            GetPBISPlusStudentList(studentNotesList: studentLocalList));
        showSearchList.value = false;
        showErrorInSearch.value = false;
      } else if (_searchController.text.length >= 3) {
        PBISPlusBlocSearchInstance.add(PBISPlusNotesSearchStudent(
            searchKey: _searchController.text,
            studentNotes: studentLocalList!));
        showSearchList.value = true;
        showErrorInSearch.value = false;
      } else {
        showErrorInSearch.value = true;
      }
    });
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
                borderRadius: BorderRadius.circular(20))));
  }
}
