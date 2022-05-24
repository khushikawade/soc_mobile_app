import 'dart:convert';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/ocr/ui/camera_screen.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'assessment_summary.dart';

class OpticalCharacterRecognition extends StatefulWidget {
  const OpticalCharacterRecognition({Key? key}) : super(key: key);

  @override
  State<OpticalCharacterRecognition> createState() =>
      _OpticalCharacterRecognitionPageState();
}

class _OpticalCharacterRecognitionPageState
    extends State<OpticalCharacterRecognition> {
  static const double _KVertcalSpace = 60.0;
  final assessmentController = TextEditingController();
  final classController = TextEditingController();
  // OcrBloc _bloc = OcrBloc();
  int indexColor = 2;
  int scoringColor = 0;
  final HomeBloc _homeBloc = new HomeBloc();
  File? myImagePath;
  String pathOfImage = '';

  @override
  void initState() {
    Globals.gradeList.clear();
    _homeBloc.add(FetchStandardNavigationBar());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          CommonBackGroundImgWidget(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
              isBackButton: false,
            ),
            body: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  // height:
                  //     MediaQuery.of(context).orientation == Orientation.portrait
                  //         ? MediaQuery.of(context).size.height
                  //         : MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Utility.textWidget(
                          text: 'Points Possible',
                          context: context,
                          textTheme: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontWeight: FontWeight.bold)),
                      SpacerWidget(_KVertcalSpace / 4),
                      smallButton(),
                      SpacerWidget(_KVertcalSpace / 2),
                      Utility.textWidget(
                          text: 'Scoring Rubric',
                          context: context,
                          textTheme: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontWeight: FontWeight.bold)),
                      SpacerWidget(_KVertcalSpace / 4),
                      scoringRubric(),
                      Container(
                        height: 0,
                        width: 0,
                        child: BlocListener<HomeBloc, HomeState>(
                            bloc: _homeBloc,
                            listener: (context, state) async {
                              if (state is BottomNavigationBarSuccess) {
                                AppTheme.setDynamicTheme(
                                    Globals.appSetting, context);
                                Globals.appSetting =
                                    AppSetting.fromJson(state.obj);
                                setState(() {});
                              }
                            },
                            child: EmptyContainer()),
                      ),
                    ],
                  ),
                )
              ],
            ),
            floatingActionButton: scanButton(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        ],
      ),
    );
  }

  Widget scanButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
            backgroundColor: AppTheme.kButtonColor,
            onPressed: () async {
              Globals.studentInfo = [];
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraScreen()),
              );
            },
            icon: Icon(
                IconData(0xe875,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: Theme.of(context).backgroundColor,
                size: 16),
            label: Utility.textWidget(
                text: 'Start Scanning',
                context: context,
                textTheme: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Theme.of(context).backgroundColor))),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AssessmentSummary()),
            );
          },
          child: Container(
              padding: EdgeInsets.only(top: 10),
              // color: Colors.red,
              child: Utility.textWidget(
                  text: 'History Assessment',
                  context: context,
                  textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                        decoration: TextDecoration.underline,
                      ))),
        ),
      ],
    );
  }

  Widget smallButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 70,
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: Globals.icons
            .map<Widget>(
                (element) => pointsButton(Globals.icons.indexOf(element)))
            .toList(),
      ),
    );
  }

  Widget pointsButton(index) {
    return InkWell(
        onTap: () {
          Globals.pointpossible = "${index + 1}";
          setState(() {
            indexColor = index + 1;
            if (index == 1) {
              scoringColor = 0;
            } else if (index == 2) {
              scoringColor = 2;
            } else if (index == 3) {
              scoringColor = 4;
            }
          });
        },
        child: AnimatedContainer(
          padding: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color:
                indexColor == index + 1 ? AppTheme.kSelectedColor : Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          duration: Duration(microseconds: 100),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Color(0xff000000) != Theme.of(context).backgroundColor
                    ? Color(0xffF7F8F9)
                    : Color(0xff111C20),
                border: Border.all(
                  color: indexColor == index + 1
                      ? AppTheme.kSelectedColor
                      : Colors.grey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: TranslationWidget(
                message: '${index + 1}',
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: indexColor == index + 1
                            ? AppTheme.kSelectedColor
                            : Theme.of(context).colorScheme.primaryVariant,
                      ),
                ),
              )),
        ));
  }

  Widget scoringRubric() {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.45
          : MediaQuery.of(context).size.width * 0.30,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 70,
              right: MediaQuery.of(context).size.width / 70),
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.height * 0.5,
              childAspectRatio: 6 / 3.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 20),
          itemCount: Globals.scoringList.length,
          itemBuilder: (BuildContext ctx, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  scoringColor = index;
                });
              },
              child: AnimatedContainer(
                padding: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: scoringColor == index
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
                  // width:Globals.scoringList.length -1 == index ? MediaQuery.of(context).size.width: null,
                  alignment: Alignment.center,
                  child: Utility.textWidget(
                    text: Globals.scoringList[index],
                    context: context,
                    textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: scoringColor == index
                            ? AppTheme.kSelectedColor
                            : Theme.of(context).colorScheme.primaryVariant),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: scoringColor == index
                            ? AppTheme.kSelectedColor
                            : Colors.grey,
                      ),
                      color:
                          Color(0xff000000) != Theme.of(context).backgroundColor
                              ? Color(0xffF7F8F9)
                              : Color(0xff111C20),
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            );
          }),
    );
  }

  void getGallaryImage() async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    final bytes = File(image!.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    setState(() {
      myImagePath = File(image.path);
      // isLoading2 = false;
      pathOfImage = image.path.toString();
    });

    if (myImagePath != null) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => SuccessScreen(
      //             img64: img64,
      //             imgPath: myImagePath,
      //           )),
      // );

      //_bloc.add(FetchTextFromImage(base64: img64));
    }
    // reconizeText(pathOfImage);
  }
}
