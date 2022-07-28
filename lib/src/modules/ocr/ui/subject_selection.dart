import 'dart:async';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/custom_rubic_modal.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/ocr/ui/search_screen.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/ui/results_summary.dart';
import 'package:Soc/src/modules/ocr/widgets/searchbar_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../../../services/local_database/local_db.dart';
import '../widgets/bottom_sheet_widget.dart';

class SubjectSelection extends StatefulWidget {
  final String? selectedClass;
  final bool? isSearchPage;
  final String? domainNameC;
  final String? searchClass;
  final String? selectedSubject;
  SubjectSelection(
      {Key? key,
      required this.selectedClass,
      this.isSearchPage,
      this.domainNameC,
      this.searchClass,
      this.selectedSubject})
      : super(key: key);

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
  GoogleDriveBloc _googleDriveBloc = GoogleDriveBloc();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String? subject;
  String? learningStandard;
  String? subLearningStandard;
  String? subjectId;
  String? standardId;

  // new part of code
  final ValueNotifier<int> pageIndex = ValueNotifier<int>(0);
  final ValueNotifier<int> subjectIndex1 =
      ValueNotifier<int>(-1); //To bypass the default selection
  final ValueNotifier<int> nycIndex1 =
      ValueNotifier<int>(-1); //To bypass the default selection
  final ValueNotifier<int> nycSubIndex1 =
      ValueNotifier<int>(-1); //To bypass the default selection
  final ValueNotifier<bool> isSubmitButton = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isSkipButton = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);

  LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
      LocalDatabase('student_info');
  LocalDatabase<SubjectDetailList> subjectRecentOptionDB =
      LocalDatabase('recent_option_subject');
  LocalDatabase<SubjectDetailList> learningRecentOptionDB =
      LocalDatabase('recent_option_learning_standard');

  @override
  initState() {
    if (widget.isSearchPage == true) {
      _ocrBloc.add(FatchSubjectDetails(
          type: 'nycSub',
          keyword: widget.domainNameC,
          grade: widget.searchClass,
          subjectSelected: widget.selectedSubject));
    } else {
      _ocrBloc.add(
          FatchSubjectDetails(type: 'subject', keyword: widget.selectedClass));
    }

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
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              appBar: CustomOcrAppBarWidget(
                isSuccessState: ValueNotifier<bool>(true),
                isbackOnSuccess: isBackFromCamera,
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
                      // isSkipButton.value = false;
                      isSkipButton.value = false;
                      subjectIndex1.value = 0;
                      isSubmitButton.value = false;
                      _ocrBloc.add(FatchSubjectDetails(
                          type: 'subject', keyword: widget.selectedClass));
                    } else if (pageIndex.value == 2) {
                      // isSkipButton.value = false;
                      isSubmitButton.value = false;
                      nycIndex1.value = 0;
                      if (widget.isSearchPage == true) {
                        //   FatchSubjectDetails(type: 'nyc', keyword: keyword));
                        Navigator.pop(context);
                      } else {
                        _ocrBloc.add(
                            FatchSubjectDetails(type: 'nyc', keyword: keyword));
                      }
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  children: [
                    SpacerWidget(_KVertcalSpace * 0.50),
                    titleWidget(),
                    SpacerWidget(_KVertcalSpace / 3.5),
                    ValueListenableBuilder(
                        valueListenable: pageIndex,
                        builder: (BuildContext context, dynamic value,
                            Widget? child) {
                          return pageIndex.value == 0
                              ? Container()
                              : SearchBar(
                                  isSubLearningPage:
                                      pageIndex.value == 2 ? true : false,
                                  onTap: () {
                                    if (pageIndex.value == 1) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchScreenPage(
                                                  keyword: keyword,
                                                  grade: widget.selectedClass,
                                                )),
                                      );
                                    }
                                  },
                                  controller: searchController,
                                  onSaved: (String value) {
                                    if (searchController.text.isEmpty &&
                                        pageIndex.value != 1) {
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
                                                  : keywordSub ??
                                                      widget.domainNameC,
                                          grade: widget.searchClass,
                                          subjectSelected:
                                              widget.selectedSubject));
                                    } else if (pageIndex.value != 1) {
                                      _debouncer.run(() async {
                                        pageIndex.value == 0
                                            ? searchList(
                                                classNo: widget.selectedClass!,
                                                searchKeyword:
                                                    searchController.text)
                                            : null;

                                        _ocrBloc.add(SearchSubjectDetails(
                                            searchKeyword:
                                                searchController.text,
                                            type: pageIndex.value == 0
                                                ? 'subject'
                                                : pageIndex.value == 1
                                                    ? 'nyc'
                                                    : 'nycSub',
                                            keyword: pageIndex.value == 0
                                                ? widget.selectedClass
                                                : pageIndex.value == 1
                                                    ? keyword
                                                    : keywordSub ??
                                                        widget.domainNameC,
                                            grade: widget.searchClass,
                                            subjectSelected:
                                                widget.selectedSubject));
                                        setState(() {});
                                      });
                                    }

                                    if (pageIndex.value == 1) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchScreenPage(
                                                  keyword: keyword,
                                                  grade: widget.selectedClass,
                                                )),
                                      );
                                    }
                                  });
                        }),
                    SpacerWidget(_KVertcalSpace / 4),
                    ValueListenableBuilder(
                        valueListenable: pageIndex,
                        builder: (BuildContext context, dynamic value,
                            Widget? child) {
                          return pageIndex.value == 1
                              ? searchDomainText()
                              : Container();
                        }),
                    SpacerWidget(_KVertcalSpace / 4),
                    blocBuilderWidget(),
                    BlocListener(
                      bloc: _ocrBloc,
                      listener: (context, state) async {
                        if (state is SubjectDataSuccess) {
                          pageIndex.value = 0;
                        } else if (state is NycDataSuccess) {
                          // AnimationController?.dispose();
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
            state.obj!.forEach((element) {
              if (element.dateTime != null) {
                state.obj!.sort((a, b) => DateTime.parse(b.dateTime.toString())
                    .compareTo(DateTime.parse(a.dateTime.toString())));
              }
            });
            // state.obj!.forEach((element) { userAddedSubjectList.add(element.subjectNameC!);});

            return gridButtonsWidget(
                list: state.obj!, page: 0, isSubjectScreen: true);
          } else if (state is NycDataSuccess) {
            state.obj.forEach((element) {
              if (element.dateTime != null) {
                state.obj.sort((a, b) => DateTime.parse(b.dateTime.toString())
                    .compareTo(DateTime.parse(a.dateTime.toString())));
              }
            });

            return gridButtonsWidget(
                list: state.obj, page: 1, isSubjectScreen: false);
          } else if (state is NycSubDataSuccess) {
            state.obj!.forEach((element) {
              if (element.domainCodeC != null) {
                state.obj!.sort((a, b) => a.name!.compareTo(b.name!));
              }
            });

            return buttonListWidget(list: state.obj!);
          } else if (state is SearchSubjectDetailsSuccess) {
            List<SubjectDetailList> list = [];
            if (pageIndex.value == 0) {
              state.obj!.forEach((element) {
                if (element.subjectNameC != null) {
                  state.obj!.sort(
                      (a, b) => a.subjectNameC!.compareTo(b.subjectNameC!));
                }
              });

              for (int i = 0; i < state.obj!.length; i++) {
                if (state.obj![i].subjectNameC!
                    .toUpperCase()
                    .contains(searchController.text.toUpperCase())) {
                  list.add(state.obj![i]);
                }
              }
            } else if (pageIndex.value == 1) {
              state.obj!.forEach((element) {
                if (element.domainNameC != null) {
                  state.obj!
                      .sort((a, b) => a.domainNameC!.compareTo(b.domainNameC!));
                }
              });

              for (int i = 0; i < state.obj!.length; i++) {
                if (state.obj![i].domainNameC!
                    .toUpperCase()
                    .contains(searchController.text.toUpperCase())) {
                  list.add(state.obj![i]);
                }
              }
            } else if (pageIndex.value == 2) {
              state.obj!.forEach((element) {
                if (element.domainCodeC != null) {
                  state.obj!
                      .sort((a, b) => a.domainCodeC!.compareTo(b.domainCodeC!));
                }
              });

              for (int i = 0; i < state.obj!.length; i++) {
                if (state.obj![i].standardAndDescriptionC!
                    .toUpperCase()
                    .contains(searchController.text.toUpperCase())) {
                  list.add(state.obj![i]);
                }
              }
            }

            return pageIndex.value == 0
                ? gridButtonsWidget(list: list, page: 0, isSubjectScreen: true)
                : pageIndex.value == 1
                    ? gridButtonsWidget(
                        list: list, page: 1, isSubjectScreen: false)
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
                : 'NY Next Generation Learning Standard',
            context: context);
      },
      child: Container(),
    );
  }

  Widget searchDomainText() {
    return Utility.textWidget(
        text: 'Select Domain',
        textTheme: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.bold,
            ),
        context: context);
  }

  Widget buttonListWidget({required List<SubjectDetailList> list}) {
    return ValueListenableBuilder(
      valueListenable: nycSubIndex1,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Container(
          padding: EdgeInsets.only(bottom: 50),
          height: Globals.deviceType == 'phone'
              ? MediaQuery.of(context).size.height * 0.65
              : MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView.separated(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.03),
            itemCount: list.length,
            itemBuilder: (BuildContext ctx, index) {
              return Column(children: [
                Bouncing(
                  child: InkWell(
                    onTap: () {
                      subLearningStandard =
                          list[index].standardAndDescriptionC!.split(' - ')[0];
                      if (pageIndex.value == 2) {
                        nycSubIndex1.value = index;
                        if (nycSubIndex1.value != -1) {
                          isSubmitButton.value = true;
                          isSkipButton.value = false;
                        }
                      }
                      print(subLearningStandard);
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
                        alignment: Alignment.centerLeft,
                        child: TranslationWidget(
                          message: list[index].standardAndDescriptionC ?? '',
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => RichText(
                            text: translatedMessage != null &&
                                    translatedMessage
                                            .toString()
                                            .split(' - ')
                                            .length >
                                        1
                                ? TextSpan(
                                    // Note: Styles for TextSpans must be explicitly defined.
                                    // Child text spans will inherit styles from parent
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: translatedMessage
                                              .toString()
                                              .split(' - ')[0]
                                              .replaceAll('Â', '')
                                              .replaceAll('U+2612', '')
                                              .replaceAll('⍰', ''), //🖾
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              )),
                                      TextSpan(text: '  '),
                                      TextSpan(
                                        text: translatedMessage
                                            .toString()
                                            .split(' - ')[1]
                                            .replaceAll('Â', '')
                                            .replaceAll('U+2612', '')
                                            .replaceAll('⍰', ''),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                    ],
                                  )
                                : TextSpan(
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                    children: [
                                        TextSpan(text: translatedMessage)
                                      ]),
                          ),

                          // Text(
                          //     translatedMessage.toString(),
                          //     style: Theme.of(context).textTheme.bodyText1!),
                        ),

                        // RichText(
                        //   text: list[index].standardAndDescriptionC != null &&
                        //           list[index]
                        //                   .standardAndDescriptionC!
                        //                   .split(' - ')
                        //                   .length >
                        //               1
                        //       ? TextSpan(
                        //           // Note: Styles for TextSpans must be explicitly defined.
                        //           // Child text spans will inherit styles from parent
                        //           style: Theme.of(context).textTheme.headline2,
                        //           children: <TextSpan>[
                        //             TextSpan(
                        //                 text: list[index]
                        //                     .standardAndDescriptionC!
                        //                     .split(' - ')[0]
                        //                     .replaceAll('Â', '')
                        //                     .replaceAll('U+2612', '')
                        //                     .replaceAll('⍰', ''), //🖾
                        //                 style: Theme.of(context)
                        //                     .textTheme
                        //                     .headline2!
                        //                     .copyWith(
                        //                       fontWeight: FontWeight.bold,
                        //                     )),
                        //             TextSpan(text: '  '),
                        //             TextSpan(
                        //               text: list[index]
                        //                   .standardAndDescriptionC!
                        //                   .split(' - ')[1]
                        //                   .replaceAll('Â', '')
                        //                   .replaceAll('U+2612', '')
                        //                   .replaceAll('⍰', ''),
                        //               style:
                        //                   Theme.of(context).textTheme.headline2,
                        //             ),
                        //           ],
                        //         )
                        //       : TextSpan(
                        //           style: Theme.of(context).textTheme.headline2,
                        //           children: [
                        //               TextSpan(
                        //                   text: list[index]
                        //                           .standardAndDescriptionC ??
                        //                       '')
                        //             ]),
                        // ),

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
                        height: 40,
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
      child: Container(
        height: 0,
      ),
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
                      // duration: Duration(seconds: 5),
                      duration: Duration(microseconds: 100),
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

  Widget gridButtonsWidget(
      {required List<SubjectDetailList> list,
      int? page,
      bool? isSubjectScreen}) {
    return ValueListenableBuilder(
      valueListenable: pageIndex.value == 0 ? subjectIndex1 : nycIndex1,
      child: Container(),
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Container(
          padding: EdgeInsets.only(bottom: pageIndex.value == 0 ? 0 : 50),
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.62
              : MediaQuery.of(context).size.width * 0.30,
          width: MediaQuery.of(context).size.width * 0.9,
          child: GridView.builder(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.09),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: Globals.deviceType == 'phone' ? 180 : 400,
                  childAspectRatio:
                      Globals.deviceType == 'phone' ? 5 / 3 : 5 / 1.5,
                  crossAxisSpacing: Globals.deviceType == 'phone' ? 15 : 20,
                  mainAxisSpacing: 15),
              itemCount: page == 1 ? list.length : list.length + 1,
              itemBuilder: (BuildContext ctx, index) {
                return page == 1 || (page == 0 && index < list.length)
                    ? Bouncing(
                        // onPress: () {

                        // },
                        child: InkWell(
                          onTap: () async {
                            if (page != 1) {
                              print("INSIDE ON TAPPPPPPPPPPPPPPPPPPPPP");
                            }

                            searchController.clear();
                            FocusManager.instance.primaryFocus?.unfocus();

                            if (pageIndex.value == 0) {
                              isSkipButton.value = true;
                              subject = list[index].subjectNameC ?? '';
                              subjectId = list[index].subjectC ?? '';
                              standardId = list[index].id ?? '';

                              subjectIndex1.value = index;

                              if ((subject != 'Math' &&
                                  subject != 'Science' &&
                                  subject != 'ELA' &&
                                  subject != null)) {
                                isSubmitButton.value = true;
                              } else {
                                isSubmitButton.value = false;
                              }

                              if (index < list.length &&
                                  !isSubmitButton.value) {
                                keyword = list[index].subjectNameC;
                                _ocrBloc.add(FatchSubjectDetails(
                                    type: 'nyc', keyword: keyword));
                              }
                              //To manage the recent subject list
                              List<SubjectDetailList> recentlUsedList =
                                  await subjectRecentOptionDB.getData();

                              SubjectDetailList recentSubjectList =
                                  SubjectDetailList();

                              if (recentlUsedList.isNotEmpty) {
                                bool addToRecentList = false;

                                //To update the object if already exist
                                for (int i = 0;
                                    i < recentlUsedList.length;
                                    i++) {
                                  if (recentlUsedList[i].subjectNameC ==
                                      list[index].subjectNameC) {
                                    recentSubjectList = recentlUsedList[i];

                                    recentSubjectList.dateTime = DateTime.now();
                                    await subjectRecentOptionDB.putAt(
                                        i, recentSubjectList);
                                    addToRecentList = true;
                                    break;
                                  }
                                }

                                //To add the object if not exist
                                if (addToRecentList == false) {
                                  recentSubjectList.subjectNameC =
                                      list[index].subjectNameC;
                                  recentSubjectList.dateTime = DateTime.now();
                                  await subjectRecentOptionDB
                                      .addData(recentSubjectList);
                                }
                              } else {
                                recentSubjectList.subjectNameC =
                                    list[index].subjectNameC;
                                recentSubjectList.dateTime = DateTime.now();
                                await subjectRecentOptionDB
                                    .addData(recentSubjectList);
                              }
                            } else if (pageIndex.value == 1) {
                              learningStandard = list[index].domainNameC;
                              nycIndex1.value = index;
                              // nycSubIndex1.value = index;

                              if (index < list.length) {
                                keywordSub = list[index].domainNameC;
                                _ocrBloc.add(FatchSubjectDetails(
                                    type: 'nycSub', keyword: keywordSub));
                              }
                              //To manage the recent learning standard list
                              List<SubjectDetailList> learningrecentList =
                                  await learningRecentOptionDB.getData();

                              SubjectDetailList learningRecentObject =
                                  SubjectDetailList();
                              //To add the object if not exist
                              if (learningrecentList.isNotEmpty) {
                                bool addToRecentList = false;

                                for (int i = 0;
                                    i < learningrecentList.length;
                                    i++) {
                                  if (learningrecentList[i].domainNameC ==
                                      list[index].domainNameC) {
                                    learningRecentObject =
                                        learningrecentList[i];

                                    learningRecentObject.dateTime =
                                        DateTime.now();
                                    await learningRecentOptionDB.putAt(
                                        i, learningRecentObject);
                                    addToRecentList = true;
                                    break;
                                  }
                                }
                                //To update the object if not exist
                                if (addToRecentList == false) {
                                  learningRecentObject.domainNameC =
                                      list[index].domainNameC;
                                  learningRecentObject.dateTime =
                                      DateTime.now();
                                  await learningRecentOptionDB
                                      .addData(learningRecentObject);
                                }
                              } else {
                                learningRecentObject.domainNameC =
                                    list[index].domainNameC;
                                learningRecentObject.dateTime = DateTime.now();
                                await learningRecentOptionDB
                                    .addData(learningRecentObject);
                              }
                            }
                            if (index >= list.length &&
                                index !=
                                    list.length + userAddedSubjectList.length) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResultsSummary(
                                          subjectId: subjectId ?? '',
                                          standardId: standardId ?? '',
                                          asssessmentName:
                                              Globals.assessmentName,
                                          shareLink: Globals.shareableLink!,
                                          assessmentDetailPage: false,
                                        )),
                              );
                            }
                          },
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
                            duration: Duration(microseconds: 5000),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: isSubjectScreen == true
                                  ? Alignment.center
                                  : Alignment.centerLeft,
                              child: Utility.textWidget(
                                  textAlign: TextAlign.left,
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
                        child: InkWell(
                          onTap: () {
                            // if (pageIndex.value == 0) {
                            //   subjectIndex1.value = index;
                            // }
                            customRubricBottomSheet();
                          },
                          child: AnimatedContainer(
                            padding: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color:
                                  // (subjectIndex1.value == index &&
                                  //         pageIndex.value == 0)
                                  //     ? AppTheme.kSelectedColor
                                  //     :
                                  Colors.grey,
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
        sheetHeight: MediaQuery.of(context).orientation == Orientation.landscape
            ? MediaQuery.of(context).size.height * 0.82
            : MediaQuery.of(context).size.height * 0.45,
        valueChanged: (controller) async {
          await updateList(
              subjectName: controller.text, classNo: widget.selectedClass!);
          _ocrBloc.add(FatchSubjectDetails(
              type: 'subject', keyword: widget.selectedClass));

          controller.clear();
          Navigator.pop(context, false);
        },
      ),
      // SizedBox(
      //   height: 30,
      // )
    );
  }

  Widget submitAssessmentButton() {
    return Wrap(
      alignment: WrapAlignment.end,
      children: [
        ValueListenableBuilder(
            valueListenable: isSkipButton,
            child: Container(),
            builder: (BuildContext context, dynamic value, Widget? child) {
              return isSkipButton.value && pageIndex.value != 0
                  ? OfflineBuilder(
                      connectivityBuilder: (BuildContext context,
                          ConnectivityResult connectivity, Widget child) {
                        final bool connected =
                            connectivity != ConnectivityResult.none;
                        return FloatingActionButton.extended(
                            backgroundColor:
                                AppTheme.kButtonColor.withOpacity(1.0),
                            onPressed: () async {
                              _uploadSheetOnDriveAndnavigate(
                                  isSkip: true, connected: connected);
                              Utility.updateLoges(
                                  // ,
                                  activityId: '18',
                                  description: 'Skip subject selection process',
                                  operationResult: 'Success');
                            },
                            label: Row(
                              children: [
                                BlocListener<GoogleDriveBloc, GoogleDriveState>(
                                    bloc: _googleDriveBloc,
                                    child: Container(),
                                    listener: (context, state) async {
                                      if (state is GoogleDriveLoading) {
                                        Utility.showLoadingDialog(
                                            context, true);
                                      }
                                      if (state is GoogleSuccess) {
                                        Globals.currentAssessmentId = '';
                                        _ocrBloc.add(SaveAndGetAssessmentID(
                                            assessmentName:
                                                Globals.assessmentName ??
                                                    'Assessment Name',
                                            rubricScore:
                                                Globals.scoringRubric ?? '2',
                                            subjectId: subjectId ??
                                                '', //Student Id will not be there in case of custom subject
                                            schoolId: Globals
                                                    .appSetting.schoolNameC ??
                                                '',
                                            standardId: standardId ?? '',
                                            scaffoldKey: _scaffoldKey,
                                            context: context,
                                            fileId:
                                                Globals.googleExcelSheetId ??
                                                    'Excel Id not found',
                                            sessionId: Globals.sessionId,
                                            teacherContactId: Globals.teacherId,
                                            teacherEmail:
                                                Globals.teacherEmailId));
                                      }
                                      if (state is ErrorState) {
                                        if (state.errorMsg ==
                                            'Reauthentication is required') {
                                          await Utility
                                              .refreshAuthenticationToken(
                                                  isNavigator: true,
                                                  errorMsg: state.errorMsg!,
                                                  context: context,
                                                  scaffoldKey: _scaffoldKey);

                                          _googleDriveBloc.add(
                                            UpdateDocOnDrive(
                                                createdAsPremium:
                                                    Globals.isPremiumUser,
                                                assessmentName:
                                                    Globals.assessmentName,
                                                fileId:
                                                    Globals.googleExcelSheetId,
                                                isLoading: true,
                                                studentData: await Utility
                                                    .getStudentInfoList(
                                                        tableName:
                                                            'student_info')
                                                //list2
                                                //Globals.studentInfo!
                                                ),
                                          );
                                        } else {
                                          Navigator.of(context).pop();
                                          Utility.currentScreenSnackBar(
                                              "Something Went Wrong. Please Try Again.");
                                        }
                                      }
                                    }),
                                BlocListener<OcrBloc, OcrState>(
                                    bloc: _ocrBloc,
                                    child: Container(),
                                    listener: (context, state) {
                                      if (state is OcrLoading) {
                                        // Utility.showLoadingDialog(context);
                                      }
                                      if (state is AssessmentIdSuccess) {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResultsSummary(
                                                    fileId: Globals
                                                        .googleExcelSheetId,
                                                    subjectId: subjectId ?? '',
                                                    standardId:
                                                        standardId ?? '',
                                                    asssessmentName:
                                                        Globals.assessmentName,
                                                    shareLink: '',
                                                    assessmentDetailPage: false,
                                                  )),
                                        );
                                      }
                                    }),
                                Utility.textWidget(
                                    text: 'Skip',
                                    context: context,
                                    textTheme: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .backgroundColor)),
                              ],
                            ));
                      },
                      child: Container(),
                    )
                  : Container();
            }),
        ValueListenableBuilder(
          valueListenable: isSubmitButton,
          child: Container(),
          builder: (BuildContext context, dynamic value, Widget? child) {
            return //pageIndex.value == 2
                isSubmitButton.value
                    ? OfflineBuilder(
                        connectivityBuilder: (BuildContext context,
                            ConnectivityResult connectivity, Widget child) {
                          final bool connected =
                              connectivity != ConnectivityResult.none;
                          return FloatingActionButton.extended(
                              backgroundColor:
                                  AppTheme.kButtonColor.withOpacity(1.0),
                              onPressed: () async {
                                _uploadSheetOnDriveAndnavigate(
                                    isSkip: false, connected: connected);
                              },
                              label: Row(
                                children: [
                                  BlocListener<GoogleDriveBloc,
                                          GoogleDriveState>(
                                      bloc: _googleDriveBloc,
                                      child: Container(),
                                      listener: (context, state) async {
                                        if (state is GoogleDriveLoading) {
                                          Utility.showLoadingDialog(
                                              context, true);
                                        }
                                        if (state is GoogleSuccess) {
                                          Globals.currentAssessmentId = '';
                                          _ocrBloc.add(SaveAndGetAssessmentID(
                                              assessmentName:
                                                  Globals.assessmentName ??
                                                      'Assessment Name',
                                              rubricScore:
                                                  Globals.scoringRubric ?? '2',
                                              subjectId: subjectId ??
                                                  '', //Student Id will not be there in case of custom subject
                                              schoolId: Globals
                                                      .appSetting.schoolNameC ??
                                                  '',
                                              standardId: standardId ?? '',
                                              scaffoldKey: _scaffoldKey,
                                              context: context,
                                              fileId:
                                                  Globals.googleExcelSheetId ??
                                                      'Excel Id not found',
                                              sessionId: Globals.sessionId,
                                              teacherContactId:
                                                  Globals.teacherId,
                                              teacherEmail:
                                                  Globals.teacherEmailId));
                                        }
                                        if (state is ErrorState) {
                                          if (state.errorMsg ==
                                              'Reauthentication is required') {
                                            await Utility
                                                .refreshAuthenticationToken(
                                                    isNavigator: true,
                                                    errorMsg: state.errorMsg!,
                                                    context: context,
                                                    scaffoldKey: _scaffoldKey);

                                            _googleDriveBloc.add(
                                              UpdateDocOnDrive(
                                                createdAsPremium:
                                                    Globals.isPremiumUser,
                                                assessmentName:
                                                    Globals.assessmentName,
                                                fileId:
                                                    Globals.googleExcelSheetId,
                                                isLoading: true,
                                                studentData:
                                                    //list2
                                                    await Utility
                                                        .getStudentInfoList(
                                                            tableName:
                                                                'student_info'),
                                              ),
                                            );
                                          } else {
                                            Navigator.of(context).pop();
                                            Utility.currentScreenSnackBar(
                                                "Something Went Wrong. Please Try Again.");
                                          }
                                        }
                                      }),
                                  BlocListener<OcrBloc, OcrState>(
                                      bloc: _ocrBloc,
                                      child: Container(),
                                      listener: (context, state) {
                                        if (state is OcrLoading) {
                                          //Utility.showLoadingDialog(context);
                                        }
                                        if (state is AssessmentIdSuccess) {
                                          Navigator.of(context).pop();
                                          Utility.updateLoges(
                                              // ,
                                              activityId: '14',
                                              description: 'Save to drive',
                                              operationResult: 'Success');

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ResultsSummary(
                                                      fileId: Globals
                                                          .googleExcelSheetId,
                                                      subjectId:
                                                          subjectId ?? '',
                                                      standardId:
                                                          standardId ?? '',
                                                      asssessmentName: Globals
                                                          .assessmentName,
                                                      shareLink: '',
                                                      assessmentDetailPage:
                                                          false,
                                                    )),
                                          );
                                        }
                                      }),
                                  Utility.textWidget(
                                      text: 'Save to drive',
                                      context: context,
                                      textTheme: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .backgroundColor)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    //    margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    child: Image(
                                      width: Globals.deviceType == "phone"
                                          ? 23
                                          : 28,
                                      height: Globals.deviceType == "phone"
                                          ? 23
                                          : 28,
                                      image: AssetImage(
                                        "assets/images/drive_ico.png",
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                        },
                        child: Container(),
                      )
                    : Container();
          },
        ),
      ],
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
      Utility.showSnackBar(_scaffoldKey,
          "Subject \'$subjectName\' Already Exist", context, null);
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

  // showBottomSheet() {
  //   showMaterialModalBottomSheet(
  //     backgroundColor: Colors.transparent,
  //     animationCurve: Curves.easeOutQuart,
  //     elevation: 10,
  //     context: context,
  //     builder: (context) => SingleChildScrollView(
  //       controller: ModalScrollController.of(context),
  //       child: Container(
  //         height: MediaQuery.of(context).size.height * 0.7,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               height: 60,
  //               decoration: BoxDecoration(
  //                   color: AppTheme.kButtonColor,
  //                   border: Border.symmetric(horizontal: BorderSide.none),
  //                   borderRadius: BorderRadius.only(
  //                       topRight: Radius.circular(15),
  //                       topLeft: Radius.circular(15))),
  //             ),
  //             SizedBox(
  //               height: 30,
  //             ),
  //             Container(
  //               padding: EdgeInsets.symmetric(horizontal: 20),
  //               child: Utility.textWidget(
  //                   context: context,
  //                   text: 'Add Subject',
  //                   textTheme: Theme.of(context)
  //                       .textTheme
  //                       .headline1!
  //                       .copyWith(color: Colors.black)),
  //             ),
  //             Container(
  //               padding: EdgeInsets.symmetric(horizontal: 20),
  //               child: TextFieldWidget(
  //                   msg: "Subject Is Already Exist",
  //                   controller: addController,
  //                   onSaved: (String value) {}),
  //             ),
  //             SizedBox(
  //               height: 80,
  //             ),
  //             Container(
  //               //padding: EdgeInsets.symmetric(horizontal: 20,),
  //               child: FloatingActionButton.extended(
  //                   backgroundColor: AppTheme.kButtonColor
  //                       .withOpacity(nycSubIndex1.value == null ? 0.5 : 1.0),
  //                   onPressed: () async {
  //                     await updateList(
  //                         subjectName: addController.text,
  //                         classNo: widget.selectedClass!);
  //                     _ocrBloc.add(FatchSubjectDetails(
  //                         type: 'subject', keyword: widget.selectedClass));

  //                     // await fatchList(classNo: widget.selectedClass!);
  //                     Navigator.pop(context, false);
  //                   },
  //                   label: Row(
  //                     children: [
  //                       Utility.textWidget(
  //                           text: 'Submit',
  //                           context: context,
  //                           textTheme: Theme.of(context)
  //                               .textTheme
  //                               .headline2!
  //                               .copyWith(
  //                                   color: Theme.of(context).backgroundColor)),
  //                     ],
  //                   )),
  //             ),
  //             SizedBox(
  //               height: 80,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _uploadSheetOnDriveAndnavigate(
      {required bool isSkip, required bool connected}) async {
    {
      if (!connected) {
        Utility.currentScreenSnackBar("No Internet Connection");
      } else {
        LocalDatabase<CustomRubicModal> _localDb =
            LocalDatabase('custom_rubic');

        List<CustomRubicModal>? _localData = await _localDb.getData();
        String? rubricImgUrl;
        // String? rubricScore;
        for (int i = 0; i < _localData.length; i++) {
          if (_localData[i].customOrStandardRubic == "Custom" &&
              _localData[i].name == Globals.scoringRubric!.split(" ")[0]) {
            rubricImgUrl = _localData[i].imgUrl;
            // rubricScore = null;
          }
          //  else if (_localData[i].name == Globals.scoringRubric &&
          //         _localData[i].customOrStandardRubic != "Custom") {
          //       // rubricScore = _localData[i].score;
          //     }
          else {
            rubricImgUrl = 'NA';
            // rubricScore = 'NA';
          }
        }

        //TODO : REMOVE THIS AND ADD COMMON FIELDS IN EXCEL MODEL (SAME IN CASE OF SCAN MORE AT CAMERA SCREEN)
        //Adding blank fields to the list : Static data
        // Globals.studentInfo!.forEach((element) {
        //   element.subject = subject;
        //   element.learningStandard =
        //       learningStandard == null ? "NA" : learningStandard;
        //   element.subLearningStandard =
        //       subLearningStandard == null ? "NA" : subLearningStandard;
        //   element.scoringRubric = Globals.scoringRubric;
        //   element.className = Globals.assessmentName!.split("_")[1];
        //   element.customRubricImage = rubricImgUrl ?? "NA";
        //   element.grade = widget.selectedClass;
        //   element.questionImgUrl = Globals.questionImgUrl != null &&
        //           Globals.questionImgUrl!.isNotEmpty
        //       ? Globals.questionImgUrl
        //       : "NA";
        // });

        // studentInfodblist.asMap().forEach((index, element) async {
        //   StudentAssessmentInfo element = studentInfodblist[index];

        //   element.subject = subject;
        //   element.learningStandard =
        //       learningStandard == null ? "NA" : learningStandard;
        //   element.subLearningStandard =
        //       subLearningStandard == null ? "NA" : subLearningStandard;
        //   element.scoringRubric = Globals.scoringRubric;
        //   element.className = Globals.assessmentName!.split("_")[1];
        //   element.customRubricImage = rubricImgUrl ?? "NA";
        //   element.grade = widget.selectedClass;
        //   element.questionImgUrl = Globals.questionImgUrl != null &&
        //           Globals.questionImgUrl!.isNotEmpty
        //       ? Globals.questionImgUrl
        //       : "NA";

        //   await _studentInfoDb.putAt(index, element);
        // });

        // studentInfodblist.forEach((element) async {
        //   element.subject = subject;
        //   element.learningStandard =
        //       learningStandard == null ? "NA" : learningStandard;
        //   element.subLearningStandard =
        //       subLearningStandard == null ? "NA" : subLearningStandard;
        //   element.scoringRubric = Globals.scoringRubric;
        //   element.className = Globals.assessmentName!.split("_")[1];
        //   element.customRubricImage = rubricImgUrl ?? "NA";
        //   element.grade = widget.selectedClass;
        //   element.questionImgUrl = Globals.questionImgUrl != null &&
        //           Globals.questionImgUrl!.isNotEmpty
        //       ? Globals.questionImgUrl
        //       : "NA";
        //   await _studentInfoDb.addData(element);
        // });

        List<StudentAssessmentInfo> studentInfodblist =
            await Utility.getStudentInfoList(tableName: 'student_info');

        //Updating remaining common details of assessment
        StudentAssessmentInfo element = studentInfodblist.first;

        element.subject = subject;
        element.learningStandard =
            learningStandard == null ? "NA" : learningStandard;
        element.subLearningStandard =
            subLearningStandard == null ? "NA" : subLearningStandard;
        element.scoringRubric = Globals.scoringRubric;
        element.className = Globals.assessmentName!.split("_")[1];
        element.customRubricImage = rubricImgUrl ?? "NA";
        element.grade = widget.selectedClass;
        element.questionImgUrl =
            Globals.questionImgUrl != null && Globals.questionImgUrl!.isNotEmpty
                ? Globals.questionImgUrl
                : "NA";

        await _studentInfoDb.putAt(0, element);

        _googleDriveBloc.add(
          UpdateDocOnDrive(
              createdAsPremium: Globals.isPremiumUser,
              assessmentName: Globals.assessmentName,
              fileId: Globals.googleExcelSheetId,
              isLoading: true,
              studentData:
                  //list2
                  await Utility.getStudentInfoList(tableName: 'student_info')),
        );
      }
    }
  }
}
