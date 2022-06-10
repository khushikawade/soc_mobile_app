import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/ocr/ui/assessment_summary.dart';
import 'package:Soc/src/modules/ocr/ui/camera_screen.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import '../../../widgets/empty_container_widget.dart';
import '../bloc/ocr_bloc.dart';

class ResultsSummary extends StatefulWidget {
  ResultsSummary(
      {Key? key,
      required this.assessmentDetailPage,
      this.fileId,
      this.subjectId,
      this.standardId,
      this.rubricScore,
      this.isScanMore,
      this.assessmentListLenght})
      : super(key: key);
  final bool? assessmentDetailPage;
  final String? fileId;
  final String? subjectId;
  final String? standardId;
  final String? rubricScore;
  final bool? isScanMore;
  final int? assessmentListLenght;
  @override
  State<ResultsSummary> createState() => _ResultsSummaryState();
}

class _ResultsSummaryState extends State<ResultsSummary> {
  static const double _KVertcalSpace = 60.0;
  GoogleDriveBloc _driveBloc = GoogleDriveBloc();
  OcrBloc _ocrBloc = OcrBloc();
  int? assessmentCount;
  ScrollController _scrollController = new ScrollController();
  final ValueNotifier<bool> isScrolling = ValueNotifier<bool>(false);
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final ValueNotifier<String> dashoardState = ValueNotifier<String>('');
  int? assessmentListLenght;

  @override
  void initState() {
    if (widget.assessmentDetailPage!) {
      _driveBloc.add(GetAssessmentDetail(fileId: widget.fileId));
    } else {
      assessmentCount = Globals.studentInfo!.length;
    }
    if (Globals.studentInfo!.length == widget.assessmentListLenght) {
      dashoardState.value = 'Success';
    }
    _scrollController.addListener(_scrollListener);
    super.initState();
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
              key: GlobalKey(),
              isBackButton: widget.assessmentDetailPage,
              assessmentDetailPage: widget.assessmentDetailPage,
              actionIcon: Container(
                  padding: EdgeInsets.only(right: 5),
                  child: TextButton(
                      style: ButtonStyle(alignment: Alignment.center),
                      child: Text("DONE",
                          style: TextStyle(
                            color: AppTheme.kButtonColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                      onPressed: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (_) => false);
                        // onFinishedPopup();
                      })),
              isResultScreen: true,
            ),

            body: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpacerWidget(_KVertcalSpace * 0.50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Utility.textWidget(
                            text: 'Results Summary',
                            context: context,
                            textTheme: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold)),
                        Text(
                            "${assessmentCount != null && assessmentCount! > 0 ? assessmentCount! : ''}",
                            style: Theme.of(context).textTheme.headline3),
                      ],
                    ),
                  ),
                  SpacerWidget(_KVertcalSpace / 3),
                  !widget.assessmentDetailPage!
                      ? Column(
                          children: [
                            resultTitle(),
                            listView(
                              Globals.studentInfo!,
                            ),
                          ],
                        )
                      : BlocConsumer(
                          bloc: _driveBloc,
                          builder:
                              (BuildContext contxt, GoogleDriveState state) {
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
                              // return

                              // state.obj.length > 1
                              //     ? listView(
                              //         state.obj,
                              //       )
                              //     : Expanded(
                              //         child: NoDataFoundErrorWidget(
                              //             isResultNotFoundMsg: true,
                              //             isNews: false,
                              //             isEvents: false),
                              //       );
                            }
                            //  else if (state is GoogleNoAssessment) {
                            //   return Container(
                            //     height:
                            //         MediaQuery.of(context).size.height * 0.7,
                            //     child: Center(
                            //         child: Text(
                            //       "No assessment available",
                            //       style: Theme.of(context).textTheme.bodyText1!,
                            //     )),
                            //   );
                            // }
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                              )),
                            );
                          },
                          listener:
                              (BuildContext contxt, GoogleDriveState state) {
                            if (state is AssessmentDetailSuccess) {
                              if (state.obj.length > 1) {
                                setState(() {
                                  assessmentCount = state.obj.length;
                                });
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
                            dashoardState.value = 'Success';
                            // Utility.showSnackBar(
                            //     scaffoldKey,
                            //     'Yay! Data has been successully saved to the dashboard',
                            //     context,
                            //     null);
                          }
                        },
                        child: EmptyContainer()),
                  ),
                ],
              ),
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                !widget.assessmentDetailPage!
                    ? _scanFloatingWidget()
                    : Container(),
                SpacerWidget(10),
                !widget.assessmentDetailPage!
                    ? Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor ==
                                    Color(0xff000000)
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
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.height * 0.086
                            : MediaQuery.of(context).size.width * 0.086,
                        width: MediaQuery.of(context).size.width * 0.9,
                        //  color: Colors.blue,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: Globals.ocrResultIcons
                              .map<Widget>((element) => _iconButton(
                                  Globals.ocrResultIcons.indexOf(element)))
                              .toList(),

                          // [
                          //   Icon(Icons.star_border),
                          //   Icon(Icons.star_border),
                          //   Icon(Icons.star_border),
                          //   Icon(Icons.star_border),
                          // ],
                        ))
                    : Container(),
              ],
            ),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerFloat,
          ),
        ],
      ),
    );
  }

  Widget resultTitle() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            height: 60.0,
            margin: const EdgeInsets.only(
                bottom: 6.0), //Same as `blurRadius` i guess
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
      ),
    );
    // return Container(
    //     child: ListTile(
    //   leading: Utility.textWidget(
    //       text: 'Student Name',
    //       context: context,
    //       textTheme: Theme.of(context)
    //           .textTheme
    //           .headline2!
    //           .copyWith(fontWeight: FontWeight.bold)),
    //   trailing: Utility.textWidget(
    //       text: 'Points Earned',
    //       context: context,
    //       textTheme: Theme.of(context)
    //           .textTheme
    //           .headline2!
    //           .copyWith(fontWeight: FontWeight.bold)),
    // ));
  }

  Widget _iconButton(int index) {
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
                    text: Globals.ocrResultIconsName[index],
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
                          print(
                              'Google drive folder path : ${Globals.googleDriveFolderPath}');
                          Utility.launchUrlOnExternalBrowser(
                              Globals.googleDriveFolderPath!);
                        },
                        child: Container(
                          //    margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: Image(
                            width: Globals.deviceType == "phone" ? 35 : 32,
                            height: Globals.deviceType == "phone" ? 35 : 32,
                            image: AssetImage(
                              "assets/images/drive_ico.png",
                            ),
                          ),
                        ),
                      ),
                    )
                  : index == 3 && dashoardState.value == 'Loading'
                      ? GestureDetector(
                          onTap: () {
                            // Utility.showSnackBar(
                            //     scaffoldKey,
                            //     'Please wait! Saving is in progress',
                            //     context,
                            //     null);
                          },
                          child: Container(
                              padding: EdgeInsets.only(bottom: 14, top: 8),
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
                            icon: Icon(
                              IconData(
                                  index == 3 && dashoardState.value == 'Success'
                                      ? 0xe877
                                      : Globals.ocrResultIcons[index],
                                  fontFamily: Overrides.kFontFam,
                                  fontPackage: Overrides.kFontPkg),
                              size: index == 3 && dashoardState.value == ''
                                  ? 38
                                  : 32,
                              color: index == 2 ||
                                      (index == 3 && dashoardState.value == '')
                                  ? Theme.of(context).backgroundColor ==
                                          Color(0xff000000)
                                      ? Colors.white
                                      : Colors.black
                                  : index == 3 &&
                                          dashoardState.value == 'Success'
                                      ? Colors.green
                                      : AppTheme.kButtonColor,
                            ),
                            onPressed: () {
                              if (index == 0) {
                                Share.share(Globals.shareableLink!);
                              } else if (index == 2) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AssessmentSummary()),
                                );
                              } else if (index == 3 &&
                                  dashoardState.value == '') {
                                if (widget.isScanMore == true &&
                                    widget.assessmentListLenght! <
                                        Globals.studentInfo!.length) {
                                  _ocrBloc.add(SaveAssessmentToDashboard(
                                      previouslyAddedListLength:
                                          widget.assessmentListLenght,
                                      assessmentName: Globals.assessmentName!,
                                      rubricScore: widget.rubricScore ?? '',
                                      subjectId: widget.subjectId ?? '',
                                      schoolId: Globals
                                          .appSetting.schoolNameC!, //Account Id
                                      standardId: widget.standardId ?? '',
                                      scaffoldKey: scaffoldKey,
                                      context: context));
                                } else {
                                  _ocrBloc.add(SaveAssessmentToDashboard(
                                      assessmentName: Globals.assessmentName!,
                                      rubricScore: widget.rubricScore ?? '',
                                      subjectId: widget.subjectId ?? '',
                                      schoolId: Globals
                                          .appSetting.schoolNameC!, //Account Id
                                      standardId: widget.standardId ?? '',
                                      scaffoldKey: scaffoldKey,
                                      context: context));
                                }
                              }
                              // else if (index == 3 &&
                              //     dashoardState.value == 'Success') {
                              // Utility.showSnackBar(
                              //     scaffoldKey,
                              //     'Data has already been saved to the dashboard',
                              //     context,
                              //     null);
                              // }
                            },
                          ),
                        ),
            ],
          );
        });
  }

  Widget listView(List<StudentAssessmentInfo> _list) {
    return Container(
      // padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.08),
      height: widget.assessmentDetailPage!
          ? (MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.65
              : MediaQuery.of(context).size.height * 0.45)
          : (MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.5
              : MediaQuery.of(context).size.height * 0.45),
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        // padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
        scrollDirection: Axis.vertical,
        itemCount: _list.length, // Globals.gradeList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildList(index, _list, context);
        },
      ),
    );
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
              visualDensity: VisualDensity(horizontal: 0, vertical: 0),
              // contentPadding:
              //     EdgeInsets.only(left: _kLabelSpacing, right: _kLabelSpacing / 2),
              leading:
                  // Text('Unknown'),

                  Utility.textWidget(
                      text: _list[index].studentName == '' ||
                              _list[index].studentName == null
                          ? 'Unknown'
                          : _list[index].studentName!,
                      context: context,
                      textTheme: Theme.of(context).textTheme.headline2!),

              trailing:
                  // Text(_list[index].pointpossible!),
                  Utility.textWidget(
                      text: //'2/2',
                          _list[index].studentGrade == ''
                              ? '-/${_list[index].pointpossible ?? '2'}'
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
            width: isScrolling.value ? null : 200,
            child: FloatingActionButton.extended(
                isExtended: !isScrolling.value,
                backgroundColor: AppTheme.kButtonColor,
                onPressed: () {
                  Globals.scanMoreStudentInfoLength =
                      Globals.studentInfo!.length;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraScreen(
                                isScanMore: true,
                                // lastStudentInfoLenght: Globals.studentInfo!.length,
                                pointPossible: Globals.pointpossible ?? '2',
                              )));
                },
                icon: Icon(
                    IconData(0xe875,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: Theme.of(context).backgroundColor,
                    size: 16),
                label: Utility.textWidget(
                    text: 'Scan More',
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Theme.of(context).backgroundColor))),
          );
        });
  }

  // onFinishedPopup() {
  //   return showDialog(
  //       context: context,
  //       builder: (context) =>
  //           OrientationBuilder(builder: (context, orientation) {
  //             return AlertDialog(
  //               backgroundColor: Colors.white,
  //               title: Container(
  //                   padding: Globals.deviceType == 'phone'
  //                       ? null
  //                       : const EdgeInsets.only(top: 10.0),
  //                   height: Globals.deviceType == 'phone'
  //                       ? null
  //                       : orientation == Orientation.portrait
  //                           ? MediaQuery.of(context).size.height / 15
  //                           : MediaQuery.of(context).size.width / 15,
  //                   width: Globals.deviceType == 'phone'
  //                       ? null
  //                       : orientation == Orientation.portrait
  //                           ? MediaQuery.of(context).size.width / 2
  //                           : MediaQuery.of(context).size.height / 2,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Utility.textWidget(
  //                           text: 'Finished!',
  //                           context: context,
  //                           textTheme: Theme.of(context)
  //                               .textTheme
  //                               .headline6!
  //                               .copyWith(
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.black)),
  //                       SizedBox(width: 10),
  //                       Icon(
  //                         IconData(0xe878,
  //                             fontFamily: Overrides.kFontFam,
  //                             fontPackage: Overrides.kFontPkg),
  //                         size: 30,
  //                         color: AppTheme.kButtonColor,
  //                       ),
  //                     ],
  //                   )),
  //               actions: [
  //                 Container(
  //                   height: 1,
  //                   width: MediaQuery.of(context).size.height,
  //                   color: Colors.grey.withOpacity(0.2),
  //                 ),
  //                 Center(
  //                   child: Container(
  //                     // height: 20,
  //                     child: TextButton(
  //                       child: TranslationWidget(
  //                           message: "Done ",
  //                           fromLanguage: "en",
  //                           toLanguage: Globals.selectedLanguage,
  //                           builder: (translatedMessage) {
  //                             return Text(translatedMessage.toString(),
  //                                 style: Theme.of(context)
  //                                     .textTheme
  //                                     .headline5!
  //                                     .copyWith(
  //                                       color: AppTheme.kButtonColor,
  //                                     ));
  //                           }),
  //                       onPressed: () {
  //                         //Globals.iscameraPopup = false;
  //                         Navigator.of(context).pushAndRemoveUntil(
  //                             MaterialPageRoute(
  //                                 builder: (context) => HomePage()),
  //                             (_) => false);
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12)),
  //               elevation: 16,
  //             );
  //           }));
  // }
}
