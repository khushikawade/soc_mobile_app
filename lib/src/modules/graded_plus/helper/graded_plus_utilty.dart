import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/graded_plus/modal/individualStudentModal.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
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

//Ading the sorted list
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
          ..questionImgFilePath = firstStudent.questionImgFilePath;
      }

      await _studentInfoDb.addData(studentObj);
    });
  }

  static Future<List<StudentAssessmentInfo>> getSortedStudentInfoList(
      {required String tableName, bool? isEdit}) async {
    LocalDatabase<StudentAssessmentInfo> _studentInfoDb =
        LocalDatabase(tableName);
    List<StudentAssessmentInfo> _studentInfoListDb = [];
    _studentInfoListDb = await _studentInfoDb.getData();

    if (isEdit == true) {
      await sortStudents(
        tableName: tableName,
      );
    }

    if (_studentInfoListDb.isNotEmpty) {
      if (_studentInfoListDb[0].studentId == 'Id' ||
          _studentInfoListDb[0].studentId == 'Name') {
        _studentInfoListDb.removeAt(0);
      }
    }

    return _studentInfoListDb;
  }

  static Future<int> getStudentInfoListLength(
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
}
