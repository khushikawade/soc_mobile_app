import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/graded_plus/modal/individualStudentModal.dart';
import 'package:Soc/src/modules/graded_plus/modal/result_summery_detail_model.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

import '../../google_classroom/google_classroom_globals.dart';

class OcrUtility {
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

  static Future<List<StudentAssessmentInfo>>
      checkAllStudentBelongsToSameClassOrNot(
          {required LocalDatabase<StudentAssessmentInfo> studentInfoDB,
          required bool isScanMore,
          required String title}) async {
    try {
      List<StudentAssessmentInfo> studentInfo = await studentInfoDB.getData();

      if (isScanMore) {
        studentInfo.removeWhere((element) =>
            element?.isScanMore == null || element?.isScanMore == false);

        //event.studentClassObj = Google classroom Course Object come from import roster
        if ((GoogleClassroomGlobals
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
                  GoogleClassroomGlobals.studentAssessmentAndClassroomObj.name =
                      classroom.name;
                  GoogleClassroomGlobals?.studentAssessmentAndClassroomObj
                      .courseId = classroom.courseId;
                  GoogleClassroomGlobals?.studentAssessmentAndClassroomObj
                      .studentList = classroom.studentList;
                  break;
                }
              }
            }
          }
        }
      }

      return GoogleClassroomGlobals
                  ?.studentAssessmentAndClassroomObj?.studentList ==
              null
          ? []
          : studentInfo.where((student) {
              return GoogleClassroomGlobals
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


  static Future<List<ResultSummeryDetailModel>> getDetailsByValue(
      {required double width,
      required bool isMcqSheet,
      required bool assessmentDetailPage,
      List<StudentAssessmentInfo>? assessmentList}) async {
    List<StudentAssessmentInfo> studentAssessmentList = assessmentList != null
        ? assessmentList
        : await Utility.getStudentInfoList(
            tableName: assessmentDetailPage == true
                ? 'history_student_info'
                : 'student_info');

    
    List<ResultSummeryDetailModel> list = [];
    List<String> rubricList = [];
    for (var i = 0; i < studentAssessmentList.length; i++) {
      if (rubricList.contains(isMcqSheet == true
          ? studentAssessmentList[i].studentResponseKey
          : studentAssessmentList[i].studentGrade)) {
        for (var j = 0; j < list.length; j++) {
          if (list[j].value ==
              (isMcqSheet == true
                  ? studentAssessmentList[i].studentResponseKey
                  : studentAssessmentList[i].studentGrade)) {
            list[j].count = list[j].count! + 1;
          }
        }
      } else {
        rubricList.add(isMcqSheet == true
            ? studentAssessmentList[i].studentResponseKey!
            : studentAssessmentList[i].studentGrade!);
        list.add(ResultSummeryDetailModel(
            value:isMcqSheet == true
                ? studentAssessmentList[i].studentResponseKey
                : studentAssessmentList[i].studentGrade,
            count: 1,
            pointPossible: isMcqSheet == true
                ? studentAssessmentList[i].answerKey
                : studentAssessmentList[i].pointPossible));
      }
    }

    for (var i = 0; i < list.length; i++) {
      list[i].width = width / (studentAssessmentList.length / list[i].count!);
      Color color = AppTheme.kPrimaryColor;
      if (isMcqSheet == true) {
        color = studentAssessmentList[i].answerKey == list[i].value
            ? Color(0xAA7ac36a)
            : Color(0xAAe57373);
      } else {
        switch (list[i].value) {
          case '0':
            {
              color = Color(0xAAe57373);
              break;
            }
          case '1':
            {
              color =
                  list[i].pointPossible == '2' || list[i].pointPossible == '3'
                      ? Color(0xAAffd54f)
                      : Color(0xAAe57373);
              break;
            }
          case '2':
            {
              color = list[i].pointPossible == '2'
                  ? Color(0xAA7ac36a)
                  : Color(0xAAffd54f);
              break;
            }
          case '3':
            {
              color = list[i].pointPossible == '3'
                  ? Color(0xAA7ac36a)
                  : Color(0xAAffd54f);
              break;
            }
          case '4':
            {
              color = Color(0xAA7ac36a);
              break;
            }
        }
      }
      list[i].color = color;
    }
    list.sort((a, b) => a.value!.compareTo(b.value!));
    return list;
  }
}
