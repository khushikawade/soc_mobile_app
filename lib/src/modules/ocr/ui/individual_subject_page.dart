import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/subject_details_modal.dart';
import 'package:Soc/src/modules/ocr/ui/subject_selection.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndividualSubjectPage extends StatefulWidget {
  final String questionimageUrl;
  final String selectedClass;
  const IndividualSubjectPage(
      {Key? key, required this.questionimageUrl, required this.selectedClass})
      : super(key: key);

  @override
  State<IndividualSubjectPage> createState() => _IndividualSubjectPageState();
}

class _IndividualSubjectPageState extends State<IndividualSubjectPage> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(-1);
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  OcrBloc _ocrBloc = OcrBloc();
  List<String> subjectList = [
    'Common Core',
    'NY Next Generation Learning Standard'
  ];

  final double _KVertcalSpace = 60.0;

  @override
  void dispose() {
    _ocrBloc.close();
    super.dispose();
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
              // bottomNavigationBar: progressIndicatorBar(),
              //   floatingActionButton: submitAssessmentButton(),
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

                      Navigator.pop(context);
                    }),
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
                    SpacerWidget(_KVertcalSpace / 3.5),
                    Utility.textWidget(
                      context: context,
                      text: 'Select Standards',
                      // textTheme: Theme.of(context).textTheme.headline1
                    ),
                    SpacerWidget(_KVertcalSpace / 4),
                    SpacerWidget(_KVertcalSpace / 4),
                    ValueListenableBuilder(
                      valueListenable: selectedIndex,
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        return buttonListWidget(list: subjectList);
                      },
                      child: Container(),
                    ),
                    BlocListener(
                      bloc: _ocrBloc,
                      listener: (context, state) async {
                        if (state is OcrLoading) {
                          //  Utility.showLoadingDialog(context, true);
                        } else if (state is SaveSubjectListDetailsSuccess) {
                          Navigator.pop(context);
                          // AnimationController?.dispose();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubjectSelection(
                                      isCommonCore: selectedIndex.value == 0
                                          ? true
                                          : false,
                                      questionimageUrl: widget.questionimageUrl,
                                      selectedClass: widget.selectedClass,
                                    )),
                          );
                        } else if (state is OcrErrorReceived) {
                          Navigator.pop(context);
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

  Widget gridButtonsWidget({required List<String> list}) {
    return Container(
      padding: EdgeInsets.only(bottom: 0),
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.62
          : MediaQuery.of(context).size.width * 0.30,
      width: MediaQuery.of(context).size.width * 0.9,
      child: GridView.builder(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.09),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              childAspectRatio: 5 / 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15),
          itemCount: list.length,
          itemBuilder: (BuildContext ctx, index) {
            return Bouncing(
              // onPress: () {

              // },
              child: InkWell(
                onTap: () async {
                  selectedIndex.value = index;
                  if (index == 0) {
                    _ocrBloc.add(SaveSubjectListDetails(isCommonCore: true));
                  } else {
                    // _ocrBloc.close();
                    _ocrBloc.add(SaveSubjectListDetails(isCommonCore: false));
                  }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => SubjectSelection(
                  //             questionimageUrl: widget.questionimageUrl ?? '',
                  //             selectedClass: widget.selectedClass,
                  //           )),
                  // );
                },
                child: AnimatedContainer(
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: selectedIndex.value == index
                        ? AppTheme.kSelectedColor
                        : Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  duration: Duration(microseconds: 5000),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Utility.textWidget(
                        textAlign: TextAlign.left,
                        text: list[index],
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
                          color: selectedIndex.value == index
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
  }

  Widget buttonListWidget({required List<String> list}) {
    return Container(
      padding: EdgeInsets.only(bottom: 50),
      height: Globals.deviceType == 'phone'
          ? MediaQuery.of(context).size.height * 0.65
          : MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ListView.separated(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
        itemCount: list.length,
        itemBuilder: (BuildContext ctx, index) {
          return Column(children: [
            Bouncing(
              child: InkWell(
                onTap: () {
                  selectedIndex.value = index;
                  if (index == 0) {
                    _ocrBloc.add(SaveSubjectListDetails(isCommonCore: true));
                    Utility.showLoadingDialog(context, true);
                  } else {
                    // _ocrBloc.close();
                    _ocrBloc.add(SaveSubjectListDetails(isCommonCore: false));
                    Utility.showLoadingDialog(context, true);
                  }
                  //print(subLearningStandard);
                },
                child: AnimatedContainer(
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: selectedIndex.value == index
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
                      message: list[index],
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
                                style: Theme.of(context).textTheme.headline2,
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
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ],
                              )
                            : TextSpan(
                                style: Theme.of(context).textTheme.headline2,
                                children: [TextSpan(text: translatedMessage)]),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xff000000) !=
                                Theme.of(context).backgroundColor
                            ? Color(0xffF7F8F9)
                            : Color(0xff111C20),
                        border: Border.all(
                          color: selectedIndex.value == index
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
  }
}
