import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/ocr/ui/assessment_summary.dart';
import 'package:Soc/src/modules/ocr/ui/camera_screen.dart';
import 'package:Soc/src/modules/ocr/widgets/Common_popup.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/edit_bottom_sheet.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/widgets/user_profile.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/image_popup.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';
import '../../../widgets/empty_container_widget.dart';
import '../../google_drive/model/user_profile.dart';
import '../bloc/ocr_bloc.dart';
import '../modal/user_info.dart';

class ResultsSummary extends StatefulWidget {
  ResultsSummary({
    Key? key,
    this.obj,
    this.createdAsPremium,
    required this.assessmentDetailPage,
    this.fileId,
    this.subjectId,
    this.standardId,
    this.rubricScore,
    this.isScanMore,
    this.assessmentListLenght,
    required this.shareLink,
    required this.asssessmentName,
    this.historysecondTime,
  }) : super(key: key);
  final bool? assessmentDetailPage;
  String? fileId;
  // final HistoryAssessment? obj;
  final obj;
  final String? subjectId;
  final String? standardId;
  final String? rubricScore;
  final bool? isScanMore;
  final int? assessmentListLenght;
  String? shareLink;
  String? asssessmentName;
  bool? historysecondTime;

  final bool? createdAsPremium;
  @override
  State<ResultsSummary> createState() => _ResultsSummaryState();
}

class _ResultsSummaryState extends State<ResultsSummary> {
  static const double _KVertcalSpace = 60.0;
  GoogleDriveBloc _driveBloc = GoogleDriveBloc();
  GoogleDriveBloc _driveBloc2 = GoogleDriveBloc();
  OcrBloc _ocrBloc = OcrBloc();
  // int? assessmentCount;
  ScrollController _scrollController = new ScrollController();
  final ValueNotifier<bool> isScrolling = ValueNotifier<bool>(false);
  final ValueNotifier<bool> disableSlidableAction = ValueNotifier<bool>(false);
  final ValueNotifier<bool> editStudentDetailSuccess =
      ValueNotifier<bool>(false);
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final ValueNotifier<String> dashoardState = ValueNotifier<String>('');
  int? assessmentListLenght;
  ValueNotifier<int> assessmentCount = ValueNotifier<int>(0);
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  ValueNotifier<bool> isSuccessStateRecived = ValueNotifier<bool>(false);
  ValueNotifier<bool> infoIconValue = ValueNotifier<bool>(false);
  String? isAssessmentAlreadySaved = '';
  int? savedRecordCount;
  String? questionImageUrl;

  String? webContentLink;
  String? sheetrubricScore;
  List<StudentAssessmentInfo> historyRecordList = [];
  List iconsList = [];
  List iconsName = [];
  bool createdAsPremium = false;

  final editingStudentNameController = TextEditingController();
  final editingStudentIdController = TextEditingController();
  final editingStudentScoreController = TextEditingController();

  // ValueNotifier<List<StudentAssessmentInfo>> sudentRecordList =
  //     ValueNotifier([]);
  ValueNotifier<int> _listCount = ValueNotifier(0);

  LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
      LocalDatabase('student_info');
  LocalDatabase<StudentAssessmentInfo> _historyStudentInfoDb =
      LocalDatabase('history_student_info');

  String? historyAssessmentId;

  // ValueNotifier<List<bool>> dashboardWidget =
  //     ValueNotifier<List<bool>>([false, false]);

  bool isGoogleSheetStateRecived = false;

  @override
  void initState() {
    _futurMethod();
    if (widget.assessmentDetailPage!) {
      // Globals.historyStudentInfo = [];
      _historyStudentInfoDb.clear();
      if (widget.historysecondTime == true) {
        widget.asssessmentName = Globals.historyAssessmentName;
        widget.fileId = Globals.historyAssessmentFileId;
      } else {
        Globals.historyAssessmentName = '';
        Globals.historyAssessmentFileId = '';
        Globals.historyAssessmentName = widget.asssessmentName;
        Globals.historyAssessmentFileId = widget.fileId;
      }

      iconsList = [0xe876, 0xe871, 0xe87a];
      iconsName = ["Share", "Drive", "Dashboard"];
      _driveBloc
          .add(GetAssessmentDetail(fileId: widget.fileId, nextPageUrl: ''));
      _ocrBloc.add(GetDashBoardStatus(fileId: widget.fileId!));
    } else {
      if (widget.isScanMore != true) {
        _driveBloc.add(GetShareLink(fileId: widget.fileId));
      } else {
        //TODO : REMOVE GLOBAL ACCESS : IMPROVE
        widget.shareLink = Globals.shareableLink;
      }

      iconsList = Globals.ocrResultIcons;
      iconsName = Globals.ocrResultIconsName;

      _method();
    }
    //Checking in case of scan more if data is already saved to the dashboard for previously scanned sheets
    // if (Globals.studentInfo!.length == Globals.scanMoreStudentInfoLength) {
    //   dashoardState.value = 'Success';
    // }
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _scrollListener() async {
    bool isTop = _scrollController.position.pixels < 150;
    if (isTop) {
      if (isScrolling.value == false) return;
      isScrolling.value = false;
    } else {
      if (isScrolling.value == true) return;
      isScrolling.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          CommonBackGroundImgWidget(),
          Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
              isSuccessState: ValueNotifier<bool>(true),
              isbackOnSuccess: isBackFromCamera,
              key: GlobalKey(),
              sessionId: widget.obj != null ? widget.obj!.sessionId : '',
              isBackButton: widget.assessmentDetailPage,
              assessmentDetailPage: widget.assessmentDetailPage,
              actionIcon: Container(
                  padding: EdgeInsets.only(right: 5),
                  child: TextButton(
                      style: ButtonStyle(alignment: Alignment.center),
                      child: TranslationWidget(
                          message: "DONE",
                          fromLanguage: "en",
                          toLanguage: Globals.selectedLanguage,
                          builder: (translatedMessage) {
                            return Text(translatedMessage,
                                style: TextStyle(
                                  color: AppTheme.kButtonColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ));
                          }),
                      onPressed: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        Utility.updateLoges(
                            activityId: '19',
                            description:
                                'Teacher Successfully Completed the process and press done ',
                            operationResult: 'Success');
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      isFromOcrSection: true,
                                    )),
                            (_) => false);
                        // onFinishedPopup();
                      })),
              isResultScreen: true,
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpacerWidget(_KVertcalSpace * 0.40),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 5,
                        right: 20), //EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Utility.textWidget(
                              text: 'Results Summary',
                              context: context,
                              textTheme: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ),
                        ValueListenableBuilder(
                            valueListenable: assessmentCount,
                            builder: (BuildContext context, int value,
                                Widget? child) {
                              return FutureBuilder(
                                  future: Utility.getStudentInfoList(
                                      tableName:
                                          widget.assessmentDetailPage == true
                                              ? 'history_student_info'
                                              : 'student_info'),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<StudentAssessmentInfo>>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      return snapshot.data!.length == 0
                                          ? CupertinoActivityIndicator(
                                              //  color: Colors.white,
                                              )
                                          : Text('${snapshot.data!.length}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3);
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CupertinoActivityIndicator(
                                          //color: Colors.white,
                                          );
                                    }

                                    return Container();
                                  });
                            }),
                      ],
                    ),
                  ),
                  // SpacerWidget(_KVertcalSpace / 5),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    child: ValueListenableBuilder(
                      valueListenable: infoIconValue,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                        return Padding(
                          padding: EdgeInsets.only(left: 5), //EdgeInsets.only(
                          //   left: 20,
                          // ),
                          child: infoIconValue.value == true ||
                                  widget.assessmentDetailPage != true
                              ? ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: Utility.textWidget(
                                        text:
                                            // 'hykhyptjpotp]iotgjhoityhjoiyjhieorgjhnklrtnhkgjnkljgbhjrkbthn;rtnjlrnhlrdnhrjhnrjkhnkrljnjklrnrihnrtihn',
                                            widget.asssessmentName == null
                                                ? 'Asssessment Name'
                                                //     //     // : widget.asssessmentName!.length > 20
                                                //     //     //     ? '${widget.asssessmentName!.substring(0, 20)}' +
                                                //     //     //         '...'
                                                : widget.asssessmentName!,
                                        context: context,
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
                                        textTheme: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(
                                                // fontWeight: FontWeight.bold,
                                                )),
                                  ),
                                  trailing: Container(
                                      padding: EdgeInsets.only(left: 5),
                                      child: infoWidget()))
                              : Container(),
                        );
                      },
                      child: Container(),
                    ),
                  ),
                  // SpacerWidget(_KVertcalSpace / 5),
                  !widget.assessmentDetailPage!
                      ? Column(
                          children: [
                            resultTitle(),
                            ValueListenableBuilder(
                                valueListenable: assessmentCount,
                                builder: (BuildContext context, int listCount,
                                    Widget? child) {
                                  return FutureBuilder(
                                      future: Utility.getStudentInfoList(
                                          tableName:
                                              widget.assessmentDetailPage ==
                                                      true
                                                  ? 'history_student_info'
                                                  : 'student_info'),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<
                                                  List<StudentAssessmentInfo>>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data!.length != 0) {
                                            questionImageUrl = snapshot
                                                .data![0].questionImgUrl;
                                          }

                                          return listView(
                                            snapshot.data!,
                                          );
                                        }
                                        return CircularProgressIndicator();
                                      });
                                }),
                            BlocListener<GoogleDriveBloc, GoogleDriveState>(
                                bloc: _driveBloc2,
                                child: Container(),
                                listener: (context, state) async {
                                  if (state is GoogleDriveLoading) {
                                    Utility.showLoadingDialog(context, true);
                                  }
                                  if (state is GoogleSuccess) {
                                    Navigator.of(context).pop();
                                  }
                                  if (state is ErrorState) {
                                    if (state.errorMsg ==
                                        'Reauthentication is required') {
                                      await Utility.refreshAuthenticationToken(
                                          isNavigator: true,
                                          errorMsg: state.errorMsg!,
                                          context: context,
                                          scaffoldKey: scaffoldKey);

                                      _driveBloc2.add(UpdateDocOnDrive(
                                        questionImage: questionImageUrl ?? "NA",
                                        createdAsPremium: createdAsPremium,
                                        assessmentName: Globals.assessmentName!,
                                        fileId: Globals.googleExcelSheetId,
                                        isLoading: true,
                                        studentData:
                                            //list2
                                            await Utility.getStudentInfoList(
                                                tableName:
                                                    widget.assessmentDetailPage ==
                                                            true
                                                        ? 'history_student_info'
                                                        : 'student_info'),
                                      ));
                                    } else {
                                      Navigator.of(context).pop();
                                      Utility.currentScreenSnackBar(
                                          "Something Went Wrong. Please Try Again.");
                                    }

                                    // Navigator.of(context).pop();
                                    // Utility.currentScreenSnackBar(
                                    //     "Something Went Wrong. Please Try Again.");
                                  }
                                }),
                          ],
                        )
                      : BlocConsumer(
                          bloc: _driveBloc,
                          builder:
                              (BuildContext contxt, GoogleDriveState state) {
                            if (state is GoogleDriveLoading2) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant,
                                )),
                              );
                            }

                            if (state is AssessmentDetailSuccess) {
                              if (state.obj.length > 0) {
                                // isGoogleSheetStateRecived = true;

                                // savedRecordCount != null
                                //     ? savedRecordCount == state.obj.length
                                //         ? dashoardState.value = 'Success'
                                //         : dashoardState.value = ''
                                //     : print("");

                                return Column(
                                  children: [
                                    resultTitle(),
                                    FutureBuilder(
                                        future: Utility.getStudentInfoList(
                                            tableName:
                                                widget.assessmentDetailPage ==
                                                        true
                                                    ? 'history_student_info'
                                                    : 'student_info'),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<
                                                    List<StudentAssessmentInfo>>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            if (snapshot.data!.length != 0) {
                                              questionImageUrl = snapshot
                                                  .data![0].questionImgUrl;
                                            }
                                            return listView(snapshot.data!);
                                          }
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.7,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryVariant,
                                            )),
                                          );
                                        })
                                  ],
                                );
                              } else {
                                return Expanded(
                                  child: NoDataFoundErrorWidget(
                                      isResultNotFoundMsg: true,
                                      isNews: false,
                                      isEvents: false),
                                );
                              }
                            }
                            if (state is AssessmentDetailSuccess) {
                              if (state.obj.length > 0) {
                                return Column(
                                  children: [
                                    resultTitle(),
                                    listView(
                                      state.obj,
                                    )
                                  ],
                                );
                              } else {
                                return Expanded(
                                  child: NoDataFoundErrorWidget(
                                      isResultNotFoundMsg: true,
                                      isNews: false,
                                      isEvents: false),
                                );
                              }
                            }

                            return Container();
                          },
                          listener: (BuildContext contxt,
                              GoogleDriveState state) async {
                            if (state is AssessmentDetailSuccess) {
                              if (state.obj.length > 0) {
                                if (await Utility.getStudentInfoListLength(
                                        tableName: 'history_student_info') ==
                                    0) {
                                  state.obj.forEach((e) async {
                                    //print(
                                    // 'ffffffffffffffffffffffffffffffffffff');
                                    await _historyStudentInfoDb.addData(e);
                                  });
                                }

                                isGoogleSheetStateRecived = true;

                                savedRecordCount != null
                                    ? savedRecordCount == state.obj.length
                                        ? dashoardState.value = 'Success'
                                        : dashoardState.value = ''
                                    : print("");

                                sheetrubricScore =
                                    state.obj.first.scoringRubric;
                                webContentLink = state.webContentLink;
                                isSuccessStateRecived.value = true;
                                infoIconValue.value = true;
                                historyRecordList = state.obj;

                                assessmentCount.value = state.obj.length;
                              }
                            } else if (state is ErrorState) {
                              if (state.errorMsg ==
                                  'Reauthentication is required') {
                                await Utility.refreshAuthenticationToken(
                                    isNavigator: false,
                                    errorMsg: state.errorMsg!,
                                    context: context,
                                    scaffoldKey: scaffoldKey);

                                _driveBloc.add(GetAssessmentDetail(
                                    fileId: widget.fileId, nextPageUrl: ''));
                              } else {
                                Navigator.of(context).pop();
                                Utility.currentScreenSnackBar(
                                    "Something Went Wrong. Please Try Again.");
                              }
                            }
                          },
                        ),
                  Container(
                    height: 0,
                    width: 0,
                    child: BlocListener<OcrBloc, OcrState>(
                        bloc: _ocrBloc,
                        listener: (context, state) async {
                          if (state is OcrLoading) {
                            dashoardState.value = 'Loading';
                          } else if (state is AssessmentSavedSuccessfully) {
                            //To update slidable action buttons : Enable/Disable
                            disableSlidableAction.value = true;

                            dashoardState.value = 'Success';
                            Utility.updateLoges(
                                // accountType: 'Free',
                                activityId: '14',
                                description: 'Save to deshboard success',
                                operationResult: 'Success');
                            List<StudentAssessmentInfo> studentInfo =
                                await Utility.getStudentInfoList(
                                    tableName:
                                        widget.assessmentDetailPage == true
                                            ? 'history_student_info'
                                            : 'student_info');

                            studentInfo.asMap().forEach((index, element) async {
                              StudentAssessmentInfo element =
                                  studentInfo[index];
                              //Disabling all the existing records edit functionality. Only scan more records will be allowed to edit.
                              if (element.isSavedOnDashBoard == null) {
                                element.isSavedOnDashBoard = true;
                              }
                              await _studentInfoDb.putAt(index, element);
                            });

                            List list = await Utility.getStudentInfoList(
                                tableName: 'student_info');
                            assessmentCount.value = list.length;

                            Globals.scanMoreStudentInfoLength = list.length;
                            //print(Globals.scanMoreStudentInfoLength);
                            // _driveBloc.add(UpdateDocOnDrive(
                            //   isLoading: false,
                            //     fileId: widget.fileId,
                            //     studentData: Globals.studentInfo!)
                            //     );

                            _showDataSavedPopup(
                                historyAssessmentSection: false,
                                title: 'Saved To Data Dashboard',
                                msg:
                                    'Yay! Assessment data has been successfully added to your school’s Data Dashboard.',
                                noActionText: 'No',
                                yesActionText: 'Perfect!');

                            // Utility.showSnackBar(
                            //     scaffoldKey,
                            //     'Yay! Data has been successully saved to the dashboard',
                            //     context,
                            //     null);

                          } else if (state is OcrErrorReceived) {
                            disableSlidableAction.value = false;
                          }
                          if (state is AssessmentDashboardStatus) {
                            if (state.assessmentId == null &&
                                state.resultRecordCount == null) {
                              dashoardState.value = '';
                            } else {
                              if (isGoogleSheetStateRecived == true) {
                                List list = await Utility.getStudentInfoList(
                                    tableName: 'history_student_info');

                                state.resultRecordCount == list.length
                                    ? dashoardState.value = 'Success'
                                    : dashoardState.value = '';
                              }
                              // dashboardWidget.value[0] = true;

                              savedRecordCount = state.resultRecordCount;
                              historyAssessmentId = state.assessmentId;
                            }
                          }
                          if (state is OcrLoading2) {
                            dashoardState.value = 'Loading';
                          }
                        },
                        child: EmptyContainer()),
                  ),
                ],
              ),
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!widget.assessmentDetailPage!) _scanFloatingWidget(),
                SpacerWidget(10),
                !widget.assessmentDetailPage!
                    ? _bottomButtons(context, iconsList, iconsName,
                        webContentLink: Globals.googleDriveFolderPath ?? '')
                    : ValueListenableBuilder(
                        valueListenable: isSuccessStateRecived,
                        child: Container(),
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return isSuccessStateRecived.value == true
                              ? Column(
                                  children: [
                                    _scanFloatingWidget(),
                                    SpacerWidget(10),
                                    _bottomButtons(
                                        context, iconsList, iconsName,
                                        webContentLink: webContentLink!),
                                  ],
                                )
                              : Container();
                        }),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        ],
      ),
    );
  }

  Widget resultTitle() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          height: 50.0,
          margin:
              const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Theme.of(context).backgroundColor == Color(0xff000000)
                ? Color(0xff162429)
                : Color(0xffF7F8F9),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.5), //Colors.grey,
                // Theme.of(context).backgroundColor == Color(0xff000000)
                //     ? Color(0xff162429)
                //     : Color(0xffE9ECEE),
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Container(
              child: ListTile(
            leading: Utility.textWidget(
                text: 'Student Name',
                context: context,
                textTheme: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontWeight: FontWeight.bold)),
            trailing: Utility.textWidget(
                text: 'Points Earned',
                context: context,
                textTheme: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontWeight: FontWeight.bold)),
          )),
        ),
      ),
    );
  }

  Widget _iconButton(int index, List iconName,
      {required String webContentLink}) {
    return ValueListenableBuilder(
        valueListenable: dashoardState,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding:
                    // index == 3 && dashoardState.value == 'Loading'
                    //     ? EdgeInsets.only(bottom: 10)
                    //     :
                    EdgeInsets.only(top: 10),
                child: Utility.textWidget(
                    text: iconName[index],
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              index == 1
                  ? Expanded(
                      child: InkWell(
                        onTap: () {
                          Utility.updateLoges(
                              activityId: '16',
                              sessionId: widget.assessmentDetailPage == true
                                  ? widget.obj!.sessionId
                                  : '',
                              description: widget.assessmentDetailPage == true
                                  ? 'Drive Button pressed from Assessment History Detail Page'
                                  : 'Drive Button pressed from Result Summary',
                              operationResult: 'Success');
                          Globals.googleDriveFolderPath != null
                              ? Utility.launchUrlOnExternalBrowser(
                                  Globals.googleDriveFolderPath!)
                              : getGoogleFolderPath();

                          // Utility.launchUrlOnExternalBrowser(webContentLink);
                        },
                        child: Container(
                          //    margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: Image(
                            width: Globals.deviceType == "phone" ? 35 : 50,
                            height: Globals.deviceType == "phone" ? 35 : 50,
                            image: AssetImage(
                              "assets/images/drive_ico.png",
                            ),
                          ),
                        ),
                      ),
                    )
                  : (widget.assessmentDetailPage! ? index == 2 : index == 3) &&
                          dashoardState.value == 'Loading'
                      ? GestureDetector(
                          onTap: () {
                            // Utility.showSnackBar(
                            //     scaffoldKey,
                            //     'Please wait! Saving is in progress',
                            //     context,
                            //     null);
                          },
                          child: Container(
                              padding: EdgeInsets.only(bottom: 14, top: 10),
                              height:
                                  MediaQuery.of(context).size.height * 0.058,
                              width: MediaQuery.of(context).size.width * 0.058,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                              )),
                        )
                      : Expanded(
                          child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: index == 0 &&
                                      !widget.assessmentDetailPage! &&
                                      widget.isScanMore == null
                                  ?
                                  //Calling builder in case of result summary (Not detail page)

                                  BlocConsumer(
                                      bloc: _driveBloc,
                                      builder: (context, state) {
                                        if (state is ShareLinkRecived) {
                                          widget.shareLink = state.shareLink;

                                          return Icon(
                                            IconData(iconsList[index],
                                                fontFamily: Overrides.kFontFam,
                                                fontPackage:
                                                    Overrides.kFontPkg),
                                            size: (widget.assessmentDetailPage!
                                                        ? index == 2
                                                        : index == 3) &&
                                                    dashoardState.value == ''
                                                ? Globals.deviceType == 'phone'
                                                    ? 38
                                                    : 45
                                                : Globals.deviceType == 'phone'
                                                    ? 32
                                                    : 45,
                                            color: AppTheme.kButtonColor,
                                          );
                                        }

                                        return Container(
                                            padding: EdgeInsets.only(
                                                bottom: 14, top: 10),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.058,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.058,
                                            alignment: Alignment.center,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryVariant,
                                            )));
                                      },
                                      listener: (context, state) async {
                                        if (state is ErrorState) {
                                          if (state.errorMsg ==
                                              'Reauthentication is required') {
                                            await Utility
                                                .refreshAuthenticationToken(
                                                    isNavigator: false,
                                                    errorMsg: state.errorMsg!,
                                                    context: context,
                                                    scaffoldKey: scaffoldKey);

                                            _driveBloc.add(GetShareLink(
                                                fileId: widget.fileId));
                                          } else {
                                            Navigator.of(context).pop();
                                            Utility.currentScreenSnackBar(
                                                "Something Went Wrong. Please Try Again.");
                                          }
                                        }
                                      },
                                    )
                                  : dashoardWidget(index: index),
                              onPressed: () async {
                                if (index == 0) {
                                  Utility.updateLoges(
                                      activityId: '13',
                                      sessionId:
                                          widget.assessmentDetailPage == true
                                              ? widget.obj!.sessionId
                                              : '',
                                      description: widget
                                                  .assessmentDetailPage ==
                                              true
                                          ? 'Share Button pressed from Assessment History Detail Page'
                                          : 'Share Button pressed from Result Summary',
                                      operationResult: 'Success');
                                  widget.shareLink != null &&
                                          widget.shareLink!.isNotEmpty
                                      ? Share.share(widget.shareLink!)
                                      : print("no link ");
                                } else if (!widget.assessmentDetailPage! &&
                                    // ? index == 1
                                    // :
                                    index == 2) {
                                  Utility.updateLoges(
                                      activityId: '15',
                                      description:
                                          'History Assesment button pressed',
                                      operationResult: 'Success');

                                  _showDataSavedPopup(
                                      historyAssessmentSection: true,
                                      title: 'Action Required',
                                      msg:
                                          'If you navigate to the history section, You will not be able to return back to the current screen. \n\nDo you still want to move forward?',
                                      noActionText: 'No',
                                      yesActionText: 'Yes, Take Me There');
                                } else if ((widget.assessmentDetailPage!
                                        ? index == 2
                                        : index == 3) &&
                                    dashoardState.value == '') {
                                  if (Globals.isPremiumUser) {
                                    if (widget.assessmentDetailPage == true &&
                                        widget.createdAsPremium == false) {
                                      Utility.updateLoges(
                                          // ,
                                          activityId: '14',
                                          description:
                                              'Oops! Teacher cannot save the assessment to the dashboard which was scanned before the premium account',
                                          operationResult: 'Failed');
                                      popupModal(
                                          title: 'Data Not Saved',
                                          message:
                                              'Oops! You cannot save the assessment to the dashboard which was scanned before the premium account. If you still want to save this to the Dashboard, Please rescan the assessment.');
                                      Globals.scanMoreStudentInfoLength =
                                          await Utility
                                                  .getStudentInfoListLength(
                                                      tableName:
                                                          'student_info') -
                                              1;
                                    } else {
                                      List list =
                                          await Utility.getStudentInfoList(
                                              tableName: 'student_info');
                                      if (widget.isScanMore == true &&
                                          widget.assessmentListLenght != null &&
                                          widget.assessmentListLenght! <
                                              list.length) {
                                        Utility.updateLoges(
                                            // accountType: 'Free',
                                            activityId: '14',
                                            description:
                                                'Save to deshboard pressed in case for scanmore',
                                            operationResult: 'Success');
                                        //print(
                                        // 'if     calling is scanMore -------------------------->');
                                        //print(widget.assessmentListLenght);
                                        _ocrBloc.add(SaveAssessmentToDashboard(
                                            assessmentId: !widget
                                                    .assessmentDetailPage!
                                                ? Globals.currentAssessmentId
                                                : historyAssessmentId ?? '',
                                            assessmentSheetPublicURL:
                                                widget.shareLink,
                                            resultList: await Utility
                                                .getStudentInfoList(
                                                    tableName: widget
                                                                .assessmentDetailPage ==
                                                            true
                                                        ? 'history_student_info'
                                                        : 'student_info'),
                                            previouslyAddedListLength:
                                                widget.assessmentListLenght,
                                            assessmentName:
                                                widget.asssessmentName!,
                                            rubricScore:
                                                widget.rubricScore ?? '',
                                            subjectId: widget.subjectId ?? '',
                                            schoolId: Globals.appSetting
                                                .schoolNameC!, //Account Id
                                            // standardId: widget.standardId ?? '',
                                            scaffoldKey: scaffoldKey,
                                            context: context,
                                            isHistoryAssessmentSection:
                                                widget.assessmentDetailPage!));
                                      } else {
                                        //print(
                                        // 'else      calling is noramal -------------------------->');
                                        // Adding the non saved record of dashboard in the list
                                        List<StudentAssessmentInfo>
                                            _listRecord = [];

                                        if (widget.assessmentDetailPage! &&
                                            savedRecordCount != null &&
                                            historyRecordList.length !=
                                                savedRecordCount!) {
                                          _listRecord =
                                              historyRecordList.sublist(
                                                  savedRecordCount!,
                                                  historyRecordList.length);
                                        } else {
                                          //
                                          _listRecord = historyRecordList;
                                        }

                                        _ocrBloc.add(SaveAssessmentToDashboard(
                                          assessmentId:
                                              !widget.assessmentDetailPage!
                                                  ? Globals.currentAssessmentId
                                                  : historyAssessmentId ?? '',
                                          assessmentSheetPublicURL:
                                              widget.shareLink,
                                          resultList: !widget
                                                  .assessmentDetailPage!
                                              ? await Utility
                                                  .getStudentInfoList(
                                                      tableName: 'student_info')
                                              : _listRecord,
                                          assessmentName:
                                              widget.asssessmentName!,
                                          rubricScore:
                                              !widget.assessmentDetailPage!
                                                  ? widget.rubricScore ?? ''
                                                  : sheetrubricScore ?? '',
                                          subjectId: widget.subjectId ?? '',
                                          schoolId: Globals.appSetting
                                              .schoolNameC!, //Account Id
                                          // standardId: widget.standardId ?? '',
                                          scaffoldKey: scaffoldKey,
                                          context: context,
                                          isHistoryAssessmentSection:
                                              widget.assessmentDetailPage!,
                                          fileId: widget.fileId ?? '',
                                        ));
                                      }
                                    }
                                  } else {
                                    Utility.updateLoges(
                                        // ,
                                        activityId: '14',
                                        description:
                                            'Free User tried to save the data to the dashboard',
                                        operationResult: 'Failed');
                                    popupModal(
                                        title: 'Upgrade To Premium',
                                        message:
                                            'This is a premium feature. To view a sample dashboard, click here: \nhttps://datastudio.google.com/u/0/reporting/75743c2d-5749-45e7-9562-58d0928662b2/page/p_79velk1hvc \n\nTo speak to SOLVED about obtaining the premium version of GRADED+, including a custom data Dashboard, email admin@solvedconsulting.com');
                                  }
                                  // }
                                } else if (dashoardState.value == 'Success') {
                                  popupModal(
                                      title: 'Already Saved',
                                      message:
                                          'The data has already been saved to the data dashboard.');
                                }
                              }),
                        ),
            ],
          );
        });
  }

  Widget listView(List<StudentAssessmentInfo> _list) {
    return ValueListenableBuilder<bool>(
        valueListenable: disableSlidableAction,
        child: Container(),
        builder: (BuildContext context, bool value, Widget? child) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height *
                    0.08), //For bottom padding from FAB
            height: widget.assessmentDetailPage!
                ? (MediaQuery.of(context).orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height * 0.55
                    : MediaQuery.of(context).size.height * 0.45)
                : (MediaQuery.of(context).orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height * 0.57
                    : MediaQuery.of(context).size.height * 0.45),
            child: ListView.builder(
              //padding:widget.assessmentDetailPage==true? EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.06):null,
              controller: _scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 25), //AppTheme.klistPadding),
              scrollDirection: Axis.vertical,
              itemCount: _list.length, // Globals.gradeList.length,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                    enabled: widget.assessmentDetailPage == true ? false : true,
                    // Specify a key if the Slidable is dismissible.
                    key: ValueKey(index),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          // An action can be bigger than the others.

                          onPressed: (i) {
                            //To reset the value listener
                            disableSlidableAction.value = false;

                            //print(i);
                            _list[index].isSavedOnDashBoard == null
                                ? performEditAndDelete(context, index, true)
                                : Utility.currentScreenSnackBar(
                                    "You Cannot Edit The Record Which Is Already Saved To The \'Data Dashboard\'");
                          },
                          backgroundColor:
                              _list[index].isSavedOnDashBoard == null
                                  ? AppTheme.kButtonColor
                                  : Colors.grey,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (i) {
                            //To reset the value listener
                            disableSlidableAction.value = false;

                            _list[index].isSavedOnDashBoard == null
                                ? performEditAndDelete(context, index, false)
                                : Utility.currentScreenSnackBar(
                                    "You Cannot Delete The Record Which Is Already Saved To The \'Data Dashboard\'");
                          },
                          backgroundColor:
                              _list[index].isSavedOnDashBoard == null
                                  ? Colors.red
                                  : Colors.grey,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: _buildList(index, _list, context));
              },
            ),
          );
        });
  }

  Widget _buildList(int index, List<StudentAssessmentInfo> _list, context) {
    return _list[index].studentName == 'Name'
        ? Container()
        : Container(
            height: 54,
            padding: EdgeInsets.symmetric(
              horizontal: 5,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0.0),
                color: (index % 2 == 0)
                    ? Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? AppTheme.klistTilePrimaryDark
                        : AppTheme
                            .klistTilePrimaryLight //Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? AppTheme.klistTileSecoandryDark
                        : AppTheme
                            .klistTileSecoandryLight //Theme.of(context).colorScheme.secondary,
                ),
            child: ListTile(
              onTap: (() => showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (_) =>
                      ImagePopup(imageURL: _list[index].assessmentImage!))),
              visualDensity: VisualDensity(horizontal: 0, vertical: 0),
              // contentPadding:
              //     EdgeInsets.only(left: _kLabelSpacing, right: _kLabelSpacing / 2),
              leading:
                  // Text('Unknown'),
                  Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Utility.textWidget(
                    text: _list[index].studentName == '' ||
                            _list[index].studentName == null
                        ? 'Unknown'
                        : _list[index].studentName!,
                    maxLines: 2,
                    context: context,
                    textTheme: Theme.of(context).textTheme.headline2!),
              ),

              trailing:
                  // Text(_list[index].pointpossible!),
                  Utility.textWidget(
                      text: //'2/2',
                          _list[index].studentGrade == '' ||
                                  _list[index].studentGrade == null
                              ? '2/${_list[index].pointpossible ?? '2'}'
                              : '${_list[index].studentGrade}/${_list[index].pointpossible ?? '2'}', // '${Globals.gradeList[index]} /2',
                      context: context,
                      textTheme: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(fontWeight: FontWeight.bold)),
            ),
          );
  }

  Widget _scanFloatingWidget() {
    return ValueListenableBuilder<bool>(
        valueListenable: isScrolling,
        child: Container(),
        builder: (BuildContext context, bool value, Widget? child) {
          return Container(
            //margin: EdgeInsets.only(left: 15),
            alignment: Alignment.center,
            // width: isScrolling.value ? null : 130,
            child: FloatingActionButton.extended(
                isExtended: !isScrolling.value,
                backgroundColor: AppTheme.kButtonColor,
                onPressed: () async {
                  // Globals.scanMoreStudentInfoLength =
                  //     Globals.studentInfo!.length;
                  if ((widget.assessmentDetailPage == true) &&
                      ((widget.createdAsPremium == true &&
                              Globals.isPremiumUser != true) ||
                          (widget.createdAsPremium == false &&
                              Globals.isPremiumUser == true))) {
                    popupModal(
                        title: 'Alert!',
                        message: Globals.isPremiumUser == true
                            ? 'Oops! You are currently a "Premium" user. You cannot update the assessment that you created as a "Free" user. You can start with a fresh scan as a Premium user.'
                            : 'Opps! You are currently a "Free" user. You cannot update the assessment that you created as a "Premium" user. If you still want to edit this assessment then please upgrade to Premium. You can still create new assessments as Free user.');
                    return;
                  }

                  Utility.updateLoges(
                      //,
                      activityId: '22',
                      sessionId: widget.assessmentDetailPage == true
                          ? widget.obj!.sessionId
                          : '',
                      description: widget.assessmentDetailPage == true
                          ? 'Scan more button pressed from Assessment History Detail Page'
                          : 'Scan more button pressed from Result Summary',
                      operationResult: 'Success');

                  if (widget.obj != null &&
                      widget.obj!.isCreatedAsPremium == "true") {
                    createdAsPremium = true;
                  }
                  String pointPossiable = await _getPointPossiable(
                      tableName: widget.assessmentDetailPage == true
                          ? 'history_student_info'
                          : 'student_info');

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraScreen(
                              isFlashOn: ValueNotifier<bool>(false),
                              questionImageLink: questionImageUrl,
                              obj: widget.obj,
                              createdAsPremium:
                                  widget.assessmentDetailPage == true
                                      ? createdAsPremium
                                      : Globals.isPremiumUser,
                              oneTimeCamera: widget.assessmentDetailPage!,
                              isFromHistoryAssessmentScanMore:
                                  widget.assessmentDetailPage!,
                              onlyForPicture: false,
                              isScanMore: true,
                              // lastStudentInfoLenght: Globals.studentInfo!.length,
                              pointPossible: pointPossiable != null &&
                                      pointPossiable.isNotEmpty
                                  ? pointPossiable
                                  : '2')));
                },
                icon: Icon(
                    IconData(0xe875,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: Theme.of(context).backgroundColor,
                    size: 16),
                label: Utility.textWidget(
                    text: isScrolling.value ? '' : 'Scan More',
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Theme.of(context).backgroundColor))),
          );
        });
  }

  Widget _bottomButtons(context, List iconsList, List iconName,
      {required String webContentLink}) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor == Color(0xff000000)
                ? Color(0xff162429)
                : Color(0xffF7F8F9),
            // color: Theme.of(context).backgroundColor,
            boxShadow: [
              new BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 20.0,
              ),
            ],
            borderRadius: BorderRadius.circular(4)),
        margin: widget.assessmentDetailPage!
            ? EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.20,
                right: MediaQuery.of(context).size.width * 0.20)
            : !widget.assessmentDetailPage!
                ? EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.0,
                    right: MediaQuery.of(context).size.width * 0.0)
                : Globals.deviceType == 'tablet'
                    ? EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.03)
                    : null,
        padding: Globals.deviceType == 'tablet'
            ? EdgeInsets.symmetric(horizontal: 20)
            : EdgeInsets.symmetric(horizontal: 8),
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.086
            : MediaQuery.of(context).size.width * 0.086,
        width: widget.assessmentDetailPage!
            ? MediaQuery.of(context).size.width * 0.7
            : MediaQuery.of(context).size.width * 0.9,
        //  color: Colors.blue,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: iconsList
              .map<Widget>((element) => _iconButton(
                  iconsList.indexOf(element), iconName,
                  webContentLink: webContentLink))
              .toList(),
          // [
          //  // Container()
          // ]
        ));
  }

  _showDataSavedPopup(
      {required bool? historyAssessmentSection,
      required String? title,
      required String? msg,
      required String? yesActionText,
      required String? noActionText}) {
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
                        message: title, //"Saved To Data Dashboard",
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) {
                          return Text(translatedMessage.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(color: AppTheme.kButtonColor));
                        }),
                  ),
                ),
                content: TranslationWidget(
                    message: msg,
                    //'Yay! Assessment data has been successfully added to your school’s Data Dashboard.',
                    //     'Yay! Data has been successully saved to the dashboard',
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) {
                      return Text(translatedMessage.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.black));
                    }),
                actions: <Widget>[
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.height,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  if (historyAssessmentSection == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          child: FittedBox(
                            child: TranslationWidget(
                                message: noActionText ?? "NO",
                                fromLanguage: "en",
                                toLanguage: Globals.selectedLanguage,
                                builder: (translatedMessage) {
                                  return Text(translatedMessage.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                            fontSize: 16,
                                            color: AppTheme.kButtonColor,
                                          ));
                                }),
                          ),
                          onPressed: () {
                            //Globals.iscameraPopup = false;
                            Navigator.of(context).pop();
                          },
                        ),
                        Container(
                          height: 35,
                          width: 1,
                          color: Colors.grey[300],
                        ),
                        TextButton(
                          child: FittedBox(
                            child: TranslationWidget(
                                message: yesActionText ?? "OK ",
                                fromLanguage: "en",
                                toLanguage: Globals.selectedLanguage,
                                builder: (translatedMessage) {
                                  return Text(translatedMessage.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                            fontSize: 16,
                                            color: yesActionText ==
                                                    'Yes, Take Me There'
                                                ? Colors.red
                                                : AppTheme.kButtonColor,
                                          ));
                                }),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            if (yesActionText != null) {
                              await _historyStudentInfoDb.clear();
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssessmentSummary(
                                        isFromHomeSection: false,
                                      )),
                            );

                            //Globals.iscameraPopup = false;
                          },
                        ),
                      ],
                    ),
                  if (historyAssessmentSection == false)
                    Center(
                      child: TextButton(
                        child: TranslationWidget(
                            message: "OK ",
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
                          Navigator.of(context).pop();

                          //Globals.iscameraPopup = false;
                        },
                      ),
                    )
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              );
            }));
  }

  getGoogleFolderPath() async {
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();
    Utility.showSnackBar(scaffoldKey,
        "Unable To Navigate At The Moment. Please Try Again.", context, null);

    _driveBloc.add(GetDriveFolderIdEvent(
        isFromOcrHome: false,
        //  filePath: file,
        token: _profileData[0].authorizationToken,
        folderName: "SOLVED GRADED+",
        refreshtoken: _profileData[0].refreshToken));
  }

  performEditAndDelete(BuildContext context, int index, bool? edit) async {
    List<StudentAssessmentInfo> studentInfo =
        await Utility.getStudentInfoList(tableName: 'student_info');
    if (edit!) {
      Utility.updateLoges(
          // ,
          activityId: '17',
          description: 'Teacher edited the record',
          operationResult: 'Success');

      editingStudentNameController.text = studentInfo[index].studentName!;
      editingStudentIdController.text = studentInfo[index].studentId!;
      editingStudentScoreController.text = studentInfo[index].studentGrade!;

      editBottomSheet(
          controllerOne: editingStudentNameController,
          controllerTwo: editingStudentIdController,
          controllerThree: editingStudentScoreController,
          index: index);
    } else {
      //  Globals.studentInfo!.length > 2
      if (studentInfo.length > 1) {
        _deletePopUP(
            //    studentName: Globals.studentInfo![index].studentName!,
            studentName: studentInfo[index].studentName!,
            index: index);
      } else {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Utility.currentScreenSnackBar(
            "Action Not Performed. Result List Cannot Be Empty.");
      }
    }
  }

  editBottomSheet(
      {required TextEditingController controllerOne,
      required TextEditingController controllerTwo,
      required TextEditingController controllerThree,
      required int index}) {
    showModalBottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        // animationCurve: Curves.easeOutQuart,
        elevation: 10,
        context: context,
        builder: (context) => EditBottomSheet(
              textFieldControllerthree: controllerThree,
              textFieldControllerOne: controllerOne,
              textFieldControllerTwo: controllerTwo,
              sheetHeight: MediaQuery.of(context).size.height * 0.6,
              title: 'Edit Student Details',
              isImageField: false,
              textFieldTitleOne: 'Student Name',
              textFieldTitleTwo: 'Student Id',
              textFileTitleThree: "Student Grade",
              isSubjectScreen: false,
              update: (
                  {required TextEditingController name,
                  required TextEditingController id,
                  required TextEditingController score}) async {
                List<StudentAssessmentInfo> _list =
                    await Utility.getStudentInfoList(tableName: 'student_info');
                StudentAssessmentInfo studentInfo = _list[index];

                studentInfo.studentName = name.text;
                studentInfo.studentId = id.text;
                studentInfo.studentGrade = score.text;
                _studentInfoDb.putAt(index, studentInfo);
                assessmentCount.value = _list.length;

                _futurMethod();
                _method();
                disableSlidableAction.value = true;

                Navigator.pop(context);

                _driveBloc2.add(UpdateDocOnDrive(
                  questionImage: questionImageUrl ?? "NA",
                  createdAsPremium: Globals.isPremiumUser,
                  assessmentName: Globals.assessmentName!,
                  fileId: Globals.googleExcelSheetId,
                  isLoading: true,
                  studentData:
                      //list2
                      await Utility.getStudentInfoList(
                          tableName: 'student_info'),
                ));

                // assessmentCount.value = await Utility.getStudentInfoListLength(
                //           tableName: 'student_info');
                // sudentRecordList.value = Utility.getStudentInfoList(
                //           tableName: 'student_info');
              },
            ));
  }

  _deletePopUP({required String studentName, required int index}) {
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
                        message: "Delete Record",
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) {
                          return Text(translatedMessage.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(color: Colors.red));
                        }),
                  ),
                ),
                content: TranslationWidget(
                    message: 'You are about to delete the record - ',
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) {
                      return RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(text: translatedMessage),
                            TextSpan(
                                text: '"$studentName"',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );

                      //  Text(translatedMessage.toString(),
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .headline2!
                      //         .copyWith(color: Colors.black));
                    }),
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
                            message: "Keep the record",
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
                          Navigator.pop(
                            context,
                          );
                        },
                      ),
                      TextButton(
                        child: TranslationWidget(
                            message: "Delete ",
                            fromLanguage: "en",
                            toLanguage: Globals.selectedLanguage,
                            builder: (translatedMessage) {
                              return Text(translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: Colors.red,
                                      ));
                            }),
                        onPressed: () async {
                          List<StudentAssessmentInfo> _list =
                              await Utility.getStudentInfoList(
                                  tableName: 'student_info');
                          if (index == 0) {
                            StudentAssessmentInfo obj = _list[1];
                            obj.className = _list[0].className;
                            obj.subject = _list[0].subject;
                            obj.studentGrade = _list[0].studentGrade;
                            obj.learningStandard = _list[0].learningStandard;
                            obj.subLearningStandard =
                                _list[0].subLearningStandard;
                            obj.scoringRubric = _list[0].scoringRubric;
                            obj.customRubricImage = _list[0].customRubricImage;
                            obj.grade = _list[0].grade;
                            obj.questionImgUrl = _list[0].questionImgUrl;
                            _studentInfoDb.putAt(0, obj);
                          }
                          _studentInfoDb.deleteAt(index);

                          Utility.updateLoges(
                              activityId: '17',
                              description:
                                  'Teacher Deleted the record successfully',
                              operationResult: 'Success');

                          // List _list = await Utility.getStudentInfoList(
                          //     tableName: 'student_info');
                          assessmentCount.value = _list.length - 1;
                          _futurMethod();
                          _method();
                          // sudentRecordList.value = Globals.studentInfo!;
                          Navigator.pop(
                            context,
                          );

                          _driveBloc2.add(UpdateDocOnDrive(
                              questionImage: questionImageUrl ?? "NA",
                              createdAsPremium: Globals.isPremiumUser,
                              assessmentName: Globals.assessmentName!,
                              fileId: Globals.googleExcelSheetId,
                              isLoading: true,
                              studentData:
                                  //list2
                                  await Utility.getStudentInfoList(
                                      tableName: 'student_info')));
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

  popupModal({required String message, required String? title}) {
    return showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return CommonPopupWidget(
                  orientation: orientation,
                  context: context,
                  message: message,
                  title: title!);
            }));
  }

  Future _method() async {
    List list = await Utility.getStudentInfoList(tableName: 'student_info');
    assessmentCount.value = list.length;

    if (Globals.scanMoreStudentInfoLength != null) {
      if (list.length == Globals.scanMoreStudentInfoLength) {
        dashoardState.value = 'Success';
      }
    }
  }

  void _futurMethod() async {
    _listCount.value =
        await Utility.getStudentInfoListLength(tableName: 'student_info');
  }

  Widget dashoardWidget({required int index}) {
    return Icon(
      IconData(
          (widget.assessmentDetailPage! ? index == 2 : index == 3) &&
                  dashoardState.value == 'Success'
              ? 0xe877
              : iconsList[index],
          fontFamily: Overrides.kFontFam,
          fontPackage: Overrides.kFontPkg),
      size: (widget.assessmentDetailPage! ? index == 2 : index == 3) &&
              dashoardState.value == ''
          ? Globals.deviceType == 'phone'
              ? 38
              : 55
          : Globals.deviceType == 'phone'
              ? 32
              : 48,
      color: (widget.assessmentDetailPage! &&
                  index == 2 &&
                  isAssessmentAlreadySaved == 'YES') ||
              (widget.assessmentDetailPage! &&
                  index == 2 &&
                  dashoardState.value == 'Success')
          ? Colors.green
          : index == 2 || (index == 3 && dashoardState.value == '')
              ? Theme.of(context).backgroundColor == Color(0xff000000)
                  ? Colors.white
                  : Colors.black
              : (widget.assessmentDetailPage! ? index == 2 : index == 3) &&
                      dashoardState.value == 'Success'
                  ? Colors.green
                  : AppTheme.kButtonColor,
    );
  }

  void _showPopUp({required StudentAssessmentInfo studentAssessmentInfo}) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CustomDialogBox(
            title: widget.asssessmentName == null
                ? 'Asssessment Name'
                : widget.asssessmentName!,
            height: MediaQuery.of(context).size.height * 0.53,
            // width: MediaQuery.of(context).size.width * 0.,
            studentAssessmentInfo: studentAssessmentInfo,
            profileData: null,
            isUserInfoPop: false,
          );
        });
  }

  Widget infoWidget() {
    return IconButton(
      padding: EdgeInsets.only(top: 2),
      onPressed: () async {
        List<StudentAssessmentInfo> list = await Utility.getStudentInfoList(
            tableName: widget.assessmentDetailPage == true
                ? 'history_student_info'
                : 'student_info');
        _showPopUp(studentAssessmentInfo: list.first);
      },
      icon: Icon(
        Icons.info,
        size: Globals.deviceType == 'tablet' ? 35 : null,
        color: Color(0xff000000) != Theme.of(context).backgroundColor
            ? Color(0xff111C20)
            : Color(0xffF7F8F9), //Colors.grey.shade400,
      ),
    );
  }

  Future<String> _getPointPossiable({required String tableName}) async {
    List<StudentAssessmentInfo> sudentInfo =
        await Utility.getStudentInfoList(tableName: tableName);
    return sudentInfo.first.pointpossible!;
  }
}
