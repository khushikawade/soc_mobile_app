import 'package:Soc/src/globals.dart';

class PBISPlusOverrides {
  static final String pbisPlusClassroomDB = 'PBISPlus_student_course_details';
  static final String pbisPlusSkillsDB = 'PBISPlus_skills';
  static final String PBISPlusHistoryDB = 'PBISPlus_history_details';
  static final String PBISPlusTotalInteractionByTeacherDB =
      'PBISPlus_total_interactions_by_teacher';
  static final String pbisStudentInteractionDB = 'pbis_student_interaction';
  // used to save local db of student details
  static final String PBISPlusStudentDetail = 'PBISPlus_student_details';

  static String pbisGoogleClassroom = 'Google Classroom';
  static String pbisGoogleSheet = 'Google Sheet';
  static String pbisFilterAll = 'All';

  static final double profilePictureSize =
      Globals.deviceType == "phone" ? 40 : 60;
  static final double circleSize = Globals.deviceType == "phone" ? 25 : 35;
  static String pbisPlusFilterValue = 'All';

  // base url used for PBIS plus section
  static final String pbisBaseUrl =
      "https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/";

  static String pbisPlusGoogleDriveFolderId = '';
  static String pbisPlusGoogleDriveFolderPath = '';
}
