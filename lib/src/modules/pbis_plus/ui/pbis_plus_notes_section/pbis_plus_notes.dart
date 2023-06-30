// ignore_for_file: deprecated_member_use

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_student_list_modal.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_notes_section/pbis_plus_notes_detail.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_search_bar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PBISPlusNotes extends StatefulWidget {
  final IconData titleIconData;

  PBISPlusNotes({
    Key? key,
    required this.titleIconData,
  }) : super(key: key);

  @override
  State<PBISPlusNotes> createState() => _PBISPlusHistoryState();
}

class _PBISPlusHistoryState extends State<PBISPlusNotes> {
  static const double _KVertcalSpace = 60.0;
  // used for space between the widgets
  static const double _kLabelSpacing = 20.0;
  static const double _kHorizontalLabelSpacing = 20.0;
  PBISPlusBloc PBISPlusBlocInstance = PBISPlusBloc();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  FocusNode searchFocusNode = new FocusNode();
  final ValueNotifier<bool> showErrorInSearch = ValueNotifier<bool>(false);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ValueNotifier<String> filterNotifier =
      ValueNotifier<String>(PBISPlusOverrides.pbisPlusFilterValue);
  // search text editing controller
  final _searchController = TextEditingController();
  // hide animated container
  final ValueNotifier<bool> moveToTopNotifier = ValueNotifier<bool>(false);
  final _deBouncer = Debouncer(milliseconds: 500);
  List<PBISPlusStudentList>? mainList;
  // final ScrollController _scrollcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    searchFocusNode.unfocus();
    PBISPlusBlocInstance.add(GetPBISPlusStudentNotes(studentNotesList: null));
    // /*-------------------------User Activity Track START----------------------------*/
    // FirebaseAnalyticsService.addCustomAnalyticsEvent(
    //     "pbis_plus_history_screen");
    // FirebaseAnalyticsService.setCurrentScreen(
    //     screenTitle: 'pbis_plus_PBISPlusNotes', screenClass: 'PBISPlusNotes');
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
      Scaffold(
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          // Theme.of(context).colorScheme.secondary,
          appBar: PBISPlusUtility.pbisAppBar(
            context: context,
            titleIconData: widget.titleIconData,
            title: 'Notes',
            scaffoldKey: _scaffoldKey,
          ),
          extendBody: true,
          body: body(context))
    ]);
  }

  Widget body(BuildContext context) {
    return Column(
      // physics: NeverScrollableScrollPhysics(),
      children: [
        SpacerWidget(StudentPlusOverrides.KVerticalSpace / 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _kHorizontalLabelSpacing),
            child: FittedBox(
              child: Utility.textWidget(
                  text: "Student Notes",
                  context: context,
                  textAlign: TextAlign.left,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
        searchBarWidget(),
        validationMessageWidget(),
        SpacerWidget(_KVertcalSpace / 5),
        ValueListenableBuilder(
            valueListenable: filterNotifier,
            builder: (BuildContext context, String value, Widget? child) {
              return BlocConsumer(
                  bloc: PBISPlusBlocInstance,
                  builder: (context, state) {
                    if (state is PBISPlusStudentNotesSucess) {
                      //---------------------return the filter list to UI-----------//
                      if (state.studentNotes.isNotEmpty) {
                        //Storing the data in another list to use in search student functionality
                        mainList = state.studentNotes;
                        return _listBuilder(state.studentNotes,
                            isShimmerLoading: false);
                      } else {
                        return _noDataFoundWidget();
                      }
                    } else if (state is PBISPlusLoading ||
                        state is PBISPlusInitial ||
                        state is PBISPlusImportRosterSuccess) {
                      return _listBuilder(
                          List.generate(10, (index) => PBISPlusStudentList()),
                          isShimmerLoading: true);
                    } else if (state is PBISPlusStudentSearchSucess) {
                      return _listBuilder(state.sortedList,
                          isShimmerLoading: false);
                    } else if (state is PBISPlusStudentSearchNoDataFound ||
                        state is PBISPlusStudentNotesError) {
                      return _noDataFoundWidget();
                    }
                    //Managing shimmer loading in case of initial loading
                    return Container();
                  },
                  listener: (context, state) {
                    if (state is PBISPlusImportRosterSuccess) {
                      PBISPlusBlocInstance.add(
                          GetPBISPlusStudentNotes(studentNotesList: null));
                    }
                  });
            }),
      ],
    );
  }

  Widget searchBarWidget() {
    return ValueListenableBuilder(
        valueListenable: moveToTopNotifier,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return PBISPlusSearchBar(
              iconOnTap: () {
                _searchController.clear();
                onItemChanged("");
              },
              hintText: StudentPlusOverrides.searchHintText,
              isMainPage: false,
              autoFocus: !_searchController.text.isEmpty,
              controller: _searchController,
              kLabelSpacing: _kLabelSpacing,
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

  Widget _listBuilder(List<PBISPlusStudentList> studentNotesList,
      {required final bool isShimmerLoading}) {
    return studentNotesList.length > 0
        ? Expanded(
            child: ValueListenableBuilder(
                valueListenable: filterNotifier,
                builder: (BuildContext context, String value, Widget? child) {
                  return _searchController.text.isEmpty
                      ? RefreshIndicator(
                          color: AppTheme.kButtonColor,
                          key: refreshKey,
                          onRefresh: refreshPage,
                          child: _buildListItem(
                              studentNotesList, isShimmerLoading))
                      : _buildListItem(studentNotesList, isShimmerLoading);
                }),
          )
        : RefreshIndicator(
            color: AppTheme.kButtonColor,
            key: refreshKey,
            onRefresh: refreshPage,
            child: NoDataFoundErrorWidget(
                isResultNotFoundMsg: true, isNews: false, isEvents: false));
  }

  Widget _buildListItem(
      List<PBISPlusStudentList> studentNotesList, bool isShimmerLoading) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: studentNotesList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    //  Theme.of(context).colorScheme.background,
                    width: 0.65,
                  ),
                  borderRadius: BorderRadius.circular(0.0),
                  color: (index % 2 == 0)
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.background),
              child: ListTile(
                  visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                  horizontalTitleGap: 24,
                  minVerticalPadding: 20,
                  contentPadding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, left: 12, right: 16),
                  leading: isShimmerLoading
                      ? Container(
                          margin: EdgeInsets.only(
                            left: 12,
                          ),
                          width: 40,
                          height: 40,
                          child: localSimmerWidget(height: 40, width: 40))
                      : Container(
                          width: 72,
                          height: 50,
                          child: CachedNetworkImage(
                            placeholder: (context, url) => SizedBox(
                              height: 8,
                              width: 8,
                              child: Center(
                                  child: CircularProgressIndicator.adaptive(
                                backgroundColor: AppTheme.kButtonColor,
                              )),
                            ),
                            imageUrl: studentNotesList[index].iconUrlC ?? '',
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 56,
                              backgroundImage: imageProvider,
                            ),
                          ),
                        ),
                  title: isShimmerLoading == true
                      ? localSimmerWidget(height: 20, width: 30)
                      : Utility.textWidget(
                          // textAlign: TextAlign.center,
                          text: studentNotesList[index].names!.fullName ?? '',
                          context: context,
                          textTheme: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(fontWeight: FontWeight.w500)),
                  trailing: ShimmerLoading(
                    isLoading: isShimmerLoading,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: Globals.deviceType == "phone" ? 12 : 20,
                        color: AppTheme.kPrimaryColor,
                      ),
                    ),
                  ),
                  onTap: (() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PBISPlusNotesDetailPage(
                            item: studentNotesList[index])));
                  })));
        });
  }

  Widget _noDataFoundWidget() {
    return Expanded(
        child: Center(
            child: RefreshIndicator(
                color: AppTheme.kButtonColor,
                key: refreshKey,
                onRefresh: refreshPage,
                child: NoDataFoundErrorWidget(
                    marginTop: MediaQuery.of(context).size.height / 4,
                    isResultNotFoundMsg: false,
                    isNews: false,
                    isEvents: false,
                    errorMessage: 'No Data Found'))));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    PBISPlusBlocInstance.add(PBISPlusImportRoster(
      isGradedPlus: false,
    ));
  }

  /* --------------- Things Perform on On changes in search bar --------------- */
  onItemChanged(String value) {
    _deBouncer.run(() {
      if (_searchController.text.isEmpty) {
        PBISPlusBlocInstance.add(
            GetPBISPlusStudentNotes(studentNotesList: mainList));
        showErrorInSearch.value = false;
      } else if (_searchController.text.length >= 3) {
        showErrorInSearch.value = false;
        PBISPlusBlocInstance.add(GetPBISPlusStudentNotesSearchEvent(
            searchKey: _searchController.text, studentNotes: mainList!));
      } else {
        showErrorInSearch.value = true;
      }
      // setState(() {});
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
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
