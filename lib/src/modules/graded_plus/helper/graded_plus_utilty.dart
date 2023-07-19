import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/modal/assessment_status_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/individualStudentModal.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../google_classroom/services/google_classroom_globals.dart';

class OcrUtility {
/*------------------------------------------------------------------------------------------------*/
/*----------------------------  ------checkEmailFromGoogleClassroom---------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static Future<bool> checkEmailFromGoogleClassroom(
      {required String studentEmail}) async {
    try {
      LocalDatabase<GoogleClassroomCourses> _localDb =
          LocalDatabase(Strings.googleClassroomCoursesList);

      List<GoogleClassroomCourses>? _localData = await _localDb.getData();
      List<String> studentEmailList = [];
      for (var i = 0; i < _localData.length; i++) {
        for (var j = 0; j < _localData[i].studentList!.length; j++) {
          studentEmailList
              .add(_localData[i].studentList![j]['profile']['emailAddress']);
        }
      }

      if (studentEmailList.contains(studentEmail)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

/*------------------------------------------------------------------------------------------------*/
/*---------------------------------------------getStudentList-------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static Future<List<StudentClassroomInfo>> getStudentList() async {
    try {
      List<StudentClassroomInfo> studentList = [];
      LocalDatabase<GoogleClassroomCourses> _localDb =
          LocalDatabase(Strings.googleClassroomCoursesList);

      List<GoogleClassroomCourses>? _localData = await _localDb.getData();

      for (var i = 0; i < _localData.length; i++) {
        for (var j = 0; j < _localData[i].studentList!.length; j++) {
          StudentClassroomInfo studentClassroomInfo = StudentClassroomInfo();
          studentClassroomInfo.studentEmail =
              _localData[i].studentList![j]['profile']['emailAddress'];
          studentClassroomInfo.studentName =
              _localData[i].studentList![j]['profile']['name']['fullName'];
          if (!studentList.contains(studentClassroomInfo)) {
            studentList.add(studentClassroomInfo);
          }
        }
      }
      // studentInfo = [];
      // studentInfo = studentList;
      return studentList;
    } catch (e) {
      List<StudentClassroomInfo> studentList = [];
      return studentList;
    }
  }

/*------------------------------------------------------------------------------------------------*/
/*----------------------------------------------getMcqAnswer--------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static String getMcqAnswer({required String detectedAnswer}) {
    try {
      switch (detectedAnswer) {
        case '0':
          {
            return 'A';
          }
        case '1':
          {
            return 'B';
          }
        case '2':
          {
            return 'C';
          }
        case '3':
          {
            return 'D';
          }
        case '4':
          {
            return 'E';
          }

        default:
          {
            return '';
          }
      }
    } catch (e) {
      return '';
    }
  }

/*------------------------------------------------------------------------------------------------*/
/*---------------------------checkAllStudentBelongsToSameClassOrNotForStandAloneApp---------------*/
/*------------------------------------------------------------------------------------------------*/
  static Future<List<StudentAssessmentInfo>>
      checkAllStudentBelongsToSameClassOrNotForStandAloneApp(
          {required LocalDatabase<StudentAssessmentInfo> studentInfoDB,
          required bool isScanMore,
          required String title}) async {
    try {
      List<StudentAssessmentInfo> studentInfo = await studentInfoDB.getData();

      if (isScanMore) {
        studentInfo.removeWhere((element) =>
            element?.isScanMore == null || element?.isScanMore == false);

        //event.studentClassObj = Google classroom Course Object come from import roster
        if ((GoogleClassroomOverrides
                ?.studentAssessmentAndClassroomObj.courseWorkId?.isEmpty ??
            true)) {
          // courseWorkId is null or empty, and isHistorySanMore is either null or false
          LocalDatabase<GoogleClassroomCourses> _googleClassRoomLocalDb =
              LocalDatabase(Strings.googleClassroomCoursesList);
          List<GoogleClassroomCourses> _googleClassRoomLocalData =
              await _googleClassRoomLocalDb.getData();

//Update the studentclassobject when the user tries to scan older records that are not available on Google Classroom
// checking the class name by title

          if ((_googleClassRoomLocalData?.isNotEmpty ?? false)) {
            if ((title?.isNotEmpty ?? false) && (title.contains('_'))) {
              for (GoogleClassroomCourses classroom
                  in _googleClassRoomLocalData) {
                // always check last "_" contains in title and get the subject
                if ((title.split("_").last == classroom.name)) {
                  // print("insdie if loopppp");
                  GoogleClassroomOverrides
                      .studentAssessmentAndClassroomObj.name = classroom.name;
                  GoogleClassroomOverrides?.studentAssessmentAndClassroomObj
                      .courseId = classroom.courseId;
                  GoogleClassroomOverrides?.studentAssessmentAndClassroomObj
                      .studentList = classroom.studentList;
                  break;
                }
              }
            }
          }
        }
      }

      return GoogleClassroomOverrides
                  ?.studentAssessmentAndClassroomObj?.studentList ==
              null
          ? []
          : studentInfo.where((student) {
              return GoogleClassroomOverrides
                  .studentAssessmentAndClassroomObj.studentList!
                  .every((courseStudent) {
                return courseStudent["profile"]["emailAddress"] !=
                    student.studentId;
              });
            }).toList();
    } catch (e) {
      return [];
    }
  }

/*------------------------------------------------------------------------------------------------*/
/*----------------------------------------------sortStudents--------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static Future sortStudents({
    required tableName,
  }) async {
    LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
        LocalDatabase(tableName);

    //get all students
    List<StudentAssessmentInfo> students = await _studentInfoDb.getData();

//remove id and name demo object for list and DB
    if (students.isNotEmpty) {
      if (students[0].studentId == 'Id' || students[0].studentId == 'Name') {
        students.removeAt(0);
        await _studentInfoDb.deleteAt(0);
      }
    }

//IF LIST IS EMPTY RETURN THE FUNCTION
    if (students == null || students.isEmpty) {
      return;
    }
    //Saving first student because its having all common details of subject, learning standard and other required info
    StudentAssessmentInfo firstStudent = students[0];

    // Sort by marks (descending) first, then by last name
    students.sort((a, b) {
      // Sort by Earned Points in descending order
      int studentEarnPoints = b.studentGrade!.compareTo(a.studentGrade!);
      if (studentEarnPoints != 0) {
        return studentEarnPoints;
      }

      String lastNameA = '';
      String lastNameB = '';
      // Sort by last name in alphabetical order
      if (a.studentName != null && a.studentName!.isNotEmpty) {
        if (a.studentName!.contains(' ')) {
          lastNameA = a.studentName!.split(' ').last.toLowerCase();
        } else {
          lastNameA = a.studentName!.toLowerCase();
        }
      }

      if (b.studentName != null && b.studentName!.isNotEmpty) {
        if (b.studentName!.contains(' ')) {
          lastNameB = b.studentName!.split(' ').last.toLowerCase();
        } else {
          lastNameB = b.studentName!.toLowerCase();
        }
      }
      return lastNameA.compareTo(lastNameB);
    });

//clean the Local DB
    await _studentInfoDb.clear();

//Adding the sorted list
    students.asMap().forEach((int index, StudentAssessmentInfo element) async {
      StudentAssessmentInfo studentObj = element;
      // TO make sure all comman data is available on first index on edit or scan more
      if (index == 0) {
        studentObj
          ..className = firstStudent.className
          ..subject = firstStudent.subject
          ..learningStandard = firstStudent.learningStandard
          ..subLearningStandard = firstStudent.subLearningStandard
          ..scoringRubric = firstStudent.scoringRubric
          ..customRubricImage = firstStudent.customRubricImage
          ..grade = firstStudent.grade
          ..questionImgUrl = firstStudent.questionImgUrl
          ..googleSlidePresentationURL = firstStudent.googleSlidePresentationURL
          ..standardDescription = firstStudent.standardDescription
          ..pointPossible = firstStudent.pointPossible
          ..answerKey = firstStudent.answerKey
          ..questionImgFilePath = firstStudent.questionImgFilePath;
      }

      await _studentInfoDb.addData(studentObj);
    });

    return students;
  }

/*------------------------------------------------------------------------------------------------*/
/*--------------------------------------getSortedStudentInfoList----------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static Future<List<StudentAssessmentInfo>> getSortedStudentInfoList(
      {required String tableName, bool? isEdit}) async {
    LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
        LocalDatabase(tableName);
    List<StudentAssessmentInfo> _studentInfoListDb = [];

    if (isEdit == true) {
      //Sorting Local db student list
      _studentInfoListDb = await sortStudents(
        tableName: tableName,
      );
    } else {
      _studentInfoListDb = await _studentInfoDb.getData();
    }
    if (_studentInfoListDb.isNotEmpty) {
      if (_studentInfoListDb[0].studentId == 'Id' ||
          _studentInfoListDb[0].studentId == 'Name') {
        _studentInfoListDb.removeAt(0);
      }
    }
    return _studentInfoListDb;
  }

/*------------------------------------------------------------------------------------------------*/
/*--------------------------------getResultSummaryStudentInfoListLength---------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static Future<int> getResultSummaryStudentInfoListLength(
      {required String tableName}) async {
    LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
        LocalDatabase(tableName);
    List<StudentAssessmentInfo> _studentInfoListDb =
        await _studentInfoDb.getData();

    if (_studentInfoListDb.isNotEmpty) {
      if (_studentInfoListDb[0].studentId == 'Id' ||
          _studentInfoListDb[0].studentId == 'Name') {
        _studentInfoListDb.removeAt(0);
        await _studentInfoDb.deleteAt(0);
      }
    }

    return _studentInfoListDb.length;
  }

/*------------------------------------------------------------------------------------------------*/
/*------------------------checkAllStudentBelongsToSameClassOrNotForStandardApp--------------------*/
/*------------------------------------------------------------------------------------------------*/
  static Future<List<StudentAssessmentInfo>>
      checkAllStudentBelongsToSameClassOrNotForStandardApp({
    required LocalDatabase<StudentAssessmentInfo> studentInfoDB,
    required bool isScanMore,
    required String title,
    required bool isFromHistoryAssignment,
  }) async {
    ClassroomCourse
        localStudentAssessmentAndClassroomAssignmentObjForStandardApp =
        isFromHistoryAssignment == true
            ? GoogleClassroomOverrides
                ?.historyStudentResultSummaryForStandardApp
            : GoogleClassroomOverrides
                ?.recentStudentResultSummaryForStandardApp;

    try {
      //Fetch locally saved students
      List<StudentAssessmentInfo> studentInfo = await studentInfoDB.getData();

      if (isScanMore) {
        //Remove already saved/scanned student from the list
        studentInfo.removeWhere((element) =>
            element?.isScanMore == null || element?.isScanMore == false);

        //event.studentClassObj = Google classroom Course Object come from import roster
        if ((localStudentAssessmentAndClassroomAssignmentObjForStandardApp
                .courseWorkId?.isEmpty ??
            true)) {
          // courseWorkId is null or empty, and isHistorySanMore is either null or false
          LocalDatabase<ClassroomCourse> _googleClassRoomLocalDb =
              LocalDatabase(OcrOverrides.gradedPlusStandardClassroomDB);
          List<ClassroomCourse> _googleClassRoomLocalData =
              await _googleClassRoomLocalDb.getData();

          //Update the student class object when the user tries to scan older records that are not available on Google Classroom
          // checking the class name by title

          if ((_googleClassRoomLocalData?.isNotEmpty ?? false)) {
            if ((title?.isNotEmpty ?? false) && (title.contains('_'))) {
              for (ClassroomCourse classroom in _googleClassRoomLocalData) {
                // always check last "_" contains in title and get the subject
                if ((title.split("_").last == classroom.name)) {
                  // print("insdie if loopppp");
                  localStudentAssessmentAndClassroomAssignmentObjForStandardApp
                      .name = classroom.name;
                  localStudentAssessmentAndClassroomAssignmentObjForStandardApp
                      .id = classroom.id;
                  localStudentAssessmentAndClassroomAssignmentObjForStandardApp
                      .students = classroom.students;

                  if (isFromHistoryAssignment == true) {
                    GoogleClassroomOverrides
                            .historyStudentResultSummaryForStandardApp =
                        localStudentAssessmentAndClassroomAssignmentObjForStandardApp;
                  } else {
                    GoogleClassroomOverrides
                            .recentStudentResultSummaryForStandardApp =
                        localStudentAssessmentAndClassroomAssignmentObjForStandardApp;
                  }

                  break;
                }
              }
            }
          }
        }
      }

      //Return list of news scanned student list
      return localStudentAssessmentAndClassroomAssignmentObjForStandardApp
                  ?.students ==
              null
          ? []
          : studentInfo.where((student) {
              return localStudentAssessmentAndClassroomAssignmentObjForStandardApp
                  .students!
                  .every((ClassroomStudents courseStudent) {
                return courseStudent.profile!.emailAddress !=
                    student.studentEmail;
              });
            }).toList();
    } catch (e) {
      return [];
    }
  }

/*------------------------------------------------------------------------------------------------*/
/*-----------------------------------showProgressLoadingDialog------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static Future<void> clearOlderAssignmentDetails() async {
    //Clean older ids related to presentaion and spreadsheets sheet
    Globals.googleExcelSheetId = '';
    Globals.googleSlidePresentationId = '';
    Globals.googleSlidePresentationLink = '';

//clean older scaned stduent records DB
    LocalDatabase<StudentAssessmentInfo> _studentAssessmentInfoDb =
        LocalDatabase(Strings.studentInfoDbName);
    await _studentAssessmentInfoDb.clear();

// clean older classroom related ids
    GoogleClassroomOverrides.recentStudentResultSummaryForStandardApp =
        ClassroomCourse(id: '');
  }

/*------------------------------------------------------------------------------------------------*/
/*-----------------------------------showProgressLoadingDialog------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static void showProgressLoadingDialog({
    BuildContext? context,
    required Function(StateSetter) state,
    required List<String> processList,
    required ValueNotifier<LoadingStatusModel> assessmentExportAndSaveStatus,
  }) async {
    return showDialog<void>(
      useRootNavigator: false,
      context: context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          if (state != null) {
            state(setState);
          }

          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  backgroundColor:
                      Color(0xff000000) != Theme.of(context).backgroundColor
                          ? Color(0xff111C20)
                          : Color(0xffF7F8F9), //Colors.black54,
                  children: <Widget>[
                    Text(
                      "Saving",
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold),
                    ),
                    SpacerWidget(10),
                    ...processList
                        .map((item) => Container(
                              margin: EdgeInsets.symmetric(vertical: 7),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 55,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppTheme.kButtonColor),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                  ),
                                  progressStatusWidget(
                                      value: item,
                                      assessmentExportAndSaveStatus:
                                          assessmentExportAndSaveStatus)
                                ],
                              ),
                            ))
                        .toList(),
                  ]));
        });
      },
    );
  }

/*------------------------------------------------------------------------------------------------*/
/*------------------------------------progressStatusWidget----------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static Widget progressStatusWidget(
      {required String value,
      required ValueNotifier<LoadingStatusModel>
          assessmentExportAndSaveStatus}) {
    if ((value == 'Google Sheet' &&
            assessmentExportAndSaveStatus.value.excelSheetPrepared!) ||
        (value == 'Google Slides' &&
            assessmentExportAndSaveStatus.value.slidePrepared!) ||
        (value == 'Google Classroom' &&
            assessmentExportAndSaveStatus.value.googleClassroomPrepared) ||
        (value == '${Globals.schoolDbnC} Dashboard' &&
            assessmentExportAndSaveStatus
                .value.saveAssessmentResultToDashboard!)) {
      return Icon(
        IconData(0xe877,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: AppTheme.kButtonColor,
      );
    } else {
      return CupertinoActivityIndicator(
        color: AppTheme.kButtonColor,
      );
    }
  }

/*------------------------------------------------------------------------------------------------*/
/*------------------------------------showSuccessDialog-------------------------------------------*/
/*------------------------------------------------------------------------------------------------*/

  static void showSuccessDialog({
    BuildContext? context,
  }) async {
    return showDialog<void>(
      useRootNavigator: false,
      context: context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                backgroundColor: Colors.transparent,
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 45),
                            decoration: BoxDecoration(
                              color: Color(0xff000000) !=
                                      Theme.of(context).backgroundColor
                                  ? Color(0xff111C20)
                                  : Color(0xffF7F8F9),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0, 2),
                                    blurRadius: 10),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  'Awesome!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Student Assignments Saved Successfully',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                              ],
                            )
                            // child: FittedBox(child: pbisStudentDetailWidget)
                            ),
                        Positioned(
                          top: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xff000000) !=
                                          Theme.of(context).backgroundColor
                                      ? Color(0xff111C20)
                                      : Color(0xffF7F8F9),
                                  width: 8),
                              //color: AppTheme.kButtonColor,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.kButtonColor,
                                //color: AppTheme.kButtonColor,
                                shape: BoxShape.circle,
                              ),
                              height: 80,
                              width: 80,
                              child: Icon(
                                IconData(0xe877,
                                    fontFamily: Overrides.kFontFam,
                                    fontPackage: Overrides.kFontPkg),
                                color: Color(0xff000000) !=
                                        Theme.of(context).backgroundColor
                                    ? Color(0xff111C20)
                                    : Color(0xffF7F8F9),
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]));
      },
    );
  }

  static getTeacherId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(OcrOverrides.teacherId) ?? "";
    } catch (e) {
      return "";
    }
  }

  static setTeacherId(techerId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(OcrOverrides.teacherId, "$techerId");
    } catch (e) {}
  }

  static focusUnfocusScreenContent(BuildContext context) {
    try {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    } catch (e) {}
  }
}

/*------------------------------------------------------------------------------------------------*/
/*----------------------------getResultSummaryCardDetailsAndBarSize-------------------------------*/
/*------------------------------------------------------------------------------------------------*/

//   static Future<List<ResultSummeryDetailModel>>
//       getResultSummaryCardDetailsAndBarSize(
//           {required double width,
//           required bool isMcqSheet,
//           required bool assessmentDetailPage,
//           List<StudentAssessmentInfo>? assessmentList}) async {
//     List<StudentAssessmentInfo> studentAssessmentList = assessmentList != null
//         ? assessmentList
//         : await OcrUtility.getSortedStudentInfoList(
//             tableName: assessmentDetailPage == true
//                 ? 'history_student_info'
//                 : 'student_info');

//     //List to be return
//     List<ResultSummeryDetailModel> summaryCardDetailsList = [];
//     List<String> studentEarnedPoint = [];

//     //Comparing Rubric with students earned point
//     for (var i = 0; i < studentAssessmentList.length; i++) {
//       //Check if earned point matches with correct response key /rubric
//       if (studentEarnedPoint.contains(isMcqSheet == true
//           ? studentAssessmentList[i].studentResponseKey
//           : studentAssessmentList[i].studentGrade)) {
//         for (var j = 0; j < summaryCardDetailsList.length; j++) {
//           if (summaryCardDetailsList[j].value ==
//               (isMcqSheet == true
//                   ? studentAssessmentList[i].studentResponseKey
//                   : studentAssessmentList[i].studentGrade)) {
//             //Increasing count of number of student exist with same score or selected key
//             summaryCardDetailsList[j].count =
//                 summaryCardDetailsList[j].count! + 1;
//           }
//         }
//       } else {
//         //Updating list to compare next values of studentAssessmentList
//         studentEarnedPoint.add(isMcqSheet == true
//             ? studentAssessmentList[i].studentResponseKey!
//             : studentAssessmentList[i].studentGrade!);
//         summaryCardDetailsList.add(ResultSummeryDetailModel(
//             value: isMcqSheet == true
//                 ? studentAssessmentList[i].studentResponseKey
//                 : studentAssessmentList[i].studentGrade,
//             count: 1,
//             pointPossible: isMcqSheet == true
//                 ? studentAssessmentList[i].answerKey
//                 : studentAssessmentList[i].pointPossible));
//       }
//     }

//     //Returning width for each result for summary card with their value
//     for (var i = 0; i < summaryCardDetailsList.length; i++) {
//       //Formula :::::::Totalwidth /AssessmentListLength/ StudentEarnedPointCount
// //-------------------------------------------------------------------
//       summaryCardDetailsList[i].width = (width /
//           (studentAssessmentList.length / summaryCardDetailsList[i].count!));
// //-------------------------------------------------------------------
//       Color color = AppTheme.kPrimaryColor;
//       if (isMcqSheet == true) {
//         color = studentAssessmentList[i].answerKey ==
//                 summaryCardDetailsList[i].value
//             ? Color(0xAA7ac36a)
//             : Color(0xAAe57373);
//       } else {
//         switch (summaryCardDetailsList[i].value) {
//           case '0':
//             {
//               color = Color(0xAAe57373);
//               break;
//             }
//           case '1':
//             {
//               color = summaryCardDetailsList[i].pointPossible == '4'
//                   ? Color(0xAAe57373)
//                   : Color(0xAAffd54f);
//               break;
//             }
//           case '2':
//             {
//               color = summaryCardDetailsList[i].pointPossible == '2'
//                   ? Color(0xAA7ac36a)
//                   : Color(0xAAffd54f);
//               break;
//             }
//           case '3':
//             {
//               color = summaryCardDetailsList[i].pointPossible == '3'
//                   ? Color(0xAA7ac36a)
//                   : Color(0xAAffd54f);
//               break;
//             }
//           case '4':
//             {
//               color = Color(0xAA7ac36a);
//               break;
//             }
//         }
//       }
//       summaryCardDetailsList[i].color = color;
//     }
//     summaryCardDetailsList.sort((a, b) => a.value!.compareTo(b.value!));
//     return summaryCardDetailsList;
//   }
