import 'dart:ffi';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/ocr/bloc/ocr_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/custom_rubic_modal.dart';
import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/modules/ocr/ui/success.dart';
import 'package:Soc/src/modules/ocr/widgets/bottom_sheet_widget.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_pdf_viewer.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/image_popup.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../../../services/local_database/local_db.dart';
import '../../../widgets/common_pdf_viewer_page.dart';
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
  final HomeBloc _homeBloc = new HomeBloc();
  final OcrBloc _bloc = new OcrBloc();
  File? myImagePath;
  String pathOfImage = '';
  static const IconData info = IconData(0xe33c, fontFamily: 'MaterialIcons');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  int? lastIndex;
  final ValueNotifier<int> pointPossibleSelectedColor = ValueNotifier<int>(1);
  final ValueNotifier<int> rubricScoreSelectedColor = ValueNotifier<int>(0);
  final ValueNotifier<bool> updateRubricList = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);

  @override
  void initState() {
    Globals.questionImgUrl = '';
    Globals.questionImgFilePath = null;
    Utility.setLocked();
    _homeBloc.add(FetchStandardNavigationBar());
    super.initState();
    Globals.scoringRubric =
        "${RubricScoreList.scoringList[0].name} ${RubricScoreList.scoringList[0].score}";
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
            isbackOnSuccess: isBackFromCamera,
            key: GlobalKey(),
            isBackButton: false,
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: ListView(
              children: [
                SpacerWidget(_KVertcalSpace / 4),
                Utility.textWidget(
                    text: 'Points Possible',
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold)),
                SpacerWidget(_KVertcalSpace / 4),
                pointPossibleButton(),
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
                                builder: (BuildContext context) =>
                                    CommonPdfViewerPage(
                                      isOCRFeature: true,
                                      isHomePage: false,
                                      url: Overrides.rubric_Score_PDF_URL,
                                      tittle: '',
                                      isbuttomsheet: false,
                                      language: Globals.selectedLanguage,
                                    )
                                // OcrPdfViewer(
                                //       url: Overrides.rubric_Score_PDF_URL,
                                //       tittle: "information",
                                //       isbuttomsheet: true,
                                //       language: Globals.selectedLanguage,
                                //     )
                                ));
                      },
                      icon: Icon(
                        info,
                        size: Globals.deviceType == 'tablet' ? 35 : null,
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
                    height: Globals.deviceType == 'tablet'
                        ? MediaQuery.of(context).size.height * 0.6
                        : MediaQuery.of(context).size.height * 0.47,
                    child: scoringRubric()),
                // Container(
                //   child: BlocListener<HomeBloc, HomeState>(
                //       bloc: _homeBloc,
                //       listener: (context, state) async {
                //         if (state is BottomNavigationBarSuccess) {
                //           AppTheme.setDynamicTheme(Globals.appSetting, context);
                //           Globals.appSetting = AppSetting.fromJson(state.obj);
                //           setState(() {});
                //         }
                //       },
                //       child: EmptyContainer()),
                // ),
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
        Builder(builder: (context) {
          return OfflineBuilder(
            connectivityBuilder: (BuildContext context,
                ConnectivityResult connectivity, Widget child) {
              final bool connected = connectivity != ConnectivityResult.none;
              return FloatingActionButton.extended(
                  backgroundColor: AppTheme.kButtonColor,
                  onPressed: () async {
                    if (!connected) {
                      Utility.currentScreenSnackBar("No Internet Connection");
                    } else {
                      Globals.studentInfo!.clear();
                      if (Globals.googleDriveFolderId!.isEmpty) {
                        _triggerDriveFolderEvent(false);
                      } else {
                        _beforenavigateOnCameraSection();
                      }
                    }
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
                          .copyWith(color: Theme.of(context).backgroundColor)));
            },
            child: Container(),
          );
        }),
        BlocListener<GoogleDriveBloc, GoogleDriveState>(
            bloc: _googleDriveBloc,
            child: Container(),
            listener: (context, state) async {
              if (state is GoogleDriveLoading) {
                Utility.showLoadingDialog(context);
              }
              if (state is GoogleSuccess) {
                if (state.assessmentSection == true) {
                  Navigator.of(context).pop();
                  _beforenavigateOnAssessmentSection();
                } else {
                  Navigator.of(context).pop();
                  _beforenavigateOnCameraSection();
                }
              }
              if (state is ErrorState) {
                if (state.errorMsg == 'Reauthentication is required') {
                  await Utility.refreshAuthenticationToken(
                      isNavigator: true,
                      errorMsg: state.errorMsg!,
                      context: context,
                      scaffoldKey: _scaffoldKey);

                  _triggerDriveFolderEvent(state.isAssessmentSection);
                } else {
                  Navigator.of(context).pop();
                  Utility.currentScreenSnackBar(
                      "Something Went Wrong. Please Try Again.");
                }
                // Utility.refreshAuthenticationToken(
                //     state.errorMsg!, context, _scaffoldKey);

                //  await _launchURL('Google Authentication');

              }
            }),
        GestureDetector(
          onTap: () async {
            if (Globals.googleDriveFolderId!.isEmpty) {
              _triggerDriveFolderEvent(true);
            } else {
              _beforenavigateOnAssessmentSection();
            }
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
        )
      ],
    );
  }

  Widget pointPossibleButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 90,
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: Globals.deviceType == 'phone'
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: Globals.pointsList
            .map<Widget>((element) => Container(
                padding: Globals.deviceType == 'tablet'
                    ? EdgeInsets.only(right: 20)
                    : null,
                child: pointsButton(Globals.pointsList.indexOf(element))))
            .toList(),
      ),
    );
  }

  Widget pointsButton(int index) {
    return ValueListenableBuilder(
        valueListenable: pointPossibleSelectedColor,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return InkWell(
              onTap: () {
                pointPossibleSelectedColor.value = index + 1;
                //To take the rubric name to result screen and save the same in excel sheet
                Globals.scoringRubric =
                    "${RubricScoreList.scoringList[index].name} ${RubricScoreList.scoringList[index].score}";
                if (index == 0) {
                  rubricScoreSelectedColor.value = 0;
                } else if (index == 1) {
                  rubricScoreSelectedColor.value = 2;
                } else if (index == 2) {
                  rubricScoreSelectedColor.value = 4;
                }
                // }
              },
              child: AnimatedContainer(
                padding: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: pointPossibleSelectedColor.value == index + 1
                      ? AppTheme.kSelectedColor
                      : Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                duration: Duration(microseconds: 100),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    decoration: BoxDecoration(
                      color:
                          Color(0xff000000) != Theme.of(context).backgroundColor
                              ? Color(0xffF7F8F9)
                              : Color(0xff111C20),
                      border: Border.all(
                        color: pointPossibleSelectedColor.value == index + 1
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
                              color:
                                  pointPossibleSelectedColor.value == index + 1
                                      ? AppTheme.kSelectedColor
                                      : Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                            ),
                      ),
                    )),
              ));
        });
  }

  Widget scoringRubric() {
    return ValueListenableBuilder(
        valueListenable: updateRubricList,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return ValueListenableBuilder(
              valueListenable: rubricScoreSelectedColor,
              child: Container(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.1,
                          left: MediaQuery.of(context).size.width / 70,
                          right: MediaQuery.of(context).size.width / 70),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent:
                              MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? MediaQuery.of(context).size.width * 0.5
                                  : MediaQuery.of(context).size.height * 0.5,
                          childAspectRatio:
                              Globals.deviceType == 'phone' ? 6 / 3.5 : 5 / 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 20),
                      itemCount: RubricScoreList.scoringList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return InkWell(
                          onLongPress: () {
                            print(
                                'Rubric image : ${RubricScoreList.scoringList[index].imgUrl}');
                            showCustomRubricImage(
                                RubricScoreList.scoringList[index]);
                          },
                          onTap: () {
                            rubricScoreSelectedColor.value = index;

                            if (RubricScoreList.scoringList[index].name ==
                                "Custom") {
                              customRubricBottomSheet();
                            } else {
                              lastIndex = index;
                              Globals.scoringRubric =
                                  RubricScoreList.scoringList[index].name;
                            }

                            print("printing ----> ${Globals.scoringRubric}");
                          },
                          child: AnimatedContainer(
                            padding: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: rubricScoreSelectedColor.value == index
                                  ? AppTheme.kSelectedColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            duration: Duration(microseconds: 100),
                            child: Container(
                              alignment: Alignment.center,
                              child: Utility.textWidget(
                                text:
                                    "${RubricScoreList.scoringList[index].name! + " " + RubricScoreList.scoringList[index].score!}",
                                context: context,
                                textTheme: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: rubricScoreSelectedColor.value ==
                                                index
                                            ? AppTheme.kSelectedColor
                                            : Theme.of(context)
                                                .colorScheme
                                                .primaryVariant),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        rubricScoreSelectedColor.value == index
                                            ? AppTheme.kSelectedColor
                                            : Colors.grey,
                                  ),
                                  color: Color(0xff000000) !=
                                          Theme.of(context).backgroundColor
                                      ? Color(0xffF7F8F9)
                                      : Color(0xff111C20),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        );
                      }),
                );
              });
        });
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
            valueChanged: (controller) async {}));
  }

//To update the rubric score list
  void _update(bool value) {
    if (!value) {
      if (lastIndex == null) {
        lastIndex = 0;
      }
      Globals.scoringRubric = RubricScoreList.scoringList[lastIndex!].name;
      rubricScoreSelectedColor.value = lastIndex!;
    } else {
      updateRubricList.value = !updateRubricList.value;
      rubricScoreSelectedColor.value = RubricScoreList.scoringList.length - 1;
      Globals.scoringRubric = RubricScoreList.scoringList.last.name;
    }

    if (value) {
      updateRubricList.value = !updateRubricList.value;
    }
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

  void _triggerDriveFolderEvent(bool isTriggerdbyAssessmentSection) async {
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();

    _googleDriveBloc.add(GetDriveFolderIdEvent(
        assessmentSection: isTriggerdbyAssessmentSection ? true : null,
        isFromOcrHome: true,
        //  filePath: file,
        token: _profileData[0].authorizationToken,
        folderName: "SOLVED GRADED+",
        refreshtoken: _profileData[0].refreshToken));
  }

  void _beforenavigateOnCameraSection() async {
    Globals.pointpossible = rubricScoreSelectedColor.value == 0
        ? '2'
        : rubricScoreSelectedColor.value == 2
            ? '3'
            : rubricScoreSelectedColor.value == 4
                ? '4'
                : '2';
    Globals.googleExcelSheetId = "";
    updateLocalDb();

    _bloc.add(SaveSubjectListDetails());
    // UNCOMMENT Below
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CameraScreen(
                isFromHistoryAssessmentScanMore: false,
                onlyForPicture: false,
                scaffoldKey: _scaffoldKey,
                isScanMore: false,
                pointPossible: rubricScoreSelectedColor.value == 0
                    ? '2'
                    : rubricScoreSelectedColor.value == 2
                        ? '3'
                        : rubricScoreSelectedColor.value == 4
                            ? '4'
                            : '4', //In case of 'None' or 'Custom rubric' selection
              )),
    );
    // End
    // // COMMENT Below
    // LocalDatabase<String> _localDb = LocalDatabase('class_suggestions');
    // List<String> classSuggestions = await _localDb.getData();
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => CreateAssessment(
    //               classSuggestions: classSuggestions,
    //               customGrades: Globals.classList,
    //             )));
    // End
  }

  void _beforenavigateOnAssessmentSection() {
    updateLocalDb();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AssessmentSummary()),
    );
  }
}
