import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/assessment_history_screen.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/camera_screen.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_fab.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/modal/RubricPdfModal.dart';
import 'package:Soc/src/modules/graded_plus/modal/custom_rubic_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/graded_plus/widgets/bottom_sheet_widget.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
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

class GradedPlusConstructedResponse extends StatefulWidget {
  const GradedPlusConstructedResponse({Key? key}) : super(key: key);

  @override
  State<GradedPlusConstructedResponse> createState() =>
      _GradedPlusConstructedResponseState();
}

class _GradedPlusConstructedResponseState
    extends State<GradedPlusConstructedResponse> {
  static const double _KVertcalSpace = 60.0;
  final assessmentController = TextEditingController();
  final classController = TextEditingController();
  final HomeBloc _homeBloc = new HomeBloc();
  final OcrBloc _bloc = new OcrBloc();
  // instance for maintaining logs
  final OcrBloc _ocrBlocLogs = new OcrBloc();
  File? myImagePath;
  String pathOfImage = '';

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  int? lastIndex = 0;
  final ValueNotifier<int> pointPossibleSelectedColor = ValueNotifier<int>(1);
  final ValueNotifier<int> rubricScoreSelectedColor = ValueNotifier<int>(0);
  final ValueNotifier<bool> updateRubricList = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);

  DateTime currentDateTime = DateTime.now(); //DateTime

  int myTimeStamp = DateTime.now().microsecondsSinceEpoch;

  LocalDatabase<CustomRubricModal> _localDb = LocalDatabase('custom_rubic');

  @override
  void initState() {
    //Globals.isPremiumUser = true;
    // Globals.questionImgUrl = '';
    getAllRubricList();
    // Globals.questionImgFilePath = null;
    Utility.setLocked();
    _homeBloc.add(FetchStandardNavigationBar());
    super.initState();
    Globals.scoringRubric =
        "${RubricScoreList.scoringList[0].name} ${RubricScoreList.scoringList[0].score}";
    FirebaseAnalyticsService.addCustomAnalyticsEvent("graded_home");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'graded_home', screenClass: 'OpticalCharacterRecognition');
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        OfflineBuilder(
            child: Container(),
            connectivityBuilder: (BuildContext context,
                ConnectivityResult connectivity, Widget child) {
              final bool connected = connectivity != ConnectivityResult.none;
              return Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                  appBar: appBar(),
                  body: body(),
                  floatingActionButton: fabButton(connected: connected),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniCenterFloat);
            }),
        AllblocListener()
      ],
    );
  }

  PreferredSizeWidget? appBar() {
    return CustomOcrAppBarWidget(
        fromGradedPlus: true,
        //Show home button in standard app and hide in standalone
        assessmentDetailPage: Overrides.STANDALONE_GRADED_APP ? true : null,
        isOcrHome: true,
        isSuccessState: ValueNotifier<bool>(true),
        isBackOnSuccess: isBackFromCamera,
        key: GlobalKey(),
        isBackButton: true //Overrides.STANDALONE_GRADED_APP ? true : false,
        );
  }

  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: StudentPlusOverrides.kSymmetricPadding),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final isSmallDevice = constraints.maxHeight <= 600;
        return ListView(
          physics: !isSmallDevice ? NeverScrollableScrollPhysics() : null,
          children: [
            SpacerWidget(StudentPlusOverrides.KVerticalSpace / 10),
            PlusScreenTitleWidget(
              kLabelSpacing: 0,
              text: 'Points Possible',
              backButton: true,
            ),
            SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
            pointPossibleButton(),
            SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlusScreenTitleWidget(
                    kLabelSpacing: StudentPlusOverrides.kLabelSpacing,
                    text: 'Scoring Rubric'),
                BlocConsumer(
                  bloc: _bloc,
                  builder: (BuildContext context, Object? state) {
                    return Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          padding: EdgeInsets.only(top: 2),
                          onPressed: () {
                            _bloc.add(GetRubricPdf());
                          },
                          icon: Icon(
                            Icons.info,
                            size: Globals.deviceType == 'tablet' ? 35 : null,
                            color: Color(0xff000000) !=
                                    Theme.of(context).backgroundColor
                                ? Color(0xff111C20)
                                : Color(0xffF7F8F9), //Colors.grey.shade400,
                          ),
                        ),
                      ),
                    );
                  },
                  listener: (BuildContext context, Object? state) {
                    if (state is OcrLoading) {
                      Utility.showLoadingDialog(
                          context: context, isOCR: true, msg: 'Please Wait...');
                    }
                    if (state is GetRubricPdfSuccess) {
                      Navigator.pop(context);
                      if (state.objList == null || state.objList!.isEmpty) {
                        Utility.currentScreenSnackBar("no pdf link ", null);
                      } else if (state.objList!.length > 1) {
                        showRubricList(state.objList);
                      } else {
                        navigateToPdfViewer(pdfObject: state.objList![0]);
                      }
                    }
                    if (state is OcrErrorReceived) {
                      print(state.err);
                      Navigator.pop(context);
                      Utility.currentScreenSnackBar(state.err.toString(), null);
                    }

                    if (state is NoRubricAvailable) {
                      Navigator.pop(context);
                      Utility.currentScreenSnackBar(
                          'No Rubric Available', null);
                    }
                  },
                )
              ],
            ),
            SpacerWidget(_KVertcalSpace / 4),
            Container(
                height: Globals.deviceType == 'tablet'
                    ? MediaQuery.of(context).size.height * 0.6
                    : MediaQuery.of(context).size.height * 0.47,
                child: scoringRubric()),
          ],
        );
      }),
    );
  }

  AllblocListener() {
    return MultiBlocListener(
      listeners: [
        BlocListener<GoogleDriveBloc, GoogleDriveState>(
            bloc: _googleDriveBloc,
            child: Container(),
            listener: (BuildContext contxt, GoogleDriveState state) {
              if (state is ImageToAwsBucketSuccess) {
                Navigator.pop(context);
                int index = 0;
                for (int i = 0; i < RubricScoreList.scoringList.length; i++) {
                  if (RubricScoreList.scoringList[i].name ==
                          state.customRubricModal.name &&
                      RubricScoreList.scoringList[i].score ==
                          state.customRubricModal.score) {
                    RubricScoreList.scoringList[i].imgUrl =
                        state.bucketImageUrl;
                    index = i;
                    break;
                  }

                  showCustomRubricImage(RubricScoreList.scoringList[index]);
                }
              }
              if (state is ErrorState) {
                Navigator.pop(context);
                Utility.currentScreenSnackBar(state.errorMsg.toString(), null);
              }
            }),
        BlocListener<GoogleDriveBloc, GoogleDriveState>(
            bloc: _googleDriveBloc,
            child: Container(),
            listener: (context, state) async {
              if (state is GoogleDriveLoading) {
                Utility.showLoadingDialog(context: context, isOCR: true, msg: 'Please Wait');
              }
              if (state is GoogleSuccess) {
                if (Globals.googleDriveFolderId != null &&
                    Globals.googleDriveFolderId!.isNotEmpty) {
                  Navigator.of(context).pop();
                  _beforenavigateOnCameraSection();
                }
              }
              if (state is ErrorState) {
                Navigator.of(context).pop();
                if (state.errorMsg == 'ReAuthentication is required') {
                  await Utility.refreshAuthenticationToken(
                      isNavigator: true,
                      errorMsg: state.errorMsg!,
                      context: context,
                      scaffoldKey: _scaffoldKey);

                  _triggerDriveFolderEvent(false);
                } else {
                  Utility.currentScreenSnackBar(
                      "Something Went Wrong. Please Try Again.", null);
                }
              }
            }),
      ],
      child: SizedBox(),
    );
  }

  Widget fabButton({required final bool connected}) {
    return GradedPlusCustomFloatingActionButton(
      isExtended: true,
      title: 'Start Scanning',
      icon: Icon(
        Icons.add,
        color: Theme.of(context).backgroundColor,
      ),
      onPressed: () async {
        if (!connected) {
          await FirebaseAnalyticsService.addCustomAnalyticsEvent(
              "start_scanning");

          Utility.currentScreenSnackBar("No Internet Connection", null);
        } else {
          //Utility.showLoadingDialog(context);
          // Globals.studentInfo!.clear();
          LocalDatabase<StudentAssessmentInfo> _localDb =
              LocalDatabase('student_info');
          await _localDb.clear();

          //clears scan more list
          Globals.scanMoreStudentInfoLength = null;

          if (Globals.googleDriveFolderId!.isNotEmpty) {
            _beforenavigateOnCameraSection();
          } else {
            _triggerDriveFolderEvent(false);
          }
        }
      },
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
              onTap: () async {
                await FirebaseAnalyticsService.addCustomAnalyticsEvent(
                    "Point_possible_selection");
                pointPossibleSelectedColor.value = index + 1;
                //To take the rubric name to result screen and save the same in excel sheet
                Globals.scoringRubric =
                    "${RubricScoreList.scoringList[index == 0 ? 0 : index == 1 ? 2 : 4].name} ${RubricScoreList.scoringList[index == 0 ? 0 : index == 1 ? 2 : 4].score}";
                //print(Globals.scoringRubric);
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
                  padding: EdgeInsets.only(bottom: 20),
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
                            //print(
                            // 'Rubric image : ${RubricScoreList.scoringList[index].imgUrl}');
                            showCustomRubricImage(
                                RubricScoreList.scoringList[index]);
                          },
                          onTap: () {
                            print(Globals.scoringRubric);
                            rubricScoreSelectedColor.value = index;

                            if (RubricScoreList.scoringList[index].name ==
                                    "Custom" &&
                                rubricScoreSelectedColor.value == 1) {
                              // To make sure, custom name not mismatches the options
                              customRubricBottomSheet();
                              if (index == 0) {
                                pointPossibleSelectedColor.value = 1;
                              } else if (index == 2) {
                                pointPossibleSelectedColor.value = 2;
                              } else if (index == 4) {
                                pointPossibleSelectedColor.value = 3;
                              } else if (RubricScoreList
                                      .scoringList[index].name ==
                                  "None") {
                                pointPossibleSelectedColor.value = 0;
                              }

                              lastIndex = index;
                              Globals.scoringRubric =
                                  '${RubricScoreList.scoringList[index].name} ${RubricScoreList.scoringList[index].score}';
                            } else if (RubricScoreList
                                    .scoringList[index].name ==
                                "None") {
                              Globals.scoringRubric =
                                  RubricScoreList.scoringList[index].name;
                            } else {
                              Globals.scoringRubric =
                                  '${RubricScoreList.scoringList[index].name} ${RubricScoreList.scoringList[index].score}';
                            }
                            // print(Globals.scoringRubric);
                            // print("//printing ----> ${Globals.scoringRubric}");
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
                                text: getScrobingRubric(index: index),
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

  showRubricList(List<RubricPdfModal>? infoPdfList) {
    showModalBottomSheet(
      useRootNavigator: true,
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
        title: 'Rubric Info',
        isImageField: false,
        textFieldTitleOne: 'Score Name',
        textFieldTitleTwo: 'Custom Score',
        isSubjectScreen: false,
        valueChanged: (controller) async {},
        section: 'PDF section',
        rubricPdfModalList: infoPdfList,
        tileOnTap: (object) => navigateToPdfViewer(pdfObject: object),
        sheetHeight: MediaQuery.of(context).size.height * 0.50,
      ),
    );
  }

//To update the rubric score list

//To update the rubric score list
  void _update(bool value) {
    if (value) {
      updateLocalDb();
      updateRubricList.value = !updateRubricList.value;
      rubricScoreSelectedColor.value = RubricScoreList.scoringList.length - 1;
      Globals.scoringRubric =
          "${RubricScoreList.scoringList.last.name} ${RubricScoreList.scoringList.last.score}";
      ;
    }
  }

  Future<void> showCustomRubricImage(
    CustomRubricModal customScoreObj,
  ) async {
    if (customScoreObj.imgUrl != null) {
      showDialog(
          context: context,
          builder: (_) => ImagePopup(
              // Implemented Dark mode image
              imageURL: customScoreObj.imgUrl!));
    } else if (customScoreObj.imgBase64 != null &&
        customScoreObj.imgBase64!.isNotEmpty) {
      Utility.showLoadingDialog(context: context, isOCR: true, msg: 'Please Wait');
      _googleDriveBloc.add(ImageToAwsBucket(
          customRubricModal: customScoreObj, getImageUrl: true));
    } else {
      Utility.currentScreenSnackBar(
          'Image not found for the selected scoring rubric', null);
    }
  }

  Future updateLocalDb() async {
    //Save user profile to locally
    // LocalDatabase<CustomRubricModal> _localDb = LocalDatabase('custom_rubric');
    //print(RubricScoreList.scoringList);
    await _localDb.clear();

    RubricScoreList.scoringList.forEach((CustomRubricModal e) async {
      await _localDb.addData(e);
    });
    // ignore: unnecessary_statements
  }

  void _triggerDriveFolderEvent(bool isTriggerdbyAssessmentSection) async {
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();

    _googleDriveBloc.add(GetDriveFolderIdEvent(
        fromGradedPlusAssessmentSection:
            isTriggerdbyAssessmentSection ? true : null,
        isReturnState: true,
        //  filePath: file,
        token: _profileData[0].authorizationToken,
        folderName: "SOLVED GRADED+",
        refreshToken: _profileData[0].refreshToken));
  }

  Future<void> _beforenavigateOnCameraSection() async {
    //Rubric selection comparision
    Globals.pointPossible = (Globals.scoringRubric == 'None'
        //Point possible index comparision
        ? pointPossibleSelectedColor.value == 1
            ? "2"
            : (pointPossibleSelectedColor.value + 1).toString()
        : rubricScoreSelectedColor.value == 0 //NYS 0-2
            ? '2'
            : rubricScoreSelectedColor.value == 2 //NYS 0-3
                ? '3'
                // : rubricScoreSelectedColor.value == 3 //None
                //     ? (pointPossibleSelectedColor.value + 2).toString() //
                : rubricScoreSelectedColor.value == 4 //NYS 0-4
                    ? '4'
                    : rubricScoreSelectedColor.value > 4 //Custom selection
                        ? (pointPossibleSelectedColor.value + 1)
                            .toString() //+1 is added for 'index+1' to get right point possible
                        : '2'); //In case of 'None' or 'Custom rubric' selection

    Globals.googleExcelSheetId = "";
    //qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
    updateLocalDb();

    if (Globals.sessionId == '') {
      Globals.sessionId = "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
    }

    _ocrBlocLogs.add(LogUserActivityEvent(
        activityType: 'GRADED+',
        sessionId: Globals.sessionId,
        teacherId: Globals.teacherId,
        activityId: '1',
        accountId: Globals.appSetting.schoolNameC,
        accountType: "Premium",
        dateTime: currentDateTime.toString(),
        description: 'Start Scanning',
        operationResult: 'Success'));

    navigateToCamera();
  }

  // void _beforenavigateOnAssessmentSection() {
  //   if (Globals.sessionId == '') {
  //     Globals.sessionId = "${Globals.teacherEmailId}_${myTimeStamp.toString()}";
  //   }

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => GradedPlusAssessmentSummary(
  //               selectedFilterValue: 'Constructed Response',
  //               isFromHomeSection: true,
  //             )),
  //   );
  // }

  void navigateToPdfViewer({required RubricPdfModal pdfObject}) {
    if (pdfObject.rubricPdfC == null ||
        pdfObject.rubricPdfC!.contains('http') == false) {
      Utility.currentScreenSnackBar("No Pdf url", null);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CommonPdfViewerPage(
                    isOCRFeature: true,
                    isHomePage: false,
                    url: pdfObject.rubricPdfC,
                    tittle: pdfObject.titleC ?? 'no tittle',
                    isBottomSheet: false,
                    language: Globals.selectedLanguage,
                  )));
    }
  }

  customRubricBottomSheet() {
    showModalBottomSheet(
        useRootNavigator: true,
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
              valueChanged: (controller) async {},
              submitButton: true,
            ));
  }

  String getScrobingRubric({required int index}) {
    String rubric =
        "${RubricScoreList.scoringList[index].name! + " " + RubricScoreList.scoringList[index].score!}";

    return Overrides.STANDALONE_GRADED_APP == true
        ? rubric.replaceAll('NYS', '')
        : rubric;
  }

  getAllRubricList() async {
    List<CustomRubricModal> _localData = await _localDb.getData();
    if (_localData.isEmpty) {
      RubricScoreList.scoringList.forEach((CustomRubricModal e) async {
        await _localDb.addData(e);
      });
      await _localDb.close();
    } else {
      RubricScoreList.scoringList.clear();
      RubricScoreList.scoringList.addAll(_localData);
      updateRubricList.value = !updateRubricList.value;
    }
  }

  void navigateToCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GradedPlusCameraScreen(
          isMcqSheet: false,
          selectedAnswer: '',
          isFromHistoryAssessmentScanMore: false,
          onlyForPicture: false,
          scaffoldKey: _scaffoldKey,
          isScanMore: false,
          pointPossible: Globals.pointPossible,
          isFlashOn: ValueNotifier<bool>(false),
        ),
        // settings: RouteSettings(name: "/home")
      ),
    );
  }
}
