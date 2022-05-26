import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/ocr/modal/subject_list_modal.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/ui/results_summary.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
  int indexGlobal = 0;
  int? subjectIndex;
  int? nycIndex;
  int? nycSubIndex;
  String? keyword;
  String? keywordSub;
  OcrBloc _ocrBloc = OcrBloc();
  List<String> userAddedSubjectList = [];
  final _debouncer = Debouncer(milliseconds: 10);
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  @override
  void initState() {
    fatchList(classNo: widget.selectedClass!);
    _ocrBloc.add(
        FatchSubjectDetails(type: 'subject', keyword: widget.selectedClass));
    // fatchList(classNo: widget.selectedClass!);
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
              bottomNavigationBar: progressIndicatorBar(),
              floatingActionButton:
                  indexGlobal == 2 ? textActionButton() : null,
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    IconData(0xe80d,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: AppTheme.kButtonColor,
                  ),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (indexGlobal == 1) {
                      await fatchList(classNo: widget.selectedClass!);
                      _ocrBloc.add(FatchSubjectDetails(
                          type: 'subject', keyword: widget.selectedClass));
                    } else if (indexGlobal == 2) {
                      _ocrBloc.add(
                          FatchSubjectDetails(type: 'nyc', keyword: keyword));
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                actions: [
                  Container(
                      padding: EdgeInsets.only(right: 10),
                      child: IconButton(
                        icon: Icon(
                          IconData(0xe874,
                              fontFamily: Overrides.kFontFam,
                              fontPackage: Overrides.kFontPkg),
                          color: AppTheme.kButtonColor,
                          size: 30,
                        ),
                        onPressed: () {
                          _onHomePressed();
                        },
                      )),
                ],
              ),
              body: Container(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.85
                        : MediaQuery.of(context).size.width * 0.80,
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),

                  children: [
                    SpacerWidget(_KVertcalSpace * 0.50),
                    Utility.textWidget(
                        text: indexGlobal == 0
                            ? 'Subject'
                            : indexGlobal == 1
                                ? 'Learning Standard'
                                : 'Learning Sub Standard',
                        context: context),
                    SpacerWidget(_KVertcalSpace / 3.5),
                    _buildSearchbar(
                        controller: searchController,
                        onSaved: (String value) {
                          if (searchController.text.isEmpty) {
                            // ignore: unnecessary_statements
                            indexGlobal == 0
                                ? fatchList(classNo: widget.selectedClass!)
                                : null;
                            _ocrBloc.add(FatchSubjectDetails(
                                type: indexGlobal == 0
                                    ? 'subject'
                                    : indexGlobal == 1
                                        ? 'nyc'
                                        : 'nycSub',
                                keyword: indexGlobal == 0
                                    ? widget.selectedClass
                                    : indexGlobal == 1
                                        ? keyword
                                        : keywordSub));
                          } else {
                            _debouncer.run(() async {
                              indexGlobal == 0
                                  ? searchList(
                                      classNo: widget.selectedClass!,
                                      // ignore: unnecessary_statements
                                      searchKeyword: searchController.text)
                                  : null;

                              _ocrBloc.add(SearchSubjectDetails(
                                  searchKeyword: searchController.text,
                                  type: indexGlobal == 0
                                      ? 'subject'
                                      : indexGlobal == 1
                                          ? 'nyc'
                                          : 'nycSub',
                                  keyword: indexGlobal == 0
                                      ? widget.selectedClass
                                      : indexGlobal == 1
                                          ? keyword
                                          : keywordSub));
                              setState(() {});
                            });
                          }
                        }),
                    SpacerWidget(_KVertcalSpace / 4),
                    BlocBuilder<OcrBloc, OcrState>(
                        bloc: _ocrBloc,
                        builder: (context, state) {
                          if (state is OcrLoading) {
                            return loadingPage();
                          }
                          if (state is SubjectDataSuccess) {
                            indexGlobal = 0;
                            return gridButton(list: state.obj!, page: 1);
                          } else if (state is NycDataSuccess) {
                            indexGlobal = 1;
                            return gridButton(list: state.obj, page: 2);
                          } else if (state is NycSubDataSuccess) {
                            indexGlobal = 2;
                            return listButton(list: state.obj!);
                          } else if (state is SearchSubjectDetailsSuccess) {
                            List<SubjectDetailList> list = [];
                            if (indexGlobal == 0) {
                              for (int i = 0; i < state.obj!.length; i++) {
                                if (state.obj![i].subjectNameC!
                                    .toUpperCase()
                                    .contains(
                                        searchController.text.toUpperCase())) {
                                  list.add(state.obj![i]);
                                }
                              }
                            } else if (indexGlobal == 1) {
                              for (int i = 0; i < state.obj!.length; i++) {
                                if (state.obj![i].domainNameC!
                                    .toUpperCase()
                                    .contains(
                                        searchController.text.toUpperCase())) {
                                  list.add(state.obj![i]);
                                }
                              }
                            } else if (indexGlobal == 2) {
                              for (int i = 0; i < state.obj!.length; i++) {
                                if (state.obj![i].descriptionC!
                                    .toUpperCase()
                                    .contains(
                                        searchController.text.toUpperCase())) {
                                  list.add(state.obj![i]);
                                }
                              }
                            }

                            return indexGlobal == 0
                                ? gridButton(list: list, page: 1)
                                : indexGlobal == 1
                                    ? gridButton(list: list, page: 2)
                                    : listButton(list: list);
                          }
                          return Container();
                          // return widget here based on BlocA's state
                        }),
                    BlocListener(
                      bloc: _ocrBloc,
                      listener: (context, state) {
                        if (state is SubjectDataSuccess) {
                          setState(() {
                            indexGlobal = 0;
                          });
                        } else if (state is NycDataSuccess) {
                          setState(() {
                            indexGlobal = 1;
                          });
                        } else if (state is NycSubDataSuccess) {
                          setState(() {
                            indexGlobal = 2;
                          });
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

  Widget secondPage({required List<SubjectDetailList> list}) {
    return gridButton(list: list, page: 2);
  }

  Widget loadingPage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.kButtonColor,
        ),
      ),
    );
  }

  Widget listButton({required List<SubjectDetailList> list}) {
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
                  if (indexGlobal == 2) {
                    setState(() {
                      nycSubIndex = index;
                    });
                  }
                },
                child: AnimatedContainer(
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: (nycSubIndex == index && indexGlobal == 2)
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
                        text: list[index].descriptionC!,
                        textTheme: Theme.of(context).textTheme.headline2,
                        context: context),
                    decoration: BoxDecoration(
                        color: Color(0xff000000) !=
                                Theme.of(context).backgroundColor
                            ? Color(0xffF7F8F9)
                            : Color(0xff111C20),
                        border: Border.all(
                          color: (nycSubIndex == index && indexGlobal == 2)
                              ? AppTheme.kSelectedColor
                              : Colors.grey,
                        ),
                        // color: scoringColor == index ? Colors.orange : null,
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
  }

  Widget progressIndicatorBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: AnimatedContainer(
            duration: Duration(seconds: 5),
            curve: Curves.easeOutExpo,
            child: LinearProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(AppTheme.kButtonColor),
              backgroundColor:
                  Color(0xff000000) != Theme.of(context).backgroundColor
                      ? Color.fromRGBO(0, 0, 0, 0.1)
                      : Color.fromRGBO(255, 255, 255, 0.16),
              minHeight: 15.0,
              value: indexGlobal == 0
                  ? 0.33
                  : indexGlobal == 1
                      ? 0.66
                      : 1,
            ),
          ),
        ),
      ),
    );
  }

  // Widget subjectPage({required List<SubjectDetailList> list}) {
  //   return gridButton(list: list, page: 1);
  // }

  Widget gridButton({required List<SubjectDetailList> list, int? page}) {
    // return Bouncing(child: Container(color: Colors.blue, height: 200, width: 200));
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.62
          : MediaQuery.of(context).size.width * 0.30,
      width: MediaQuery.of(context).size.width * 0.9,
      child: GridView.builder(
          // physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              childAspectRatio: 5 / 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15),
          itemCount: page == 2
              ? list.length
              : list.length + 1 + userAddedSubjectList.length,
          itemBuilder: (BuildContext ctx, index) {
            return page == 2 ||
                    (page == 1 &&
                        index < list.length + userAddedSubjectList.length)
                ? Bouncing(
                    onPress: () {
                      searchController.clear();
                      FocusManager.instance.primaryFocus?.unfocus();

                      if (indexGlobal == 0) {
                        setState(() {
                          subjectIndex = index;
                        });
                        if (index < list.length) {
                          keyword = list[index].subjectNameC;
                          _ocrBloc.add(FatchSubjectDetails(
                              type: 'nyc', keyword: keyword));
                        }
                      } else if (indexGlobal == 1) {
                        setState(() {
                          nycIndex = index;
                        });
                        if (index < list.length) {
                          keywordSub = list[index].domainNameC;
                          _ocrBloc.add(FatchSubjectDetails(
                              type: 'nycSub', keyword: keywordSub));
                        }
                      } else if (indexGlobal == 1) {
                        setState(() {
                          nycSubIndex = index;
                        });
                      }
                    },
                    child: Container(
                      child: AnimatedContainer(
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: (subjectIndex == index && indexGlobal == 0) ||
                                  (nycIndex == index && indexGlobal == 1)
                              ? AppTheme.kSelectedColor
                              : Colors.grey,
                          // Theme.of(context)
                          //     .colorScheme
                          //     .background.withOpacity(0.2), // indexColor == index + 1 ? AppTheme.kSelectedColor : null,

                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        duration: Duration(microseconds: 100),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          child: Utility.textWidget(
                              text: page == 1 && index < list.length
                                  ? list[index].subjectNameC!
                                  : page == 2
                                      ? list[index].domainNameC!
                                      : userAddedSubjectList[
                                          index - list.length],
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
                                color: (subjectIndex == index &&
                                            indexGlobal == 0) ||
                                        (nycIndex == index && indexGlobal == 1)
                                    ? AppTheme.kSelectedColor
                                    : Colors.grey,
                              ),
                              // color: scoringColor == index ? Colors.orange : null,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  )
                : Bouncing(
                    onPress: () {
                      if (indexGlobal == 0) {
                        setState(() {
                          subjectIndex = index;
                        });
                      }
                      showBottomSheet();
                    },
                    child: Container(
                      child: AnimatedContainer(
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: (subjectIndex == index && indexGlobal == 0)
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
                                color:
                                    (subjectIndex == index && indexGlobal == 0)
                                        ? AppTheme.kSelectedColor
                                        : Colors.grey,
                              ),
                              // color: scoringColor == index ? Colors.orange : null,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  );
          }),
    );
  }

  Widget textFormField(
      {required TextEditingController controller, required onSaved}) {
    return TextFormField(
      autofocus: true,
      //
      textAlign: TextAlign.start,
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primaryVariant,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.kButtonColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme
                .kButtonColor, // Theme.of(context).colorScheme.primaryVariant,
          ),
        ),
        contentPadding: EdgeInsets.only(top: 10, bottom: 10),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.kButtonColor,
          ),
        ),
      ),
      onChanged: onSaved,
    );
  }

  Widget _buildSearchbar(
      {required TextEditingController controller, required onSaved}) {
    return SizedBox(
      height: 55,
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        //  padding: EdgeInsets.symmetric(
        //      vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing / 2),
        child: TranslationWidget(
            message: 'Search',
            fromLanguage: "en",
            toLanguage: Globals.selectedLanguage,
            builder: (translatedMessage) {
              return TextFormField(
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryVariant),
                //  focusNode: myFocusNode,
                controller: controller,
                cursorColor: Theme.of(context).colorScheme.primaryVariant,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      )),
                  hintText: translatedMessage.toString(),
                  hintStyle: TextStyle(color: Color(0xffAAAAAA), fontSize: 15),
                  fillColor:
                      Color(0xff000000) != Theme.of(context).backgroundColor
                          ? Color.fromRGBO(0, 0, 0, 0.1)
                          : Color.fromRGBO(255, 255, 255, 0.16),
                  prefixIcon: Icon(
                    const IconData(0xe805,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: Color(0xffAAAAAA),
                    size: Globals.deviceType == "phone" ? 18 : 16,
                  ),
                  suffixIcon: controller.text.isEmpty
                      ? null
                      : InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.clear,
                            color: Theme.of(context).colorScheme.primaryVariant,
                            size: Globals.deviceType == "phone" ? 20 : 28,
                          ),
                        ),
                ),
                onChanged: onSaved,
              );
            }),
      ),
    );
  }

  Widget textActionButton() {
    return FloatingActionButton.extended(
        backgroundColor:
            AppTheme.kButtonColor.withOpacity(nycSubIndex == null ? 0.5 : 1.0),
        onPressed: () async {
          if (nycSubIndex == null) return;
          print(Globals.studentInfo!);
          _googleDriveBloc
              .add(UpdateDocOnDrive(studentData: Globals.studentInfo!));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultsSummary()),
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
                    .copyWith(color: Theme.of(context).backgroundColor)),
          ],
        ));
  }

  _onHomePressed() {
    return showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Center(
                  child: Container(
                    padding: Globals.deviceType == 'phone'
                        ? null
                        : const EdgeInsets.only(top: 10.0),
                    height: Globals.deviceType == 'phone'
                        ? null
                        : orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.height / 15
                            : MediaQuery.of(context).size.width / 15,
                    width: Globals.deviceType == 'phone'
                        ? null
                        : orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.height / 2,
                    child: TranslationWidget(
                        message:
                            "you are about to lose scanned assessment sheet",
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) {
                          return Text(translatedMessage.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(color: Colors.black));
                        }),
                  ),
                ),
                actions: <Widget>[
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.height,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        child: TranslationWidget(
                            message: "No",
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) {
                              return Text(translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: AppTheme.kButtonColor,
                                      ));
                            }),
                        onPressed: () {
                          //Globals.iscameraPopup = false;
                          Navigator.pop(context, false);
                        },
                      ),
                      TextButton(
                        child: TranslationWidget(
                            message: "Yes ",
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) {
                              return Text(translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: AppTheme.kButtonColor,
                                      ));
                            }),
                        onPressed: () {
                          //Globals.iscameraPopup = false;
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (_) => false);
                        },
                      ),
                    ],
                  )
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              );
            }));
  }

  Future<void> updateList(
      {required String subjectName, required String classNo}) async {
    LocalDatabase<String> _localDb = LocalDatabase('Subject_list$classNo');
    List<String>? _localData = await _localDb.getData();
    _localData.add(subjectName);
    // setState(() {
    //   userAddedSubjectList = _localData;
    // });
    await _localDb.clear();
    _localData.forEach((String e) {
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

  Future<void> fatchList({required String classNo}) async {
    LocalDatabase<String> _localDb = LocalDatabase('Subject_list$classNo');
    List<String>? _localData = await _localDb.getData();
    userAddedSubjectList = _localData;
    _ocrBloc.add(
        FatchSubjectDetails(type: 'subject', keyword: widget.selectedClass));
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
                child: textFormField(
                    controller: addController, onSaved: (String value) {}),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: FloatingActionButton.extended(
                    backgroundColor: AppTheme.kButtonColor
                        .withOpacity(nycSubIndex == null ? 0.5 : 1.0),
                    onPressed: () async {
                      await updateList(
                          subjectName: addController.text,
                          classNo: widget.selectedClass!);

                      Navigator.pop(context, false);
                      await fatchList(classNo: widget.selectedClass!);
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
