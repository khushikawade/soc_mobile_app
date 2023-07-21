import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_search_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_work_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentPlusUtility {
  /* -------------------------------------------------------------------------- */
  /*              Function to get recent search student details                 */
  /* -------------------------------------------------------------------------- */

  static Future<List<dynamic>> getRecentStudentSearchData() async {
    LocalDatabase<StudentPlusSearchModel> _localDb =
        LocalDatabase(StudentPlusOverrides.studentInfoRecentList);

    //Clear student_ Recent plus_details local data
    SharedPreferences clearNewsCache = await SharedPreferences.getInstance();
    final clearCacheResult = await clearNewsCache
        .getBool('delete_local_recent_student_plus_details_cache');

    if (clearCacheResult != true) {
      await _localDb.clear();
      await clearNewsCache.setBool(
          'delete_local_recent_student_plus_details_cache', true);
    }

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
      StudentPlusInfoModel(label: 'Age', value: '${studentDetails.age ?? '-'}'),
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
      if (!subjectList.contains(list[i].subjectC) &&
          list[i].subjectC != null &&
          list[i].subjectC != "") {
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
          list[i].subjectC != null &&
          (list[i].firstName != " " && list[i].lastName != " ") &&
          (list[i].firstName != null || list[i].lastName != null)) {
        teacherList.add("${list[i].firstName ?? ''} ${list[i].lastName ?? ''}");
      }
    }
    return teacherList;
  }

  /* ----------------------------- Widget to show all CaughtUp message ---------------------------- */
  static Widget allCaughtUp({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Divider(
                    color: Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? Colors.white
                        : Colors.black,
                    height: 40,
                  )),
            ),
            Container(
              width: 50,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return RadialGradient(
                        center: Alignment.topLeft,
                        radius: 0.5,
                        colors: <Color>[
                          AppTheme.kButtonColor,
                          AppTheme.kSelectedColor,
                        ],
                        tileMode: TileMode.repeated,
                      ).createShader(bounds);
                    },
                    child: Icon(Icons.done, color: AppTheme.kButtonColor),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? Color(0xff111C20)
                        : Color(0xffF7F8F9),
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).primaryColor,
                  AppTheme.kSelectedColor,
                ]),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Divider(
                    color: Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? Colors.white
                        : Colors.black,
                    height: 40,
                  )),
            ),
          ]),
          Container(
            padding: EdgeInsets.only(top: 15),
            // height: 80,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Utility.textWidget(
                    context: context,
                    text:
                        'You\'re All Caught Up', //'You\'re All Caught Up', //'Yay! Assessment Result List Updated',
                    textAlign: TextAlign.center,
                    textTheme: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Theme.of(context).colorScheme.background ==
                                Color(0xff000000)
                            ? Colors.white
                            : Colors.black, //AppTheme.kButtonColor,
                        fontWeight: FontWeight.bold)),
                SpacerWidget(10),
                Utility.textWidget(
                    context: context,
                    text: 'You\'ve seen all Classroom Assignment.',
                    textAlign: TextAlign.center,
                    textTheme: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Colors.grey, //AppTheme.kButtonColor,
                        )),
              ],
            ),
          )
        ],
      ),
    );
  }

  static String convertToSentenceCase(String input) {
    if (input.isEmpty) {
      return input;
    }

    // Convert the string to lowercase and split it into words
    List<String> words = input.toLowerCase().split(' ');

    // Capitalize the first letter of each word
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        words[i] = word[0].toUpperCase() + word.substring(1);
      }
    }

    // Join the words back into a sentence
    return words.join(' ');
  }

  /* --------------------------- function to get color in Regents screen -------------------------- */

  static Color getRegentsColors(String value) {
    try {
      if (value.toLowerCase() == "waiver" || value.toLowerCase() == "w") {
        return Colors.blue;
      } else {
        int result = int.parse(value);
        if (result >= 65) {
          return Colors.green;
        } else {
          return Colors.grey;
        }
      }
    } catch (e) {
      return Colors.blue;
    }
  }
}
