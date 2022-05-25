import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/ui/subject_selection.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class CreateAssessment extends StatefulWidget {
  const CreateAssessment({Key? key}) : super(key: key);

  @override
  State<CreateAssessment> createState() => _CreateAssessmentState();
}

class _CreateAssessmentState extends State<CreateAssessment>
    with SingleTickerProviderStateMixin {
  static const double _KVertcalSpace = 60.0;
  final assessmentController = TextEditingController(text: 'Version_0.01');
  final classController = TextEditingController(text: '11th');
  double? _scale;
  AnimationController? _controller;
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  int scoringColor = 0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller!.value;

    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          CommonBackGroundImgWidget(),
          Scaffold(
            floatingActionButton: textActionButton(),
            // floatingActionButtonLocation:
            //   FloatingActionButtonLocation.centerFloat,
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
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
            body: ListView(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.9
                        : MediaQuery.of(context).size.width,
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
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
                        theme: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryVariant
                                .withOpacity(0.3))),
                    textFormField(
                        controller: assessmentController,
                        onSaved: (String value) {}),
                    SpacerWidget(_KVertcalSpace / 2),
                    highlightText(
                        text: 'Class Name',
                        theme: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryVariant
                                .withOpacity(0.3))),
                    textFormField(
                        controller: classController,
                        onSaved: (String value) {}),

                    SpacerWidget(_KVertcalSpace / 0.90),
                    scoringButton(),
                    SpacerWidget(_KVertcalSpace / 20),
                    // textActionButton()
                    // smallButton(),
                    // SpacerWidget(_KVertcalSpace / 2),

                    // SpacerWidget(_KVertcalSpace / 4),
                    // scoringButton(),
                    // // SpacerWidget(_KVertcalSpace / 8),
                    // cameraButton(),
                  ],
                ),
              ),
            ]),
            // bottomNavigationBar: null,
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
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.35
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
            return GestureDetector(
              onTap: () {
                setState(() {
                  scoringColor = index;
                });
              },
              onTapDown: _tapDown,
              onTapUp: _tapUp,
              child: Transform.scale(
                scale: _scale!,
                child: AnimatedContainer(
                  duration: Duration(microseconds: 100),
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scoringColor == index
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
                          color: scoringColor == index
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
                                color: scoringColor == index
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
      {required TextEditingController controller, required onSaved}) {
    return TextFormField(
      //
      textAlign: TextAlign.start,
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(fontWeight: FontWeight.bold),
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primaryVariant,
      decoration: InputDecoration(
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
    );
  }

  Widget textActionButton() {
    return FloatingActionButton.extended(
        backgroundColor: AppTheme.kButtonColor,
        onPressed: () async {
          Globals.assessmentName =
              "${assessmentController.text}_${classController.text}";
          print(Globals.assessmentName);
          _googleDriveBloc.add(CreateExcelSheetToDrive(
              name: "${assessmentController.text}_${classController.text}"));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubjectSelection()),
          );
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
  }

  void _tapDown(TapDownDetails details) {
    _controller!.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller!.reverse();
  }
}
