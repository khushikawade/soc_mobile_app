import 'package:Soc/src/modules/google_classroom/modal/google_classroom_courses.dart';
import 'package:Soc/src/modules/google_classroom/services/google_classroom_globals.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_overrides.dart';
import 'package:Soc/src/modules/graded_plus/helper/graded_plus_utilty.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/graded_plus/new_ui/subject_selection_screen.dart';
import 'package:Soc/src/modules/graded_plus/ui/state_selection_page.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAssessmentScreenMethod {
/*------------------------------------------------------------------------------------------------*/
/*---------------------------------updateClassNameForStandAloneApp--------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static updateClassNameForStandAloneApp(
      {required classSuggestions,
      required classController,
      required classError}) async {
    GoogleClassroomOverrides.studentAssessmentAndClassroomObj =
        GoogleClassroomCourses(courseId: '');

    LocalDatabase<GoogleClassroomCourses> _localDb =
        LocalDatabase(Strings.googleClassroomCoursesList);

    /////---------
    //Validating suggestion list comes from camera screen //comparing string of list and return course object
    //Manage here to manage standalone and standard app
    List<GoogleClassroomCourses> googleClassroomCoursesDB =
        await _localDb.getData();

    //Return class suggestion list
    List<GoogleClassroomCourses> _localData = googleClassroomCoursesDB
        .where((GoogleClassroomCourses classroomCourses) =>
            classSuggestions.contains(classroomCourses.name))
        .toList();

    _localData.sort((a, b) => (a?.name ?? '').compareTo(b?.name ?? ''));

    /////--------
    List<StudentAssessmentInfo> studentInfo =
        await OcrUtility.getSortedStudentInfoList(
            tableName: Strings.studentInfoDbName);

    if (studentInfo.isNotEmpty) {
      for (GoogleClassroomCourses classroom in _localData) {
        if (classController.text?.isNotEmpty == true &&
            classroom.name != classController.text) {
          continue;
        }

        //Updating student email address
        for (var student in classroom.studentList!) {
          for (StudentAssessmentInfo info in studentInfo) {
            if (info.studentId == student['profile']['emailAddress']) {
              classError.value = classroom.name!;
              if (Overrides.STANDALONE_GRADED_APP) {
                GoogleClassroomOverrides.studentAssessmentAndClassroomObj =
                    classroom;
              }
              if (classController.text?.isEmpty != false) {
                classController.text = classroom.name!;
              }
              break;
            }
          }
        }
      }
    }
  }

/*------------------------------------------------------------------------------------------------*/
/*-----------------------------------navigateToSubjectSection-------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  static navigateToSubjectSection(
      {required BuildContext context,
      required classSuggestions,
      required classController,
      required selectedAnswer,
      required selectedGrade,
      required localDb,
      required imageFile,
      required isMcqSheet}) async {
    for (int i = 0; i < classSuggestions.length; i++) {
      if (classController.text == classSuggestions[i])
        classSuggestions.removeAt(i);
    }

    classSuggestions.insert(0, classController.text);
// ignore: unnecessary_statements
    if (classSuggestions.length > 9) {
      classSuggestions.removeAt(0);
    }

    await localDb.clear();
    classSuggestions.forEach((String e) {
      localDb.addData(e);
    });

    PlusUtility.updateLogs(
        activityType: 'GRADED+',
        activityId: '11',
        description: 'Created G-Excel file',
        operationResult: 'Success');

    // To check State is selected or not only for standalone app (if selected then navigate to subject screen otherwise navigate to state selection screen)
    String? selectedState;
    if (Overrides.STANDALONE_GRADED_APP) {
      SharedPreferences clearSelectedStateCache =
          await SharedPreferences.getInstance();

      final clearSelectedCacheResult = await clearSelectedStateCache
          .getBool('delete_local_selected_state_cache');

      if (clearSelectedCacheResult != true) {
        await clearSelectedStateCache.setBool(
            'delete_local_selected_state_cache', true);
      } else {
        SharedPreferences pref = await SharedPreferences.getInstance();
        selectedState = pref.getString('selected_state');
      }
    } else {
      //for school app default state
      selectedState = OcrOverrides.defaultStateForSchoolApp;
    }

    // FirebaseAnalyticsService.addCustomAnalyticsEvent(
    //     "navigate_from_create_assignment_page_to_subject_page");
    if (selectedState != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GradedPluSubjectSelection(
                  gradedPlusQueImage: imageFile,
                  isMcqSheet: isMcqSheet,
                  selectedAnswer: selectedAnswer,
                  stateName: Overrides.STANDALONE_GRADED_APP != true
                      ? "New York"
                      : selectedState,
                  // questionImageUrl: questionImageUrl ?? '',
                  selectedClass: selectedGrade.value,
                )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StateSelectionPage(
                  gradedPlusQueImage: imageFile,
                  isMcqSheet: isMcqSheet,
                  selectedAnswer: selectedAnswer,
                  isFromCreateAssessmentScreen: true,
                  // questionImageUrl: questionImageUrl ?? '',
                  selectedClass: selectedGrade.value,
                )),
      );
    }
  }

/*------------------------------------------------------------------------------------------------*/
/*---------------------------------------updateSelectedGrade--------------------------------------*/
/*------------------------------------------------------------------------------------------------*/

  //Function to update last selected Index
  static updateSelectedGrade({required String value}) async {
    SharedPreferences updateSelectedGrade =
        await SharedPreferences.getInstance();
    updateSelectedGrade.setString(OcrOverrides.lastSelectedGrade, value);
  }

/*------------------------------------------------------------------------------------------------*/
/*---------------------------------updateClassNameForStandardApp--------------------------------*/
/*------------------------------------------------------------------------------------------------*/
//this will get all necessary information related to selected classroom will use while updating the google classroom
  //this will get all necessary information related to selected classroom will use while updating the google classroom
  static Future<void> updateClassNameForStandardApp(
      {required String courseName}) async {
    GoogleClassroomOverrides.recentStudentResultSummaryForStandardApp =
        ClassroomCourse(id: '');

    if (courseName?.isEmpty ?? true) {
      return;
    }

//get all classroom couses for localDB
    LocalDatabase<ClassroomCourse> _localDb =
        LocalDatabase(OcrOverrides.gradedPlusStandardClassroomDB);
    List<ClassroomCourse> googleClassroomCoursesDB = await _localDb.getData();

//this will find the selected course name in local db and get  all information related to that google classroom course
    GoogleClassroomOverrides.recentStudentResultSummaryForStandardApp =
        googleClassroomCoursesDB.firstWhere(
      (ClassroomCourse classroomCourses) =>
          classroomCourses.name!.toLowerCase() == courseName.toLowerCase(),
      orElse: () {
        // Handle the case when no element is found
        // For example, you can return null or throw an exception
        return ClassroomCourse(id: '');
        // or throw Exception('No matching element found');
      },
    );
  }

/*------------------------------------------------------------------------------------------------*/
/*---------------------------------------getLastSelectedGrade-------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
  // Function to get last selected Index
  static getLastSelectedGrade({required selectedGrade}) async {
    SharedPreferences lastSelectedGrade = await SharedPreferences.getInstance();
    var lastGrade =
        await lastSelectedGrade.getString(OcrOverrides.lastSelectedGrade);
    if (lastGrade != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectedGrade.value = lastGrade;
      });
    }
  }
}
