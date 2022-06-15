import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/ui/subject_selection.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CreateAssessment extends StatefulWidget {
  const CreateAssessment({Key? key}) : super(key: key);

  @override
  State<CreateAssessment> createState() => _CreateAssessmentState();
}

class _CreateAssessmentState extends State<CreateAssessment>
    with SingleTickerProviderStateMixin {
  static const double _KVertcalSpace = 60.0;
  final assessmentController = TextEditingController();
  final classController = TextEditingController();
  // int selectedGrade.value = 0;
  final _formKey = GlobalKey<FormState>();
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  // final ScrollController listScrollController = ScrollController();
  final ValueNotifier<int> selectedGrade = ValueNotifier<int>(0);
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);

  @override
  void initState() {
    // listScrollController.addListener(_scrollListener);
    Globals.googleExcelSheetId = '';
    super.initState();
  }

  // _scrollListener() {
  //   FocusScope.of(context).requestFocus(FocusNode());
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          CommonBackGroundImgWidget(),
          Scaffold(
            resizeToAvoidBottomInset: true,
            floatingActionButton: textActionButton(),
            // floatingActionButtonLocation:
            //   FloatingActionButtonLocation.centerFloat,
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
              isbackOnSuccess: isBackFromCamera,
              key: GlobalKey(),
              isBackButton: false,
              isHomeButtonPopup: true,
            ),
            // AppBar(
            //   elevation: 0,
            //   automaticallyImplyLeading: false,
            //   actions: [
            //     Container(
            //       padding: EdgeInsets.only(right: 10),
            //       child: Icon(
            //         IconData(0xe874,
            //             fontFamily: Overrides.kFontFam,
            //             fontPackage: Overrides.kFontPkg),
            //         color: AppTheme.kButtonColor,
            //       ),
            //     ),
            //   ],
            // ),
            //  CustomAppBarWidget(
            //   appBarTitle: 'OCR',
            //   isSearch: true,
            //   isShare: false,
            //   language: Globals.selectedLanguage,
            //   isCenterIcon: false,
            //   ishtmlpage: false,
            //   sharedpopBodytext: '',
            //   sharedpopUpheaderText: '',
            // ),
            body: Form(
              key: _formKey,
              child: ListView(children: [
                Container(
                  // color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.7
                          : MediaQuery.of(context).size.width,
                  child: ListView(
                    // controller: listScrollController,
                    shrinkWrap: true,
                    children: [
                      SpacerWidget(_KVertcalSpace * 0.50),
                      highlightText(
                        text: 'Create Assessment',
                        theme: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SpacerWidget(_KVertcalSpace / 1.8),
                      highlightText(
                          text: 'Assessment Name',
                          theme: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant
                                      .withOpacity(0.3))),
                      textFormField(
                          controller: assessmentController,
                          hintText: 'Assessment Name',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Assessment name is required';
                            } else if (value.length < 2) {
                              return 'Assessment name should contain atlease 2 characters';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (String value) {}),
                      SpacerWidget(_KVertcalSpace / 2),
                      highlightText(
                          text: 'Class Name',
                          theme: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant
                                      .withOpacity(0.3))),
                      textFormField(
                        controller: classController,
                        hintText: '1st',
                        onSaved: (String value) {},
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Class name is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SpacerWidget(_KVertcalSpace / 0.90),
                      scoringButton(),
                      // SpacerWidget(_KVertcalSpace / 20),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
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

  Widget scoringButton() {
    return ValueListenableBuilder(
        valueListenable: selectedGrade,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return Container(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.45
                : MediaQuery.of(context).size.width * 0.35,
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 50,
                    childAspectRatio: 5 / 6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 10),
                itemCount: Globals.classList.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Bouncing(
                    onPress: () {
                      selectedGrade.value = index;
                    },
                    child: Transform.scale(
                      scale: 1, //_scale!,
                      child: AnimatedContainer(
                        duration: Duration(microseconds: 10),
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedGrade.value == index
                              ? AppTheme.kSelectedColor
                              : Colors.grey,
                        ),
                        child: new Container(
                          decoration: BoxDecoration(
                              color: Color(0xff000000) !=
                                      Theme.of(context).backgroundColor
                                  ? Color(0xffF7F8F9)
                                  : Color(0xff111C20),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedGrade.value == index
                                    ? AppTheme.kSelectedColor
                                    : Colors.grey,
                              )),
                          child: Center(
                            child: textwidget(
                              text: Globals.classList[index],
                              textTheme: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                      color: selectedGrade.value == index
                                          ? AppTheme.kSelectedColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .primaryVariant),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
  }

  Widget highlightText({required String text, required theme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        maxLines: 2,
        //overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: theme,
      ),
    );
  }

  Widget textFormField(
      {required TextEditingController controller,
      required onSaved,
      required hintText,
      required validator}) {
    return TextFormField(
      //
      autovalidateMode: AutovalidateMode.always,
      textAlign: TextAlign.start,
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(fontWeight: FontWeight.bold),
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primaryVariant,
      decoration: InputDecoration(
        hintText: hintText,
        errorMaxLines: 2,
        hintStyle: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
        fillColor: Colors.transparent,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color:
                Theme.of(context).colorScheme.primaryVariant.withOpacity(0.5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primaryVariant.withOpacity(
                  0.5) // Theme.of(context).colorScheme.primaryVariant,
              ),
        ),
        contentPadding: EdgeInsets.only(top: 10, bottom: 10),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color:
                Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3),
          ),
        ),
      ),
      onChanged: onSaved,
      validator: validator,
    );
  }

  Widget textActionButton() {
    return OfflineBuilder(
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        final bool connected = connectivity != ConnectivityResult.none;
        return FloatingActionButton.extended(
            backgroundColor: AppTheme.kButtonColor,
            onPressed: () async {
              if (!connected) {
                Utility.noInternetSnackBar();
              } else {
                if (_formKey.currentState!.validate()) {
                  Globals.assessmentName =
                      "${assessmentController.text}_${classController.text}";

                  //Create excel sheet if not created already for current assessment
                  Globals.googleExcelSheetId!.isEmpty
                      ? _googleDriveBloc.add(CreateExcelSheetToDrive(
                          name:
                              "${assessmentController.text}_${classController.text}"))
                      : print("file is already exists on drive ");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubjectSelection(
                              selectedClass: selectedGrade.value.toString(),
                            )),
                  );
                }
              }
            },
            label: Row(
              children: [
                textwidget(
                    text: 'Next',
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Theme.of(context).backgroundColor)),
                SpacerWidget(5),
                RotatedBox(
                  quarterTurns: 90,
                  child: Icon(Icons.arrow_back,
                      color: Theme.of(context).backgroundColor, size: 20),
                )
              ],
            ));
      },
      child: Container(),
    );
  }
}
