import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/ocr/modal/subject_list_modal.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/ui/results_summary.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectSelection extends StatefulWidget {
  final String? selectedClass;
  SubjectSelection({Key? key, required this.selectedClass}) : super(key: key);

  @override
  State<SubjectSelection> createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends State<SubjectSelection> {
  static const double _KVertcalSpace = 60.0;
  final searchController = TextEditingController();
  int indexGlobal = 0;
  int? subjectIndex;
  int? nycIndex;
  int? nycSubIndex;
  String? keyword;
  String? keywordSub;
  OcrBloc _ocrBloc = OcrBloc();
  @override
  void initState() {
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
                  onPressed: () {
                    if (indexGlobal == 1) {
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
              body: ListView(
               // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocBuilder<OcrBloc, OcrState>(
                      bloc: _ocrBloc,
                      builder: (context, state) {
                        if (state is OcrLoading) {
                          return loadingPage();
                        }
                        if (state is SubjectDataSuccess) {
                          indexGlobal = 0;
                          return subjectPage(list: state.obj!);
                        } else if (state is NycDataSuccess) {
                          indexGlobal = 1;
                          return secondPage(list: state.obj);
                        } else if (state is NycSubDataSuccess) {
                          indexGlobal = 2;
                          return thirdPage(list: state.obj!);
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
                  //  SpacerWidget(_KVertcalSpace / 4),
                  // changePages(),
                ],
              ),
              bottomNavigationBar: progressIndicatorBar(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget changePages() {
  //   if (indexGlobal == 0) {
  //     return subjectPage();
  //   } else if (indexGlobal == 1) {
  //     return secondPage();
  //   } else {
  //     return Container();
  //   }
  // }

  Widget secondPage({required List<SubjectDetailList> list}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.85
          : MediaQuery.of(context).size.width * 0.50,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SpacerWidget(_KVertcalSpace * 0.50),
        highlightText(text: 'Learning Standard'),
        SpacerWidget(_KVertcalSpace / 2.5),
        _buildSearchbar(
            controller: searchController, onSaved: (String value) {}),
        SpacerWidget(_KVertcalSpace / 4),
        scoringButton(list: list, page: 2),
      ]),
    );
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

  Widget thirdPage({required List<SubjectDetailList> list}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.85
          : MediaQuery.of(context).size.width * 0.80,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SpacerWidget(_KVertcalSpace * 0.50),
        highlightText(text: 'Learning Standard'),
        SpacerWidget(_KVertcalSpace / 2.5),
        _buildSearchbar(
            controller: searchController, onSaved: (String value) {}),
        SpacerWidget(_KVertcalSpace / 4),
        detailsList(list: list),
        // textActionButton(),
        // scoringButton(list: Globals.subjectDetailsList),
      ]),
    );
  }

  Widget detailsList({required List<SubjectDetailList> list}) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.65
          : MediaQuery.of(context).size.width * 0.50,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ListView.separated(
        //physics: NeverScrollableScrollPhysics(),
        // gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        //     maxCrossAxisExtent: 180,
        //     childAspectRatio: 5 / 3,
        //     crossAxisSpacing: 15,
        //     mainAxisSpacing: 15),
        itemCount: list.length,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
              onTap: () {
                // if(indexGlobal == 0){
                //   _ocrBloc.add(FatchSubjectDetails(type: 'nyc'));
                // } else if(indexGlobal == 1){
                //   _ocrBloc.add(FatchSubjectDetails(type: 'nycSub'));
                // }
                if (indexGlobal == 2) {
                  setState(() {
                    nycSubIndex = index;
                  });
                }
              },
              child: Column(children: [
                AnimatedContainer(
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: (nycSubIndex == index && indexGlobal == 2)
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
                    padding: EdgeInsets.all(15),
                    // alignment: Alignment.center,
                    child: textwidget(
                      text: list[index].standardAndDescriptionC!,
                      textTheme: Theme.of(context).textTheme.headline2,
                    ),
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
                index == list.length - 1
                    ? SizedBox(
                        height: 30,
                      )
                    : Container()
              ]));
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
            duration: Duration(seconds: 2),
            curve: Curves.easeOutExpo,
            child: LinearProgressIndicator(
              color: AppTheme.kButtonColor,
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

  Widget subjectPage({required List<SubjectDetailList> list}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.85
          : MediaQuery.of(context).size.width * 0.60,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SpacerWidget(_KVertcalSpace * 0.50),
        highlightText(text: 'Subject'),
        SpacerWidget(_KVertcalSpace / 2.5),
        //   SizedBox(height: 23,),
        _buildSearchbar(
            controller: searchController, onSaved: (String value) {}),
        SpacerWidget(_KVertcalSpace / 4),
        scoringButton(list: list),
      ]),
    );
  }

  Widget scoringButton({required List<SubjectDetailList> list, int? page}) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.65
          : MediaQuery.of(context).size.width * 0.30,
      width: MediaQuery.of(context).size.width * 0.9,
      child: GridView.builder(
          // physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              childAspectRatio: 5 / 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15),
          itemCount: list.length,
          itemBuilder: (BuildContext ctx, index) {
            return InkWell(
              onTap: () {
                if (indexGlobal == 0) {
                  setState(() {
                    subjectIndex = index;
                  });
                  keyword = list[index].subjectNameC;
                  _ocrBloc
                      .add(FatchSubjectDetails(type: 'nyc', keyword: keyword));
                } else if (indexGlobal == 1) {
                  setState(() {
                    nycIndex = index;
                  });
                  keywordSub = list[index].domainNameC;
                  _ocrBloc.add(
                      FatchSubjectDetails(type: 'nycSub', keyword: keywordSub));
                } else if (indexGlobal == 1) {
                  setState(() {
                    nycSubIndex = index;
                  });
                }
              },
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
                  // alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: textwidget(
                      text: page == 2
                          ? list[index].domainNameC!
                          : list[index].subjectNameC!,
                      textTheme: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color:
                          Color(0xff000000) != Theme.of(context).backgroundColor
                              ? Color(0xffF7F8F9)
                              : Color(0xff111C20),
                      border: Border.all(
                        color: (subjectIndex == index && indexGlobal == 0) ||
                                (nycIndex == index && indexGlobal == 1)
                            ? AppTheme.kSelectedColor
                            : Colors.grey,
                      ),
                      // color: scoringColor == index ? Colors.orange : null,
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            );
          }),
    );
  }

  Widget textwidget({required String text, required dynamic textTheme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        style: textTheme,
      ),
    );
  }

  Widget highlightText({required String text, theme}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: TranslationWidget(
        message: text,
        toLanguage: Globals.selectedLanguage,
        fromLanguage: "en",
        builder: (translatedMessage) => Text(
          translatedMessage.toString(),
          textAlign: TextAlign.center,
          style: theme != null
              ? theme
              : Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultsSummary()),
          );
        },
        label: Row(
          children: [
            textwidget(
                text: 'Submit',
                textTheme: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Theme.of(context).backgroundColor)),
            // SpacerWidget(5),
            // RotatedBox(
            //   quarterTurns: 90,
            //   child: Icon(Icons.arrow_back,
            //       color: Theme.of(context).backgroundColor, size: 20),
            // )
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
}
