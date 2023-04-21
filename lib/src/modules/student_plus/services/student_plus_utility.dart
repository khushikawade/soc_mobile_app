import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_search_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_work_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class StudentPlusUtility {
  /* -------------------------------------------------------------------------- */
  /*              Function to get recent search student details                 */
  /* -------------------------------------------------------------------------- */

  static Future<List<dynamic>> getRecentStudentSearchData() async {
    LocalDatabase<StudentPlusSearchModel> _localDb =
        LocalDatabase(StudentPlusOverrides.studentInfoRecentList);
    List<StudentPlusSearchModel>? _localData = await _localDb.getData();
    return _localData;
  }

  /* --------------------------------------------------------------------*/
  /*          Function to add student info to add recent List            */
  /* --------------------------------------------------------------------*/

  static addStudentInfoToLocalDb(
      {required StudentPlusSearchModel studentInfo}) async {
    LocalDatabase<StudentPlusSearchModel> _localDb =
        LocalDatabase(StudentPlusOverrides.studentInfoRecentList);
    List<StudentPlusSearchModel>? _localData = await _localDb.getData();
    List<StudentPlusSearchModel> studentInfoList = [];
    studentInfoList.add(studentInfo);
    for (var i = 0; i < _localData.length; i++) {
      if (_localData[i].id != studentInfo.id) {
        studentInfoList.add(_localData[i]);
      }
    }
    await _localDb.clear();
    studentInfoList.forEach((StudentPlusSearchModel e) async {
      await _localDb.addData(e);
    });
  }

  /* --------------------------------------------------------------------*/
  /*                Setting Lock At Portrait Mode                        */
  /* --------------------------------------------------------------------*/

  static Future setLocked() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /* --------------------------------------------------------------------*/
  /*          Function to return student details with labels             */
  /* --------------------------------------------------------------------*/

  static List<StudentPlusInfoModel> createStudentList(
      {required StudentPlusDetailsModel studentDetails}) {
    List<StudentPlusInfoModel> studentInfoList = [
      StudentPlusInfoModel(
          label: 'Name',
          value:
              '${studentDetails.firstNameC ?? ''} ${studentDetails.lastNameC ?? ''}'),
      StudentPlusInfoModel(
          label: 'ID', value: '${studentDetails.studentIdC ?? '-'}'),
      StudentPlusInfoModel(
          label: 'Phone', value: '${studentDetails.parentPhoneC ?? '-'}'),
      StudentPlusInfoModel(
          label: 'Email', value: '${studentDetails.emailC ?? '-'}'),
      StudentPlusInfoModel(
          label: 'Grade', value: '${studentDetails.gradeC ?? '-'}'),
      StudentPlusInfoModel(
          label: 'Class', value: '${studentDetails.classC ?? '-'}'),
      StudentPlusInfoModel(
          label: 'Teacher', value: '${studentDetails.teacherProperC ?? '-'}'),
      StudentPlusInfoModel(
          label: 'Attend%',
          value: '${studentDetails.currentAttendance ?? '-'}'),
      StudentPlusInfoModel(
          label: 'Gender', value: '${studentDetails.genderFullC ?? '-'}'),
      StudentPlusInfoModel(
          label: 'Ethnicity', value: '${studentDetails.ethnicityNameC ?? '-'}'),
      StudentPlusInfoModel(label: 'Age', value: '-'),
      StudentPlusInfoModel(
          label: 'DOB',
          value: studentDetails.dobC == " " || studentDetails.dobC == null
              ? '${studentDetails.dobC ?? '-'}'
              : '${DateFormat('MM/dd/yyyy').format(DateTime.parse(studentDetails.dobC ?? ''))}'),
      // value: '${studentDetails.dobC ?? '-'}'
      // value:
      //     '${DateFormat('MM/dd/yyyy').format(DateTime.parse(studentDetails.dobC ?? '-')) ?? ''}'),
      StudentPlusInfoModel(
          label: 'ELL Status', value: '${studentDetails.ellC ?? '-'}'),
      StudentPlusInfoModel(
          label: 'ELL Level',
          value: '${studentDetails.ellProficiencyC ?? '-'}'),
      StudentPlusInfoModel(
          label: 'IEP Status', value: '${studentDetails.iepProgramC ?? '-'}'),
    ];
    return studentInfoList;
  }

  /* --------------------------------------------------------------------*/
  /*              Function to get pointPossible from rubric              */
  /* --------------------------------------------------------------------*/

  static String getMaxPointPossible({required String rubric}) {
    String maxPointPossible = '2';
    if (rubric.contains('4')) {
      maxPointPossible = '4';
    } else if (rubric.contains('3')) {
      maxPointPossible = '3';
    }
    return maxPointPossible;
  }

  /* --------------------------------------------------------------------*/
  /*              Function to return opposite background color           */
  /* --------------------------------------------------------------------*/

  static Color oppositeBackgroundColor({required BuildContext context}) {
    return Color(0xff000000) != Theme.of(context).backgroundColor
        ? Color(0xff111C20)
        : Color(0xffF7F8F9);
  }

  /* --------------------------------------------------------------------*/
  /*                  Function to calculate age from DOB                 */
  /* --------------------------------------------------------------------*/

  static String calculateAgeFromDOBString(String dobString) {
    try {
      if (dobString == '') {
        return 'NA';
      }
      DateTime dob = DateFormat("dd/MM/yyyy").parse(dobString);
      DateTime now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age.toString();
    } catch (e) {
      return 'NA';
    }
  }

  /* --------------------- Function to return subject list -------------------- */
  static List<String> getSubjectList(
      {required List<StudentPlusWorkModel> list}) {
    List<String> subjectList = [];
    for (var i = 0; i < list.length; i++) {
      if (!subjectList.contains(list[i].subjectC) && list[i].subjectC != null) {
        subjectList.add(list[i].subjectC ?? '');
      }
    }
    return subjectList;
  }

  /* --------- Function to return teacher list from student work list --------- */
  static List<String> getTeacherList(
      {required List<StudentPlusWorkModel> list}) {
    List<String> teacherList = [];
    for (var i = 0; i < list.length; i++) {
      if (!teacherList.contains(
              "${list[i].firstName ?? ''} ${list[i].lastName ?? ''}") &&
          list[i].subjectC != null) {
        teacherList.add("${list[i].firstName ?? ''} ${list[i].lastName ?? ''}");
      }
    }
    return teacherList;
  }
}
