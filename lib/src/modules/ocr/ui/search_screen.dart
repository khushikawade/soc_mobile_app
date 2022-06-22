import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/custom_rubic_modal.dart';
import 'package:Soc/src/modules/ocr/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/ocr/ui/results_summary.dart';
import 'package:Soc/src/modules/ocr/ui/subject_selection.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/widgets/searchbar_widget.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreenPage extends StatefulWidget {
  final String? keyword;
  final String? grade;

  SearchScreenPage({Key? key, this.keyword, this.grade}) : super(key: key);

  @override
  State<SearchScreenPage> createState() => _SearchScreenPageState();
}

class _SearchScreenPageState extends State<SearchScreenPage> {
  final searchController = TextEditingController();
  final ValueNotifier<int> nycSubIndex1 =
      ValueNotifier<int>(5000); //To bypass the default selection
  final ValueNotifier<int> listLength =
      ValueNotifier<int>(5000); //To bypass the default selection
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();

  static const double _KVertcalSpace = 60.0;
  OcrBloc _ocrBloc = OcrBloc();
  OcrBloc _ocrBloc2 = OcrBloc();
  final _debouncer = Debouncer(milliseconds: 10);
  List<SubjectDetailList> searchList = [];
  int standerdLearningLength = 0;
  String? learningStandard;
  String? subLearningStandard;
  final ValueNotifier<bool> isSubmitButton = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _ocrBloc.add(FatchSubjectDetails(
        type: 'nycSub',
        keyword: widget.keyword,
        isSearchPage: true,
        grade: widget.grade));
    _ocrBloc2.add(FatchSubjectDetails(
        type: 'nyc',
        keyword: widget.keyword,
        isSearchPage: true,
        grade: widget.grade));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackGroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: submitAssessmentButton(),
          appBar: CustomOcrAppBarWidget(
            isBackButton: true,
            isbackOnSuccess: isBackFromCamera,
            key: GlobalKey(),
          ),

          //  AppBar(
          //   automaticallyImplyLeading: false,
          //   backgroundColor: Colors.transparent,
          //   // Color(0xff000000) != Theme.of(context).backgroundColor
          //   //     ? Color.fromRGBO(0, 0, 0, 0.1)
          //   //     : Color.fromRGBO(255, 255, 255, 0.16),
          //   //leadingWidth: 0,
          //   title: Container(
          //    // padding: EdgeInsets.symmetric(horizontal: 20),
          //     child: SearchBar(
          //       isSearchPage: true,
          //       controller: searchController,
          //       onSaved: (value) {
          //         if (searchController.text.isEmpty) {
          //           _ocrBloc.add(FatchSubjectDetails(
          //               type: 'nycSub',
          //               keyword: widget.keyword,
          //               isSearchPage: true,
          //               grade: widget.grade));
          //           _ocrBloc2.add(FatchSubjectDetails(
          //               type: 'nyc',
          //               keyword: widget.keyword,
          //               isSearchPage: true,
          //               grade: widget.grade));
          //         } else {
          //           _debouncer.run(() async {
          //             _ocrBloc.add(SearchSubjectDetails(
          //                 searchKeyword: searchController.text,
          //                 type: 'nycSub',
          //                 keyword: widget.keyword,
          //                 isSearchPage: true,
          //                 grade: widget.grade));
          //             _ocrBloc2.add(SearchSubjectDetails(
          //               searchKeyword: searchController.text,
          //               type: 'nyc',
          //               keyword: widget.keyword,
          //               isSearchPage: true,
          //               grade: widget.grade,
          //             ));
          //             setState(() {});
          //           });
          //         }
          //       },
          //     ),

          //     // searchBarWidget(

          //     // ),
          //   ),
          // ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SearchBar(
                    isSearchPage: true,
                    controller: searchController,
                    onSaved: (value) {
                      if (searchController.text.isEmpty) {
                        _ocrBloc.add(FatchSubjectDetails(
                            type: 'nycSub',
                            keyword: widget.keyword,
                            isSearchPage: true,
                            grade: widget.grade));
                        _ocrBloc2.add(FatchSubjectDetails(
                            type: 'nyc',
                            keyword: widget.keyword,
                            isSearchPage: true,
                            grade: widget.grade));
                      } else {
                        _debouncer.run(() async {
                          _ocrBloc.add(SearchSubjectDetails(
                              searchKeyword: searchController.text,
                              type: 'nycSub',
                              keyword: widget.keyword,
                              isSearchPage: true,
                              grade: widget.grade));
                          _ocrBloc2.add(SearchSubjectDetails(
                            searchKeyword: searchController.text,
                            type: 'nyc',
                            keyword: widget.keyword,
                            isSearchPage: true,
                            grade: widget.grade,
                          ));
                          setState(() {});
                        });
                      }
                    },
                  ),
                ),
                // SpacerWidget(10),
                BlocListener<OcrBloc, OcrState>(
                  bloc: _ocrBloc,
                  listener: (context, state) {
                    if (state is NycSubDataSuccess) {
                      searchList.clear();
                      searchList.addAll(state.obj!);
                      listLength.value = searchList.length;
                    } else if (state is SearchSubjectDetailsSuccess) {
                      List<SubjectDetailList> list = [];

                      for (int i = 0; i < state.obj!.length; i++) {
                        if (state.obj![i].standardAndDescriptionC!
                            .toUpperCase()
                            .contains(searchController.text.toUpperCase())) {
                          list.add(state.obj![i]);
                        }
                      }
                      searchList.clear();
                      searchList.addAll(list);
                      listLength.value = searchList.length;
                    }
                    // do stuff here based on BlocA's state
                  },
                  child: Container(),
                ),
                BlocListener<OcrBloc, OcrState>(
                  bloc: _ocrBloc2,
                  listener: (context, state) {
                    if (state is NycDataSuccess) {
                      searchList.insertAll(0, state.obj);
                      standerdLearningLength = state.obj.length;
                      listLength.value = searchList.length;
                    } else if (state is SearchSubjectDetailsSuccess) {
                      List<SubjectDetailList> list = [];

                      for (int i = 0; i < state.obj!.length; i++) {
                        if (state.obj![i].domainNameC!
                            .toUpperCase()
                            .contains(searchController.text.toUpperCase())) {
                          list.add(state.obj![i]);
                        }
                      }
                      searchList.insertAll(0, list);
                      standerdLearningLength = list.length;
                      listLength.value = searchList.length;
                    }
                    // do stuff here based on BlocA's state
                  },
                  child: Container(),
                ),
                SpacerWidget(20),
                verticalListWidget()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget verticalListWidget() {
    return ValueListenableBuilder(
        valueListenable: listLength,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return buttonListWidget(list: searchList);
        });
  }

  Widget buttonListWidget({required List<SubjectDetailList> list}) {
    return ValueListenableBuilder(
      valueListenable: nycSubIndex1,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Container(
          //  padding: EdgeInsets.only(bottom: 50),
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.8
              : MediaQuery.of(context).size.width * 0.8,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView.separated(
            itemCount: list.length,
            itemBuilder: (BuildContext ctx, index) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    index == 0 && standerdLearningLength != 0
                        ? Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Utility.textWidget(
                                text: 'Learning Standard',
                                context: context,
                                textTheme: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(fontWeight: FontWeight.bold)))
                        : (index == standerdLearningLength && list.length != 0
                            ? Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Utility.textWidget(
                                    text:
                                        'NY Next Generation Learning Standard',
                                    context: context,
                                    textTheme: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontWeight: FontWeight.bold)))
                            : Container()),
                    Bouncing(
                      child: InkWell(
                        onTap: () {
                          //subLearningStandard = list[index].standardAndDescriptionC;
                          //if (pageIndex.value == 2) {
                          nycSubIndex1.value = index;
                          if (index < standerdLearningLength) {
                            isSubmitButton.value = false;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubjectSelection(
                                        selectedClass: widget.grade,
                                        isSearchPage: true,
                                        domainNameC: learningStandard =
                                            list[index].domainNameC,
                                        searchClass: widget.grade,
                                        selectedSubject: widget.keyword,
                                      )),
                            );
                          } else {
                            learningStandard = list[index].domainNameC;
                            subLearningStandard = list[index].descriptionC;
                            isSubmitButton.value = true;
                          }
                          // if (nycSubIndex1.value != 50000) {
                          //   isSubmitButton.value = true;
                          // }
                          // }
                        },
                        child: AnimatedContainer(
                          padding: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            color: (nycSubIndex1.value == index)
                                ? AppTheme.kSelectedColor
                                : Colors.grey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          duration: Duration(microseconds: 100),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            alignment: Alignment.centerLeft,

                            child: index < standerdLearningLength
                                ? Utility.textWidget(
                                    text: list[index].domainNameC!,
                                    context: context,
                                    textTheme:
                                        Theme.of(context).textTheme.headline2)
                                : RichText(
                                    text: list[index].standardAndDescriptionC !=
                                                null &&
                                            list[index]
                                                    .standardAndDescriptionC!
                                                    .split(' - ')
                                                    .length >
                                                1
                                        ? TextSpan(
                                            // Note: Styles for TextSpans must be explicitly defined.
                                            // Child text spans will inherit styles from parent
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: list[index]
                                                      .standardAndDescriptionC!
                                                      .split(' - ')[0],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline2!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                              TextSpan(text: '  '),
                                              TextSpan(
                                                text: list[index]
                                                    .standardAndDescriptionC!
                                                    .split(' - ')[1],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline2,
                                              ),
                                            ],
                                          )
                                        : TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                            children: [
                                                TextSpan(
                                                    text: list[index]
                                                            .standardAndDescriptionC ??
                                                        '')
                                              ]),
                                  ),

                            //  Utility.textWidget(
                            //     text: HtmlUnescape()
                            //         .convert(list[index].standardAndDescriptionC!),
                            //     textTheme: Theme.of(context).textTheme.headline2,
                            //     context: context),
                            decoration: BoxDecoration(
                                color: Color(0xff000000) !=
                                        Theme.of(context).backgroundColor
                                    ? Color(0xffF7F8F9)
                                    : Color(0xff111C20),
                                border: Border.all(
                                  color: (nycSubIndex1.value == index)
                                      ? AppTheme.kSelectedColor
                                      : Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    index == list.length - 1
                        ? SizedBox(
                            height: 20,
                          )
                        : Container()
                  ]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return SpacerWidget(_KVertcalSpace / 3.75);
            },
          ),
        );
      },
    );
  }

  Widget submitAssessmentButton() {
    return ValueListenableBuilder(
      valueListenable: isSubmitButton,
      child: Container(),
      builder: (BuildContext context, dynamic value, Widget? child) {
        return //pageIndex.value == 2
            isSubmitButton.value
                ? FloatingActionButton.extended(
                    backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
                    onPressed: () async {
                      LocalDatabase<CustomRubicModal> _localDb =
                          LocalDatabase('custom_rubic');
                      List<CustomRubicModal>? _localData =
                          await _localDb.getData();
                      String? rubricImgUrl;
                      // String? rubricScore;
                      for (int i = 0; i < _localData.length; i++) {
                        if (_localData[i].customOrStandardRubic == "Custom" &&
                            _localData[i].name == Globals.scoringRubric) {
                          rubricImgUrl = _localData[i].imgUrl;
                          // rubricScore = null;
                        }
                        if (_localData[i].name == Globals.scoringRubric &&
                            _localData[i].customOrStandardRubic != "Custom") {
                          // rubricScore = _localData[i].score;
                        } else {
                          rubricImgUrl = 'NA';
                          // rubricScore = 'NA';
                        }
                      }
                      //List<StudentAssessmentInfo> list = Globals.studentInfo!;
                      // List<StudentAssessmentInfo> list2 = [];
                      // Globals.studentInfo!.clear();

                      //Adding blank fields to the list : Static data
                      Globals.studentInfo!.forEach((element) {
                        element.subject = widget.keyword;
                        element.learningStandard =
                            learningStandard == null ? "NA" : learningStandard;
                        element.subLearningStandard =
                            subLearningStandard == null
                                ? "NA"
                                : subLearningStandard;
                        element.scoringRubric = Globals.scoringRubric;
                        element.customRubricImage = rubricImgUrl ?? "NA";
                        element.grade = widget.grade;
                      });

                      _googleDriveBloc.add(UpdateDocOnDrive(
                          isLoading: true,
                          studentData:
                              //list2
                              Globals.studentInfo!));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultsSummary(
                                  shareLink: Globals.shareableLink,
                                  asssessmentName: Globals.assessmentName,
                                  assessmentDetailPage: false,
                                )),
                      );
                    },
                    label: Row(
                      children: [
                        Utility.textWidget(
                            text: 'Save to drive',
                            context: context,
                            textTheme: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(
                                    color: Theme.of(context).backgroundColor)),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          //    margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: Image(
                            width: Globals.deviceType == "phone" ? 23 : 28,
                            height: Globals.deviceType == "phone" ? 23 : 28,
                            image: AssetImage(
                              "assets/images/drive_ico.png",
                            ),
                          ),
                        ),
                      ],
                    ))
                : Container();
      },
    );
  }
}
