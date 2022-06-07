import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/ocr/ui/assessment_summary.dart';
import 'package:Soc/src/modules/ocr/ui/camera_screen.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:googleapis/calendar/v3.dart';
import 'package:share/share.dart';

class ResultsSummary extends StatefulWidget {
  ResultsSummary({Key? key, required this.assessmentDetailPage, this.fileId})
      : super(key: key);
  final bool? assessmentDetailPage;
  final String? fileId;
  @override
  State<ResultsSummary> createState() => _ResultsSummaryState();
}

class _ResultsSummaryState extends State<ResultsSummary> {
  static const double _KVertcalSpace = 60.0;
  GoogleDriveBloc _driveBloc = GoogleDriveBloc();
  int? assessmentCount;
  ScrollController _scrollController = new ScrollController();
  final ValueNotifier<bool> isScrolling = ValueNotifier<bool>(false);

  @override
  void initState() {
    if (widget.assessmentDetailPage!) {
      _driveBloc.add(GetAssessmentDetail(fileId: widget.fileId));
    } else {
      assessmentCount = Globals.studentInfo!.length;
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
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
              key: GlobalKey(),
              isBackButton: widget.assessmentDetailPage,
              assessmentDetailPage: widget.assessmentDetailPage,
              actionIcon: IconButton(
                onPressed: () {
                  onFinishedPopup();
                },
                icon: Icon(
                  IconData(0xe877,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  size: 30,
                  color: AppTheme.kButtonColor,
                ),
              ),
              //isBackButton: false,
              isResultScreen: true,
            ),

            // AppBar(
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            //   automaticallyImplyLeading: false,
            //   actions: [
            //     Container(
            //         child: IconButton(
            //       onPressed: () {},
            //       icon: Icon(
            //         IconData(0xe874,
            //             fontFamily: Overrides.kFontFam,
            //             fontPackage: Overrides.kFontPkg),
            //         color: AppTheme.kButtonColor,
            //         size: 30,
            //       ),
            //     )),
            //     Container(
            //         padding: EdgeInsets.only(right: 5),
            //         child: IconButton(
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => FinishedScreen()),
            //             );
            //           },
            //           icon: Icon(
            //             IconData(0xe877,
            //                 fontFamily: Overrides.kFontFam,
            //                 fontPackage: Overrides.kFontPkg),
            //             color: AppTheme.kButtonColor,
            //             size: 30,
            //           ),
            //         )),
            //   ],
            // ),
            body: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpacerWidget(_KVertcalSpace * 0.50),
                  // IconButton(
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //     },
                  //     icon: Icon(
                  //       Icons.arrow_back,
                  //       color: Colors.red,
                  //     )),
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
                                    ),
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
                        )
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
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
            : Expanded(
                child: IconButton(
                  icon: Icon(
                    IconData(Globals.ocrResultIcons[index],
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    size: 32,
                    color: index == 2
                        ? Theme.of(context).backgroundColor == Color(0xff000000)
                            ? Colors.white
                            : Colors.black
                        : index == 3
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
                            builder: (context) => AssessmentSummary()),
                      );
                    } else {}
                  },
                ),
              ),
      ],
    );
  }

  Widget listView(List<StudentAssessmentInfo> _list) {
    return Container(
      // padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.08),
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.5
          : MediaQuery.of(context).size.height * 0.45,
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

                // border: Border.all(

                //   color: Theme.of(context).colorScheme.background,
                // ),
                borderRadius: BorderRadius.circular(0.0),
                color: (index % 2 == 0)
                    ? Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? Color(0xff162429)
                        : Color(
                            0xffF7F8F9) //Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? Color(0xff111C20)
                        : Color(
                            0xffE9ECEE) //Theme.of(context).colorScheme.secondary,
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
                              ? '2/2'
                              : '${_list[index].studentGrade}/2', // '${Globals.gradeList[index]} /2',
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraScreen(
                                isScanMore: true,
                                pointPossible: '2',
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

  onFinishedPopup() {
    return showDialog(
        context: context,
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Container(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Utility.textWidget(
                            text: 'Finished!',
                            context: context,
                            textTheme: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                        SizedBox(width: 10),
                        Icon(
                          IconData(0xe878,
                              fontFamily: Overrides.kFontFam,
                              fontPackage: Overrides.kFontPkg),
                          size: 30,
                          color: AppTheme.kButtonColor,
                        ),
                      ],
                    )),
                actions: [
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.height,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  Center(
                    child: Container(
                      // height: 20,
                      child: TextButton(
                        child: TranslationWidget(
                            message: "Done ",
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
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (_) => false);
                        },
                      ),
                    ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 16,
              );
            }));
  }
}
