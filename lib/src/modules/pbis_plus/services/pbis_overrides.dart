import 'package:Soc/src/globals.dart';

class PBISPlusOverrides {
  static final String pbisPlusClassroomDB = 'PBISPlus_student_course_details';
  static final String pbisPlusBehaviorGenricDB = 'PBISPlus_Behavior_Genric';
  // static final String pbisPlusAdditionalBehviourDB =
  //     'PBISPlusAdditionalBehviour';
  static final String pbisPlusDefaultBehviourDB = 'PBISPlusDefaultBehviour';
  static final String PBISPlusHistoryDB = 'PBISPlus_history_details';
  static final String pbisPlusStudentListDB = 'PBISPlus_student_list';
  // static final String pbisPlusStudentNotesListtDB =
  //     'PBISPlus_student_notes_list';
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

//for reseting bottom sheet items titles
  static const String kresetOptionOnetitle = 'All Classes & Students';
  static const String kresetOptionTwotitle = 'Select Students';
  static const String kresetOptionThreetitle = 'Select Classes';
  static const String kresetOptionFourtitle = 'Select Students by Class';

//PBIS custom behavior local DBs
  static final String PbisPlusDefaultBehaviorLocalDbTable =
      'pbis_plus_default_behavior';
  static final String PbisPlusAdditionalBehaviorLocalDbTable =
      'pbis_plus_additional_behavior';
  static final String PbisPlusTeacherCustomBehaviorLocalDbTable =
      'pbis_plus_custom_behavior';
}
