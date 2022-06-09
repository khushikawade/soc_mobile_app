import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/custom_rubic_modal.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/ui/results_summary.dart';
import 'package:Soc/src/modules/ocr/widgets/searchbar_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../widgets/textfield_widget.dart';
import 'bottom_sheet_widget.dart';

class SubjectSelection extends StatefulWidget {
  final String? selectedClass;
  SubjectSelection({Key? key, required this.selectedClass}) : super(key: key);

  @override
  State<SubjectSelection> createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends State<SubjectSelection> {
  static const double _KVertcalSpace = 60.0;
  final searchController = TextEditingController();
  final addController = TextEditingController();

  String? keyword;
  String? keywordSub;
  OcrBloc _ocrBloc = OcrBloc();
  List<String> userAddedSubjectList = [];
  final _debouncer = Debouncer(milliseconds: 10);
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String? subject;
  String? learningStandard;
  String? subLearningStandard;
  String? subjectId;
  String? standardId;

  // new part of code
  final ValueNotifier<int> pageIndex = ValueNotifier<int>(0);
  final ValueNotifier<int> subjectIndex1 =
      ValueNotifier<int>(50000); //To bypass the default selection
  final ValueNotifier<int> nycIndex1 = ValueNotifier<int>(5000);
  final ValueNotifier<int> nycSubIndex1 = ValueNotifier<int>(5000);
  final ValueNotifier<bool> isSubmitButton = ValueNotifier<bool>(false);

  @override
  initState() {
    _ocrBloc.add(
        FatchSubjectDetails(type: 'subject', keyword: widget.selectedClass));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: Stack(
          children: [
            CommonBackGroundImgWidget(),
            Scaffold(
              key: _scaffoldKey,
              bottomNavigationBar: progressIndicatorBar(),
              floatingActionButton: submitAssessmentButton(),
              // (subject != 'Math' &&
              //         subject != 'Science' &&
              //         subject != 'ELA' &&
              //         subject != null)
              //     ? submitAssessmentButton()
              //     : null,
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              appBar: CustomOcrAppBarWidget(
                //key: null,
                isBackButton: true,
                key: null,
                isHomeButtonPopup: true,

                customBackButton: IconButton(
                  icon: Icon(
                    IconData(0xe80d,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: AppTheme.kButtonColor,
                  ),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (pageIndex.value == 1) {
                      _ocrBloc.add(FatchSubjectDetails(
                          type: 'subject', keyword: widget.selectedClass));
                    } else if (pageIndex.value == 2) {
                      _ocrBloc.add(
                          FatchSubjectDetails(type: 'nyc', keyword: keyword));
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              body: Container(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.85
                        : MediaQuery.of(context).size.width * 0.80,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    SpacerWidget(_KVertcalSpace * 0.50),
                    titleWidget(),
                    SpacerWidget(_KVertcalSpace / 3.5),
                    SearchBar(
                        controller: searchController,
                        onSaved: (String value) {
                          if (searchController.text.isEmpty) {
                            _ocrBloc.add(FatchSubjectDetails(
                                type: pageIndex.value == 0
                                    ? 'subject'
                                    : pageIndex.value == 1
                                        ? 'nyc'
                                        : 'nycSub',
                                keyword: pageIndex.value == 0
                                    ? widget.selectedClass
                                    : pageIndex.value == 1
                                        ? keyword
                                        : keywordSub));
                          } else {
                            _debouncer.run(() async {
                              pageIndex.value == 0
                                  ? searchList(
                                      classNo: widget.selectedClass!,
                                      searchKeyword: searchController.text)
                                  : null;

                              _ocrBloc.add(SearchSubjectDetails(
                                  searchKeyword: searchController.text,
                                  type: pageIndex.value == 0
                                      ? 'subject'
                                      : pageIndex.value == 1
                                          ? 'nyc'
                                          : 'nycSub',
                                  keyword: pageIndex.value == 0
                                      ? widget.selectedClass
                                      : pageIndex.value == 1
                                          ? keyword
                                          : keywordSub));
                              setState(() {});
                            });
                          }
                        }),
                    SpacerWidget(_KVertcalSpace / 4),
                    blocBuilderWidget(),
                    BlocListener(
                      bloc: _ocrBloc,
                      listener: (context, state) async {
                        if (state is SubjectDataSuccess) {
                          pageIndex.value = 0;
                        } else if (state is NycDataSuccess) {
                          pageIndex.value = 1;
                        } else if (state is NycSubDataSuccess) {
                          pageIndex.value = 2;
                        }
                      },
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget blocBuilderWidget() {
    return BlocBuilder<OcrBloc, OcrState>(
        bloc: _ocrBloc,
        builder: (context, state) {
          if (state is SubjectDataSuccess) {
            // state.obj!.forEach((element) { userAddedSubjectList.add(element.subjectNameC!);});

            return gridButtonsWidget(list: state.obj!, page: 0);
          } else if (state is NycDataSuccess) {
            return gridButtonsWidget(list: state.obj, page: 1);
          } else if (state is NycSubDataSuccess) {
            return buttonListWidget(list: state.obj!);
          } else if (state is SearchSubjectDetailsSuccess) {
            List<SubjectDetailList> list = [];
            if (pageIndex.value == 0) {
              for (int i = 0; i < state.obj!.length; i++) {
                if (state.obj![i].subjectNameC!
                    .toUpperCase()
                    .contains(searchController.text.toUpperCase())) {
                  list.add(state.obj![i]);
                }
              }
            } else if (pageIndex.value == 1) {
              for (int i = 0; i < state.obj!.length; i++) {
                if (state.obj![i].domainNameC!
                    .toUpperCase()
                    .contains(searchController.text.toUpperCase())) {
                  list.add(state.obj![i]);
                }
              }
            } else if (pageIndex.value == 2) {
              for (int i = 0; i < state.obj!.length; i++) {
                if (state.obj![i].standardAndDescriptionC!
                    .toUpperCase()
                    .contains(searchController.text.toUpperCase())) {
                  list.add(state.obj![i]);
                }
              }
            }

            return pageIndex.value == 0
                ? gridButtonsWidget(list: list, page: 0)
                : pageIndex.value == 1
                    ? gridButtonsWidget(list: list, page: 1)
                    : buttonListWidget(list: list);
          }
          return Container();
          // return widget here based on BlocA's state
        });
  }

  Widget titleWidget() {
    return ValueListenableBuilder(
      valueListenable: pageIndex,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Utility.textWidget(
            text: pageIndex.value == 0
                ? 'Subject'
                : pageIndex.value == 1
                    ? 'Learning Standard'
                    : 'NY Next Generation Learning Standard',
            context: context);
      },
      child: Container(),
    );
  }

  Widget buttonListWidget({required List<SubjectDetailList> list}) {
    return ValueListenableBuilder(
      valueListenable: nycSubIndex1,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Container(
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.65
              : MediaQuery.of(context).size.width * 0.50,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView.separated(
            itemCount: list.length,
            itemBuilder: (BuildContext ctx, index) {
              return Column(children: [
                Bouncing(
                  child: InkWell(
                    onTap: () {
                      subLearningStandard = list[index].standardAndDescriptionC;
                      if (pageIndex.value == 2) {
                        nycSubIndex1.value = index;
                        if (nycSubIndex1.value != 50000) {
                          isSubmitButton.value = true;
                        }
                      }
                    },
                    child: AnimatedContainer(
                      padding: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: (nycSubIndex1.value == index &&
                                pageIndex.value == 2)
                            ? AppTheme.kSelectedColor
                            : Colors.grey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      duration: Duration(microseconds: 100),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.center,
                        child: Utility.textWidget(
                            text: HtmlUnescape()
                                .convert(list[index].standardAndDescriptionC!),
                            textTheme: Theme.of(context).textTheme.headline2,
                            context: context),
                        decoration: BoxDecoration(
                            color: Color(0xff000000) !=
                                    Theme.of(context).backgroundColor
                                ? Color(0xffF7F8F9)
                                : Color(0xff111C20),
                            border: Border.all(
                              color: (nycSubIndex1.value == index &&
                                      pageIndex.value == 2)
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

  Widget progressIndicatorBar() {
    return ValueListenableBuilder(
      valueListenable: pageIndex,
      child: Container(),
      builder: (BuildContext context, dynamic value, Widget? child) {
        return ValueListenableBuilder(
            valueListenable: isSubmitButton,
            child: Container(),
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: AnimatedContainer(
                      duration: Duration(seconds: 5),
                      curve: Curves.easeOutExpo,
                      child: LinearProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppTheme.kButtonColor),
                        backgroundColor: Color(0xff000000) !=
                                Theme.of(context).backgroundColor
                            ? Color.fromRGBO(0, 0, 0, 0.1)
                            : Color.fromRGBO(255, 255, 255, 0.16),
                        minHeight: 15.0,
                        value: isSubmitButton.value
                            ? 100
                            : pageIndex.value == 0
                                ? 0.33
                                : pageIndex.value == 1
                                    ? 0.66
                                    : 1,
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  Widget gridButtonsWidget({required List<SubjectDetailList> list, int? page}) {
    return ValueListenableBuilder(
      valueListenable: pageIndex.value == 0 ? subjectIndex1 : nycIndex1,
      child: Container(),
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Container(
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.62
              : MediaQuery.of(context).size.width * 0.30,
          width: MediaQuery.of(context).size.width * 0.9,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180,
                  childAspectRatio: 5 / 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15),
              itemCount: page == 1 ? list.length : list.length + 1,
              itemBuilder: (BuildContext ctx, index) {
                return page == 1 || (page == 0 && index < list.length)
                    ? Bouncing(
                        onPress: () {
                          if (page == 1) {
                            // subject = list[index].subjectNameC;
                            // subjectId = list[index].subjectC;
                            // standardId = list[index].id;
                          } else {
                            learningStandard = list[index].domainNameC;
                          }

                          // if ((subject != 'Math' &&
                          //     subject != 'Science' &&
                          //     subject != 'ELA' &&
                          //     subject != null)) {
                          //   isSubmitButton.value = true;
                          // }
                          searchController.clear();
                          FocusManager.instance.primaryFocus?.unfocus();

                          if (pageIndex.value == 0) {
                            subject = list[index].subjectNameC;
                            subjectId = list[index].subjectC;
                            standardId = list[index].id;
                            subjectIndex1.value = index;
                            if ((subject != 'Math' &&
                                subject != 'Science' &&
                                subject != 'ELA' &&
                                subject != null)) {
                              isSubmitButton.value = true;
                            }

                            if (index < list.length && !isSubmitButton.value) {
                              keyword = list[index].subjectNameC;
                              _ocrBloc.add(FatchSubjectDetails(
                                  type: 'nyc', keyword: keyword));
                            }
                          } else if (pageIndex.value == 1) {
                            nycIndex1.value = index;

                            if (index < list.length) {
                              keywordSub = list[index].domainNameC;
                              _ocrBloc.add(FatchSubjectDetails(
                                  type: 'nycSub', keyword: keywordSub));
                            }
                          } else if (pageIndex.value == 1) {
                            nycSubIndex1.value = index;
                          }
                          if (index >= list.length &&
                              index !=
                                  list.length + userAddedSubjectList.length) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultsSummary(
                                        assessmentDetailPage: false,
                                      )),
                            );
                          }
                        },
                        child: Container(
                          child: AnimatedContainer(
                            padding: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: (subjectIndex1.value == index &&
                                          pageIndex.value == 0) ||
                                      (nycIndex1.value == index &&
                                          pageIndex.value == 1)
                                  ? AppTheme.kSelectedColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            duration: Duration(microseconds: 100),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              child: Utility.textWidget(
                                  text: page == 0
                                      ? list[index].subjectNameC!
                                      : list[index].domainNameC!,
                                  textTheme: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(fontWeight: FontWeight.bold),
                                  context: context),
                              decoration: BoxDecoration(
                                  color: Color(0xff000000) !=
                                          Theme.of(context).backgroundColor
                                      ? Color(0xffF7F8F9)
                                      : Color(0xff111C20),
                                  border: Border.all(
                                    color: (subjectIndex1.value == index &&
                                                pageIndex.value == 0) ||
                                            (nycIndex1.value == index &&
                                                pageIndex.value == 1)
                                        ? AppTheme.kSelectedColor
                                        : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      )
                    : Bouncing(
                        onPress: () {
                          if (pageIndex.value == 0) {
                            subjectIndex1.value = index;
                          }
                          customRubricBottomSheet();
                        },
                        child: Container(
                          child: AnimatedContainer(
                            padding: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: (subjectIndex1.value == index &&
                                      pageIndex.value == 0)
                                  ? AppTheme.kSelectedColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            duration: Duration(microseconds: 100),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              child: Utility.textWidget(
                                  text: '+',
                                  textTheme: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(fontWeight: FontWeight.bold),
                                  context: context),
                              decoration: BoxDecoration(
                                  color: Color(0xff000000) !=
                                          Theme.of(context).backgroundColor
                                      ? Color(0xffF7F8F9)
                                      : Color(0xff111C20),
                                  border: Border.all(
                                    color: (subjectIndex1.value == index &&
                                            pageIndex.value == 0)
                                        ? AppTheme.kSelectedColor
                                        : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      );
              }),
        );
      },
    );
  }

  customRubricBottomSheet() {
    showModalBottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        elevation: 10,
        context: context,
        builder: (context) => BottomSheetWidget(
              title: 'Add Subject',
              isImageField: false,
              textFieldTitleOne: 'Subject Name',
              isSubjectScreen: true,
              sheetHeight:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? MediaQuery.of(context).size.height * 0.82
                      : MediaQuery.of(context).size.height * 0.40,
              valueChanged: (controller) async {
                await updateList(
                    subjectName: controller.text,
                    classNo: widget.selectedClass!);
                _ocrBloc.add(FatchSubjectDetails(
                    type: 'subject', keyword: widget.selectedClass));

                controller.clear();
                Navigator.pop(context, false);
              },
            ));
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
                      String? rubricScore;
                      for (int i = 0; i < _localData.length; i++) {
                        if (_localData[i].customOrStandardRubic == "Custom" &&
                            _localData[i].name == Globals.scoringRubric) {
                          rubricImgUrl = _localData[i].imgUrl;
                          rubricScore = null;
                        }
                        if (_localData[i].name == Globals.scoringRubric &&
                            _localData[i].customOrStandardRubic != "Custom") {
                          rubricScore = _localData[i].score;
                        } else {
                          rubricImgUrl = 'NA';
                          // rubricScore = 'NA';
                        }
                      }
                      //List<StudentAssessmentInfo> list = Globals.studentInfo!;
                      // List<StudentAssessmentInfo> list2 = [];
                      // Globals.studentInfo!.clear();

                      for (int i = 0; i < Globals.studentInfo!.length; i++) {
                        Globals.studentInfo![i].subject = subject;
                        Globals.studentInfo![i].learningStandard =
                            learningStandard == null ? "NA" : learningStandard;
                        Globals.studentInfo![i].subLearningStandard =
                            subLearningStandard == null
                                ? "NA"
                                : subLearningStandard;
                        Globals.studentInfo![i].scoringRubric =
                            Globals.scoringRubric;
                        Globals.studentInfo![i].customRubricImage =
                            rubricImgUrl ?? "NA";
                        Globals.studentInfo![i].grade = widget.selectedClass;
                      }

                      // list.forEach(
                      //   (StudentAssessmentInfo element) {
                      //     Globals.studentInfo!.add(StudentAssessmentInfo(
                      //         studentName: element.studentName,
                      //         studentId: element.studentId,
                      //         studentGrade: element.studentGrade,
                      //         pointpossible: element.pointpossible,
                      //         grade: widget.selectedClass,
                      //         subject: subject,
                      //         learningStandard: learningStandard == null
                      //             ? "NA"
                      //             : learningStandard,
                      //         subLearningStandard: subLearningStandard == null
                      //             ? "NA"
                      //             : subLearningStandard,
                      //         scoringRubric: Globals.scoringRubric,
                      //         customRubricImage: rubricImgUrl,
                      //         assessmentImage: element.assessmentImage ?? ''));
                      //   },
                      // );
                      _googleDriveBloc.add(UpdateDocOnDrive(
                          studentData:
                              //list2
                              Globals.studentInfo!));

                      // _ocrBloc.add(SaveAssessmentIntoDataBase(
                      //     assessmentName: Globals.assessmentName!,
                      //     rubricScore: rubricScore!,
                      //     subjectId: subjectId!,
                      //     schoolId: Globals.appSetting.schoolNameC!,
                      //     standardId: standardId!));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultsSummary(
                                  assessmentDetailPage: false,
                                )),
                      );
                    },
                    label: Row(
                      children: [
                        Utility.textWidget(
                            text: 'Submit',
                            context: context,
                            textTheme: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(
                                    color: Theme.of(context).backgroundColor)),
                      ],
                    ))
                : Container();
      },
    );
  }

  Future<void> updateList(
      {required String subjectName, required String classNo}) async {
    LocalDatabase<SubjectDetailList> _localDb =
        LocalDatabase('Subject_list$classNo');
    List<SubjectDetailList>? _localData = await _localDb.getData();

    if (!_localData.contains(subjectName) && subjectName != '') {
      SubjectDetailList subjectDetailList = SubjectDetailList();
      subjectDetailList.subjectNameC = subjectName;
      _localData.add(subjectDetailList);
    } else {
      Utility.showSnackBar(
          _scaffoldKey, "Subject $subjectName already exist", context, null);
    }

    await _localDb.clear();
    _localData.forEach((SubjectDetailList e) {
      _localDb.addData(e);
    });
  }

  Future<void> searchList(
      {required String searchKeyword, required String classNo}) async {
    LocalDatabase<String> _localDb = LocalDatabase('Subject_list$classNo');
    List<String>? _localData = await _localDb.getData();
    userAddedSubjectList = [];
    for (int i = 0; i < _localData.length; i++) {
      if (_localData[i].toUpperCase().contains(searchKeyword.toUpperCase())) {
        userAddedSubjectList.add(_localData[i]);
      }
    }
  }

  showBottomSheet() {
    showMaterialModalBottomSheet(
      backgroundColor: Color(0xff000000) != Theme.of(context).backgroundColor
          ? Color(0xffF7F8F9)
          : Color(0xff111C20),
      animationCurve: Curves.easeOutQuart,
      elevation: 10,
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                    color: AppTheme.kButtonColor,
                    border: Border.symmetric(horizontal: BorderSide.none),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15))),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Utility.textWidget(
                    context: context,
                    text: 'Add Subject',
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(color: Colors.black)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFieldWidget(
                    msg: "Subject is already exist",
                    controller: addController,
                    onSaved: (String value) {}),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: FloatingActionButton.extended(
                    backgroundColor: AppTheme.kButtonColor
                        .withOpacity(nycSubIndex1.value == null ? 0.5 : 1.0),
                    onPressed: () async {
                      await updateList(
                          subjectName: addController.text,
                          classNo: widget.selectedClass!);
                      _ocrBloc.add(FatchSubjectDetails(
                          type: 'subject', keyword: widget.selectedClass));

                      // await fatchList(classNo: widget.selectedClass!);
                      Navigator.pop(context, false);
                    },
                    label: Row(
                      children: [
                        Utility.textWidget(
                            text: 'Submit',
                            context: context,
                            textTheme: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(
                                    color: Theme.of(context).backgroundColor)),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
