import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/subject_list_modal.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassDetails extends StatefulWidget {
  ClassDetails({Key? key}) : super(key: key);

  @override
  State<ClassDetails> createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> {
  static const double _KVertcalSpace = 60.0;
  final searchController = TextEditingController();
  int indexGlobal = 0;
  OcrBloc _ocrBloc = OcrBloc();
  @override
  void initState() {
    _ocrBloc.add(FatchSubjectDetails(type: 'subject'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
      ),
      body: Column(
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
          // changePages(),
          progressIndicatorBar(),
        ],
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

  Widget secondPage({required List<SubjectList> list}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).size.height * 0.72,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        highlightText(text: 'Learning Standard'),
        SpacerWidget(_KVertcalSpace / 4),
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
      height: MediaQuery.of(context).size.height * 0.72,
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
      height: MediaQuery.of(context).size.height * 0.72,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        highlightText(text: 'Learning Standard'),
        SpacerWidget(_KVertcalSpace / 4),
        _buildSearchbar(
            controller: searchController, onSaved: (String value) {}),
        SpacerWidget(_KVertcalSpace / 4),
        detailsList(list: list),
        // scoringButton(list: Globals.subjectDetailsList),
      ]),
    );
  }

  Widget detailsList({required List<SubjectList> list}) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.55
          : MediaQuery.of(context).size.width * 0.55,
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
            },
            child: Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              child: textwidget(
                text: list[index].subjectNameC!,
                textTheme: Theme.of(context).textTheme.headline2,
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primaryVariant,
                  ),
                  // color: scoringColor == index ? Colors.orange : null,
                  borderRadius: BorderRadius.circular(15)),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SpacerWidget(_KVertcalSpace / 3);
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
              color: Colors.green,
             // border: Border(left: BorderSide(color: Colors.black)),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15))
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 20,
            decoration: BoxDecoration(
              color: indexGlobal == 1 || indexGlobal == 2
                  ? Colors.green
                  : Colors.grey,
              // border: Border(left: BorderSide(color: Colors.black)),
              // borderRadius: BorderRadius.circular(15)
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 20,
            decoration: BoxDecoration(
              color: indexGlobal == 2
                  ? Colors.green
                  :Colors.grey,
            //  border: Border(left: BorderSide(color: Colors.black)),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15))
            ),
          )
        ],
      ),
    );
  }

  Widget subjectPage({required List<SubjectList> list}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).size.height * 0.72,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        highlightText(text: 'Subject'),
        SpacerWidget(_KVertcalSpace / 4),
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
          ? MediaQuery.of(context).size.height * 0.55
          : MediaQuery.of(context).size.width * 0.55,
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
                  _ocrBloc.add(FatchSubjectDetails(type: 'nyc'));
                } else if (indexGlobal == 1) {
                  _ocrBloc.add(FatchSubjectDetails(type: 'nycSub'));
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: textwidget(
                  text: list[index].subjectNameC!,
                  textTheme: Theme.of(context).textTheme.headline2,
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ),
                    // color: scoringColor == index ? Colors.orange : null,
                    borderRadius: BorderRadius.circular(15)),
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

  Widget highlightText({required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: TranslationWidget(
        message: text,
        toLanguage: Globals.selectedLanguage,
        fromLanguage: "en",
        builder: (translatedMessage) => Text(
          translatedMessage.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
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
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primaryVariant,
                        width: 2),
                  ),
                  hintText: translatedMessage.toString(),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  prefixIcon: Icon(
                    const IconData(0xe805,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: Theme.of(context).colorScheme.primaryVariant,
                    size: Globals.deviceType == "phone" ? 20 : 28,
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
}
