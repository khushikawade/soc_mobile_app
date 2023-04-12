import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class StudentPlusUtility {
  /* -------------------------------------------------------------------------- */
  /*              Function to get recent search student details                 */
  /* -------------------------------------------------------------------------- */

  static Future<List<dynamic>> getRecentStudentSearchData() async {
    LocalDatabase<StudentPlusDetailsModel> _localDb =
        LocalDatabase(StudentPlusOverrides.studentInfoRecentList);
    List<StudentPlusDetailsModel>? _localData = await _localDb.getData();
    return _localData;
  }

  /* --------------------------------------------------------------------*/
  /*          Function to add student info to add recent List            */
  /* --------------------------------------------------------------------*/

  static addStudentInfoToLocalDb(
      {required StudentPlusDetailsModel studentInfo}) async {
    LocalDatabase<StudentPlusDetailsModel> _localDb =
        LocalDatabase(StudentPlusOverrides.studentInfoRecentList);

    List<StudentPlusDetailsModel>? _localData = await _localDb.getData();
    List<StudentPlusDetailsModel> studentInfoList = [];
    studentInfoList.add(studentInfo);
    for (var i = 0; i < _localData.length; i++) {
      if (_localData[i].id != studentInfo.id) {
        studentInfoList.add(_localData[i]);
      }
    }
    await _localDb.clear();
    studentInfoList.forEach((StudentPlusDetailsModel e) async {
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
          label: 'ID', value: '${studentDetails.studentIdC ?? 'NA'}'),
      StudentPlusInfoModel(
          label: 'Phone', value: '${studentDetails.parentPhoneC ?? 'NA'}'),
      StudentPlusInfoModel(
          label: 'Email', value: '${studentDetails.emailC ?? 'NA'}'),
      StudentPlusInfoModel(
          label: 'Grade', value: '${studentDetails.gradeC ?? 'NA'}'),
      StudentPlusInfoModel(
          label: 'Class', value: '${studentDetails.classC ?? 'NA'}'),
      StudentPlusInfoModel(
          label: 'Teacher', value: '${studentDetails.teacherC ?? 'NA'}'),
      StudentPlusInfoModel(
          label: 'Attend%', value: '${studentDetails.academicYearC ?? 'NA'}'),
      StudentPlusInfoModel(
          label: 'Gender', value: '${studentDetails.genderC ?? 'NA'}'),
      StudentPlusInfoModel(
          label: 'Ethnicity',
          value: '${studentDetails.ethnicityNameC ?? 'NA'}'),
      StudentPlusInfoModel(
          label: 'Age',
          value:
              '${calculateAgeFromDOBString(studentDetails.dateOfBirthFormulaC ?? '')}'),
      StudentPlusInfoModel(
          label: 'DOB',
          value:
              '${studentDetails.dateOfBirthFormulaC == '//' ? 'NA' : studentDetails.dateOfBirthFormulaC ?? 'NA'}'),
      StudentPlusInfoModel(
          label: 'ELL Status', value: '${studentDetails.ellC ?? 'NA'}'),
      StudentPlusInfoModel(
          label: 'ELL Level',
          value: '${studentDetails.ellProficiencyC ?? 'NA'}'),
      StudentPlusInfoModel(
          label: 'IEP Status', value: '${studentDetails.iepC ?? 'NA'}'),
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
}
