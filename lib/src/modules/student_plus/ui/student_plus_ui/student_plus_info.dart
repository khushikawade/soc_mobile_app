import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_ui/student_plus_search_page.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_searchbar_and_dropdown_widget.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_app_search_bar.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_family_student_list.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class StudentPlusInfoScreen extends StatefulWidget {
  final StudentPlusDetailsModel studentDetails;
  final String sectionType;
  const StudentPlusInfoScreen(
      {Key? key, required this.studentDetails, required this.sectionType})
      : super(key: key);

  @override
  State<StudentPlusInfoScreen> createState() => _StudentPlusInfoScreenState();
}

class _StudentPlusInfoScreenState extends State<StudentPlusInfoScreen> {
  static const double _kLabelSpacing = 20.0;
  FocusNode myFocusNode = new FocusNode();
  final _controller = TextEditingController(); // textController for search
  List<StudentPlusInfoModel> studentInfoList =
      []; // list to show student details

  @override
  void initState() {
    studentInfoList = StudentPlusUtility.createStudentList(
        studentDetails: widget
            .studentDetails); // function to get student details with label
    super.initState();

    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "student_plus_info_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'student_plus_info_screen',
        screenClass: 'StudentPlusGradesPage');

    PlusUtility.updateLogs(
        activityType: 'STUDENT+',
        userType: 'Teacher',
        activityId: '49',
        description: 'Student+ Info Screen',
        operationResult: 'Success');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: StudentPlusAppBar(
              sectionType: widget.sectionType,
              titleIconCode: 0xe883,
              refresh: (v) {
                setState(() {});
              },
            ),
            body: body()),
      ],
    );
  }

  /*--------------------- Main Body ---------------------*/
  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: StudentPlusOverrides.kSymmetricPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 4),
          PlusScreenTitleWidget(
              kLabelSpacing: _kLabelSpacing,
              text: StudentPlusOverrides.studentInfoPageTitle),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
          widget.sectionType == "Student"
              ? Container()
              : StudentPlusSearchBarAndDropdown(
                index: 0,
                  sectionType: widget.sectionType,
                  studentDetails: widget.studentDetails),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding / 2),
          studentInfoListView()
        ],
      ),
    );
  }

  /* --------------------- widget to show student details --------------------- */
  Widget studentInfoListView() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(
            bottom: 25,
            left: StudentPlusOverrides.kSymmetricPadding,
            right: StudentPlusOverrides.kSymmetricPadding),
        scrollDirection: Axis.vertical,
        itemCount: studentInfoList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildInfoTile(
              index: index, studentInfo: studentInfoList[index]);
        },
      ),
    );
  }

  /* ------------------ widget to show tiles of each details ------------------ */
  Widget _buildInfoTile(
      {required int index, required StudentPlusInfoModel studentInfo}) {
    return Container(
        height: 54,
        padding: EdgeInsets.symmetric(
          horizontal: 5,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.0),
            color: (index % 2 == 0)
                ? Theme.of(context).colorScheme.background == Color(0xff000000)
                    ? AppTheme.klistTilePrimaryDark
                    : AppTheme
                        .klistTilePrimaryLight //Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.background == Color(0xff000000)
                    ? AppTheme.klistTileSecoandryDark
                    : AppTheme
                        .klistTileSecoandryLight //Theme.of(context).colorScheme.secondary,
            ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              width: (MediaQuery.of(context).size.width / 2) - 25,
              child: Utility.textWidget(
                  text: studentInfo.label,
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: EdgeInsets.only(right: 0),
              width: (MediaQuery.of(context).size.width / 2) - 25,
              child: (studentInfo.label == "Phone" ||
                          studentInfo.label == "Email") &&
                      studentInfo.value != "-"
                  ? InkWell(
                      onTap: () {
                        Utility.launchUrlOnExternalBrowser(
                            (studentInfo.label == "Email"
                                    ? "mailto:"
                                    : "tel:") +
                                studentInfo.value);
                      },
                      child: Text(
                        studentInfo.value,
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              color: Colors.blue,
                            ),
                      ))
                  : studentInfo.label == "Name" ||
                          studentInfo.label == "Teacher"
                      ? Text(
                          studentInfo.value,
                          style: Theme.of(context).textTheme.headline2!,
                        )
                      : Utility.textWidget(
                          text: studentInfo.value,
                          context: context,
                          textTheme: Theme.of(context).textTheme.headline2!),
            ),
          ],
        ));
  }
}
