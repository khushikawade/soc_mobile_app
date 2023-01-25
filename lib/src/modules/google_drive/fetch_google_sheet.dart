import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/overrides.dart';

class FetchGoogleSheet {
  // Function to extract google sheet details
  static List<StudentAssessmentInfo> fetchGoogleSheetData(
      {required List fields}) {
    try {
      List<StudentAssessmentInfo> studentAssessmentInfoList = [];
      for (var j = 1; j < fields.length; j++) {
        StudentAssessmentInfo studentAssessmentInfo = StudentAssessmentInfo();
        for (var i = 0; i < fields[0].length; i++) {
          switch (fields[0][i]) {
            case 'Id':
              studentAssessmentInfo.studentId =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'Email Id':
              studentAssessmentInfo.studentId =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'Name':
              studentAssessmentInfo.studentName = fields[j][i].toString();
              break;
            case 'Points Earned':
              studentAssessmentInfo.studentGrade =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'Point Possible':
              studentAssessmentInfo.pointPossible =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'Student Selection':
              studentAssessmentInfo.studentResponseKey =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'Answer Key':
              studentAssessmentInfo.answerKey =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'Assessment Question Img':
              studentAssessmentInfo.questionImgUrl =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'Grade':
              studentAssessmentInfo.grade =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'Class Name':
              studentAssessmentInfo.className =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'Subject':
              studentAssessmentInfo.subject =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'Learning Standard':
              studentAssessmentInfo.learningStandard =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'NY Next Generation Learning Standard':
              studentAssessmentInfo.subLearningStandard =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'Scoring Rubric':
              studentAssessmentInfo.scoringRubric =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'Custom Rubric Image':
              studentAssessmentInfo.customRubricImage =
                  fields[j][i].toString().replaceFirst(" ", "");
              break;
            case 'Assessment Image':
              if (Overrides.STANDALONE_GRADED_APP == true) {
                studentAssessmentInfo.questionImgUrl =
                    fields[j][i].toString().replaceFirst(" ", "");
              } else {
                studentAssessmentInfo.assessmentImage =
                    fields[j][i].toString().replaceFirst(" ", "");
              }

              break;
            case 'Student Work Image':
              studentAssessmentInfo.assessmentImage =
                  fields[j][i].toString().replaceFirst(" ", "");

              break;
            case 'Presentation URL':
              studentAssessmentInfo.googleSlidePresentationURL =
                  fields[j][i].toString().replaceFirst(" ", "");

              break;
          }
        }
        studentAssessmentInfoList.add(studentAssessmentInfo);
      }
      return studentAssessmentInfoList;
    } catch (e) {
      return [];
    }
  }
}
