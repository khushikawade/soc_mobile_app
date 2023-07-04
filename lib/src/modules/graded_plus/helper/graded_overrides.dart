import 'package:flutter/material.dart';

class OcrOverrides {
  static String? OCR_API_BASE_URL =
      'https://anl2h22jc4.execute-api.us-east-2.amazonaws.com/production/';

  //Google Service Auth URL
  static String? googleDriveAuthURL =
      'https://anl2h22jc4.execute-api.us-east-2.amazonaws.com/production/secure-login/auth';
  static String? googleClassroomAuthURL =
      'https://anl2h22jc4.execute-api.us-east-2.amazonaws.com/production/classroom-login/auth';

  static String defaultStateForSchoolApp = "New York";
  static String lastSelectedGrade = "last_selected_graded";
  static String? cameraPermissionTitle = 'Camera Required';
  static String? cameraPermissionMessage =
      'GRADED+ requires camera access to capture student work. Go to your phone\'s App Settings to enable camera access for this app';
  static final String teacherId = 'teacherId';

  // To manage Graded plus bottom nav bar
  static final ValueNotifier<bool> gradedPlusNavBarIsHide =
      ValueNotifier<bool>(false);

  static final String gradedPlusStandardClassroomDB =
      'GradedPlus_student_course_details';
  static String? gradedPlusHistoryAssignmentGooglePresentationId;

  static String? gradedPlusHistoryAssignmentGooglePresentationLink;
}
