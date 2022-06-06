import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/custom_rubic_modal.dart';
import 'package:Soc/src/modules/ocr/ui/bottom_sheet_widget.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_pdf_viewer.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/image_popup.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/local_database/local_db.dart';
import '../../../widgets/common_image_widget.dart';
import 'assessment_summary.dart';
import 'camera_screen.dart';
import 'create_assessment.dart';

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
  int indexColor = 1;
  int scoringColor = 0;
  final HomeBloc _homeBloc = new HomeBloc();
  final OcrBloc _bloc = new OcrBloc();
  File? myImagePath;
  String pathOfImage = '';
  static const IconData info = IconData(0xe33c, fontFamily: 'MaterialIcons');
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // bool? createCustomRubic = false;
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final GoogleDriveBloc _googleBloc = new GoogleDriveBloc();

  @override
  void initState() {
    Globals.gradeList.clear();
    _homeBloc.add(FetchStandardNavigationBar());
    super.initState();
    Globals.scoringRubric = RubricScoreList.scoringList[0].name;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackGroundImgWidget(),
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: CustomOcrAppBarWidget(
            key: GlobalKey(),
            isBackButton: false,
          ),
          body:
              // ListView(
              //   children: [
              Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            // height:
            //     MediaQuery.of(context).orientation == Orientation.portrait
            //         ? MediaQuery.of(context).size.height
            //         : MediaQuery.of(context).size.width * 0.8,
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Utility.textWidget(
                        text: 'Scoring Rubric',
                        context: context,
                        textTheme: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontWeight: FontWeight.bold)),
                    SpacerWidget(5),
                    IconButton(
                      padding: EdgeInsets.only(top: 2),
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => OcrPdfViewer(
                                      url:
                                          "https://solved-schools.s3.us-east-2.amazonaws.com/graded_doc/NYS+Rubric+3-8+ELA+MATH.pdf",
                                      tittle: "information",
                                      isbuttomsheet: true,
                                      language: Globals.selectedLanguage,
                                    )));
                      },
                      icon: Icon(
                        info,
                        color: Color(0xff000000) !=
                                Theme.of(context).backgroundColor
                            ? Color(0xff111C20)
                            : Color(0xffF7F8F9), //Colors.grey.shade400,
                      ),
                    )
                  ],
                ),
                SpacerWidget(_KVertcalSpace / 4),
                Container(
                    height: MediaQuery.of(context).size.height * 0.47,
                    child: scoringRubric()),
                Container(
                  child: BlocListener<HomeBloc, HomeState>(
                      bloc: _homeBloc,
                      listener: (context, state) async {
                        if (state is BottomNavigationBarSuccess) {
                          AppTheme.setDynamicTheme(Globals.appSetting, context);
                          Globals.appSetting = AppSetting.fromJson(state.obj);
                          setState(() {});
                        }
                      },
                      child: EmptyContainer()),
                ),
              ],
            ),
          ),
          // ],
          // ),
          floatingActionButton: scanButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ],
    );
  }

  Widget scanButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
            backgroundColor: AppTheme.kButtonColor,
            onPressed: () async {
              // if (createCustomRubic == true &&
              //     RubricScoreList.scoringList.last.imgBase64 != null) {
              //   print("heeleeelo");
              //   _googleBloc.add(ImageToAwsBucked(
              //       imgBase64: RubricScoreList.scoringList.last.imgBase64));
              // } else {
              updateLocalDb();
              // }
              _bloc.add(SaveSubjectListDetails());
              // Globals.studentInfo = [];
              Globals.studentInfo!.clear();
              // _bloc.add(SaveSubjectListDetails());
              //UNCOMMENT
              print(
                  "----> ${RubricScoreList.scoringList.last.name} B64-> ${RubricScoreList.scoringList.last.imgBase64}");
              // print(RubricScoreList.scoringList);
              // if (createCustomRubic == true &&
              //     RubricScoreList.scoringList.last.imgBase64 != null) {
              //   print("heeleeelo");
              //   _googleBloc.add(ImageToAwsBucked(
              //       imgBase64: RubricScoreList.scoringList.last.imgBase64));
              // } else {
              //   updateLocalDb();
              // }

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => CameraScreen(
              //             isScanMore: false,
              //             pointPossible: scoringColor == 0
              //                 ? '2'
              //                 : scoringColor == 2
              //                     ? '3'
              //                     : scoringColor == 4
              //                         ? '4'
              //                         : '2',
              //           )),
              // );

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CameraScreen(
                          isScanMore: false,
                        )),
              );
              //  getGallaryImage(); // COMMENT
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
            updateLocalDb();
            // if (createCustomRubic == true &&
            //     RubricScoreList.scoringList.last.imgBase64 != null) {
            //   print("heeleeelo");
            //   _googleBloc.add(ImageToAwsBucked(
            //       imgBase64: RubricScoreList.scoringList.last.imgBase64));
            // } else {
            //   updateLocalDb();
            // }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AssessmentSummary()),
            );
          },
          child: Container(
              padding: EdgeInsets.only(top: 10),
              // color: Colors.red,
              child: Utility.textWidget(
                  text: 'Assessment History',
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
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 90,
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: Globals.pointsList
            .map<Widget>(
                (element) => pointsButton(Globals.pointsList.indexOf(element)))
            .toList(),
      ),
    );
  }

  Widget pointsButton(int index) {
    return InkWell(
        onTap: () {
          //Globals.pointpossible = "${index + 1}";
          setState(() {
            indexColor = index + 1;
            if (index == 0) {
              scoringColor = 0;
            } else if (index == 1) {
              scoringColor = 2;
            } else if (index == 2) {
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
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
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
                message: Globals.pointsList[index].toString(),
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
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
      height: MediaQuery.of(context).size.height,
      //  MediaQuery.of(context).orientation == Orientation.portrait
      //     ? MediaQuery.of(context).size.height * 0.45
      //     : MediaQuery.of(context).size.width * 0.30,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 70,
              right: MediaQuery.of(context).size.width / 70),
          // physics: ScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.height * 0.5,
              childAspectRatio: 6 / 3.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 20),
          itemCount: RubricScoreList.scoringList.length,
          itemBuilder: (BuildContext ctx, index) {
            return InkWell(
              onLongPress: () {
                print(
                    'Rubric image : ${RubricScoreList.scoringList[index].imgUrl}');
                showCustomRubricImage(RubricScoreList.scoringList[index]);
              },
              onTap: () {
                setState(() {
                  scoringColor = index;
                });
                if (RubricScoreList.scoringList[index].name == "Custom") {
                  //   if (createCustomRubic == true) {
                  //     Utility.showSnackBar(_scaffoldKey,
                  //         "Create custom rubic section at a time", context, null);
                  //   } else {
                  //     createCustomRubic = true;
                  customRubricBottomSheet();
                  //   }
                } else {
                  //To take the rubric name to result screen and save the same in excel sheet
                  Globals.scoringRubric =
                      RubricScoreList.scoringList[index].name;
                }

                print("printing ----> ${Globals.scoringRubric}");
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
                  // width:RubricScoreList.scoringList.length -1 == index ? MediaQuery.of(context).size.width: null,
                  alignment: Alignment.center,
                  child: Utility.textWidget(
                    text:
                        "${RubricScoreList.scoringList[index].name! + " " + RubricScoreList.scoringList[index].score!}",
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

  customRubricBottomSheet() {
    showModalBottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        // animationCurve: Curves.easeOutQuart,
        elevation: 10,
        context: context,
        builder: (context) => BottomSheetWidget(
              update: _update,
              title: 'Scoring Rubric',
              isImageField: true,
              textFieldTitleOne: 'Score Name',
              textFieldTitleTwo: 'Custom Score',
              isSubjectScreen: false,
            ));
  }

  void _update(bool value) {
    value
        ? setState(() {
            //  createCustomRubic = value;
          })
        : print("");
  }

  void showCustomRubricImage(CustomRubicModal customScoreObj) {
    customScoreObj.imgUrl != null
        ? showDialog(
            context: context,
            builder: (_) => ImagePopup(
                // Implemented Dark mode image
                imageURL: customScoreObj.imgUrl!))
        : Utility.showSnackBar(_scaffoldKey,
            'Image not found for the selected scoring rubric', context, null);
  }

  Future updateLocalDb() async {
    //Save user profile to locally
    LocalDatabase<CustomRubicModal> _localDb = LocalDatabase('custom_rubic');

    await _localDb.clear();
    RubricScoreList.scoringList.forEach((CustomRubicModal e) {
      _localDb.addData(e);
    });
  }
}
