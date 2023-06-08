import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_work_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/services/local_database/local_db.dart';
import 'package:intl/intl.dart';

class GooglePresentationBlocMethods {
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------Method prepareAssignmentTableCellValue----------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
  static prepareStudentDetailsTableCellValue(
      {required StudentPlusWorkModel student, required int index}) {
    Map map = {
      0: student.nameC ?? '',
      1: student.assessmentType ?? '',
      2: student.teacherEmail ?? '',
      3: student.subjectC ?? '',
      //  4: student.dateC,
      4: student.dateC != null && student.dateC!.isNotEmpty
          ? DateFormat("MM/dd/yyyy")
              .format(DateTime.parse(student.dateC ?? '-'))
          : '-',
      5: student.resultC ?? '',
      6: StudentPlusUtility.getMaxPointPossible(rubric: student.rubricC ?? '')
          .toString()
    };

    return map[index] != null && map[index] != '' ? map[index] : '-';
  }

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------Method prepareTableCellValueForFirstSlide---------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------*/

  static prepareTableCellValueForFirstSlide(
      {required final StudentPlusDetailsModel studentDetails,
      required int index}) {
    Map map = {
      0: "${studentDetails.firstNameC} ${studentDetails.lastNameC}" ?? '-',
      1: studentDetails.id ?? '-',
      2: studentDetails.parentPhoneC ?? '-',
      3: studentDetails.emailC ?? '-',
      4: studentDetails.gradeC ?? '-',
      5: studentDetails.classC ?? '-',
      6: studentDetails.currentAttendance ?? '-',
      7: studentDetails.genderFullC ?? '-',
      8: studentDetails.age ?? '-',
      // 9: studentDetails.dobC ?? '-'
      9: studentDetails.dobC != null && studentDetails.dobC!.isNotEmpty
          ? DateFormat("MM/dd/yyyy")
              .format(DateTime.parse(studentDetails.dobC ?? '-'))
          : '-'
    };

    return map[index] != null && map[index] != '' ? map[index] : '-';
  }

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------Method updateStudentLocalDBWithGooglePresentationUrl------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
  static updateStudentLocalDBWithGooglePresentationUrl(
      {required StudentPlusDetailsModel studentDetails,
      required final String studentGooglePresentationUrl}) async {
    try {
      //this will get the all students saved in local db
      LocalDatabase<StudentPlusDetailsModel> _localDb = LocalDatabase(
          "${StudentPlusOverrides.studentPlusDetails}_${studentDetails.id}");

      List<StudentPlusDetailsModel> studentsLocalData =
          await _localDb.getData();
      //it will find the student by id and update the updated object wwith googlePresentationUrl

      for (int index = 0; index < studentsLocalData.length; index++) {
        if (studentsLocalData[index].studentIdC == studentDetails.studentIdC) {
          StudentPlusDetailsModel student = studentsLocalData[index];

          student.googlePresentationUrl = studentGooglePresentationUrl;

          await _localDb.putAt(index, student);
          break;
        }
      }
    } catch (e) {
      throw (e);
    }
  }

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------Method prepareAddAndUpdateSlideRequestBody-----------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
  static prepareAddAndUpdateSlideRequestBody({
    required List<StudentPlusWorkModel> allRecords,
    required final int numberOfSlidesAlreadyAvailable,
    required final StudentPlusDetailsModel studentDetails,
  }) {
    try {
      List<String> listOfFieldsForFirstSlide = [
        'Name',
        'ID',
        'Phone',
        'Email',
        'Grade',
        'Class',
        'Attend %',
        'Gender',
        'Age',
        'DOB',
      ];

      List<String> listOfFieldsForEveryStudentSlide = [
        'Assignment Name',
        'Assignment Type',
        'Teacher',
        'Assignment Subject',
        'Date',
        'Points Earned',
        'Points Possible'
      ];

      List<Map> slideRequiredObjectsList = [];

      if (numberOfSlidesAlreadyAvailable == 0) {
        //prepare blank slide
        Map blankSlide = {
          "createSlide": {
            "objectId": "Slide1",
            "slideLayoutReference": {"predefinedLayout": "BLANK"}
          }
        };

        //--------------------------------------------------------------------------------------
        //prepare blank table on slide
        Map blankTable = {
          "createTable": {
            "rows": listOfFieldsForFirstSlide.length, //pass no. of names
            "columns": 2, //key:value
            "objectId": "123456",
            "elementProperties": {
              "pageObjectId": "Slide1",
              "size": {
                "width": {"magnitude": 5000000, "unit": "EMU"},
                "height": {"magnitude": 3500000, "unit": "EMU"}
              },
              "transform": {
                "scaleX": 1,
                "scaleY": 1,
                "translateX": 2005000,
                "translateY": 850000,
                "unit": "EMU",
              }
            },
          }
        };

        slideRequiredObjectsList.add(blankSlide);
        slideRequiredObjectsList.add(blankTable);

        //--------------------------------------------------------------------------------------
        // To update slide table cells with title and values
        listOfFieldsForFirstSlide.asMap().forEach((rowIndex, value) {
          for (int columnIndex = 0; columnIndex < 2; columnIndex++) {
            slideRequiredObjectsList.add(
              {
                "insertText": {
                  "objectId": "123456",
                  "cellLocation": {
                    "rowIndex": rowIndex,
                    "columnIndex": columnIndex
                  },
                  "text": columnIndex == 0
                      ? listOfFieldsForFirstSlide[rowIndex] //Keys
                      : GooglePresentationBlocMethods
                          .prepareTableCellValueForFirstSlide(
                          studentDetails: studentDetails,
                          index: rowIndex,
                        ) //Values
                }
              },
            );

            //--------------------------------------------------------------------------------------
            //update the textstyle and fontsize of table cells
            slideRequiredObjectsList.add({
              "updateTextStyle": {
                "objectId": "123456",
                "style": {
                  "fontSize": {"magnitude": 10, "unit": "PT"},
                  "bold": columnIndex == 0
                },
                "fields": "*",
                "cellLocation": {
                  "columnIndex": columnIndex,
                  "rowIndex": rowIndex
                }
              }
            });
          }
        });
      } else {
        print("REMOVING ITEAM FORM LIST--------");

        allRecords.removeRange(0, numberOfSlidesAlreadyAvailable - 1);
        print("${allRecords.length}  after -------------");
      }

      allRecords
          .asMap()
          .forEach((int index, StudentPlusWorkModel element) async {
        String pageObjectUniqueId =
            DateTime.now().microsecondsSinceEpoch.toString() + "$index";

        String tableObjectUniqueId =
            DateTime.now().microsecondsSinceEpoch.toString() + "$index";

        //--------------------------------------------------------------------------------------
        // Preparing all other blank slide (based on student detail length) type to add assessment images
        Map slideObject = {
          "createSlide": {
            "objectId": pageObjectUniqueId,
            "slideLayoutReference": {"predefinedLayout": "BLANK"}
          }
        };

        slideRequiredObjectsList.add(slideObject);

        //--------------------------------------------------------------------------------------
        // Preparing to update assignment sheet images - students
        if (element.assessmentImageC?.isNotEmpty ?? false) {
          Map obj = {
            "createImage": {
              "url": element.assessmentImageC,
              "elementProperties": {
                "pageObjectId": pageObjectUniqueId,
              },
              "objectId": DateTime.now().microsecondsSinceEpoch.toString()
            }
          };
          slideRequiredObjectsList.add(obj);
        }

        //--------------------------------------------------------------------------------------
        // Preparing table and structure for each student slide
        Map table = {
          "createTable": {
            "rows": listOfFieldsForEveryStudentSlide.length, //pass no. of names
            "columns": 2, //key:value
            "objectId": tableObjectUniqueId,
            "elementProperties": {
              "pageObjectId": pageObjectUniqueId,
              "size": {
                "width": {"magnitude": 6000000, "unit": "EMU"},
                "height": {"magnitude": 3000000, "unit": "EMU"}
              },
              "transform": {
                "scaleX": 1,
                "scaleY": 1,
                "translateX": 3005000,
                "translateY": 1050000,
                "unit": "EMU"
              }
            },
          }
        };
        slideRequiredObjectsList.add(table);

        //--------------------------------------------------------------------------------------
        // Updating table with student information
        listOfFieldsForEveryStudentSlide.asMap().forEach((rowIndex, value) {
          for (int columnIndex = 0; columnIndex < 2; columnIndex++) {
            slideRequiredObjectsList.add(
              {
                "insertText": {
                  "objectId": tableObjectUniqueId,
                  "cellLocation": {
                    "rowIndex": rowIndex,
                    "columnIndex": columnIndex
                  },
                  "text": columnIndex == 0
                      ? listOfFieldsForEveryStudentSlide[rowIndex] //Keys
                      : GooglePresentationBlocMethods
                          .prepareStudentDetailsTableCellValue(
                              student: element, index: rowIndex) //Values
                }
              },
            );
          }
        });
      });
      //  print(assessmentData);
      return slideRequiredObjectsList;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
