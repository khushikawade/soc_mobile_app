import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/graded_plus/bloc/graded_plus_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/select_rubric_screen.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/select_mcq_key_screen.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GradedPlusSelectAssessmentTypeSection extends StatefulWidget {
  const GradedPlusSelectAssessmentTypeSection({Key? key}) : super(key: key);

  @override
  State<GradedPlusSelectAssessmentTypeSection> createState() =>
      _GradedPlusSelectAssessmentTypeSectionState();
}

class _GradedPlusSelectAssessmentTypeSectionState
    extends State<GradedPlusSelectAssessmentTypeSection> {
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  DateTime currentDateTime = DateTime.now(); //DateTime
  GoogleDriveBloc _googleDriveBloc = new GoogleDriveBloc();
  final OcrBloc _ocrBlocLogs = new OcrBloc();
  List<String> selectionList = ['Constructed Response', 'Multiple Choice'];
  final ValueNotifier<String> selectedAnswerKey = ValueNotifier<String>('');
  int myTimeStamp = DateTime.now().microsecondsSinceEpoch;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAnalyticsService.addCustomAnalyticsEvent("state_selection_page");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'state_selection_page', screenClass: 'StateSelectionPage');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar(),
          body: body(),
        )
      ],
    );
  }

  PreferredSizeWidget appBar() {
    return CustomOcrAppBarWidget(
      iconData: Icons.add,
      plusAppName: 'GRADED+',
      fromGradedPlus: true,
      //Show home button in standard app and hide in standalone
      assessmentDetailPage: Overrides.STANDALONE_GRADED_APP ? true : null,
      isOcrHome: true,
      isSuccessState: ValueNotifier<bool>(true),
      isBackOnSuccess: isBackFromCamera,
      key: GlobalKey(),
      isBackButton: Overrides.STANDALONE_GRADED_APP ? true : false,
    );
  }

  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: StudentPlusOverrides.kSymmetricPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 4),
          PlusScreenTitleWidget(
              kLabelSpacing: StudentPlusOverrides.kLabelSpacing,
              text: 'Select Assignment Type'),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 1.5,
                ),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: selectionList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buttonDesign(index: index);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonDesign({required int index}) {
    return ValueListenableBuilder(
        valueListenable: selectedAnswerKey,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return Bouncing(
            child: GestureDetector(
              onTap: () async {
                selectedAnswerKey.value = selectionList[index];
                Globals.scanMoreStudentInfoLength = 0;
                OcrUtility.clearOlderAssignmentDetails();
                if (selectedAnswerKey.value.isEmpty) {
                  Utility.currentScreenSnackBar("Select the Answer Key", null);
                } else if (selectedAnswerKey.value == 'Multiple Choice') {
                  PlusUtility.updateLogs(
                      activityType: 'GRADED+',
                      userType: 'Teacher',
                      activityId: '28',
                      description: 'MCQ Type Selection',
                      operationResult: 'Success');
                  Fluttertoast.cancel();
                  Globals.scoringRubric = '0-1';

                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GradedPlusMultipleChoice()));
                } else {
                  PlusUtility.updateLogs(
                      activityType: 'GRADED+',
                      userType: 'Teacher',
                      activityId: '27',
                      description: 'Constructive Type Selection',
                      operationResult: 'Success');
                  Fluttertoast.cancel();
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GradedPlusConstructedResponse()));
                }
                OcrOverrides.gradedPlusNavBarIsHide.value = false;

                FirebaseAnalyticsService.addCustomAnalyticsEvent(
                    "assessment_type_selected_${selectedAnswerKey.value}");
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 15,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: selectedAnswerKey.value ==
                                          selectionList[index]
                                      ? AppTheme.kSelectedColor
                                      : Colors.grey,
                                  border: Border.all(
                                    width: 2,
                                    color: selectedAnswerKey.value ==
                                            selectionList[index]
                                        ? AppTheme.kSelectedColor
                                        : Colors.transparent,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              height: MediaQuery.of(context).size.height * 0.19,
                              width: MediaQuery.of(context).size.width * 0.903,
                            ),
                            AnimatedContainer(
                              decoration: BoxDecoration(
                                  color: Color(0xff000000) !=
                                          Theme.of(context).backgroundColor
                                      ? Color(0xffF7F8F9)
                                      : Color(0xff111C20),
                                  border: Border.all(
                                    width: 2,
                                    color: selectedAnswerKey.value ==
                                            selectionList[index]
                                        ? AppTheme.kSelectedColor
                                        : Colors.transparent,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              height:
                                  MediaQuery.of(context).size.height * 0.185,
                              width: MediaQuery.of(context).size.width * 0.9,
                              duration: Duration(microseconds: 100),
                              child: Center(
                                  child: Container(
                                      padding: EdgeInsets.only(top: 50),
                                      child: Utility.textWidget(
                                          text: selectionList[index],
                                          context: context,
                                          textTheme: Theme.of(context)
                                              .textTheme
                                              .headline1))),
                            ),
                          ],
                        )),
                  ),
                  AnimatedContainer(
                    duration: Duration(microseconds: 100),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: selectedAnswerKey.value == selectionList[index]
                              ? AppTheme.kSelectedColor
                              : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.18),
                    child: CircleAvatar(
                      backgroundColor:
                          Color(0xff000000) != Theme.of(context).backgroundColor
                              ? Colors.grey.shade200
                              : Colors.grey.shade800,
                      radius: MediaQuery.of(context).size.height * 0.07,
                      child: CircleAvatar(
                        backgroundColor: Color(0xff000000) !=
                                Theme.of(context).backgroundColor
                            ? Color(0xffF7F8F9)
                            : Color(0xff111C20),
                        radius: MediaQuery.of(context).size.height * 0.06,
                        child: Icon(
                            IconData(index == 1 ? 0xe833 : 0xe87c,
                                fontFamily: Overrides.kFontFam,
                                fontPackage: Overrides.kFontPkg),
                            size: index == 0 ? 35 : 42,
                            color:
                                selectedAnswerKey.value == selectionList[index]
                                    ? AppTheme.kSelectedColor
                                    : AppTheme.kButtonColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
