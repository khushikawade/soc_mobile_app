import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
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
  SubjectSelection({Key? key}) : super(key: key);

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
  OcrBloc _ocrBloc = OcrBloc();
  @override
  void initState() {
    _ocrBloc.add(FatchSubjectDetails(type: 'subject'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackGroundImgWidget(),
        Scaffold(
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
                  _ocrBloc.add(FatchSubjectDetails(type: 'subject'));
                } else if (indexGlobal == 2) {
                  _ocrBloc.add(FatchSubjectDetails(type: 'nyc'));
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
                    onPressed: () {},
                  )),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                progressIndicatorBar(),
              ],
            ),
          ),
        ),
      ],
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

  Widget secondPage({required List<SubjectList> list}) {
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
        scoringButton(list: list),
      ]),
    );
  }

  Widget loadingPage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget thirdPage({required List<SubjectList> list}) {
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
        textActionButton(),
        // scoringButton(list: Globals.subjectDetailsList),
      ]),
    );
  }

  Widget detailsList({required List<SubjectList> list}) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.56
          : MediaQuery.of(context).size.width * 0.50,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
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
            child: AnimatedContainer(
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
                alignment: Alignment.center,
                child: textwidget(
                  text: list[index].subjectNameC!,
                  textTheme: Theme.of(context).textTheme.headline2,
                ),
                decoration: BoxDecoration(
                    color:
                        Color(0xff000000) != Theme.of(context).backgroundColor
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
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SpacerWidget(_KVertcalSpace / 3.75);
        },
      ),
    );
  }

  Widget progressIndicatorBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.912,
      height: 15,
      // decoration: BoxDecoration(
      //      color: Colors.grey,
      //     border: Border.all(color: Colors.black, width: 2),
      //     borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 20,
            decoration: BoxDecoration(
                color: AppTheme.kButtonColor,
                // border: Border(left: BorderSide(color: Colors.black)),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15))),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 20,
            decoration: BoxDecoration(
              color: indexGlobal == 1 || indexGlobal == 2
                  ? AppTheme.kButtonColor
                  : Colors.grey,
              // border: Border(left: BorderSide(color: Colors.black)),
              // borderRadius: BorderRadius.circular(15)
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 20,
            decoration: BoxDecoration(
                color: indexGlobal == 2 ? AppTheme.kButtonColor : Colors.grey,
                //  border: Border(left: BorderSide(color: Colors.black)),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
          )
        ],
      ),
    );
  }

  Widget subjectPage({required List<SubjectList> list}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.85
          : MediaQuery.of(context).size.width * 0.50,
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

  Widget scoringButton({required List<SubjectList> list}) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.60
          : MediaQuery.of(context).size.width * 0.30,
      width: MediaQuery.of(context).size.width * 0.9,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
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
                  _ocrBloc.add(FatchSubjectDetails(type: 'nyc'));
                } else if (indexGlobal == 1) {
                  setState(() {
                    nycIndex = index;
                  });
                  _ocrBloc.add(FatchSubjectDetails(type: 'nycSub'));
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
                  alignment: Alignment.center,
                  child: textwidget(
                    text: list[index].subjectNameC!,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(fontWeight: FontWeight.bold),
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultsSummary()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.kButtonColor,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        height: 54,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Center(
          child: highlightText(
            text: 'Next',
            theme: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
