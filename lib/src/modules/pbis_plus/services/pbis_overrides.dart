import 'package:intl/intl.dart';

class PBISPlusOverrides {
  static final String pbisPlusClassroomDB = 'PBISPlus_student_course_details';
  static final String PBISPlusHistoryDB = 'PBISPlus_history_details';
  static final String PBISPlusTotalInteractionByTeacherDB =
      'PBISPlus_total_interactions_by_teacher';
  static final String pbisStudentInteractionDB = 'pbis_student_interaction';
  // base url used for PBIS plus section
  static final String pbisBaseUrl =
      "https://ea5i2uh4d4.execute-api.us-east-2.amazonaws.com/production/";
  static final double profilePictureSize = 40;
  static final double circleSize = 25;
  static final String PBISPlusStudentDetail = 'PBISPlus_student_details'; // used to save local db of student details
  static final List<Map<String, dynamic>> data = [
    {
      'Date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'Engaged': 4,
      'Nice Work': 30,
      'Helpful': 0,
      'Total': 100,
    },
    {
      'Date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'Engaged': 4,
      'Nice Work': 25,
      'Helpful': 0,
      'Total': 0,
    },
    {
      'Date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'Engaged': 4,
      'Nice Work': 45,
      'Helpful': 0,
      'Total': 10000,
    },
    {
      'Date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'Engaged': 4,
      'Nice Work': 30,
      'Helpful': 0,
      'Total': 1000,
    },
    {
      'Date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'Engaged': 4,
      'Nice Work': 25,
      'Helpful': 0,
      'Total': 0,
    },
    {
      'Date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'Engaged': 4,
      'Nice Work': 45,
      'Helpful': 0,
      'Total': 0,
    },
    {
      'Date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'Engaged': 4,
      'Nice Work': 30,
      'Helpful': 0,
      'Total': 0,
    },
    {
      'Date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'Engaged': 4,
      'Nice Work': 25,
      'Helpful': 0,
      'Total': 0,
    },
    {
      'Date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'Engaged': 4,
      'Nice Work': 45,
      'Helpful': 0,
      'Total': 0,
    },
    {
      'Date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'Engaged': 4,
      'Nice Work': 30,
      'Helpful': 0,
      'Total': 0,
    },
    {
      'Date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'Engaged': 4,
      'Nice Work': 25,
      'Helpful': 0,
      'Total': 0,
    },
    {
      'Date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'Engaged': 4,
      'Nice Work': 45,
      'Helpful': 0,
      'Total': 0,
    },
  ];
}
