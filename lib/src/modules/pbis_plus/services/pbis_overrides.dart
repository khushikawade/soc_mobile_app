import 'package:intl/intl.dart';

class PBISPlusOverrides {
  static final String pbisPlusClassroomDB = 'PBISPlus_student_course_details';
  static final String PBISPlusHistoryDB = 'PBISPlus_history_details';
  static final String PBISPlusTotalInteractionByTeacherDB =
      'PBISPlus_total_interactions_by_teacher';
  static final String pbisStudentInteractionDB = 'pbis_student_interaction';
  // used to save local db of student details
  static final String PBISPlusStudentDetail = 'PBISPlus_student_details';

  static String pbisGoogleClassroom = 'Google Classroom';
  static String pbisGoogleSheet = 'Google Sheet';
  static String pbisFilterAll = 'All';

  static final double profilePictureSize = 40;
  static final double circleSize = 25;
  static String pbisPlusFilterValue = 'All';

  // base url used for PBIS plus section
  static final String pbisBaseUrl =
      "https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/";
}
